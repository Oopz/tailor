package com.tailor.entities

import java.util.Date;
import java.util.SortedSet;

import com.tailor.SecUser;
import com.tailor.utils.TSFile;

class TSWorkflow {
	
	SecUser workflowOwner;
	String workflowName='';
	TSWorkflowModel workflowModel;
	TSWorkflowPhase workflowCurrentPhase;
	Date workflowExcutedDate;
	
	SortedSet workflowPhases;
		
	boolean workflowShouldNotify=true;
	
	static belongsTo = [workflowProject : TSProject];
	
	SortedSet workflowAccessories;
	static hasMany = [workflowPhases: TSWorkflowPhase, workflowAccessories : TSFile];
	
	// 删除标记
	boolean entityDeleted = false;
	
	Date dateCreated;
	Date lastUpdated;
	
	static constraints = {
		workflowProject nullable:false
		workflowModel nullable:true
		
		
		workflowOwner nullable:false
		
		workflowName blank:true, maxSize:1000
		
		workflowCurrentPhase nullable:true
		
		workflowExcutedDate nullable:true
	}
}
