import java.text.SimpleDateFormat;

import com.tailor.SecRole;
import com.tailor.SecUser;
import com.tailor.SecUserSecRole;
import com.tailor.entities.TSFabricSample;
import com.tailor.entities.TSPiece;
import com.tailor.entities.TSPieceLog;
import com.tailor.entities.TSProject;
import com.tailor.entities.TSRole;
import com.tailor.entities.TSWorkflow;
import com.tailor.entities.TSWorkflowModel;
import com.tailor.entities.TSWorkflowModelPhase;
import com.tailor.entities.TSWorkflowModelPhaseField;
import com.tailor.entities.TSWorkflowPhase;
import com.tailor.entities.TSWorkflowPhaseField;
import com.tailor.entities.TSYarn;
import com.tailor.entities.TSYarnLog;
import com.tailor.entities.TSYarnOrder;
import com.tailor.utils.TSFile;

class BootStrap {

	def grailsApplication

    def init = { servletContext ->
		/*
		 * 隐藏JSON遍历某些属性并deep
		 */
		grails.converters.JSON.registerObjectMarshaller(GroovyObject) {
			def props = it.properties.findAll {k,v -> 
				// prevent byte data transfer in JSON
				k != 'class' && k != 'password' && !v.getClass().equals(byte[].class) && k!= 'springSecurityService'
			}
			if(it.hasProperty("id")) props.id = it.id;
			return props;
		}
		
		/*
		 * 初始化Date Formatter, 只能针对json
		 * 另外的解决方案: http://stackoverflow.com/questions/17241914/bind-date-to-command-object-in-grails/17243717#17243717
		 * and http://stackoverflow.com/questions/2871977/binding-a-grails-date-from-params-in-a-controller/2872291#2872291
		 */
		def dateFormatter=new SimpleDateFormat("yyyy-MM-dd");// HH:mm:ss
		grails.converters.JSON.registerObjectMarshaller(Date) {
			return dateFormatter.format(it);
		}
		
		/*
		 * 解释TSFile, 不解释byte
		 */
		grails.converters.JSON.registerObjectMarshaller(TSFile) {
			def props = it.properties.findAll {k,v-> k!= 'fileData'}
			props.id = it.id;
			return props;
		}
		
		/*
		 * 初始化用户及角色
		 */
		//权限
		def moduleSuper = SecRole.findByAuthority('ROLE_SUPER') ?: new SecRole(authority: 'ROLE_SUPER').save(failOnError: true)//超级权限(保留用)
		
		def moduleYarn = SecRole.findByAuthority('ROLE_YARN') ?: new SecRole(authority: 'ROLE_YARN').save(failOnError: true)//纱仓仓库
		def moduleYarnStockio = SecRole.findByAuthority('ROLE_YARN_STOCKIO') ?: new SecRole(authority: 'ROLE_YARN_STOCKIO').save(failOnError: true)//纱仓进出仓
		def modulePiece = SecRole.findByAuthority('ROLE_PIECE') ?: new SecRole(authority: 'ROLE_PIECE').save(failOnError: true)//布仓仓库
		def moduleFabric = SecRole.findByAuthority('ROLE_FABRIC') ?: new SecRole(authority: 'ROLE_FABRIC').save(failOnError: true)//面料版
		def moduleEmployee = SecRole.findByAuthority('ROLE_EMPLOYEE') ?: new SecRole(authority: 'ROLE_EMPLOYEE').save(failOnError: true)//用户管理
		
		def moduleWorkflowModel = SecRole.findByAuthority('ROLE_WORKFLOW_MODEL') ?: new SecRole(authority: 'ROLE_WORKFLOW_MODEL').save(failOnError: true)//工作流模型
		
		def moduleWorkflow = SecRole.findByAuthority('ROLE_WORKFLOW') ?: new SecRole(authority: 'ROLE_WORKFLOW').save(failOnError: true)//工作流
		def moduleWorkflowDelete = SecRole.findByAuthority('ROLE_WORKFLOW_DELETE') ?: new SecRole(authority: 'ROLE_WORKFLOW_DELETE').save(failOnError: true)//工作流(删除)
		
		def moduleAdmin = SecRole.findByAuthority('ROLE_ADMIN') ?: new SecRole(authority: 'ROLE_ADMIN').save(failOnError: true)//高级权限(权限分配等)
		
		// 角色
		def sysRoleSuper = TSRole.findByRoleName('超级管理员') ?: new TSRole(roleName:'超级管理员',entityDeleted:true).save(failOnError: true);
		if (!sysRoleSuper.authorities.contains(moduleSuper)) {
			SecUserSecRole.create sysRoleSuper, moduleSuper
		}
		
		def sysRoleAdmin = TSRole.findByRoleName('管理员') ?: new TSRole(roleName:'管理员',roleAdmin:true).save(failOnError: true);
		if (!sysRoleAdmin.authorities.contains(moduleAdmin)) {
			SecUserSecRole.create sysRoleAdmin, moduleAdmin
		}
		if (!sysRoleAdmin.authorities.contains(moduleYarn)) {
			SecUserSecRole.create sysRoleAdmin, moduleYarn
		}
		if (!sysRoleAdmin.authorities.contains(moduleYarnStockio)) {
			SecUserSecRole.create sysRoleAdmin, moduleYarnStockio
		}
		if (!sysRoleAdmin.authorities.contains(modulePiece)) {
			SecUserSecRole.create sysRoleAdmin, modulePiece
		}
		if (!sysRoleAdmin.authorities.contains(moduleFabric)) {
			SecUserSecRole.create sysRoleAdmin, moduleFabric
		}
		if (!sysRoleAdmin.authorities.contains(moduleEmployee)) {
			SecUserSecRole.create sysRoleAdmin, moduleEmployee
		}
		if (!sysRoleAdmin.authorities.contains(moduleWorkflowModel)) {
			SecUserSecRole.create sysRoleAdmin, moduleWorkflowModel
		}
		if (!sysRoleAdmin.authorities.contains(moduleWorkflow)) {
			SecUserSecRole.create sysRoleAdmin, moduleWorkflow
		}
		if (!sysRoleAdmin.authorities.contains(moduleWorkflowDelete)) {
			SecUserSecRole.create sysRoleAdmin, moduleWorkflowDelete
		}
		
		def sysRole1 = TSRole.findByRoleName('面料主管') ?: new TSRole(roleName:'面料主管').save(failOnError: true);
		def sysRole2 = TSRole.findByRoleName('纱仓主管') ?: new TSRole(roleName:'纱仓主管').save(failOnError: true);
		def sysRole3 = TSRole.findByRoleName('织布车间主管') ?: new TSRole(roleName:'织布车间主管').save(failOnError: true);
		def sysRole4 = TSRole.findByRoleName('验布主管') ?: new TSRole(roleName:'验布主管').save(failOnError: true);
		def sysRole5 = TSRole.findByRoleName('外厂主管') ?: new TSRole(roleName:'外厂主管').save(failOnError: true);
		def sysRole6 = TSRole.findByRoleName('布仓主管') ?: new TSRole(roleName:'布仓主管').save(failOnError: true);
		
		// 对角色授予权限
		if (!sysRole1.authorities.contains(moduleWorkflow)) {SecUserSecRole.create sysRole1, moduleWorkflow}
		
		if (!sysRole2.authorities.contains(moduleYarn)) {SecUserSecRole.create sysRole2, moduleYarn}
		if (!sysRole2.authorities.contains(moduleWorkflow)) {SecUserSecRole.create sysRole2, moduleWorkflow}
		
		if (!sysRole3.authorities.contains(moduleWorkflow)) {SecUserSecRole.create sysRole3, moduleWorkflow}
		
		if (!sysRole4.authorities.contains(moduleWorkflow)) {SecUserSecRole.create sysRole4, moduleWorkflow}
		
		if (!sysRole5.authorities.contains(moduleWorkflow)) {SecUserSecRole.create sysRole5, moduleWorkflow}
		
		if (!sysRole6.authorities.contains(modulePiece)) {SecUserSecRole.create sysRole6, modulePiece}
		if (!sysRole6.authorities.contains(moduleWorkflow)) {SecUserSecRole.create sysRole6, moduleWorkflow}
		
		
		// 用户
		def adminUser = SecUser.findByUsername('admin') ?: new SecUser(
			username: 'admin',
			password: 'admin',
			userAlias: '张三',
			userMemo: '这是一个管理员',
			userRole: sysRoleAdmin,
			enabled: true).save(failOnError: true)
			
		def normalUser1 = SecUser.findByUsername('user1') ?: new SecUser(
			username: 'user1',
			password: 'user1',
			userAlias: '中文名1',
			userMemo: '备注',
			userRole: sysRole2,
			enabled: true).save(failOnError: true)
		
		def normalUser2 = SecUser.findByUsername('user2') ?: new SecUser(
			username: 'user2',
			password: 'user2',
			userAlias: '中文名2',
			userMemo: '备注...',
			userRole: sysRole6,
			enabled: true).save(failOnError: true)
			
		def testUser1 = SecUser.findByUsername('user3') ?: new SecUser(
			username: 'user3',
			password: 'user3',
			userAlias: '无角色用户',
			userMemo: '',
			enabled: true).save(failOnError: true)
			
		def testUser2 = SecUser.findByUsername('user4') ?: new SecUser(
			username: 'user4',
			password: 'user4',
			userAlias: '已禁用用户',
			userMemo: '',
			userRole: sysRole1,
			enabled: false).save(failOnError: true)
			
		def testUser3 = SecUser.findByUsername('user5') ?: new SecUser(
			username: 'user5',
			password: 'user5',
			userAlias: '',
			userMemo: '',
			userRole: sysRole1,
			enabled: false).save(failOnError: true)
			
		def testUser4 = SecUser.findByUsername('user6') ?: new SecUser(
			username: 'user6',
			password: 'user6',
			userAlias: '',
			userMemo: '',
			userRole: sysRole3,
			enabled: false).save(failOnError: true)
			
		def testUser5 = SecUser.findByUsername('user7') ?: new SecUser(
			username: 'user7',
			password: 'user7',
			userAlias: '',
			userMemo: '',
			userRole: sysRole3,
			enabled: false).save(failOnError: true)
			
		def superUser = SecUser.findByUsername('superadmin2200') ?: new SecUser(
			username: 'superadmin2200',
			password: 'superadmin2200',
			userAlias: '超级用户',
			userMemo: '',
			userRole: sysRoleSuper,
			enabled: true).save(failOnError: true)
				
		/*
		 *  初始化纱仓数据
		 */
		for(int i=0; i<18; i++) {
			def yarn = TSYarn.findByYarnTypeAndYarnCountAndYarnHue("测试纱${i}","c${i}","hue${i}") ?: new TSYarn(yarnType:"测试纱${i}",yarnCount:"c${i}",yarnHue:"hue${i}").save(failOnError: true);
			def yarnOrder = new TSYarnOrder(orderNumber:"O-${i}",orderType:['in','out'][i%2],orderContact:"xxxx",orderYarnLogs:[],orderDate:new Date(System.currentTimeMillis()));
			for(int j=0; j<(i%5); j++) {
				/*
				 * 初始化出入仓记录
				 */
				def yarnLog = new TSYarnLog(logType:yarnOrder.orderType, logYarn:yarn, 
					logDate: yarnOrder.orderDate,logTotal:j+1,logWeight:j,logMemo:"事由").save(failOnError: true);
				yarnOrder.orderYarnLogs.add(yarnLog);
			}
			yarnOrder.save(failOnError: true);
		}
		
		/*
		 * 初始化布仓数据
		 */
		for(int i=0; i<21; i++) {
			def piece = TSPiece.findByPieceNumber("00A2-${i}") ?: new TSPiece(pieceNumber:"00A2-${i}",pieceColor:["红","红","蓝"][i%3]).save(failOnError: true);
			for(int j=1; j<(i%12); j++) {
				/*
				 * 初始化出入仓记录
				 */
				def pieceLog = new TSPieceLog(logType:['in','in','out'][j%3], 
					logPiece:piece, logDate: new Date(System.currentTimeMillis()),logWeight:j*1.3,logMemo:"事由").save(failOnError: true);
			}
		}
		
		/*
		 * 初始化面料版数据
		 */
		for(int i=0; i<14; i++) {
			def piece = TSFabricSample.findByFabricNumber("F00-${i}") ?: new TSFabricSample(fabricNumber:"F00-${i}",fabricColor:["红","红","蓝"][i%3]).save(failOnError: true);
		}
		
		/*
		 * 初始化工作流模型
		 */
		def model1=TSWorkflowModel.findByModelName("织布工作流") ?: new TSWorkflowModel(modelName:"织布工作流",modelCreators:[sysRoleAdmin],modelPhases:[]).save(failOnError: true);
		if(model1.modelPhases.size()==0) {
			def phase1=new TSWorkflowModelPhase(phaseName:"织布备纱",phaseParticipants:[sysRoleAdmin],phaseIndex:1)//.save(failOnError: true);
			def modelPhaseField11=new TSWorkflowModelPhaseField(fieldName: '纱名', fieldType: 'input', fieldIndex: 0);
			def modelPhaseField12=new TSWorkflowModelPhaseField(fieldName: '纱种', fieldType: 'input', fieldIndex: 1);
			def modelPhaseField13=new TSWorkflowModelPhaseField(fieldName: '备注', fieldType: 'textbox', fieldIndex: 5);
			def modelPhaseField14=new TSWorkflowModelPhaseField(fieldName: '数量(kg)', fieldType: 'number', fieldIndex: 2);
			def modelPhaseField15=new TSWorkflowModelPhaseField(fieldName: '参数 A01', fieldType: 'boolean', fieldIndex: 3);
			phase1.addToPhaseFields(modelPhaseField11)
				.addToPhaseFields(modelPhaseField12)
				.addToPhaseFields(modelPhaseField13)
				.addToPhaseFields(modelPhaseField14)
				.addToPhaseFields(modelPhaseField15);
			
			def phase2=new TSWorkflowModelPhase(phaseName:"车间织布",phaseParticipants:[sysRoleAdmin,sysRole1],phaseIndex:2)//.save(failOnError: true);
			def modelPhaseField21=new TSWorkflowModelPhaseField(fieldName: '布名', fieldType: 'input', fieldIndex: 0);
			def modelPhaseField22=new TSWorkflowModelPhaseField(fieldName: '布种', fieldType: 'input', fieldIndex: 1);
			def modelPhaseField23=new TSWorkflowModelPhaseField(fieldName: '备注', fieldType: 'textbox', fieldIndex: 5);
			def modelPhaseField24=new TSWorkflowModelPhaseField(fieldName: '数量(t)', fieldType: 'number', fieldIndex: 2);
			phase2.addToPhaseFields(modelPhaseField21)
				.addToPhaseFields(modelPhaseField22)
				.addToPhaseFields(modelPhaseField23)
				.addToPhaseFields(modelPhaseField24);
				
			def phase3=new TSWorkflowModelPhase(phaseName:"验胚布",phaseParticipants:[sysRoleAdmin,sysRole2],phaseIndex:3)//.save(failOnError: true);
			def phase4=new TSWorkflowModelPhase(phaseName:"后整",phaseParticipants:[sysRoleAdmin,sysRole3],phaseIndex:4)//.save(failOnError: true);
			def phase5=new TSWorkflowModelPhase(phaseName:"后整回厂验布",phaseParticipants:[sysRoleAdmin,sysRole4],phaseIndex:5)//.save(failOnError: true);
			def phase6=new TSWorkflowModelPhase(phaseName:"入仓",phaseParticipants:[sysRoleAdmin,sysRole5],phaseIndex:6)//.save(failOnError: true);
			model1.addToModelPhases(phase1)
				.addToModelPhases(phase2)
				.addToModelPhases(phase3)
				.addToModelPhases(phase4)
				.addToModelPhases(phase5)
				.addToModelPhases(phase6)
				.save(failOnError: true, flush:true);
		}
		
		def model2=TSWorkflowModel.findByModelName("大货印花单") ?: new TSWorkflowModel(modelName:"大货印花单",modelCreators:[sysRoleAdmin],modelPhases:[]).save(failOnError: true);
		if(model2.modelPhases.size()==0) {
			def phase1=new TSWorkflowModelPhase(phaseName:"印花起版",phaseParticipants:[sysRole1],phaseIndex:1,phaseModel:model2).save(failOnError: true);
			def phase2=new TSWorkflowModelPhase(phaseName:"印花厂印花",phaseParticipants:[sysRole2],phaseIndex:2,phaseModel:model2).save(failOnError: true);
			def phase3=new TSWorkflowModelPhase(phaseName:"印花布后整",phaseParticipants:[sysRole3],phaseIndex:3,phaseModel:model2).save(failOnError: true);
			def phase4=new TSWorkflowModelPhase(phaseName:"印花后整回厂验布",phaseParticipants:[sysRole3,sysRole4],phaseIndex:4,phaseModel:model2).save(failOnError: true);
			def phase5=new TSWorkflowModelPhase(phaseName:"印花入仓",phaseParticipants:[sysRole2,sysRole3,sysRole5],phaseIndex:5,phaseModel:model2).save(failOnError: true);
			model2.addToModelPhases(phase1)
				.addToModelPhases(phase2)
				.addToModelPhases(phase3)
				.addToModelPhases(phase4)
				.addToModelPhases(phase5)
				.save(failOnError: true, flush:true);
		}
		
		def model3=TSWorkflowModel.findByModelName("面料外购单") ?: new TSWorkflowModel(modelName:"面料外购单",modelCreators:[sysRoleAdmin],modelPhases:[]).save(failOnError: true);
		if(model3.modelPhases.size()==0) {
			def phase1=new TSWorkflowModelPhase(phaseName:"采购",phaseParticipants:[sysRoleAdmin],phaseIndex:1,phaseModel:model3).save(failOnError: true);
			def phase2=new TSWorkflowModelPhase(phaseName:"回厂验布",phaseParticipants:[sysRoleAdmin],phaseIndex:2,phaseModel:model3).save(failOnError: true);
			def phase3=new TSWorkflowModelPhase(phaseName:"入仓",phaseParticipants:[sysRoleAdmin],phaseIndex:3,phaseModel:model3).save(failOnError: true);
			model3.addToModelPhases(phase1)
				.addToModelPhases(phase2)
				.addToModelPhases(phase3)
				.save(failOnError: true, flush:true);
		}
		
		/*
		 * 初始化测试用工作项目
		 */
//		def project1=TSProject.findByProjectName("项目-1") ?: new TSProject(projectNumber:"0000", projectName:"项目-1",projectOwner:adminUser, projectWorkflows:[]).save(failOnError: true);
		
		/*
		 * 初始化测试用工作流
		 */
//		def workflow1=TSWorkflow.findByWorkflowName("测试工作流-1") ?: new TSWorkflow(workflowName:"测试工作流-1",workflowOwner:adminUser,workflowModel:model1,
//			workflowShouldNotify:true, workflowPhases:[],workflowExcutedDate:new Date(System.currentTimeMillis()));//.save(failOnError: true)
//		project1.addToProjectWorkflows(workflow1);
//		workflow1.save(failOnError: true);
//		
//		if(workflow1.workflowPhases.size()==0) {
//			def currentPhase=null;
//			workflow1.workflowModel.modelPhases?.sort()?.each {
//				def workflowPhase=new TSWorkflowPhase(phaseIndex: it.phaseIndex, phaseName: it.phaseName, phaseParticipants:[]+it.phaseParticipants);
//				workflow1.addToWorkflowPhases(workflowPhase);
//				
//				// 构建流程步骤数据项
//				it.phaseFields?.each { modelField->
//					def field=new TSWorkflowPhaseField(fieldName: modelField.fieldName, fieldType: modelField.fieldType, fieldIndex: modelField.fieldIndex);
//					workflowPhase.addToPhaseFields(field);
//				}
//				
//				currentPhase = currentPhase ?: workflowPhase;
//			}
//			workflow1.workflowCurrentPhase=currentPhase;
//			workflow1.save(failOnError: true);
//		}
		
		
		
    }
	
    def destroy = {
    }
}
