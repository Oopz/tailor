package com.tailor.entities

import java.util.Date;

class TSWorkflowModelPhaseField implements Comparable  {
	
	String fieldName='';
	String fieldType='';
	int fieldIndex;//用于排序 目前未使用
	
	static belongsTo = [fieldPhase : TSWorkflowModelPhase];
	
	// 删除标记
	boolean entityDeleted = false;
	
	Date dateCreated;
	Date lastUpdated;
	
    static constraints = {
		fieldName blank:true, maxSize:1000
		fieldType blank:true, maxSize:1000
    }
	
	@Override
	int compareTo(obj) {
		fieldIndex.compareTo(obj?.fieldIndex);
	}
}
