<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	
	<body>
	    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
		    <div data-options="region:'west',split:true,border:false" style="width:450px;">
	    		<div class="easyui-layout" data-options="fit:true">
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
							    onClickRow:function(row, data){
							    	$('#authorities').panel({href:'${createLink(action:'authorities')}/'+data.id});
							    },
				            	fit:true,border:false,idField:'id',nowrap:true
				            	">
					        <thead>
					            <tr>
					                <th data-options="field:'roleName',width:1,align:'center'">角色名</th>
					            </tr>
					        </thead>
					    </table>
			        </div>
	    		</div>
		    </div>
		    
		    <div data-options="region:'center',split:false">
	    		<div class="easyui-panel" id="authorities"
	    			data-options="fit:true,border:false" 
	    			style="background:#eee">
				</div>
		    </div>
		</div>
		
	</body>

<r:script>
function saveAuthorities(form) {
	var authorities=$('#tt').tree('getChecked');
	for(var i=0; i < authorities.length; i++) {
		var item=authorities[i];
		if($('#tt').tree('isLeaf', item.target)) {
			var element=$("<input type='hidden' name='authorities'>");
			$(element).val(item.id);
			$(form).append(element);
		}
	}
	
	$(form).form('submit',{
		url:"${createLink(action:'dataSaveAuthorities')}?json",
		onSubmit:function() {
			var isValid = $(this).form('validate');
			if (isValid){
				showProgress();
			}
			return isValid;
		},
	    success:function(data){
	    	hideProgress();
	    	var data = eval('(' + data + ')');  // change the JSON string to javascript object
			if(data.state=="success") {
				$('#authorities').panel('refresh');
			}else{
				$.messager.alert('错误',data.message,'error');
			}
	    }
	});
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
