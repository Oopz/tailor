package com.tailor.entities

import java.util.Date;
import java.util.SortedSet;

import com.tailor.SecUser;
import com.tailor.utils.TSFile;

class TSProject {
	
	SecUser projectOwner;
	
	String projectName='';
	
	String projectNumber;
	String projectCustomer;//客户名称
	String projectInnerNumber;//公司款号
	String projectOuterNumber;//客户款号：
	String projectColors;//色组：
	String projectDesc//款式描述：
	int projectAmount;//下单数：
	Date projectDate1;//成衣交期：
	Date projectDate2;//要求面料交期
	
	SortedSet projectAccessories;
	static hasMany = [projectWorkflows : TSWorkflow, projectAccessories : TSFile];
	
	// 删除标记
	boolean entityDeleted = false;
	
	Date dateCreated;
	Date lastUpdated;
	
    static constraints = {
		projectOwner nullable:false
		
		projectName nullable:false, blank:true, maxSize:1000
		projectNumber nullable:false, blank:true, maxSize:200, unique:true
		projectCustomer nullable:false, blank:true, maxSize:1000
		projectInnerNumber nullable:false, blank:true, maxSize:1000
		projectOuterNumber nullable:false, blank:true, maxSize:1000
		projectColors nullable:false, blank:true, maxSize:1000
		
		projectDate1 nullable:true
		projectDate2 nullable:true
    }
	
	static mapping={
		projectDesc type:'text'
	}
}
