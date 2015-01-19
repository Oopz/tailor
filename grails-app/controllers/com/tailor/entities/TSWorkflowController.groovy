package com.tailor.entities

import java.text.SimpleDateFormat;

import org.springframework.web.multipart.MultipartFile

import com.tailor.SecUser;
import com.tailor.exception.TSException
import com.tailor.utils.TSFile;

import grails.plugins.springsecurity.Secured;
import grails.validation.ValidationException;

class TSWorkflowController {
	def springSecurityService;
	def TSMessageService;
	
	def dataHandleTSException(TSException e) {
		["out": [
			"state":"failure",
			"message": e.getMessage()
		]];
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
    def index() {
		
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
    def projects() {
		
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def workflows() {
		def project=TSProject.get(params.id);
		
		[
			'project': project
		]
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
    def modelPhases() {
		def model=TSWorkflowModel.get(params.id);
		def bean= model ? ([:] + model?.properties) : null;
		
		def phases=[];
		bean?.modelPhases?.each { phase ->
			def prop= [:] + phase.properties;
			phases.add(prop);
			
			def criteria = SecUser.createCriteria();
			def result = criteria.list {//(max: max, offset: offset)
				'userRole' {
					or {
						phase?.phaseParticipants?.each { participant ->
							idEq(participant.id)
						}
					}
				}
			};
			
			def assignees = [];
			result?.each { user ->
				def tmp=[:] + user.properties;
				tmp['id'] = user.id;
				tmp['display'] = "[${user.username}] ${user.userAlias}";
				assignees.add(tmp);
			}
		
			prop['assignees'] = assignees;
		}
		bean?.modelPhases = phases;
		
		[
			'bean': bean
		]
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def detailCreate() {
		def models=TSWorkflowModel.findAll {entityDeleted==false};
		
		[
			'models': models
		]
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def project() {
		def project=TSProject.get(params.id);
		
		def models=TSWorkflowModel.findAll {entityDeleted==false};
		
		[
			'project': project,
			'models': models
		]
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def detailUpdate() {
		def workflow=TSWorkflow.get(params.id);
		
		[
			'currentUser': springSecurityService.currentUser,
			'bean': workflow,
			'project': workflow?.workflowProject
		]
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def dataListWorkflows() {
		println params;
		
		def max = (params.rows ?: 10) as int;
		def offset = (((params.page ?: 1) as int) - 1) * max;
		
		def criteria = TSWorkflow.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
				
				params.id && eq('workflowProject', TSProject.get(params.id))
				
				params.workflowName && ilike('workflowName', "%${params.workflowName}%")
			}
			
			if(params.sort) {
				order(params.sort, params.order)
			}else{
				order('workflowExcutedDate', 'desc')
				order("id", "desc")
			}
		};
	
		def totalCount = result.totalCount;//size()
		result = result.collect{
			def workflowOwner=[
				'username': it.workflowOwner?.username,
				'userAlias': it.workflowOwner?.userAlias
			];
		
			def workflowModel=['modelName': it.workflowModel?.modelName];
			
			def workflowCurrentPhase=it.workflowCurrentPhase ? [
				'id': it.workflowCurrentPhase?.id, 
				'phaseName': it.workflowCurrentPhase?.phaseName,
				'phaseIndex': it.workflowCurrentPhase?.phaseIndex,
				'phaseAssignee': it.workflowCurrentPhase?.phaseAssignee ? [
					'username': it.workflowCurrentPhase?.phaseAssignee?.username, 
					'userAlias': it.workflowCurrentPhase?.phaseAssignee?.userAlias] : null,
				'phaseParticipants': it.workflowCurrentPhase?.phaseParticipants?.collect { pp->
					return ['roleName': pp?.roleName];
				},
				'phaseFields': null,
				'phaseWorkflow': null
			] : null;
		
			def workflowPhases=it.workflowPhases?.sort{it?.phaseIndex}.collect  { ph->
				def workflowPhase=[
					'id': ph.id,
					'phaseName': ph?.phaseName,
					'phaseIndex': ph?.phaseIndex,
					'phaseAssignee': ph?.phaseAssignee ? [
						'username': ph?.phaseAssignee?.username,
						'userAlias': ph?.phaseAssignee?.userAlias] : null,
					'phaseParticipants': ph?.phaseParticipants?.collect { pp->
						return ['roleName': pp?.roleName];
					},
					'phaseFields': null,
					'phaseWorkflow': null
				];
			
				return workflowPhase;
			}
			
			[
				'id':it.id
			]+it.properties+[
				'workflowProject': null,
				'workflowOwner': workflowOwner,
				'workflowModel': workflowModel,
				'workflowCurrentPhase': workflowCurrentPhase,
				'workflowPhases': workflowPhases
			]
		};
	
		["out": [
			"rows": result,
			"total": totalCount//result.totalCount
		]];
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def dataListProjects() {
		def max = (params.rows ?: 10) as int;
		def offset = (((params.page ?: 1) as int) - 1) * max;
		
		def criteria = TSProject.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
				
				params.projectName && ilike('projectName', "%${params.projectName}%")
				params.projectNumber && ilike('projectNumber', "%${params.projectNumber}%")
			}
			
			if(params.sort) {
				order(params.sort, params.order)
			}else{
				order('dateCreated', 'desc')
				order("id", "desc")
			}
		};
	
		def totalCount = result.totalCount;//size()
		result = result.collect{
			def projectOwner=[
				'username': it.projectOwner?.username,
				'userAlias': it.projectOwner?.userAlias
			];
			
			[
				'id':it.id
			]+it.properties+[
				'projectAccessories': null,
				'projectOwner': projectOwner,
				'projectWorkflows': null
			]
		};
		
		["out": [
			"rows": result,
			"total": totalCount//result.totalCount
		]];
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def dataSaveProject() {
		println params;
		
		def theFile = null;
		
		TSProject.withTransaction { status->
			try {
				def project=TSProject.get(params.id) ?: new TSProject();
				bindData(project, params, [exclude:['entityDeleted','projectNumber','projectAmount','projectDate1','projectDate2']]);
				project.projectOwner=springSecurityService.currentUser;;
				project.projectAmount=params.int('projectAmount') ?: 0;
				project.projectDate1=params.projectDate1 ? new SimpleDateFormat("yyyy-MM-dd").parse(params.projectDate1) : null;
				project.projectDate2=params.projectDate2 ? new SimpleDateFormat("yyyy-MM-dd").parse(params.projectDate2) : null;
				
				// 自动生成单号
				if (!project.projectNumber) {
					def rightNow=Calendar.getInstance();
					def p4=rightNow.getTimeInMillis()
					project.projectNumber=String.format("${formatDate(format:'yyyyMMdd')}-%010d", (p4 % 10000000000));//追加10位避免重复
				}
				
				// 处理附件
				if(true) {
					// remove thumbs marked deleted
					def ass2del = project?.projectAccessories?.findAll {
						params.deletedAccessories?.contains(it.fileName);
					}
					project?.projectAccessories?.removeAll(ass2del);
					
					// upload new files
					params.projectAccessories?.each { fileKey, fileVal->
						if(fileVal.getSize()>0){
							def file = fileVal as MultipartFile;
							def fileName=file?.getOriginalFilename();//CommonsMultipartFile
							def fileContentType=file?.getContentType() ?: "application/octet-stream";
							
							theFile = new TSFile(
								fileData: file.getBytes(),
								fileType: fileContentType,
								fileOriginName: fileName
							);
							theFile.save(flush: true);
						
							project.projectAccessories.add(theFile);
						}
					}
					//project?.save();
				}
				
				params.list('workflowName')?.eachWithIndex { workflowName, index ->
					def workflowModelId=params.list('workflowModel')[index];
					if(workflowModelId && workflowName) {
						def model=TSWorkflowModel.get(workflowModelId as long);
						if(model) {
							// 创建对应的工作流
							def sample=TSWorkflow.get(params.list('workflowId')[index]) ?: new TSWorkflow(workflowPhases:[]);
							
							if(sample?.id) {// 旧的工作流只允许改名
								sample.workflowName=workflowName;
							}else{// 新的工作流
								sample.workflowName=workflowName;
								sample.workflowModel=model;
								sample.workflowOwner=springSecurityService.currentUser;
								sample.workflowShouldNotify=params.workflowModNotify ? true : false;
								
								// 关联到project
								project.addToProjectWorkflows(sample);
								project?.save();
								sample?.save();
								
								// 创建流程步骤
								def currentPhase=null;
								
								sample.workflowModel.modelPhases?.sort()?.eachWithIndex { modelPhase, phaseIndex ->
									// 构建步骤并关联到工作流
									def workflowPhase=new TSWorkflowPhase(phaseIndex:modelPhase.phaseIndex,phaseName:modelPhase.phaseName,phaseType:modelPhase.phaseType,
										phaseAssignee: null, phaseParticipants:[] + modelPhase.phaseParticipants);
									sample.addToWorkflowPhases(workflowPhase);
									workflowPhase?.save();
									
									// 构建流程步骤数据项
									modelPhase.phaseFields?.each { modelField->
										def field=new TSWorkflowPhaseField(fieldName: modelField.fieldName, fieldType: modelField.fieldType, fieldIndex: modelField.fieldIndex);
										workflowPhase.addToPhaseFields(field);
										field?.save();
									}
									
									// 初始化工作流当前步骤
									currentPhase = currentPhase ?: workflowPhase;
								}
									
								// 发送通知信息
								currentPhase?.phaseParticipants.each { theRole->
									def reflink=g.createLink(controller:'TSWorkflow', action:'detailUpdate', id:sample?.id);
									TSMessageService.sendMessageToRole(
										theRole, 
										'系统', 
										"工作流(${sample?.workflowName})等待处理",
										"系统发现有属于你角色(${theRole?.roleName})的 步骤(${currentPhase?.phaseName})",
										"${reflink}#phase-${currentPhase?.id}"
									);
								}
								
								sample.workflowCurrentPhase=currentPhase;
							}
							
							sample?.save();
							
						}else{
							throw new TSException("找不到工作流模型 [ID=${workflowModelId}]"){};
						}
					}
				}
				
				project?.save();
				
				["out": [
					"state":"success",
					"data": project?.id
				]];
			
			}catch(e) {//throw e;
				status.setRollbackOnly();
				
				if(e instanceof ValidationException) {
					//reference: http://grails.org/doc/latest/guide/single.html#constraints
					if(theFile?.errors.hasFieldErrors("fileData")) {
						
						["out": [
							"state":"failure",
							"message": "上传失败，请保证文件不超过 4 MB"
						]];
					}else{
						["out": [
							"state":"failure",
							"message": "数据格式有错误，请检查",
							"trace": e.getMessage()
						]];
					}
				}else{
					["out": [
						"state":"failure",
						"message": e.getMessage()
					]];
				}
			}
		}
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def dataSaveWorkflow() {
		println params
		
		TSWorkflow.withTransaction { status->
			try {
				def sample=new TSWorkflow(workflowPhases:[]);
				bindData(sample, params, [exclude:['workflowOwner','workflowModel',
					'workflowCurrentPhase','workflowPhases','workflowExcutedDate','workflowAccessories','workflowShouldNotify']]);
				sample.workflowExcutedDate=new Date(System.currentTimeMillis());
				
				def workflowModel=TSWorkflowModel.get(params.workflowModel);
				sample.workflowModel=workflowModel;
				sample.workflowOwner=springSecurityService.currentUser;
				sample.workflowShouldNotify=params.workflowModNotify ? true : false;
				sample?.save();
				
				def assignees=params.list('phaseAssignee');
				
				def currentPhase=null;
				
				// 额外步骤counter
				def initPhaseCounter=0;//TODO: 改为 1 
				
				// 创建上传步骤
				if(params.workflowModUpload == 'true') {
					def uploadPhase=new TSWorkflowPhase(phaseIndex: --initPhaseCounter, phaseName: '<上传附件>',phaseType:'upload',
						phaseAssignee: springSecurityService.currentUser, phaseParticipants:[]);
					sample.addToWorkflowPhases(uploadPhase);
					currentPhase = currentPhase ?: uploadPhase;
				}
				
				// 创建流程步骤
				sample.workflowModel.modelPhases?.sort()?.eachWithIndex { modelPhase, index ->
					def workflowPhase=new TSWorkflowPhase(phaseIndex:modelPhase.phaseIndex,phaseName:modelPhase.phaseName,phaseType:modelPhase.phaseType, 
						phaseAssignee: SecUser.get(assignees[index]),phaseParticipants:[] + modelPhase.phaseParticipants);
					sample.addToWorkflowPhases(workflowPhase);
					currentPhase = currentPhase ?: workflowPhase;
				}
				sample.workflowCurrentPhase=currentPhase;
				sample?.save();
				
				
				if(sample.workflowShouldNotify && currentPhase && currentPhase?.phaseIndex>=0) {// 若存在下一个步骤且不是初始化步骤，则发送消息通知
					if(currentPhase?.phaseAssignee) {
						TSMessageService.sendMessageToUser(currentPhase?.phaseAssignee, '系统', "工作流(${sample?.workflowName})等待处理",
							"系统发现有属于你的工作流步骤(${currentPhase?.phaseName})正在进行中",
							g.createLink(controller:'TSWorkflow', action:'detailUpdate', id:sample?.id));
					}else {
						currentPhase?.phaseParticipants.each { theRole->
							TSMessageService.sendMessageToRole(theRole, '系统', "工作流(${sample?.workflowName})等待处理",
								"系统发现有属于你角色(${theRole?.roleName})的工作流步骤(${currentPhase?.phaseName})正在进行中",
								g.createLink(controller:'TSWorkflow', action:'detailUpdate', id:sample?.id));
						}
					}
				}
				
				if(!sample.workflowModel?.modelCreators?.collect{it.id}?.contains(springSecurityService.currentUser?.userRole?.id)) {
					def allowedRole=sample.workflowModel?.modelCreators?.collect{it.roleName}?.join(", ");
					throw new TSException("当前用户所属角色不能参与此工作流的创建，需要的角色为 ${allowedRole}"){};
				}
				
				["out": [
					"state":"success",
					"data": sample?.id
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				["out": [
					"state":"failure",
					"message": e.getMessage()
				]];
			}
		}
	}
	
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def dataWorkflowNextPhase() {
		println params
		
		TSWorkflow.withTransaction { status->
			try {
				def sample=TSWorkflow.get(params.id);
				
				if(sample.version != params.int('version')) {
					throw new TSException('操作失败，此工作流已经被更新，请刷新后再尝试'){};
				}
				
				def currentPhase=sample.workflowCurrentPhase;
				if(!currentPhase) {
					throw new TSException('操作失败，此工作流已经结束'){};
				}
				
				currentPhase.phaseFinished=true;
				currentPhase.phaseRejected=false;
				currentPhase.phaseComment="<执行下一步> ${params.phaseComment}";
				currentPhase.phaseExcutedDate=new Date(System.currentTimeMillis());
				currentPhase.phaseOwner=springSecurityService.currentUser;
				
				// 保存该步骤的自定义数据
				currentPhase?.phaseFields?.each { phaseField->
					switch(phaseField?.fieldType) {
						case 'input':
						case 'textbox':
							def fieldValue=params["fieldValue-${phaseField?.id}"] ?: '';
							phaseField?.fieldValueString=fieldValue;
							break;
						case 'number':
							def fieldValue=params.float("fieldValue-${phaseField?.id}") ?: 0f;
							phaseField?.fieldValueFloat=fieldValue;
							break;
						case 'boolean':
							def fieldValue=params.boolean("fieldValue-${phaseField?.id}") ?: false;
							phaseField?.fieldValueBoolean=fieldValue;
							break;
						case 'date':
							def fieldValue=params["fieldValue-${phaseField?.id}"] ? new SimpleDateFormat("yyyy-MM-dd").parse(params["fieldValue-${phaseField?.id}"]) : null;
							phaseField?.fieldValueDate=fieldValue;
							break;
					}
				}
				
				def nextPhase=sample.workflowPhases.find{it.phaseIndex==(sample.workflowCurrentPhase.phaseIndex+1)};
				sample.workflowCurrentPhase=nextPhase;
				sample?.save();
				
				if(currentPhase?.phaseAssignee) {// 指定用户非空， 判断是否为指定用户
					if(currentPhase?.phaseAssignee.id != springSecurityService.currentUser.id) {
						throw new TSException('该步骤已指定具体用户，当前用户不能执行此步骤'){};
					}
				}else if(!currentPhase?.phaseParticipants?.collect{it.id}?.contains(springSecurityService.currentUser?.userRole?.id)) {// 角色判定//!currentPhase ||
					throw new TSException('当前用户所属角色不能执行此工作流的当前步骤'){};
				}
				
				if(currentPhase.phaseType=='upload') {
					// remove thumbs marked deleted
					def ass2del = sample?.workflowAccessories?.findAll {
						params.deletedAccessories?.contains(it.fileName);
					}
					sample?.workflowAccessories?.removeAll(ass2del);
					
					// upload new files
					params.workflowAccessories?.each { fileKey, fileVal->
						if(fileVal.getSize()>0){
							def file = fileVal as MultipartFile;
							def fileName=file?.getOriginalFilename();//CommonsMultipartFile
							def fileContentType=file?.getContentType() ?: "application/octet-stream";
							
							def theFile = new TSFile(
								fileData: file.getBytes(),
								fileType: fileContentType,
								fileOriginName: fileName
							);
							theFile.save(flush: true);
						
							if(theFile?.hasErrors()) {
								throw new TSException("上传失败，请保证文件不能大于2Mb"){};
							}
						
							sample.workflowAccessories.add(theFile);
						}
					}
					sample?.save();
				}
				
				if(nextPhase) {// 若存在下一个步骤，则发送消息通知
					// 发送通知信息
					nextPhase?.phaseParticipants.each { theRole->
						def reflink=g.createLink(controller:'TSWorkflow', action:'detailUpdate', id:sample?.id);
						TSMessageService.sendMessageToRole(
							theRole,
							'系统',
							"工作流(${sample?.workflowName})等待处理",
							"系统发现有属于你角色(${theRole?.roleName})的 步骤(${nextPhase?.phaseName})",
							"${reflink}#phase-${nextPhase?.id}"
						);
					}
				}
				
				["out": [
					"state":"success",
					"data": sample?.id
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				["out": [
					"state":"failure",
					"message": e.getMessage()
				]];
			}
		}
	}
	
	@Secured(['ROLE_WORKFLOW','ROLE_SUPER'])
	def dataWorkflowBackPhase() {
		println params
		
		TSWorkflow.withTransaction { status->
			try {
				def sample=TSWorkflow.get(params.id);
				
				if(sample.version != params.int('version')) {
					throw new TSException('操作失败，此工作流已经被更新，请刷新后再尝试'){};
				}
				
				def currentPhase=sample.workflowCurrentPhase;
				if(!currentPhase) {
					throw new TSException('操作失败，此工作流已经结束'){};
				}
				
				currentPhase.phaseFinished=false;
				currentPhase.phaseRejected=true;
				currentPhase.phaseComment="<执行步骤回退> ${params.phaseComment}";
				currentPhase.phaseAssignee=null;
				currentPhase.phaseExcutedDate=new Date(System.currentTimeMillis());
				currentPhase.phaseOwner=springSecurityService.currentUser;
				def prevPhase=sample.workflowPhases.find{it.phaseIndex==(sample.workflowCurrentPhase.phaseIndex-1)};
				if(!prevPhase) {
					throw new TSException('当前步骤已不能回退'){};
				}
				sample.workflowCurrentPhase=prevPhase;
				sample?.save();
				prevPhase.phaseFinished=false;
				prevPhase?.save();
				
				if(currentPhase?.phaseAssignee) {// 指定用户非空， 判断是否为指定用户
					if(currentPhase?.phaseAssignee.id != springSecurityService.currentUser.id) {
						throw new TSException('该步骤已指定具体用户，当前用户不能执行此步骤'){};
					}
				}else if(!currentPhase?.phaseParticipants?.collect{it.id}?.contains(springSecurityService.currentUser?.userRole?.id)) {// 角色判定//!currentPhase ||
					throw new TSException('当前用户所属角色不能执行此工作流的当前步骤'){};
				}
				
				if(prevPhase) {// 若存在上一个步骤，则发送消息通知
					// 发送通知信息
					prevPhase?.phaseParticipants.each { theRole->
						def reflink=g.createLink(controller:'TSWorkflow', action:'detailUpdate', id:sample?.id);
						TSMessageService.sendMessageToRole(
							theRole,
							'系统',
							"工作流(${sample?.workflowName})等待处理",
							"系统发现有属于你角色(${theRole?.roleName})的 步骤(${prevPhase?.phaseName})",
							"${reflink}#phase-${prevPhase?.id}"
						);
					}
				}
				
				["out": [
					"state":"success",
					"data": sample?.id
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				["out": [
					"state":"failure",
					"message": e.getMessage()
				]];
			}
		}
	}
	
	@Secured(['ROLE_WORKFLOW_DELETE','ROLE_SUPER'])
	def dataDeleteProject() {
		try {
			def provider=TSProject.get(params.id);
			provider?.entityDeleted=true;
			provider?.save();
			
			["out": [
				"state":"success",
				"data": provider?.id
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		}
	}
}
