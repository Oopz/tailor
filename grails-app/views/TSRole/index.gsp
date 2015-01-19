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
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addRole();">新建</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editRole();">修改</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="delRole();">删除</a>
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
					    				角色名：
										<span class="combo">
											<input name="roleName"
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
										url: '${createLink(action:'dataListRoles')}?json',
										type: 'post', 
										data: param,
										success: function(data){success(data);},
										error: function(){error();}
									});
							    },
							    onDblClickRow:function(row){
							    	editRole();
							    },
				            	fit:true,border:false,idField:'id',nowrap:true
				            	">
					        <thead>
					            <tr>
					                <th data-options="field:'roleName',width:1,align:'center'">角色名</th>
					                <th data-options="field:'roleMemo',width:3,align:'center'">备注</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		</div>
		
		
	    <!-- Detail Dialog-->
	    <div id="roleDetail" class="easyui-dialog" title="创建/修改" style="width:370px;height:240px;padding:5px;"
		        data-options="iconCls:'tree-file',modal:true,collapsible:false,minimizable:false,
		        maximizable:false,closed:true,buttons:'#bb'">
		    <form id="detailForm" method="post">
		    	<input name="id" type="hidden" />
		    	
				<table style="width: 100%;">
					<tr>
						<td>角色名：</td>
						<td>
							<span class="combo">
								<input name="roleName" class="combo-text easyui-validatebox" 
									style="width:270px;" 
									data-options="required:true,validType:['length[1,1000]','plain']" />
							</span>
						</td>
					</tr>
					<tr>
						<td>备注：</td>
						<td>
							<span class="combo">
								<input name="roleMemo" class="combo-text easyui-validatebox" 
									style="width:270px;" 
									data-options="validType:['length[0,1000]','plain']"/>
							</span>
						</td>
					</tr>
				</table>
			</form>
		    
			<div id="bb">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="submitSaveRole();">保存</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#roleDetail').dialog('close');">关闭</a>
			</div>
		</div>
		
		
		
	</body>

<r:script>
function submitSaveRole() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	// send request
	if($('#detailForm').form('validate')) {
		showProgress();
		$.ajax({
			url: "${createLink(action:'dataSaveRole')}?json",
			type: "post",
			data: param
		}).done(function(data,textStatus,jqXHR) {
			hideProgress();
			if(data.state=="success") {
				$('#roleDetail').dialog('close');
				
				if(param.id != '') {// update
					var idx=$('#dg').datagrid('getRowIndex',data.data.id);
					$('#dg').datagrid('updateRow', {index:idx, row:data.data});
				}else{// new
					reloadData();
				}
			}else{
				$.messager.alert('错误',data.message,'error');
			}
		}).fail(function(jqXHR,textStatus,errorThrown) {
			hideProgress();
		});
	}
}

function delRole() {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	if(row && '' != row.id) {
		$.messager.confirm('确认', '要删除该记录吗？', function(r){
			if (r){
				showProgress();
				$.ajax({
					url: "${createLink(action:'dataDelRole')}?json",
					type: "post",
					data: {id:row.id},
				}).done(function(data,textStatus,jqXHR) {
					hideProgress();
					if(data.state=="success") {
						reloadData();
						
						resetForm();
					}else{
						$.messager.alert('错误',data.message,'error');
					}
				}).fail(function(jqXHR,textStatus,errorThrown) {
					hideProgress();
				});
			}
		});
	}else{
		$.messager.alert('提示','请先选定一条记录','info');
	}
}

function addRole() {
	$('#roleDetail').dialog('setTitle', '创建角色信息').dialog('open');
	resetForm();
}

function editRole() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		$('#roleDetail').dialog('setTitle', '修改角色信息').dialog('open');
		resetForm();
		
		$('#detailForm').find('[name="id"]').val(row.id);
		$('#detailForm').find('[name="roleName"]').val(row.roleName);
		$('#detailForm').find('[name="roleMemo"]').val(row.roleMemo);
		
	}else{
		$.messager.alert('提示','请选择一条记录','info');
	}
}

function reloadData() {
	$('#dg').datagrid('clearSelections');
	$("#dg").datagrid("reload");
}

function resetFilter() {
	$("#filterForm").form('reset');
}

function resetForm() {
	$('#detailForm').form('reset');
	$('#detailForm').find('[name="id"]').val("");
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
