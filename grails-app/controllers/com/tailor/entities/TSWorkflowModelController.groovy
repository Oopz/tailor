package com.tailor.entities

import grails.converters.JSON;
import grails.plugins.springsecurity.Secured;

class TSWorkflowModelController {
	
	@Secured(['ROLE_WORKFLOW_MODEL','ROLE_SUPER'])
    def index() {
		def roles=TSRole.findAll {entityDeleted==false};
		
		[
			'roles': roles
		]
		
	}
	
	@Secured(['ROLE_WORKFLOW_MODEL','ROLE_SUPER'])
    def detail() {
		def model=TSWorkflowModel.get(params.id);
		
		def roles=TSRole.findAll {entityDeleted==false};
		
		[
			'beanJson': model as JSON,//
			'roles': roles
		]
		
	}
	
//	def dataFetchModel() {
//		def model=TSWorkflowModel.get(params.id);
//		
//		def result=null;
//		if(model) {
//			result=['id':model?.id] + model?.properties + [
//				'modelCreators': model?.modelCreators,
//				'modelPhases': model?.modelPhases];
//		}
//		
//		["out": result];
//	}
	
	@Secured(['ROLE_WORKFLOW_MODEL','ROLE_SUPER'])
	def dataListModels() {
		def max = (params.rows ?: 10) as int;
		def offset = (((params.page ?: 1) as int) - 1) * max;
		
		def criteria = TSWorkflowModel.createCriteria();
		def result = criteria.list {//(max: max, offset: offset)
			and {
				eq('entityDeleted', false)
				
				params.modelName && ilike('modelName', "%${params.modelName}%")
			}
		};
		
		["out": [
			"rows": result,
			"total": result.size//result.totalCount
		]];
	}
	
	@Secured(['ROLE_WORKFLOW_MODEL','ROLE_SUPER'])
	def dataSaveWorkflow() {
		println params
		
		TSWorkflowModel.withTransaction { status->
			try {
				def sample=TSWorkflowModel.get(params.id) ?: new TSWorkflowModel(modelCreators:[]);
				sample?.save();
				
				TSWorkflowModelPhase.findAllByPhaseModel(sample)?.each {
					it.delete();
				}
				
				sample.modelCreators.clear();
				
				params.list('phaseIndex')?.eachWithIndex { p, idx ->
					def phaseName=params.list('phaseName')[idx];
					def phaseParticipantsArr=params.list('phaseParticipants')[idx].split(",");
					
					def phaseParticipants=[];
					phaseParticipantsArr.each { roleId ->
						if(roleId != "") {
							def role=TSRole.get(roleId as long);
							phaseParticipants << role;
						}
					}
					
					if(idx==0) {
						// 当idx＝0时是定义整个model的属性
						sample.modelName=phaseName;
						phaseParticipants.each { pa->
							sample.modelCreators << pa;
						}
						sample?.save();
					}else{
						def phase=new TSWorkflowModelPhase(phaseParticipants:[]);
						//这里定义应该自 1 开始
						phase.phaseIndex=idx;//idx-1
						phase.phaseName=phaseName;
						phase.phaseParticipants=phaseParticipants;
						phase.phaseModel=sample;
						
						// 这两者长度必定也必须相同
						def phaseAttrsName=params.list("phaseAttrs-name-${idx}");
						def phaseAttrsType=params.list("phaseAttrs-type-${idx}");
						if(phaseAttrsName) {
							phaseAttrsName?.eachWithIndex { name, nameIdx->
								if(name) {// 当name不为空
									def field=new TSWorkflowModelPhaseField(fieldName: name, fieldType: phaseAttrsType[nameIdx], fieldIndex: nameIdx);
									phase.addToPhaseFields(field);
									//println "$name(${phaseAttrsType[nameIdx]})";
								}
							}
						}
						
						phase?.save();
					}
				}
				
				["out": [
					"state":"success",
					"data": sample
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				["out": [
					"state":"failure",
					"message": e.getMessage()
				]];
			
				throw e;
			}
		}
	}
	
	
	@Secured(['ROLE_WORKFLOW_MODEL','ROLE_SUPER'])
	def dataDelModel() {
		try {
			def provider=TSWorkflowModel.get(params.id);
			provider?.entityDeleted=true;
			provider?.save();
			
			["out": [
				"state":"success",
				"data": provider
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		
			throw e;
		}
	}
	
}
