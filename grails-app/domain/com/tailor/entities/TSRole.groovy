package com.tailor.entities

import java.util.Set;

import com.tailor.SecRole;
import com.tailor.SecUserSecRole;

class TSRole {
	
	String roleName='';
	String roleMemo='';
	boolean roleAdmin=false;//只用于标记role的权限是否允许修改
	
	// 删除标记
	boolean entityDeleted = false;

    static constraints = {
		roleName blank:true, maxSize:1000
		roleMemo blank:true, maxSize:1000
    }
	
	Set<SecRole> getAuthorities() {
		SecUserSecRole.findAllBySysRole(this).collect { it.secRole } as Set
	}
}
