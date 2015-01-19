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
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editProvider();">编辑</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true" onclick="excuteWorkflow();">执行</a>
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
					    				业务单号：
										<span class="combo">
											<input name="projectNumber"
												class="combo-text easyui-validatebox"/>
										</span>
					    				业务单名：
										<span class="combo">
											<input name="projectName"
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
										url: 'dataListProjects?json',
										type: 'post', 
										data: param,
										success: function(data){success(data);},
										error: function(){error();}
									});
							    },
							    onDblClickRow:function(row){
							    	excuteWorkflow();
							    },
				            	fit:true,border:false,idField:'id',nowrap:false
				            	">
					        <thead>
					            <tr>
					                <th width="10%" sortable="true" data-options="field:'projectNumber',align:'center'">单号</th>
					                <th width="10%" sortable="true" data-options="field:'projectName',align:'center'">名称</th>
					                <th width="10%" sortable="true" data-options="field:'projectCustomer',align:'center'">客户名称</th>
					                <th width="10%" sortable="true" data-options="field:'projectColors',align:'center'">色组</th>
					                <th width="10%" sortable="true" data-options="field:'projectInnerNumber',align:'center'">公司款号</th>
					                <th width="10%" sortable="true" data-options="field:'projectOuterNumber',align:'center'">客户款号</th>
					                <th data-options="field:'projectDesc',align:'center',fixed:true,width:200">款式描述</th>
					                <th width="10%" sortable="true" data-options="field:'projectAmount',align:'center'">下单数</th>
					                <th width="10%" sortable="true" data-options="field:'projectOwner',align:'center',formatter:projectOwnerFormatter">创建人</th>
					                <th width="10%" sortable="true" data-options="field:'projectDate1',align:'center'">成衣交期</th>
					                <th width="10%" sortable="true" data-options="field:'projectDate2',align:'center'">面料交期</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		</div>
		
		
	</body>

<r:script>

function projectOwnerFormatter(value,row,index) {
	return value.username + "(" + value.userAlias +")";
}

function addProvider() {
	window.location.href="${createLink(action:'project')}";
}

function editProvider() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		window.location.href="${createLink(action:'project')}/"+row.id;
	}else{
		$.messager.alert('提示','请选择一条记录','info');
	}
}

function excuteWorkflow() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		window.location.href="${createLink(action:'workflows')}/"+row.id;
	}else{
		$.messager.alert('提示','请选择一条记录','info');
	}
}

function submitDelProvider(id) {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	showProgress();
	$.ajax({
		url: "${createLink(action:'dataDeleteProject')}?json",
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
