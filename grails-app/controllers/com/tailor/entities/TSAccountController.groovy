package com.tailor.entities

import grails.plugins.springsecurity.Secured;
import grails.validation.ValidationException;

import com.tailor.SecUser;

class TSAccountController {
	
	@Secured(['ROLE_EMPLOYEE','ROLE_SUPER'])
    def index() {
		[
			'userRoles': TSRole.findAllByEntityDeleted(false)
		];
	}
	
	@Secured(['ROLE_EMPLOYEE','ROLE_SUPER'])
	def dataListAccounts() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = SecUser.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				params.username && ilike('username', "%${params.username}%")
				ne('username', 'superadmin2200')//超级用户，不显示
				//eq('entityDeleted', false)
			}
		};
	
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
	@Secured(['ROLE_EMPLOYEE','ROLE_SUPER'])
	def dataSaveUser() {
		def sample=SecUser.get(params.id) ?: new SecUser(password:'',enabled:false);
		
		SecUser.withTransaction { status->
			try {
				bindData(sample, params, [exclude:['password','userRole']]);
				if(params.password != '') {
					sample.password=params.password;
				}
				def userRole=TSRole.get(params.userRole);
				sample.userRole=userRole;
				sample?.save();
				
				["out": [
					"state":"success",
					"data": sample
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				if(e instanceof ValidationException && sample.userRole) {
					["out": [
						"state":"failure",
						"message": "该用户名已存在"
					]];
				}else{
					["out": [
						"state":"failure",
						"message": e.getMessage()
					]];
				}
			}
		}
	}
	
	@Secured(['ROLE_EMPLOYEE','ROLE_SUPER'])
	def dataChangeUserState() {
		try{
			def sample=SecUser.get(params.id);
			sample?.enabled = (params.state=='enable'?true:false);
			sample?.save();
			
			["out": [
				"state":"success",
				"data": sample
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
