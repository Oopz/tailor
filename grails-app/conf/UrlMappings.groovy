class UrlMappings {

	static mappings = {
		
		"/file/$id?/$filename?"(controller:"TSFile",action:"output"){
			constraints {
				// apply constraints here
			}
		}
		
		"/$controller/$action?/$id?"{
			constraints {
				// apply constraints here
			}
		}

		"/"(view:"/index")
		"500"(view:'/error')
	}
}
