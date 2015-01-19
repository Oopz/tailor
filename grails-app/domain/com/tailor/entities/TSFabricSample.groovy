package com.tailor.entities

import com.tailor.utils.TSFile;

class TSFabricSample implements Comparable {
	//面料号，颜色，布种，成分，纱线组成，克重，门幅，织造工厂，工艺明细，面料特性简介，备注，成品缩略图
	
	String fabricNumber="";//编号
	String fabricColor="";//颜色
	String fabricType="";//布种
	String fabricMaterial="";//成分
	
	String fabricYarn="";//纱线组成
	
	String fabricWeight="";//克重
	String fabricWidth="";//门幅
	
	String fabricFactory="";//织造工厂
	String fabricMemo1="";//工艺明细
	String fabricMemo2="";//面料特性简介
	String fabricMemo3="";//备注
	
	SortedSet fabricThumbnail;
	static hasMany = [fabricThumbnail : TSFile];
	
	// 删除标记
	boolean entityDeleted = false;

    static constraints = {
		fabricNumber nullable: false, blank: true, maxSize: 1000
		fabricColor nullable: false, blank: true, maxSize: 1000
		fabricType nullable: false, blank: true, maxSize: 1000
		fabricMaterial nullable: false, blank: true, maxSize: 1000
		
		fabricYarn nullable: false, blank: true, maxSize: 1000
		
		fabricWeight nullable: false, blank: true, maxSize: 1000
		fabricWidth nullable: false, blank: true, maxSize: 1000
		
		fabricFactory nullable: false, blank: true, maxSize: 1000
		fabricMemo1 nullable: false, blank: true, maxSize: 1000
		fabricMemo2 nullable: false, blank: true, maxSize: 1000
		fabricMemo3 nullable: false, blank: true, maxSize: 1000
    }
	
	@Override
	int compareTo(obj) {
		id.compareTo(obj.id);
	}
}
