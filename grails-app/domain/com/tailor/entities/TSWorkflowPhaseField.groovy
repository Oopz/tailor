package com.tailor.entities

import java.util.Date;

class TSWorkflowPhaseField implements Comparable {
	
	String fieldName='';
	String fieldType='';//input,boolean,number,textbox
	int fieldIndex;//用于排序 目前未使用
	
	String fieldValueString="";
	boolean fieldValueBoolean=false;
	float fieldValueFloat=0.0f;
	Date fieldValueDate;
	
	static belongsTo = [fieldPhase : TSWorkflowPhase];
	
	// 删除标记
	boolean entityDeleted = false;
	
	Date dateCreated;
	Date lastUpdated;
	
	static constraints = {
		fieldName blank:true, maxSize:1000
		fieldType blank:true, maxSize:1000
		
		fieldValueString nullable:false, blank:true
		fieldValueDate nullable:true
	}
	
	static mapping = {
		fieldValueString type:'text'
	}
	
	@Override
	int compareTo(obj) {
		fieldIndex.compareTo(obj?.fieldIndex);
	}
}
