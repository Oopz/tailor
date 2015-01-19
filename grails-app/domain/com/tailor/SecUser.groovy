package com.tailor

import com.tailor.entities.TSRole;

class SecUser {

	transient springSecurityService

	String username
	String password
	boolean enabled
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	
	TSRole userRole;
	
	String userMemo='';
	String userAlias='';

	static constraints = {
		username blank: false, unique: true
		password blank: false
		
		userRole nullable:true
		userMemo blank: true, maxSize:1000
		userAlias blank: true, maxSize:1000
	}

	static mapping = {
		password column: '`password`'
	}

	Set<SecRole> getAuthorities() {
		//SecUserSecRole.findAllBySecUser(this).collect { it.secRole } as Set
		this.userRole?.authorities
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService.encodePassword(password)
	}
}
