package com.tailor.utils

import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.image.BufferedImage;

import grails.plugins.springsecurity.Secured;

import javax.imageio.ImageIO;
import javax.servlet.http.HttpServletResponse;
import javax.swing.ImageIcon;

class TSFileController {
	
	def defaultAction = "output";
	
	@Secured(['IS_AUTHENTICATED_REMEMBERED'])//IS_AUTHENTICATED_FULLY
	def output = {
		//loads the class with a name and assigns obj a new instance created of the same object
		def filename=params.filename ?: params.id;
		def object = TSFile.findByFileNameLike(params.id);
		
		
		if(object) {
			println "out streaming file with name ${filename}(${object?.fileType})"
			
			response.setContentType(object.fileType);
			//response.setHeader("Content-disposition", "attachment;");//强制作为附件下载，不使用浏览器打开
			
			if(object.fileType?.startsWith('image/') && params.int('size')) {
				def imgSize=params.int('size');
				resize(object.fileData, response.outputStream, imgSize, imgSize, object.fileType.substring(object.fileType.indexOf('/')+1));
			}else{
				def ins=new BufferedInputStream(new ByteArrayInputStream(object.fileData));
				response.outputStream << ins;
			}
			
			//byte[] image = object.fileData;
			//response.outputStream << image;
		}else{
			response.setStatus(HttpServletResponse.SC_NOT_FOUND);
			response.outputStream << "NOT FOUND"; // must output something to change the status, otherwise default 404
		}
	}
	
	/**
	 * 用于约束图片大小
	 */
	static resize = { bytes, out, maxW, maxH, format ->
		Image ai = new ImageIcon(bytes).image;
		int width = ai.getWidth( null );
		int height = ai.getHeight( null );
	
//		def limits = 300..2000
//		assert limits.contains( width ) && limits.contains( height ) : 'Picture is either too small or too big!';
	
		float aspectRatio = width / height ;
		float requiredAspectRatio = maxW / maxH;
	
		int dstW = width;
		int dstH = height;
		if(width > maxW || height > maxH) {// 若省去次判断则是强制为maxW或maxH
			if (requiredAspectRatio < aspectRatio) {
				dstW = maxW;
				dstH = Math.round( maxW / aspectRatio);
			} else {
				dstH = maxH;
				dstW = Math.round(maxH * aspectRatio);
			}
		}
	
		BufferedImage bi;
		if("$format".equalsIgnoreCase('jpg') 
			|| "$format".equalsIgnoreCase('jpeg') 
			|| "$format".equalsIgnoreCase('bmp')) {
			
			bi = new BufferedImage(dstW, dstH, BufferedImage.TYPE_INT_RGB);
		}else{
			bi = new BufferedImage(dstW, dstH, BufferedImage.TYPE_INT_ARGB);
		}
		Graphics2D g2d = bi.createGraphics();
		g2d.drawImage(ai, 0, 0, dstW, dstH, null, null);
	
		ImageIO.write( bi, format, out);
	}
}
