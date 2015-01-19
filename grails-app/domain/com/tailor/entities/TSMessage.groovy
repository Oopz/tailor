package com.tailor.entities

import com.tailor.SecUser;

class TSMessage {
	
	String messageSender='';
	boolean messageRead = false;//是否已读
	
	String messageType='';
	String messageHead='';//title
	String messageBody='';//内容
	String messageLink='';//相关链接
	
	SecUser messageOwner;
	
	Date messageDate;//创建时间
	
	// 删除标记
	boolean entityDeleted = false;

    static constraints = {
		messageSender nullable: false, blank: true, maxSize: 1000
		
		messageType nullable: false, blank: true, maxSize: 1000
		messageHead nullable: false, blank: true, maxSize: 1000
		messageBody nullable: false, blank: true, maxSize: 1000
		messageLink nullable: false, blank: true, maxSize: 1000
		
		messageDate nullable: true
    }
}
