package com.tailor.entities

import grails.plugins.springsecurity.Secured;

import java.text.SimpleDateFormat;

import org.codehaus.groovy.grails.plugins.jasper.JasperExportFormat;
import org.codehaus.groovy.grails.plugins.jasper.JasperReportDef;

import net.sf.jasperreports.engine.data.JRBeanCollectionDataSource;

class TSYarnController {
	
	def jasperService;
	
	def scaffold = true;
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
    def index() { }
	
	def dataTest() {
	}
	
	// -------- 进出仓 --------
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def stockio() {}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def dataListOrders() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		def type = params.type;
		
		def criteria = TSYarnOrder.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				ilike('orderType', "${type}")
				eq('entityDeleted', false)
			}
		};
	
		
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def dataSaveOrder() {
		TSYarnOrder.withTransaction { status ->
			try {
				def order=new TSYarnOrder(orderYarnLogs:[]);//no modify operation allowed
				bindData(order, params, [exclude:['orderDate']]);// bind data
				order.orderDate = params.orderDate = params.date('orderDate', 'yyyy-MM-dd');
				
				params.list('logYarn')?.eachWithIndex { yarn, index->
					def logYarn = TSYarn.get(yarn);
					def yarnLogData = [:]
					yarnLogData.logWeight = params.list('logWeight')[index];
					yarnLogData.logTotal = params.list('logTotal')[index];
					yarnLogData.logMemo = params.list('logMemo')[index];
					yarnLogData.logDate = params.orderDate;
					yarnLogData.logType = params.orderType;
					
					if(logYarn) {
						def yarnLog = new TSYarnLog();
						yarnLog.logYarn = logYarn;
						bindData(yarnLog, yarnLogData);//bind data
						
						//calculate logTotal & logWeight, no matter if it's negative
						logYarn.yarnWeight =  logYarn.yarnWeight + (yarnLog.logType=='in' ? 1 : -1) * yarnLog.logWeight;
						logYarn.yarnStock =  logYarn.yarnStock + (yarnLog.logType=='in' ? 1 : -1) * yarnLog.logTotal;
						
						yarnLog.save();// persistent a new one, cascade save & update for yarn
						
						order.orderYarnLogs.add(yarnLog);
					}
				}
				
				order?.save();
				
				["out": [
					"state":"success",
					"data": order
				]];
			}catch(e) {
				status.setRollbackOnly();
			
				["out": [
					"state":"failure",
					"message": e.toString()
				]];
			
//				throw e;
			}
		}
	}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def dataDelOrder() {
		TSYarnOrder.withTransaction { status ->
			try{
				def order=TSYarnOrder.get(params.id);
				
				order.orderYarnLogs?.eachWithIndex { yarnLog, index->
					def yarn = yarnLog.logYarn;
					if(yarn) {
						yarn.yarnWeight =  yarn.yarnWeight - (yarnLog.logType=='in' ? 1 : -1) * yarnLog.logWeight;
						yarn.yarnStock =  yarn.yarnStock - (yarnLog.logType=='in' ? 1 : -1) * yarnLog.logTotal;
						yarnLog.entityDeleted = true;
					}
				}
				
				order?.entityDeleted=true;
				order?.save();//cascade update all
				
				["out": [
					"state":"success",
					"data": order
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				["out": [
					"state":"failure",
					"message": e.toString()
				]];
			
//				throw e;
			}
		}
	}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def orderItem() {}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def orderView() {
		def sample = TSYarnOrder.get(params.id);
		
		if(sample) {
			['bean': sample]
		}
	}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def orderEdit() {
		def sample = TSYarnOrder.get(params.id);
		
		if(sample) {
			['bean': sample]
		}
	}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def reportStockio() {
		def sample = TSYarnOrder.get(params.id);
		
		def result = [:];
		result.data = [];
		
		sample?.orderYarnLogs?.each { yarnLog ->
			def tmpArr=[:];
			tmpArr.yarnType = yarnLog.logYarn?.yarnType;
			tmpArr.yarnCount = yarnLog.logYarn?.yarnCount;
			tmpArr.yarnHue = yarnLog.logYarn?.yarnHue;
			tmpArr.yarnJar = yarnLog.logYarn?.yarnJar;
			tmpArr.logWeight = yarnLog.logWeight;
			tmpArr.logTotal = yarnLog.logTotal;
			tmpArr.logMemo = "${yarnLog.logMemo}";
			
			result.data << tmpArr;
		}
		params.orderContact = sample.orderContact;
		params.orderDate = sample.orderDate ? new SimpleDateFormat("yyyy-MM-dd").format(sample.orderDate) : '';
		params.orderNumber = sample.orderNumber;
		params.logoUrl = "http://localhost:${request.getServerPort()}${resource(dir:'images',file:'report_logo.png')}";
		params.IS_USING_IMAGES_TO_ALIGN = false;//html
		
		def reportDef = new JasperReportDef(
			name:(params.type=="in" ? "fashadan" : "fashadan"),
			fileFormat:(params.format=="html" ? JasperExportFormat.HTML_FORMAT : JasperExportFormat.PDF_FORMAT),
			parameters:params,
			reportData:result.data
	    );
	
		if(params.format=="html") {
			render(text: jasperService.generateReport(reportDef), contentType: reportDef.fileFormat.mimeTyp, encoding: reportDef.parameters.encoding ?: 'UTF-8');
		}else{
			response.contentType = reportDef.fileFormat.mimeTyp;
			response.characterEncoding = "UTF-8";
			response.outputStream << jasperService.generateReport(reportDef).toByteArray();
		}
	
		
		//params._format = "HTML";
		//params._file = (params.type == "in" ? "fashadan" : "fashadan");
		//def report = jasperService.buildReportDefinition(params, request.getLocale(), result);//new JRBeanCollectionDataSource(sample.orderYarnLogs)
		
		//response.contentType = report.fileFormat.mimeTyp
		//response.characterEncoding = "UTF-8"
		//response.outputStream << report.contentStream.toByteArray()
		
		//render(text: report.contentStream, contentType: report.fileFormat.mimeTyp, encoding: report.parameters.encoding ?: 'UTF-8');
	}
	
	@Secured(['ROLE_YARN_STOCKIO','ROLE_SUPER'])
	def dataSaveStockIO() {
		def yarn=TSYarn.get(params.long('logYarn'));
		
		TSYarnLog.withTransaction { status ->
			try{
				yarn.yarnWeight =  yarn.yarnWeight + (params.logType=='in' ? 1 : -1) * params.float('logWeight');
				yarn.yarnStock =  yarn.yarnStock + (params.logType=='in' ? 1 : -1) * params.float('logTotal');
				yarn.save();
				
				def yarnLog=new TSYarnLog();
				bindData(yarnLog, params, [exclude: ['logYarn']]);
				
				yarnLog.logYarn=yarn;
				yarnLog.logDate=new Date(System.currentTimeMillis());
				yarnLog?.save();
	
				["out": [
					"state":"success",
					"data": yarn
				]];
			}catch(Exception e) {
				status.setRollbackOnly();
	
				["out": [
					"state":"failure",
					"message": e.toString()
				]];
			
//				throw e;
			}
		}
	}
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
	def dataSaveYarnInfo() {
		try {
			def yarn=TSYarn.get(params.id) ?: new TSYarn();
			//yarn?.properties=params;
			bindData(yarn, params);//Reference: http://grails.org/doc/2.2.1/guide/single.html#dataBinding
			yarn?.save();
			
			["out": [
				"state":"success",
				"data": yarn
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		
//			throw e;
		}
	}
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
	def dataDelYarnInfo() {
		try{
			def yarn=TSYarn.get(params.id);
			yarn?.entityDeleted=true;
			yarn?.save();
			
			["out": [
				"state":"success",
				"data": yarn
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		
//			throw e;
		}
	}
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
	def dataListAllYarns() {
		def result = TSYarn.findAll{entityDeleted == false};
		["out": [
			"rows": result,
			"total": result.size()
		]];
	}
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
	def dataListYarnTypes() {
		
	}
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
	def dataListYarns() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = TSYarn.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
				
				ilike('yarnType', "%${params.yarnType}%")
				ilike('yarnCount', "%${params.yarnCount}%")
				ilike('yarnHue', "%${params.yarnHue}%")
				ilike('yarnColor', "%${params.yarnColor}%")
				ilike('yarnJar', "%${params.yarnJar}%")
			}
		};
	
		
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
	@Secured(['ROLE_YARN','ROLE_SUPER'])
	def dataListYarnLogs() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = TSYarnLog.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
				logYarn {
					eq('id', params.id as long)
				}
			}
			order 'logDate', 'desc'
		};
	
		
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
}
