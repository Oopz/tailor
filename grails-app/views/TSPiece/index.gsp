<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	<body>
	    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
	
		    <div data-options="region:'north',title:'布仓',collapsible:false,border:true" style="height:130px;background:#E0ECFF;padding:5px;">
		    	<form id="filterForm">
			    	<table class="filterTable" style="width:100%;">
			    		<tr>
			    			<td class="left">编号：</td><td class="right"><input name="pieceNumber" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td class="left">颜色：</td><td class="right"><input name="pieceColor" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td class="left">布种：</td><td class="right"><input name="pieceType" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    		</tr>
			    		<tr>
			    			<td class="left">成分：</td><td class="right"><input name="pieceMaterial" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
			    			<td class="left">织造工厂：</td><td class="right"><input name="pieceFactory" class="easyui-combobox value" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
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
								url: 'dataListPieces?json',
								type: 'post', 
								data: param,
								success: function(data){success(data);},
								error: function(){error();}
							});
					    },
		            	fit:true,border:false,idField:'id',toolbar:'#tb',
		            	onSelect:function(rowIndex, rowData) {
		            		showPieceInfo();
		            		$('#dg2').datagrid('load');
		            	}
		            	">
			        <thead>
			            <tr>
			                <th data-options="field:'pieceNumber',width:80,align:'center'">编号</th>
			                <th data-options="field:'pieceColor',width:80,align:'center'">颜色</th>
			                <th data-options="field:'pieceType',width:80,align:'center'">布种</th>
			                <th data-options="field:'pieceMaterial',width:60,align:'center'">成分</th>
			                <th data-options="field:'pieceYarn',width:80,align:'center'">纱线组成</th>
			                <th data-options="field:'pieceWeight',width:60,align:'center'">克重</th>
			                <th data-options="field:'pieceWidth',width:80,align:'center'">门幅</th>
			                <th data-options="field:'pieceStock',width:80,align:'center'">库存总重</th>
			                <th data-options="field:'pieceFactory',width:80,align:'center'">织造工厂</th>
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
				        			<td>编号：</td>
				        			<td><input name="pieceNumber" class="easyui-combobox pieceNumber" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>颜色：</td>
				        			<td><input name="pieceColor" class="easyui-combobox pieceColor" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>布种：</td>
				        			<td><input name="pieceType" class="easyui-combobox pieceType" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>成分：</td>
				        			<td><input name="pieceMaterial" class="easyui-combobox pieceMaterial" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>纱线组成：</td>
				        			<td><input name="pieceYarn" class="easyui-combobox pieceYarn" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>克重：</td>
				        			<td><input name="pieceWeight" class="easyui-combobox pieceWeight" value="0" data-options="hasDownArrow:false,panelHeight:'auto'"></td>
				        		</tr>
				        		<tr>
				        			<td>门幅：</td>
				        			<td><input name="pieceWidth" class="easyui-combobox pieceWidth" value="0" data-options="hasDownArrow:false,panelHeight:'auto'"></td>
				        		</tr>
				        		<tr>
				        			<td>库存重量：</td>
				        			<td><input name="pieceStock" class="easyui-numberspinner pieceStock" value="0" data-options="min:0,precision:2" style="width:80px;"></td>
				        		</tr>
				        		<tr>
				        			<td>织造工厂：</td>
				        			<td><input name="pieceFactory" class="easyui-combobox pieceFactory" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>工艺明细：</td>
				        			<td><input name="pieceMemo1" class="easyui-combobox pieceMemo1" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>面料特性简介：</td>
				        			<td><input name="pieceMemo2" class="easyui-combobox pieceMemo2" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td>备注：</td>
				        			<td><input name="pieceMemo3" class="easyui-combobox pieceMemo3" data-options="hasDownArrow:false,panelHeight:'auto'"/></td>
				        		</tr>
				        		<tr>
				        			<td></td>
				        			<td style="text-align:left;padding-top:20px;">
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="newPieceInfo();return false;">新建</a>
										<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'" onclick="savePieceInfo();return false;">保存</a>
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
													url: 'dataListPieceLogs?json',
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
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="delPieceInfo();return false;">删除</a>
			<!-- 
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-redo',plain:true" onclick="inStock();return false;">入货</a>
			<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-undo',plain:true" onclick="outStock();return false;">出仓</a>
			-->
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

function resetFilter() {
	$("#filterForm").find(".easyui-combobox").combobox("reset");
}

function showPieceInfo() {
	var row=$("#dg").datagrid('getSelected');
	
	if(row) {
		$('#detailForm input[name="id"]').val(row.id);
		$('#detailForm .pieceNumber').combobox('setValue',row.pieceNumber);
		$('#detailForm .pieceColor').combobox('setValue',row.pieceColor);
		$('#detailForm .pieceType').combobox('setValue',row.pieceType);
		$('#detailForm .pieceMaterial').combobox('setValue',row.pieceMaterial);
		$('#detailForm .pieceYarn').combobox('setValue',row.pieceYarn);
		$('#detailForm .pieceWeight').combobox('setValue',row.pieceWeight);
		$('#detailForm .pieceWidth').combobox('setValue',row.pieceWidth);
		$('#detailForm .pieceStock').numberspinner('setValue',row.pieceStock);
		$('#detailForm .pieceFactory').combobox('setValue',row.pieceFactory);
		$('#detailForm .pieceMemo1').combobox('setValue',row.pieceMemo1);
		$('#detailForm .pieceMemo2').combobox('setValue',row.pieceMemo2);
		$('#detailForm .pieceMemo3').combobox('setValue',row.pieceMemo3);
	}
}

function savePieceInfo() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	// send request
	if('' != param.id) {
		showProgress();
		$.ajax({
			url: "${createLink(action:'dataSavePieceInfo')}?json",
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

function newPieceInfo() {
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
				url: "${createLink(action:'dataSavePieceInfo')}?json",
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

function delPieceInfo() {
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
					url: "${createLink(action:'dataDelPieceInfo')}?json",
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
		$('#ioForm').find("input[name='logPiece']").val(row.id);
		$('#ioForm').find("[name='pieceNumber']").text(row.pieceNumber);
		$('#ioForm').find("[name='pieceColor']").text(row.pieceColor);
		$('#ioForm').find("[name='pieceType']").text(row.pieceType);
		$('#ioForm').find("[name='pieceMaterial']").text(row.pieceMaterial);
		
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
		$('#ioForm').find("input[name='logPiece']").val(row.id);
		$('#ioForm').find("[name='pieceNumber']").text(row.pieceNumber);
		$('#ioForm').find("[name='pieceColor']").text(row.pieceColor);
		$('#ioForm').find("[name='pieceType']").text(row.pieceType);
		$('#ioForm').find("[name='pieceMaterial']").text(row.pieceMaterial);
		
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
				$('#dg').datagrid('selectRecord', data.data.id);
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
