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
								url: 'dataListSamples?json',
								type: 'post', 
								data: param,
								success: function(data){success(data);},
								error: function(){error();}
							});
					    },
		            	fit:true,border:false,idField:'id',toolbar:'#tb',
		            	onSelect:function(rowIndex, rowData) {
		            		var tabTitle = genTabTitle(rowData.id, rowData.fabricNumber);
		            		var tab = $('#tabs').tabs('getTab', tabTitle);
		            		if(tab) {
		            			$('#tabs').tabs('select', tabTitle);
		            		}else{
			            		$('#tabs').tabs('add',{
								    title:tabTitle,
								    href:'view/'+rowData.id+'?json',
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
			                <th data-options="field:'fabricNumber',width:80,align:'center'">编号</th>
			            </tr>
			        </thead>
			    </table>
			</div>
		    <div id="mm" class="easyui-menu" style="width:80px;">
		        <div onclick="delSampleInfo()" data-options="iconCls:'icon-remove'">删除</div>
		    </div>
	
		    <div data-options="region:'center',collapsible:false">
		    	<div id="tabs" class="easyui-tabs" data-options="
		    		fit:true,border:false,tabPosition:'top',
					onLoad:function(panel){
						//do not care about orderView, coz no forms in it
						var form=$(panel).find('form').first();
						if(form.length>0 && !hasAnyItem(form)) addMoreFile(form);
					}" style="background:#eee;">
			    </div>
			</div>
		</div>
		
		
		<div id="tb" style="text-align:right;background:#E0ECFF;">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="newSample()">新建</a>
		</div>
		
	    <div id="ioStock" class="easyui-dialog" title="进出仓处理" style="width:320px;"
		        data-options="iconCls:'icon-edit',modal:true,closed:true">
			<div class="easyui-panel" data-options="fit:true,border:false" style="padding:10px;background:#fafafa;">
				<form id="ioForm">
					<input type="hidden" name="logPiece"/>
					<input type="hidden" name="logType"/>
				
					<table style="width:100%;">
						<tr><td>编号：</td><td><label name="pieceNumber"></label></td></tr>
						<tr><td>颜色：</td><td><label name="pieceColor"></label></td></tr>
						<tr><td>布种：</td><td><label name="pieceType"></label></td></tr>
						<tr><td>成分：</td><td><label name="pieceMaterial"></label></td></tr>
						<tr>
							<td>重量：</td>
							<td><input name="logWeight" class="easyui-numberspinner logWeight" value="0" data-options="min:0,precision:2" style="width:80px;"></td>
						</tr>
						<tr>
							<td>事由简述：</td>
							<td><input name="logMemo" class="easyui-combobox logMemo" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
						</tr>
						<tr>
							<td colspan="2" style="text-align:center;padding-top:10px;">
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" onclick="saveStockIO();return false;">确定</a>
							</td>
						</tr>
					</table>
				</form>
			</div>        
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
	    href:'view?json',
	    cache:true,
	    closable:true
	});
}

var fileIdxCounter=0;
function addMoreFile(form) {
	var accordions = $(form).find('.easyui-accordion');//panels
	
	accordions.accordion('add', {
		title: '新文件',
		content: '<div style="padding:5px;"><input name="fabricThumbnail.'+fileIdxCounter+++'" type="file"/></div>',
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
	$(form).form('submit',{
		url:"${createLink(action:'dataSaveSample')}?json",
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
				if(form.find("input[name='id']").val() == '') {// new sample
					var tab = $('#tabs').tabs('getSelected');
					var index = $('#tabs').tabs('getTabIndex',tab);
					$('#tabs').tabs('update', {
						tab:tab, 
						options:{
							title:genTabTitle(data.data.id, data.data.fabricNumber),
							href:'view/'+data.data.id+'?json'
						}
					});
					tab.panel('refresh');
				}else{// old sample
					var tab = $('#tabs').tabs('getSelected');
					$('#tabs').tabs('update', {
						tab:tab, options:{
							title:genTabTitle(data.data.id, data.data.fabricNumber)
						}
					});
					tab.panel('refresh');
				}
				
				reloadData();
				
			}else{
				$.messager.alert('错误',data.message,'error');
			}
	    }
	});
}

function delSampleInfo() {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	if(row && '' != row.id) {
		$.messager.confirm('确认', '要删除该记录吗？', function(r){
			if (r){
				showProgress();
				$.ajax({
					url: "${createLink(action:'dataDelSample')}?json",
					type: "post",
					data: {id:row.id},
				}).done(function(data,textStatus,jqXHR) {
					hideProgress();
					if(data.state=="success") {
						$('#dg').datagrid('reload');
						
	            		var tabTitle = genTabTitle(data.data.id, data.data.fabricNumber);
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
