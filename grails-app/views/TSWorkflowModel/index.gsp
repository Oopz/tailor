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
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delProvider();">删除</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editProvider();">修改</a>
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
					    				模型名：
										<span class="combo">
											<input name="modelName"
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
				    	<table id="dg" class="easyui-datagrid" pagination="false"
				            data-options="singleSelect:true,fitColumns:true,collapsible:false,pageSize:100,pageList:[10,50,100],
				            	loader:function(param,success,error){
				            		$('#filterForm').serializeArray().map(function(n){
				            			param[n.name]=n.value;
				            		});
							        jQuery.ajax({
										url: 'dataListModels?json',
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
					                <th data-options="field:'modelName',width:1,align:'center'">名称</th>
					                <%--<th data-options="field:'modelCreators',width:1,align:'center',formatter:modelCreatorsFormatter">可创建角色</th>--%>
					                <th data-options="field:'modelPhases',width:1,align:'center',formatter:modelPhasesFormatter">步骤</th>
					                <th data-options="field:'modelPhasesCount',width:1,align:'center',formatter:modelPhasesCountFormatter">步骤数</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		</div>
		
		
	</body>

<r:script>
function modelCreatorsFormatter(value,row,index) {
	return $.map(value, function(item){
		return item.roleName;
	}).join(", ");
}

function modelPhasesFormatter(value,row,index) {
	return $.map(value, function(item){
		return item.phaseName;
	}).join("<label style='color:blue;'> >> </label>");
}

function modelPhasesCountFormatter(value,row,index) {
	return row.modelPhases.length;
}

function addProvider() {
	window.location.href="${createLink(action:'detail')}";
}

function editProvider() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		window.location.href="${createLink(action:'detail')}/"+row.id;
	}
}

function submitDelProvider(id) {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	showProgress();
	$.ajax({
		url: "${createLink(action:'dataDelModel')}?json",
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
