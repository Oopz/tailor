<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	
	<body>
	    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
		    <div data-options="region:'north',split:false" style="height:36px;background:#E0ECFF;padding:3px 20px;">
			    <div style="padding:0px;text-align:right;">
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" onclick="window.location.href='${createLink('action':'projects')}'">返回</a>
					<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editProvider();">处理</a>
			    </div>
		    </div>
		    
		    <div data-options="region:'center',border:false">
	    		<div class="easyui-layout" data-options="fit:true">
		   			<!-- Filter Panel -->
				    <div data-options="region:'north',split:false" style="height:215px;background:#fff;padding:5px;">
				    	<g:render template="js/projectInfo.template" model="['project':project]"></g:render>
				    </div>
				    
				    <!-- Table -->
				    <div data-options="region:'center'">
				    	<table id="dg" class="easyui-datagrid" pagination="true"
				            data-options="singleSelect:true,fitColumns:true,collapsible:false,pageSize:50,pageList:[10,50,100],
				            	loader:function(param,success,error){
				            		$('#filterForm').serializeArray().map(function(n){
				            			param[n.name]=n.value;
				            		});
							        jQuery.ajax({
										url: '${createLink('action':'dataListWorkflows','params':[json:null, id:params.id])}',
										type: 'post', 
										data: param,
										success: function(data){
											success(data);
											$('.easyui-tooltip').tooltip();
										},
										error: function(){error();}
									});
							    },
							    onDblClickRow:function(row){
							    	editProvider();
							    },
				            	fit:true,border:false,idField:'id',nowrap:false
				            	">
					        <thead>
					            <tr>
					                <th width="20%" sortable="true" data-options="field:'workflowName',align:'center'">名称</th>
					                <th width="20%" sortable="true" data-options="field:'workflowModel',align:'center',formatter:workflowModelFormatter">工作流类型</th>
					                <%--<th data-options="field:'workflowOwner',width:1,align:'center',formatter:workflowOwnerFormatter">创建人</th>--%>
					                <%--<th data-options="field:'workflowExcutedDate',width:1,align:'center'">创建日期</th>--%>
					                <th width="20%" data-options="field:'workflowCurrentHandler',align:'center',formatter:workflowCurrentHandlerFormatter">当前处理角色/用户</th>
					                <th width="20%" data-options="field:'workflowCurrentPhase',align:'center',formatter:workflowCurrentPhaseFormatter">当前状态（步骤名）</th>
					                <th width="20%" data-options="field:'workflowPhases',align:'left',formatter:workflowGraphFormatter">当前状态（图示）</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		</div>
		
		<g:render template="js/workflows.js"></g:render>
		
	</body>



</html>
