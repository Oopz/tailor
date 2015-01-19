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
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addProvider();">新建</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editProvider();">查看</a>
			        <sec:ifAllGranted roles="ROLE_WORKFLOW_DELETE">
			        	<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delProvider();">删除</a>
			        </sec:ifAllGranted>
			    </div>
		    </div>
		    
		    <div data-options="region:'center',border:false">
	    		<div class="easyui-layout" data-options="fit:true">
		   			<!-- Filter Panel -->
				    <div data-options="region:'north',split:false" style="height:48px;background:#E0ECFF;padding:5px;">
				    	<form id="filterForm" method="post">
					    	<table class="filterTable">
					    		<tr>
					    			<td>
					    				工作流名：
										<span class="combo">
											<input name="workflowName"
												class="combo-text easyui-validatebox"/>
										</span>
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="reloadData();return false;" id="filterSubmit">查询</a>
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="resetFilter();return false;">重置</a>
									</td>
					    		</tr>
					    	</table>
				    	</form>
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
										success: function(data){success(data);},
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
					                <th data-options="field:'workflowModel',align:'center',formatter:workflowModelFormatter">工作流类型</th>
					                <th data-options="field:'workflowName',width:3,align:'center'">名称</th>
					                <th data-options="field:'workflowOwner',width:1,align:'center',formatter:workflowOwnerFormatter">创建人</th>
					                <th data-options="field:'workflowExcutedDate',width:1,align:'center'">创建日期</th>
					                <th data-options="field:'workflowCurrentHandler',width:3,align:'center',formatter:workflowCurrentHandlerFormatter">当前处理角色/用户</th>
					                <th data-options="field:'workflowCurrentPhase',width:3,align:'center',formatter:workflowCurrentPhaseFormatter">当前状态（步骤名）</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		</div>
		
		
	</body>

<r:script>
function workflowCurrentHandlerFormatter(value,row,index) {
	if(row.workflowCurrentPhase && row.workflowCurrentPhase.phaseAssignee) {
		return "["+row.workflowCurrentPhase.phaseAssignee.username+"] "+row.workflowCurrentPhase.phaseAssignee.userAlias;
	}if(row.workflowCurrentPhase && row.workflowCurrentPhase.phaseParticipants) {
		return $.map(row.workflowCurrentPhase.phaseParticipants, function(item){
			return item.roleName;
		}).join(", ");
	}else{
		return "";
	}
}

function workflowModelFormatter(value,row,index) {
	return value.modelName;
}

function workflowOwnerFormatter(value,row,index) {
	return value.username + "(" + value.userAlias +")";
}

function workflowCurrentPhaseFormatter(value,row,index) {
	if(value != null) {
		if(row.workflowCurrentPhase.phaseIndex >= 0) {
			return "步骤 " + (row.workflowCurrentPhase.phaseIndex+1) +": " + value.phaseName;
		}else{
			return "初始化步骤: " + value.phaseName;
		}
	}else{
		return "<< 已结束 >>";
	}
}

function addProvider() {
	window.location.href="${createLink(action:'detailCreate')}";
}

function editProvider() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		window.location.href="${createLink(action:'detailUpdate')}/"+row.id;
	}
}

function submitDelProvider(id) {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	showProgress();
	$.ajax({
		url: "${createLink(action:'dataDelWorkflow')}?json",
		type: "post",
		data: {id:id},
	}).done(function(data,textStatus,jqXHR) {
		hideProgress();
		if(data.state=="success") {
			reloadData();
		}else{
			$.messager.alert('错误',data.message,'error');
		}
	}).fail(function(jqXHR,textStatus,errorThrown) {
		hideProgress();
	});
}

function delProvider() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		$.messager.confirm('确认', '要删除吗？', function(r){
			if(r) {
				submitDelProvider(row.id);
			}
		});
	}
}

function reloadData() {
	$("#dg").datagrid("reload");
}

function resetFilter() {
	$("#filterForm").form('reset');
}

function showProgress() {
	$.messager.progress({
		interval:400,
		text: '处理中...'
	});
}

function hideProgress() {
	$.messager.progress('close');
}
</r:script>


</html>
