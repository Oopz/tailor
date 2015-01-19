package com.tailor.entities

import com.tailor.SecUser;

class TSWorkflowPhase implements Comparable {
	
	int phaseIndex;// copy from model
	String phaseName='';// copy from model
	String phaseType='';
	String phaseComment='';
	
	SecUser phaseOwner;
	SecUser phaseAssignee;// 具体用户 of TSRole, null为该角色下的任意
	boolean phaseFinished=false;
	boolean phaseRejected=false;
	
	Date phaseExcutedDate;
	
	static belongsTo = [phaseWorkflow : TSWorkflow];
	
	static hasMany = [phaseParticipants : TSRole, phaseFields: TSWorkflowPhaseField];
	
	static constraints = {
		phaseName blank:true, maxSize:1000
		phaseType blank:true, maxSize:1000
		phaseComment blank:true, maxSize:1000
		
		phaseOwner nullable: true
		phaseAssignee nullable: true
		
		phaseWorkflow nullable: false
		
		phaseExcutedDate nullable:true
	}
	
	@Override
	int compareTo(obj) {
		phaseIndex.compareTo(obj.phaseIndex);
	}

}
