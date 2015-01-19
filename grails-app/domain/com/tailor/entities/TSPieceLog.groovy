package com.tailor.entities

import java.util.Date;

class TSPieceLog {
	
	String logType="";//入仓，出仓
	
	TSPiece logPiece;
	static belongsto = [logPiece : TSPiece];
	
	Date logDate;//日期
	String logMemo="";//事由简述
	
	float logWeight;//重量
	
	// 删除标记
	boolean entityDeleted = false;

    static constraints = {
		logType nullable:false, blank:true, maxSize:1000
		
		logPiece nullable:true
		
		logDate nullable:true
		
		logMemo nullable:false, blank: true, maxSize:1000
		
		logWeight nullable: true
		
    }
}
