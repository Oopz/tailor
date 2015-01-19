package com.tailor

import org.apache.commons.lang.builder.HashCodeBuilder
import com.tailor.entities.TSRole

class SecUserSecRole implements Serializable {

	//SecUser secUser
	TSRole sysRole
	SecRole secRole

	boolean equals(other) {
		if (!(other instanceof SecUserSecRole)) {
			return false
		}

		other.sysRole?.id == sysRole?.id &&
			other.secRole?.id == secRole?.id
	}

	int hashCode() {
		def builder = new HashCodeBuilder()
		if (sysRole) builder.append(sysRole.id)
		if (secRole) builder.append(secRole.id)
		builder.toHashCode()
	}

	static SecUserSecRole get(long sysRoleId, long secRoleId) {
		find 'from SecUserSecRole where sysRole.id=:sysRoleId and secRole.id=:secRoleId',
			[sysRoleId: sysRoleId, secRoleId: secRoleId]
	}

	static SecUserSecRole create(TSRole sysRole, SecRole secRole, boolean flush = false) {
		new SecUserSecRole(sysRole: sysRole, secRole: secRole).save(flush: flush, insert: true)
	}

	static boolean remove(TSRole sysRole, SecRole secRole, boolean flush = false) {
		SecUserSecRole instance = SecUserSecRole.findBySysRoleAndSecRole(sysRole, secRole)
		if (!instance) {
			return false
		}

		instance.delete(flush: flush)
		true
	}

	static void removeAll(TSRole sysRole) {
		executeUpdate 'DELETE FROM SecUserSecRole WHERE sysRole=:sysRole', [sysRole: sysRole]
	}

	static void removeAll(SecRole secRole) {
		executeUpdate 'DELETE FROM SecUserSecRole WHERE secRole=:secRole', [secRole: secRole]
	}

	static mapping = {
		id composite: ['secRole', 'sysRole']
		version false
	}
}
