package com.tailor.entities

import java.util.SortedSet;

class TSWorkflowModel {
	
	String modelName='';
	
	// 删除标记
	boolean entityDeleted = false;
	
//	SortedSet modelCreators;
	SortedSet modelPhases;
	static hasMany = [modelCreators : TSRole, modelPhases: TSWorkflowModelPhase];
	
    static constraints = {
		modelName blank:true, maxSize:1000
    }
}
