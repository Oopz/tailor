package com.tailor.entities

import java.util.Date;
import java.util.SortedSet;

class TSWorkflowModelPhase implements Comparable {

	int phaseIndex;	
	String phaseName='';
	String phaseType='';//一般情况下为空
	
	static belongsTo = [phaseModel : TSWorkflowModel];
	
	
	//SortedSet phaseParticipants;
	static hasMany = [phaseParticipants : TSRole, phaseFields: TSWorkflowModelPhaseField];
	
	// 删除标记
	boolean entityDeleted = false;
	
	Date dateCreated;
	Date lastUpdated;
	
	static constraints = {
		phaseName blank:true, maxSize:1000
		phaseType blank:true, maxSize:1000
		
		phaseModel nullable: false
	}
	
	static mapping = {
		phaseFields cascade: 'all-delete-orphan'
	}
	
	@Override
	int compareTo(obj) {
		phaseIndex.compareTo(obj?.phaseIndex);
	}
}
