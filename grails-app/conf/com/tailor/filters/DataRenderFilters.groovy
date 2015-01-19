package com.tailor.filters

import grails.converters.JSON;
import grails.converters.XML;

/*
 * Reference: http://stackoverflow.com/questions/11876570/grails-2-produce-json-output-automatically-like-spring-3-x-does
 */
class DataRenderFilters {

	def grailsApplication

	def filters = {
		multiFormat(controller: '*', action: 'data*', find: true) {
			after = { Map model ->
				
				def accepts = ["${request.getQueryString()?.toLowerCase()}"] ?: request.getHeaders('accept')*.toLowerCase()
				
				def out = model.containsKey('out')?model.out:["message":"unsupported"]//model
				
//				JSON.use('deep');
//				XML.use('deep');
				
				if(accepts.any{ it.contains('json')  }){
					render(text: out as JSON, contentType: 'application/json', encoding:"UTF-8")
				}

				else if(accepts.any{ it.contains('html')  }){
					render(text: out as JSON, contentType: 'text/html', encoding:"UTF-8")
				}

				else if(accepts.any{ it.contains('xml')  }){
					render(text: out as XML, contentType: 'application/xml', encoding:"UTF-8")
				}

				else {
					render(text: out as JSON, contentType: 'application/json', encoding:"UTF-8")
				}
				false
			}
			
			afterView = { Exception e ->

			}
		}
	}
}

