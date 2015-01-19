package com.tailor.entities

import grails.plugins.springsecurity.Secured;

class TSPortalController {
	
	def springSecurityService;
	
	def info() {
		//原index页面，显示controller,plugin等信息
	}
	
	@Secured(['IS_AUTHENTICATED_REMEMBERED'])//IS_AUTHENTICATED_FULLY
	def index() {
		//关于springSecurity的anotation
		//参考http://spring.io/blog/2010/08/11/simplified-spring-security-with-grails/
	}
	
	@Secured(['IS_AUTHENTICATED_REMEMBERED'])
	def viewTask() {
		def task=TSMessage.get(params.id);
		task?.messageRead=true;
		task?.save();
		
		[
			'bean': task
		]
	}
	
	@Secured(['IS_AUTHENTICATED_REMEMBERED'])
	def dataListMyTasks() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def currentUser=springSecurityService.currentUser;
		
		def criteria = TSMessage.createCriteria();
		def idCounter=0;
		def result=[];
		/*
		if(currentUser) {
			result += criteria.list {
				and {
					eq('entityDeleted', false)
					
					'maintainStaff' {
						idEq(currentUser.id)
					}
					
					eq('maintainState', HCMaintainState.findByStateKey('open'))
				}
				
				order("id", "desc")
			}.collect {
				[
					'id': ++idCounter,
					'taskDate': it.maintainReservedDate,
					'taskType': '维修',
					'taskDesc': it.maintainDesc,
					'taskOperator': it.maintainOperator,
					'taskLink': g.createLink(controller:'HCMaintain',action:'viewAsTask',id:it.id)
				]
			};
		}
		*/
		result = criteria.list(max: max, offset: offset) {
			and{
				eq('entityDeleted', false)
				
				'messageOwner' {
					idEq(springSecurityService.currentUser.id)
				}
				
				order('messageRead', 'asc')
				order('messageDate', 'desc')
			}
		}.collect {
			[
				'id':it.id,
				'messageDateFull': g.formatDate(format:'yyyy-MM-dd HH:mm:ss', date:it.messageDate)
			] + it.properties
		}
		
		["out": [
			"rows": result,
			"total": result.size
		]];
	}
	
}
