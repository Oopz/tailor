package com.tailor.entities

class TSPiece implements Comparable {
	//面料号，颜色，布种，成分，纱线组成，克重，门幅，织造工厂，工艺明细，面料特性简介，备注，成品缩略图
	//入库出库加上日期、重量
	
	String pieceNumber="";//编号
	String pieceColor="";//颜色
	String pieceType="";//布种
	String pieceMaterial="";//成分
	
	String pieceYarn="";//纱线组成
	
	String pieceWeight="";//克重
	String pieceWidth="";//门幅
	
	String pieceFactory="";//织造工厂
	String pieceMemo1="";//工艺明细
	String pieceMemo2="";//面料特性简介
	String pieceMemo3="";//备注
	
	// 仓库相关
	float pieceStock;//库存总重
	
	// 删除标记
	boolean entityDeleted = false;
	
    static constraints = {
		pieceNumber nullable: false, blank: true, maxSize: 1000
		pieceColor nullable: false, blank: true, maxSize: 1000
		pieceType nullable: false, blank: true, maxSize: 1000
		pieceMaterial nullable: false, blank: true, maxSize: 1000
		
		pieceYarn nullable: false, blank: true, maxSize: 1000
		
		pieceWeight nullable: false, blank: true, maxSize: 1000
		pieceWidth nullable: false, blank: true, maxSize: 1000
		
		pieceFactory nullable: false, blank: true, maxSize: 1000
		pieceMemo1 nullable: false, blank: true, maxSize: 1000
		pieceMemo2 nullable: false, blank: true, maxSize: 1000
		pieceMemo3 nullable: false, blank: true, maxSize: 1000
    }
	
	@Override
	int compareTo(obj) {
		id.compareTo(obj.id);
	}
}
