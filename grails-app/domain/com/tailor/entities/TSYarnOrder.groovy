package com.tailor.entities

class TSYarnOrder {
	
	String orderNumber="";
	String orderType=""; // in, out
	String orderContact="";// 收货单位,供应商
	
	Date orderDate;
	
	SortedSet orderYarnLogs;
	static hasMany = [orderYarnLogs : TSYarnLog];
	
	
	// 删除标记
	boolean entityDeleted = false;
	
	
    static constraints = {
		orderNumber nullable: false, blank: true, maxSize: 1000
		orderType nullable: false, blank: true, maxSize: 1000
		orderContact nullable: false, blank: true, maxSize: 1000
		
		orderDate nullable:true
    }
	
	
}
