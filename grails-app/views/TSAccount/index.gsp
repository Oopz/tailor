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
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addUser();">新建</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-edit',plain:true" onclick="editUser();">修改</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="enableUser();">激活</a>
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-no',plain:true" onclick="disableUser();">禁用</a>
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
					    				用户名：
										<span class="combo">
											<input name="username"
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
										url: '${createLink(action:'dataListAccounts')}?json',
										type: 'post', 
										data: param,
										success: function(data){success(data);},
										error: function(){error();}
									});
							    },
							    onDblClickRow:function(row){
							    	editUser();
							    },
				            	fit:true,border:false,idField:'id',nowrap:true
				            	">
					        <thead>
					            <tr>
					                <th data-options="field:'username',width:1,align:'center'">用户名</th>
					                <th data-options="field:'userAlias',width:3,align:'center'">姓名</th>
					                <th data-options="field:'userRole',width:3,align:'center',formatter:userRoleFormatter">角色</th>
					                <th data-options="field:'userMemo',width:3,align:'center'">备注</th>
					                <th data-options="field:'enabled',width:3,align:'center',formatter:enabledFormatter">状态</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		</div>
		
		
	    <!-- Detail Dialog-->
	    <div id="userDetail" class="easyui-dialog" title="创建/修改" style="width:370px;height:240px;padding:5px;"
		        data-options="iconCls:'tree-file',modal:true,collapsible:false,minimizable:false,
		        maximizable:false,closed:true,buttons:'#bb'">
		    <form id="detailForm" method="post">
		    	<input name="id" type="hidden" />
		    	
				<table style="width: 100%;">
					<tr>
						<td>用户名：</td>
						<td>
							<span class="combo">
								<input name="username" class="combo-text easyui-validatebox" 
									style="width:270px;" 
									data-options="required:true,validType:['length[1,1000]','plain']" />
							</span>
						</td>
					</tr>
					<tr>
						<td>密码：</td>
						<td>
							<span class="combo">
								<input type="password" name="password" class="combo-text easyui-validatebox" 
									style="width:120px;" 
									data-options="validType:['password','length[1,40]']" />
								<label style="color:red;">(不修改请留空)</label>
							</span>
						</td>
					</tr>
					<tr>
						<td>角色：</td>
						<td>
		    				<g:select name="userRole" from="${userRoles}" optionKey="id" optionValue="roleName"
		    				 	class="easyui-combobox userRole" 
		    				 	data-options="panelHeight:'auto',editable:false,required:true" 
		    				 	style="min-width:120px;"/>
						</td>
					</tr>
					<tr>
						<td>姓名：</td>
						<td>
							<span class="combo">
								<input name="userAlias" class="combo-text easyui-validatebox" 
									style="width:270px;" 
									data-options="validType:['length[0,1000]','plain']"/>
							</span>
						</td>
					</tr>
					<tr>
						<td>备注：</td>
						<td>
							<span class="combo">
								<input name="userMemo" class="combo-text easyui-validatebox" 
									style="width:270px;" 
									data-options="validType:['length[0,1000]','plain']"/>
							</span>
						</td>
					</tr>
				</table>
			</form>
		    
			<div id="bb">
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="submitSaveUser();">保存</a>
				<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel'" onclick="$('#userDetail').dialog('close');">关闭</a>
			</div>
		</div>
		
		
		
	</body>

<r:script>
function userRoleFormatter(value,row,index) {
	if(row.userRole) {
		return row.userRole.roleName;
	}else{
		return '';
	}
}

function enabledFormatter(value,row,index) {
	if(value==true) {
		return '<label style="color:green;">已激活</label>';
	}
	return '<label style="color:#aaa;">已禁用</label>';
}

function submitSaveUser() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	if(param.id == '' && param.password == '') {
		$.messager.alert('提示','请填写新用户的密码','info');
		return;
	}
	
	// send request
	if($('#detailForm').form('validate')) {
		showProgress();
		$.ajax({
			url: "${createLink(action:'dataSaveUser')}?json",
			type: "post",
			data: param
		}).done(function(data,textStatus,jqXHR) {
			hideProgress();
			if(data.state=="success") {
				$('#userDetail').dialog('close');
				
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

function changeUserState(id, state) {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	showProgress();
	$.ajax({
		url: "${createLink(action:'dataChangeUserState')}?json",
		type: "post",
		data: {
			id:id,
			state:state
		},
	}).done(function(data,textStatus,jqXHR) {
		hideProgress();
		if(data.state=="success") {
			$('#dg').datagrid('reload');
		}else{
			$.messager.alert('错误',data.message,'error');
		}
	}).fail(function(jqXHR,textStatus,errorThrown) {
		hideProgress();
	});
}

function addUser() {
	$('#userDetail').dialog('setTitle', '创建用户信息').dialog('open');
	resetForm();
}

function enableUser() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		changeUserState(row.id, 'enable');
	}
}

function disableUser() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		changeUserState(row.id, 'disable');
	}
}

function editUser() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		$('#userDetail').dialog('setTitle', '修改用户信息').dialog('open');
		resetForm();
		
		$('#detailForm').find('[name="id"]').val(row.id);
		$('#detailForm').find('[name="username"]').val(row.username);
		$('#detailForm').find('[name="userAlias"]').val(row.userAlias);
		$('#detailForm').find('[name="userMemo"]').val(row.userMemo);
		
		row.userRole && $("#detailForm").find(".userRole").combobox("select",row.userRole.id);
		
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
