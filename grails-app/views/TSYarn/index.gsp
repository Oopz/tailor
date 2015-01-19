<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	<body>
	    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
	
		    <div data-options="region:'north',title:'纱仓',collapsible:false,border:true" style="height:130px;background:#E0ECFF;padding:5px;">
		    	<form id="filterForm">
			    	<table class="filterTable" style="width:100%;">
			    		<tr>
			    			<td class="left">纱种：</td><td class="right"><input name="yarnType" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td class="left">纱支：</td><td class="right"><input name="yarnCount" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td class="left">色号：</td><td class="right"><input name="yarnHue" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    		</tr>
			    		<tr>
			    			<td class="left">颜色：</td><td class="right"><input name="yarnColor" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td class="left">缸号：</td><td class="right"><input name="yarnJar" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td colspan="2"></td>
			    		</tr>
			    		<tr>
			    			<td colspan="6" style="text-align:center;">
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-search'" onclick="reloadData();return false;">查询</a>
								<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo'" onclick="resetFilter();return false;">重置</a>
			    			</td>
			    		</tr>
			    	</table>
		    	</form>
			</div>
			
		    <div data-options="region:'center',border:true">
			    <table id="dg" class="easyui-datagrid" pagination="true"
		            data-options="singleSelect:true,fitColumns:true,collapsible:false,pageSize:50,pageList:[10,50,100],
		            	loader:function(param,success,error){
		            		$('#filterForm').serializeArray().map(function(n){
		            			param[n.name]=n.value;
		            		});
					        jQuery.ajax({
								url: 'dataListYarns?json',
								type: 'post', 
								data: param,
								success: function(data){success(data);},
								error: function(){error();}
							});
					    },
		            	fit:true,border:false,idField:'id',toolbar:'#tb',
		            	onSelect:function(rowIndex, rowData) {
		            		showYarnInfo();
		            		$('#dg2').datagrid('load');
		            	}
		            	">
			        <thead>
			            <tr>
			                <th data-options="field:'yarnType',width:80,align:'center'">纱种</th>
			                <th data-options="field:'yarnCount',width:80,align:'center'">纱支</th>
			                <th data-options="field:'yarnHue',width:80,align:'center'">色号</th>
			                <th data-options="field:'yarnColor',width:60,align:'center'">颜色</th>
			                <th data-options="field:'yarnJar',width:80,align:'center'">缸号</th>
			                <th data-options="field:'yarnWeight',width:60,align:'center'">库存重量</th>
			                <th data-options="field:'yarnStock',width:80,align:'center'">库存件数</th>
			                <th data-options="field:'yarnSpace',width:80,align:'center'">仓位</th>
			            </tr>
			        </thead>
			    </table>
			</div>
	
		    <div data-options="region:'east',split:true,collapsible:false" style="width:420px;">
		    	<div class="easyui-tabs" data-options="fit:true,border:false">
			        <div title="详细信息" style="padding:10px">
		    			<form id="detailForm">
		    				<input type="hidden" name="id"/>
				        	<table style="width:100%;">
				        		<tr>
				        			<td>纱种：</td>
				        			<td><input name="yarnType" class="easyui-combobox yarnType" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>纱支：</td>
				        			<td><input name="yarnCount" class="easyui-combobox yarnCount" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>色号：</td>
				        			<td><input name="yarnHue" class="easyui-combobox yarnHue" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>颜色：</td>
				        			<td><input name="yarnColor" class="easyui-combobox yarnColor" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>缸号：</td>
				        			<td><input name="yarnJar" class="easyui-combobox yarnJar" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>库存重量：</td>
				        			<td><input name="yarnWeight" class="easyui-numberspinner yarnWeight" value="0" data-options="min:0,precision:2" style="width:80px;"></td>
				        		</tr>
				        		<tr>
				        			<td>库存件数：</td>
				        			<td><input name="yarnStock" class="easyui-numberspinner yarnStock" value="0" data-options="min:0,precision:0" style="width:80px;"></td>
				        		</tr>
				        		<tr>
				        			<td>仓位：</td>
				        			<td><input name="yarnSpace" class="easyui-combobox yarnSpace" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>纱线特性简介：</td>
				        			<td><input name="yarnMemo1" class="easyui-combobox yarnMemo1" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>备注：</td>
				        			<td><input name="yarnMemo2" class="easyui-combobox yarnMemo2" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td></td>
				        			<td style="text-align:left;padding-top:20px;">
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="newYarnInfo();return false;">新建</a>
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="saveYarnInfo();return false;">保存</a>
				        			</td>
				        		</tr>
				        	</table>
			        	</form>
			        </div>
			        
			        <div title="仓库日志">
			        	<div class="easyui-layout" data-options="fit:true">
		    				<div data-options="region:'center',collapsible:false,border:false" style="border-bottom-width:1px;">
							    <table id="dg2" class="easyui-datagrid" pagination="true"
						            data-options="singleSelect:true,fitColumns:true,collapsible:false,pageSize:50,pageList:[10,50,100],
						            	loader:function(param,success,error){
											var row=$('#dg').datagrid('getSelected');
											if(row) {
										        jQuery.ajax({
													url: 'dataListYarnLogs?json',
													type: 'post', 
													data: {id: row.id},
													success: function(data){success(data);},
													error: function(){error();}
												});
											}else{
												success([]);
											}
									    },
						            	fit:true,border:false,idField:'id',
						            	onSelect:function(rowIndex, rowData) {
						            		setDetailMemo(rowData.logMemo);
						            	}
						            	">
							        <thead>
							            <tr>
							                <th data-options="field:'logType',width:40,align:'center',formatter:logTypeFormatter">类型</th>
							                <th data-options="field:'logDate',width:80,align:'center'">日期</th>
							                <th data-options="field:'logTotal',width:40,align:'center'">件数</th>
							                <th data-options="field:'logProvider',width:60,align:'center'">供应商</th>
							                <th data-options="field:'lodReceiver',width:60,align:'center'">收货单位</th>
							                <th data-options="field:'logWeight',width:40,align:'center'">重量</th>
							            </tr>
							        </thead>
							    </table>
							</div>
		    				<div data-options="region:'south',split:true,border:false" style="height:200px;border-top-width:1px;">
							    <div class="easyui-panel" data-options="fit:true,border:false" style="padding:10px;word-break:break-all;word-wrap:break-word;background:#f0f0f0;">
							    	<p id="detailMemo"></p>
							    </div>
		    				</div>
						</div>
			        </div>
			        
			    </div>
			</div>
		</div>
		
		
		<div id="tb" style="text-align:right;background:#E0ECFF;">
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="delYarnInfo();return false;">删除</a>
			<!-- 
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true" onclick="inStock();return false;">入货</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true" onclick="outStock();return false;">出仓</a>
			 -->
		</div>
		
	    <div id="ioStock" class="easyui-dialog" title="进出仓处理" style="width:320px;"
		        data-options="iconCls:'icon-edit',modal:true,closed:true">
			<div class="easyui-panel" data-options="fit:true,border:false" style="padding:10px;background:#fafafa;">
				<form id="ioForm">
					<input type="hidden" name="logYarn"/>
					<input type="hidden" name="logType"/>
				
					<table style="width:100%;">
						<tr><td>纱种：</td><td><label name="yarnType"></label></td></tr>
						<tr><td>纱支：</td><td><label name="yarnCount"></label></td></tr>
						<tr><td>色号：</td><td><label name="yarnHue"></label></td></tr>
						<tr>
							<td>重量：</td>
							<td><input name="logWeight" class="easyui-numberspinner logWeight" value="0" data-options="min:0,precision:2" style="width:80px;"></td>
						</tr>
						<tr>
							<td>件数：</td>
							<td><input name="logTotal" class="easyui-numberspinner logTotal" value="0" data-options="min:0,precision:0" style="width:80px;"></td>
						</tr>
						<tr id="providerRow">
							<td>供应商：</td>
							<td><input name="logProvider" class="easyui-combobox logProvider" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
						</tr>
						<tr id="receiverRow" style="display:none;">
							<td>收货单位：</td>
							<td><input name="lodReceiver" class="easyui-combobox lodReceiver" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
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

function resetFilter() {
	$("#filterForm").find(".easyui-combobox").combobox("reset");
}

function showYarnInfo() {
	var row=$("#dg").datagrid('getSelected');
	
	if(row) {
		$('#detailForm input[name="id"]').val(row.id);
		$('#detailForm .yarnType').combobox('setValue',row.yarnType);
		$('#detailForm .yarnCount').combobox('setValue',row.yarnCount);
		$('#detailForm .yarnHue').combobox('setValue',row.yarnHue);
		$('#detailForm .yarnColor').combobox('setValue',row.yarnColor);
		$('#detailForm .yarnJar').combobox('setValue',row.yarnJar);
		$('#detailForm .yarnWeight').numberspinner('setValue',row.yarnWeight);
		$('#detailForm .yarnStock').numberspinner('setValue',row.yarnStock);
		$('#detailForm .yarnSpace').combobox('setValue',row.yarnSpace);
		$('#detailForm .yarnMemo1').combobox('setValue',row.yarnMemo1);
		$('#detailForm .yarnMemo2').combobox('setValue',row.yarnMemo2);
	}
}

function saveYarnInfo() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	// send request
	if('' != param.id) {
		showProgress();
		$.ajax({
			url: "${createLink(action:'dataSaveYarnInfo')}?json",
			type: "post",
			data: param
		}).done(function(data,textStatus,jqXHR) {
			hideProgress();
			if(data.state=="success") {
				var idx=$('#dg').datagrid('getRowIndex',data.data.id);
				$('#dg').datagrid('updateRow', {index:idx, row:data.data});
			}else{
				$.messager.alert('错误',data.message,'error');
			}
		}).fail(function(jqXHR,textStatus,errorThrown) {
			hideProgress();
		});
	}else{
		$.messager.alert('提示','请先选定一条记录','info');
	}
}

function newYarnInfo() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	delete param.id;
	
	// send request
	$.messager.confirm('确认', '要根据该数据创建新记录吗？', function(r){
		if (r){
			showProgress();
			$.ajax({
				url: "${createLink(action:'dataSaveYarnInfo')}?json",
				type: "post",
				data: param
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
	});
}

function setDetailMemo(memo) {
	$('#detailMemo').text(memo);
}

function delYarnInfo() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	// send request
	if('' != param.id) {
		$.messager.confirm('确认', '要删除该记录吗？', function(r){
			if (r){
				showProgress();
				$.ajax({
					url: "${createLink(action:'dataDelYarnInfo')}?json",
					type: "post",
					data: {id:param.id},
				}).done(function(data,textStatus,jqXHR) {
					hideProgress();
					if(data.state=="success") {
						
						var idx=$('#dg').datagrid('getRowIndex',data.data.id);
						$('#dg').datagrid('deleteRow', idx);
						
						$('#detailForm')[0].reset();
						$('#dg2').datagrid('loadData',[]);
						setDetailMemo("");
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

function inStock() {
	var row=$('#dg').datagrid('getSelected');
	if(row) {
		showIOStock('入仓');
		$('#ioForm').form('reset');
		$("#ioForm").find(".easyui-combobox").combobox("reset");
		$("#ioForm").find(".easyui-numberspinner").numberspinner("reset");
		
		$('#ioForm').find("input[name='logType']").val("in");
		$('#ioForm').find("input[name='logYarn']").val(row.id);
		$('#ioForm').find("[name='yarnType']").text(row.yarnType);
		$('#ioForm').find("[name='yarnCount']").text(row.yarnCount);
		$('#ioForm').find("[name='yarnHue']").text(row.yarnHue);
		
		$("#providerRow").show();
		$("#receiverRow").hide();
		
	}else{
		$.messager.alert('提示','请先选定一条记录','info');
	}
}

function outStock() {
	var row=$('#dg').datagrid('getSelected');
	if(row) {
		showIOStock('出仓');
		$('#ioForm').form('reset');
		$("#ioForm").find(".easyui-combobox").combobox("reset");
		$("#ioForm").find(".easyui-numberspinner").numberspinner("reset");
		
		$('#ioForm').find("input[name='logType']").val("out");
		$('#ioForm').find("input[name='logYarn']").val(row.id);
		$('#ioForm').find("[name='yarnType']").text(row.yarnType);
		$('#ioForm').find("[name='yarnCount']").text(row.yarnCount);
		$('#ioForm').find("[name='yarnHue']").text(row.yarnHue);
		
		$("#receiverRow").show();
		$("#providerRow").hide();
		
		
	}else{
		$.messager.alert('提示','请先选定一条记录','info');
	}
}

function saveStockIO() {
	var param={};
	$('#ioForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	// send request
	if('' != param.id) {
		showProgress();
		$.ajax({
			url: "${createLink(action:'dataSaveStockIO')}?json",
			type: "post",
			data: param,
		}).done(function(data,textStatus,jqXHR) {
			hideProgress();
			if(data.state=="success") {
				$('#ioStock').dialog('close');
				
				var idx=$('#dg').datagrid('getRowIndex',data.data.id);
				$('#dg').datagrid('updateRow', {index:idx, row:data.data});
				//$('#dg').datagrid('unselectRow', idx);
				$('#dg').datagrid('selectRecord', data.data.id);//unselectRow
			}else{
				$.messager.alert('错误',data.message,'error');
			}
		}).fail(function(jqXHR,textStatus,errorThrown) {
			hideProgress();
		});
	}else{
		$.messager.alert('提示','请先选定一条记录','info');
	}
}

function reloadData() {
	$("#dg").datagrid("reload");
}

function showIOStock(title) {
	$('#ioStock').dialog('open');
	$('#ioStock').dialog('setTitle', title || '');
}

function logTypeFormatter(value,row,index) {
	switch(value) {
		case 'in': return "<label class='green'>进</label>";
		case 'out': return "<label class='red'>出</label>";
	}
	return value;
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
