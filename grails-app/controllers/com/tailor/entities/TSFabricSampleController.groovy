package com.tailor.entities

import grails.plugins.springsecurity.Secured;

import org.codehaus.groovy.GroovyException;
import org.springframework.web.multipart.MultipartFile;

import com.tailor.utils.TSFile;

class TSFabricSampleController {
	
	@Secured(['ROLE_FABRIC','ROLE_SUPER'])
    def index() { }
	
	@Secured(['ROLE_FABRIC','ROLE_SUPER'])
	def view() {
		def sample = TSFabricSample.get(params.id);
		
		if(sample) {
			['bean': sample]
		}
	}
	
	@Secured(['ROLE_FABRIC','ROLE_SUPER'])
	def dataSaveSample() {
		TSFabricSample.withTransaction { status->
			try {
				def sample=TSFabricSample.get(params.id) ?: new TSFabricSample(fabricThumbnail:[]);
				bindData(sample, params, [exclude:['fabricThumbnail','deletedThumbnails']]);
				
				// remove thumbs marked deleted
				def thumb2del = sample?.fabricThumbnail?.findAll {
					params.deletedThumbnails?.contains(it.fileName);
				}
				sample?.fabricThumbnail?.removeAll(thumb2del);
				
				// upload new thumbs
				params.fabricThumbnail?.each { fileKey, fileVal->
					if(fileVal.getSize()>0){
						def file = fileVal as MultipartFile;
						def fileName=file?.getOriginalFilename();//CommonsMultipartFile
						def fileContentType=file?.getContentType() ?: "application/octet-stream";
						
						def thumbnail = new TSFile(
							fileData: file.getBytes(),
							fileType: fileContentType,
							fileOriginName: fileName
						);
						thumbnail.save(flush: true);
					
						if(thumbnail?.hasErrors()) {
							throw new GroovyException("上传失败，请保证文件不能大于2Mb");
						} 
					
						sample.fabricThumbnail.add(thumbnail);
					}
				}
				sample?.save();
				
				["out": [
					"state":"success",
					"data": sample
				]];
			}catch(e) {
				status.setRollbackOnly();
				
				["out": [
					"state":"failure",
					"message": e.getMessage()
				]];
			
			}
		}
	}
	
	@Secured(['ROLE_FABRIC','ROLE_SUPER'])
	def dataDelSample() {
		try{
			def sample=TSFabricSample.get(params.id);
			sample?.entityDeleted=true;
			sample?.save();
			
			["out": [
				"state":"success",
				"data": sample
			]];
		}catch(e) {
			["out": [
				"state":"failure",
				"message": e.toString()
			]];
		
			throw e;
		}
	}
	
	@Secured(['ROLE_FABRIC','ROLE_SUPER'])
	def dataListSamples() {
		def max = params.int('rows') ?: 10;
		def offset = ((params.int('page') ?: 1) - 1) * max;
		
		def criteria = TSFabricSample.createCriteria();
		def result = criteria.list(max: max, offset: offset) {
			and {
				eq('entityDeleted', false)
			}
		};
	
		
		["out": [
			"rows": result,
			"total": result.totalCount
		]];
	}
	
	
	
}
