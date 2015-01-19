<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
		<link rel="stylesheet" type="text/css" href="${resource(dir: 'css', file: 'main.css')}">
		
		<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery-1.11.2.min.js')}"></script>
		
		<g:layoutHead/>
		<r:layoutResources />
		
		<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/jquery-easyui/themes/default', file: 'easyui.css')}">
		<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/jquery-easyui/themes', file: 'icon.css')}">
		
		<link rel="stylesheet" type="text/css" href="${resource(dir: 'css/font-awesome/css', file: 'font-awesome.min.css')}">
		
		<script type="text/javascript" src="${resource(dir: 'js', file: 'patch-array-map.js')}"></script>
		<script type="text/javascript" src="${resource(dir: 'js/jquery-easyui', file: 'jquery.easyui.min.js')}"></script>
		<script type="text/javascript" src="${resource(dir: 'js/jquery-easyui/locale', file: 'easyui-lang-zh_CN.js')}"></script>
		
		<script type="text/javascript" src="${resource(dir: 'js', file: 'raphael.js')}"></script>
		
		<script type="text/javascript" src="${resource(dir: 'js', file: 'date.format.js')}"></script>
		<script type="text/javascript" src="${resource(dir: 'js', file: 'settings-global.js')}"></script>
		
		<script>
		$(function() {
			// 必须最优先加载
			extendRaphael();
		});

		function extendRaphael() {
			Raphael.fn.arrow = function(x1, y1, x2, y2, size) {
				var angle = Raphael.angle(x1, y1, x2, y2);
				var a45   = Raphael.rad(angle-45);
				var a45m  = Raphael.rad(angle+45);
				var a135  = Raphael.rad(angle-135);
				var a135m = Raphael.rad(angle+135);
				var x1a = x1 + Math.cos(a135) * size;
				var y1a = y1 + Math.sin(a135) * size;
				var x1b = x1 + Math.cos(a135m) * size;
				var y1b = y1 + Math.sin(a135m) * size;
				var x2a = x2 + Math.cos(a45) * size;
				var y2a = y2 + Math.sin(a45) * size;
				var x2b = x2 + Math.cos(a45m) * size;
				var y2b = y2 + Math.sin(a45m) * size;
				return this.path(
					"M"+x1+" "+y1+"L"+x1a+" "+y1a+
					"M"+x1+" "+y1+"L"+x1b+" "+y1b+
					"M"+x1+" "+y1+"L"+x2+" "+y2+
					"M"+x2+" "+y2+"L"+x2a+" "+y2a+
					"M"+x2+" "+y2+"L"+x2b+" "+y2b
				);
			};
		}
		</script>
		
		<style>
		.bannerLogo{
			font-size:10px;
			color:#777;
			height:24px;
			line-height:32px;
			display:inline-block;
			background-image:url("${resource(dir: 'images', file:'logo.png')}");
			background-size:40px;
			background-repeat:no-repeat;
			background-position:center center;
			margin-left:10px;
		}
		</style>
	</head>
	
	<body class="easyui-layout">
	    <div data-options="region:'north',split:false,collapsible:false" style="height:70px;">
	    	<div class="easyui-layout" data-options="fit:true" style="background:#eee;">
	            <div data-options="region:'north',border:false" style="height:28px;background:none;">
	            	<!-- Logo -->
					<div id="grailsLogo" role="banner" style="overflow-y:hidden;">
						<label class="bannerLogo">Presented By Oopz</label>
					</div>
					<div style="position:absolute;right:0;top:5px;margin-right:10px;">
						<sec:ifLoggedIn>
						</sec:ifLoggedIn>
					</div>
					<div style="position:absolute;right:0;bottom:5px;margin-right:10px;">
						<sec:ifLoggedIn>
							您好，<sec:username/>(<a href="${createLink(controller:'logout')}">登出</a>)
						</sec:ifLoggedIn>
					</div>
	            </div>
	            
	            <div data-options="region:'center',border:false" style="background:#fff;">
				    <div style="padding:5px;border-top:1px solid #95B8E7">
				        <a href="${createLink(controller:'TSPortal',action:'index')}" class="easyui-linkbutton" data-options="plain:true">
				        	<i class="fa fa-home" style="font-size:16px;margin-right:2px;"></i>我的消息
				        </a>
				        <%--<a href="${createLink(controller:'TSWorkflow',action:'index')}" class="easyui-linkbutton" data-options="iconCls:'icon-tip',plain:true">工作流</a>--%>
				        <a href="${createLink(controller:'TSWorkflow',action:'projects')}" class="easyui-linkbutton" data-options="iconCls:'icon-tip',plain:true">业务单</a>
				        <%--<a href="#" class="easyui-menubutton" data-options="menu:'#mm1',iconCls:'icon-filter'">纱仓管理</a>--%>
				        <%--<a href="${createLink(controller:'TSPiece',action:'index')}" class="easyui-linkbutton" data-options="iconCls:'icon-cut',plain:true">布仓管理</a>--%>
				        <%--<a href="${createLink(controller:'TSFabricSample',action:'index')}" class="easyui-linkbutton" data-options="iconCls:'icon-sum',plain:true">面料版管理</a>--%>
				        <a href="${createLink(controller:'TSWorkflowModel',action:'index')}" class="easyui-linkbutton" data-options="iconCls:'icon-filter',plain:true">工作流模型</a>
				        <a href="#" class="easyui-menubutton" data-options="menu:'#mm2',iconCls:'icon-filter'">系统用户</a>
				    </div>
	            </div>
	        </div>
	    </div>
	    <div id="mm1" style="width:150px;">
	    	<div href="${createLink(controller:'TSYarn',action:'index')}" data-options="iconCls:'tree-file'">仓库管理</div>
	    	<div href="${createLink(controller:'TSYarn',action:'stockio',params:['type':'in'])}" data-options="iconCls:'icon-redo'">进货单</div>
	    	<div href="${createLink(controller:'TSYarn',action:'stockio',params:['type':'out'])}" data-options="iconCls:'icon-undo'">出货单</div>
	    </div>
	    <div id="mm2" style="width:150px;">
	    	<div href="${createLink(controller:'TSAccount',action:'index')}" data-options="">用户管理</div>
	    	<div href="${createLink(controller:'TSRole',action:'index')}" data-options="">角色管理</div>
	    	<div href="${createLink(controller:'TSRole',action:'authRole')}" data-options="">权限管理</div>
	    </div>
       	
	    <!-- 
	    <div data-options="region:'east',title:'East',split:true,collapsed:true" style="width:80px;"></div>
	    
	    <div data-options="region:'west',title:'West',split:true" style="width:220px;">
	    </div>
	     -->
	     
	    <div id="navi_title" data-options="region:'center',title:'模块Title'" style="padding:5px;background:#eee;">
			<g:layoutBody/>
	    </div>
	
		<r:script>
		$(function(){
			// init module title
			var titles={
				'TSPortal': {
					'index': '我的消息',
					'viewTask': '消息内容'
				},
				'TSPiece': {
					'index': '布仓管理'
				},
				'TSFabricSample': {
					index: '面料版管理'
				},
				'TSYarn': {
					'index':'纱仓管理',
					'stockio':'进/出仓'
				},
				'TSAccount': {
					'index': '用户管理'
				},
				'TSRole': {
					'index': '角色管理',
					'authRole': '权限管理'
				},
				'TSWorkflow': {
					'index': '工作流',
					'project': '业务单',
					'projects': '业务单',
					'workflows': '执行业务单',
					'detailCreate': '工作流创建',
					'detailUpdate': '工作流细节'
				},
				'TSWorkflowModel': {
					'index': '工作流模型',
					'detail': '工作流模型'
				},
				'login': {
					'denied': '操作失败'
				},
				'': {
					'': '首页'
				}
			};
			var title=titles['${controllerName}'];
			title && (title=title['${actionName}']);
			$('#navi_title').panel('setTitle', title);
			
		});
		
		
		<g:javascript library="application"/>
		
		</r:script>
		<r:layoutResources />
	</body>
		
		
		
</html>
