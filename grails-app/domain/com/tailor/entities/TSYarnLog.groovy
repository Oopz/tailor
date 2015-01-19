package com.tailor.entities

/**
 * 
 * @author gorebill
 *
 *	入仓：
 *	供应商、日期、来纱事由简述
 *	细节列表：纱种、纱支、色号、颜色、缸号、重量、件数、仓位、纱线特性简介、备注
 *	出仓：
 *	收货单位、出纱事由简述、日期
 *	细节列表：纱种、纱支、色号、颜色、缸号、重量、件数、纱线特性简介、备注
 */
class TSYarnLog implements Comparable {
	
	String logType="";//入仓，出仓
	
	TSYarn logYarn;
	static belongsto = [logYarn : TSYarn];
	
	Date logDate;//日期
	String logMemo="";//事由简述
	
	String logProvider="";//供应商
	String lodReceiver="";//收货单位
	
	float logTotal;//件数
	float logWeight;//重量
	
	// 删除标记
	boolean entityDeleted = false;

    static constraints = {
		logType nullable:false, blank:true, maxSize:1000
		
		logYarn nullable:true
		
		logDate nullable:true
		
		logMemo nullable:false, blank: true, maxSize:1000
		logProvider nullable:false, blank: true, maxSize:1000
		lodReceiver nullable:false, blank: true, maxSize:1000
		
		logTotal nullable: true
		logWeight nullable: true
		
    }
	
	@Override
	int compareTo(obj) {
		id.compareTo(obj.id);
	}
	
}
