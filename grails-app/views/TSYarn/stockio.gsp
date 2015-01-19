<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	<body>
	    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
		    <div data-options="region:'west',border:true" style="width:240px;">
			    <table id="dg" class="easyui-datagrid" pagination="true"
		            data-options="singleSelect:true,fitColumns:true,striped:true,collapsible:false,pageSize:50,pageList:[10,50,100],
		            	loader:function(param,success,error){
					        jQuery.ajax({
								url: 'dataListOrders?json&type='+'${params.type}',
								type: 'post', 
								data: param,
								success: function(data){success(data);},
								error: function(){error();}
							});
					    },
		            	fit:true,border:false,idField:'id',toolbar:'#tb',
		            	onSelect:function(rowIndex, rowData) {
		            		var tabTitle = genTabTitle(rowData.id, rowData.orderNumber);
		            		var tab = $('#tabs').tabs('getTab', tabTitle);
		            		if(tab) {
		            			$('#tabs').tabs('select', tabTitle);
		            		}else{
			            		$('#tabs').tabs('add',{
								    title:tabTitle,
								    href:'orderView/'+rowData.id+'?json',
								    cache:true,
								    closable:true
								});
		            		}
		            	},
		            	onRowContextMenu:function(e, rowIndex, rowData) {
							e.preventDefault();
							$(this).datagrid('selectRow',rowIndex);
							$('#mm').menu('show',{
								left: e.pageX,
								top: e.pageY
							});
		            	}
		            	">
			        <thead>
			            <tr>
			                <th data-options="field:'orderNumber',width:80,align:'center'">编号</th>
			            </tr>
			        </thead>
			    </table>
			</div>
		    <div id="mm" class="easyui-menu" style="width:80px;">
		        <div onclick="delOrderInfo()" data-options="iconCls:'icon-remove'">作废</div>
		    </div>
	
		    <div data-options="region:'center',collapsible:false">
		    	<div id="tabs" class="easyui-tabs" 
		    		data-options="
		    		fit:true,border:false,tabPosition:'top',
					onLoad:function(panel){
						//do not care about orderView, coz no forms in it
						var form=$(panel).find('form').first();
						if(form.length>0 && !hasAnyItem(form)) addMoreItem(form);
					}" style="background:#eee;">
			    </div>
			</div>
		</div>
		
		
		<div id="tb" style="text-align:right;background:#E0ECFF;">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="newSample()">新建</a>
		</div>
		
	</body>
	
	
<r:script>
$(function(){
	var pager=$('#dg').datagrid('getPager');
	pager.pagination({layout:['first','prev','manual','next','last','refresh'],displayMsg:''});
});

function genTabTitle(id, number) {
	return '['+id+'] '+number;
}

function newSample() {
	$('#tabs').tabs('add',{
	    title:'新建',
	    href:'orderEdit?json&type='+'${params.type}',
	    cache:true,
	    closable:true
	});
}

function addMoreItem(form) {
	var accordions = $(form).find('.easyui-accordion');
	accordions.accordion('add', {
		href:'orderItem',
		collapsed: false,
		collapsible: false
	});
}

function hasAnyItem(form) {
	var accordions = $(form).find('.easyui-accordion');
	if($(accordions).accordion('panels').length == 0) return false;
	else return true;
}

function saveSampleInfo(form) {
	var itemCount = 0;

	var combogrids = $(form).find(".easyui-combogrid");
	for(var i=0; i < combogrids.length; i++) {
		var element = combogrids[i];
		
		var g = $(element).combogrid('grid');
		var r = g.datagrid('getSelected');
		
		if(!r && $.trim($(element).combogrid('getValue')) != "") {
			$.messager.alert('提示','存在无效的仓库项，请更正','info');
			return;
		}else if($.trim($(element).combogrid('getValue')) != ""){
			++itemCount;
		}
	}
	
	if(!itemCount) {
		$.messager.alert('提示','至少需要一个仓库项','info');
		return;
	}

	$(form).form('submit',{
		url:"${createLink(action:'dataSaveOrder')}?json",
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
				var tab = $('#tabs').tabs('getSelected');
				var index = $('#tabs').tabs('getTabIndex',tab);
				
				$('#tabs').tabs('update', {
					tab:tab, 
					options:{
						title:genTabTitle(data.data.id, data.data.orderNumber),
						href:'orderView/'+data.data.id+'?json'
					}
				});
				tab.panel('refresh');
				
				reloadData();
			}else{
				$.messager.alert('错误',data.message,'error');
			}
	    }
	});
}

function delOrderInfo() {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	if('' != row.id) {
		$.messager.confirm('确认', '此操作将对库存进行回滚，要将该记录作废吗？', function(r){
			if (r){
				showProgress();
				$.ajax({
					url: "${createLink(action:'dataDelOrder')}?json",
					type: "post",
					data: {id:row.id},
				}).done(function(data,textStatus,jqXHR) {
					hideProgress();
					if(data.state=="success") {
						$('#dg').datagrid('reload');
						
	            		var tabTitle = genTabTitle(data.data.id, data.data.orderNumber);
	            		var tab = $('#tabs').tabs('getTab', tabTitle);
	            		if(tab) {
	            			$('#tabs').tabs('close', tabTitle);
	            		}
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

function reloadData() {
	$("#dg").datagrid("reload");
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
