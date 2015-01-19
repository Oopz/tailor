package com.tailor.entities

/**
 * 纱线
 * @author gorebill
 *
 *	纱种、纱支、色号、颜色、缸号、库存重量、仓位、纱线特性简介、备注
 *	由纱种、纱支、色号才能确定一条数据，大多情况下色号可以确定一条，但有少数情况下有重复。
 *
 *	入仓：
 *	供应商、日期、来纱事由简述
 *	细节列表：纱种、纱支、色号、颜色、缸号、重量、件数、仓位、纱线特性简介、备注
 *	出仓：
 *	收货单位、出纱事由简述、日期
 *	细节列表：纱种、纱支、色号、颜色、缸号、重量、件数、纱线特性简介、备注
 *	库存：
 *	纱种、纱支、色号、颜色、缸号、重量、仓位、纱线特性简介
 *
 *
 */
class TSYarn implements Comparable {
	
	String yarnType="";//纱种
	String yarnCount="";//纱支
	String yarnHue="";//色号
	
	String yarnColor="";//颜色
	String yarnJar="";//缸号
	
	float yarnWeight;//库存重量
	float yarnStock;//库存件数
	
	String yarnSpace="";//仓位
	String yarnMemo1="";//纱线特性简介
	String yarnMemo2="";//备注
	
	static hasmany = [yarnLogs : TSYarnLog]; 
	
	// 删除标记
	boolean entityDeleted = false;

	static constraints = {
		
		yarnType nullable: false, blank: true, maxSize: 1000
		yarnCount nullable: false, blank: true, maxSize: 1000
		yarnHue nullable: false, blank: true, maxSize: 1000
		
		yarnColor nullable: false, blank: true, maxSize: 1000
		yarnJar nullable: false, blank: true, maxSize: 1000
		
		yarnSpace nullable: false, blank: true, maxSize: 1000
		yarnMemo1 nullable: false, blank: true, maxSize: 1000
		yarnMemo2 nullable: false, blank: true, maxSize: 1000
		
	}
	
	@Override
	int compareTo(obj) {
		id.compareTo(obj.id);
	}
}
