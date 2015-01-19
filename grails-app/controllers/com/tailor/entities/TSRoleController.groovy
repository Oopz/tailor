package com.tailor.entities

import grails.converters.JSON;
import grails.plugins.springsecurity.Secured;

import com.tailor.SecRole;
import com.tailor.SecUser;
import com.tailor.SecUserSecRole;
import com.tailor.exception.TSException;

class TSRoleController {
	
	
	def dataHandleTSException(TSException e) {
		["out": [
			"state":"failure",
			"message": e.getMessage()
		]];
	}
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
    def index() { }
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
	def authRole() { }
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
	def authorities() {
		
		def bean = TSRole.get(params.id);
		def authorities=bean?.authorities?.collect {it.authority} as Set;
		
		[
			'bean': bean,
			'authorities': authorities
		]
	}
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
	def dataListRoles() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = TSRole.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				params.roleName && ilike('roleName', "%${params.roleName}%")
				eq('entityDeleted', false)
			}
		};
	
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
	def dataSaveRole() {
		def sample=TSRole.get(params.id) ?: new TSRole();
		
		TSRole.withTransaction { status->
			try {
				bindData(sample, params);
				sample?.save();
				
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
			}
		}
	}
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
	def dataDelRole() {
		try{
			def sample=TSRole.get(params.id);
			sample?.entityDeleted = true;
			sample?.save();
			
			def users=SecUser.findAllByUserRole(sample);
			users.each {
				it.userRole=null;
				it.save();
			}
			
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
	
	@Secured(['ROLE_ADMIN','ROLE_SUPER'])
	def dataSaveAuthorities() {
		def sample=TSRole.get(params.id);
		
		TSRole.withTransaction { status->
			try {
				if(sample?.roleAdmin==true) {
					throw new TSException("该角色为系统最高级别权限用户，不能对其权限进行修改");
				}
				
				// clear all
				SecUserSecRole.findAllBySysRole(sample)?.each {
					it.delete();
				}
				
				params.list('authorities')?.each {
					def mod=SecRole.findByAuthority(it);
					SecUserSecRole.create sample, mod
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
			}
		}
	}
}
