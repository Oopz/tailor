package com.tailor.utils

import java.util.Date;

class TSFile implements Comparable {
	String fileName="";
	String fileOriginName="";
	String fileType="";
	String fileMemo=""
	byte[] fileData;
	Date fileCreatedDate;
	
	// 删除标记
	boolean entityDeleted = false;

    static constraints = {
		fileName nullable: false, blank: true, maxSize:1000
		fileOriginName nullable: false, blank: true, maxSize:1000
		fileType nullable: true, blank: true, maxSize:1000
		fileMemo nullable: true, blank: true, maxSize:1000
		fileData maxSize: 1024 * 1024 * 4 //max to 4 MB
		fileCreatedDate nullable: true
    }
	
	def beforeInsert = {
		fileName = UUID.randomUUID().toString(); // init with an unique name
		fileCreatedDate = new Date(System.currentTimeMillis());
	}
	
	@Override
	int compareTo(obj) {
		id.compareTo(obj?.id);
	}
}
