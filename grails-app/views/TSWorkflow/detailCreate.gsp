<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	<body>
	
	<div class="easyui-layout" id="mainFrame" data-options="fit:true" style="background:#eee;">
		<form method="post" id="detailForm" enctype="multipart/form-data">
		    <div data-options="region:'center',border:true">
			    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
				    <div data-options="region:'north',split:false,border:false" style="height:36px;background:#E0ECFF;padding:3px 20px;border-bottom-width:1px;">
					    <div style="padding:0px;text-align:right;">
					        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" onclick="goList();">返回</a>
					        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="submitSaveWorkflow();">保存</a>
					    </div>
				    </div>
				    
			    	<div data-options="region:'center',border:false">
			    		<div class="easyui-panel" data-options="border:false,fit:true">
				    		<div style="margin:5px;padding:10px;border:1px solid #eee;">
				    			<table style="width:100%;">
				    				<tr>
				    					<td>名称：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="workflowName" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${bean?.workflowName}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>工作流模型：</td>
				    					<td>
						    				<g:select id="workflowModel" name="workflowModel" from="${[['id':'', 'modelName':'-- 选择工作流模型 --']]+models}" 
						    					optionKey="id" optionValue="modelName"
						    				 	class="easyui-combobox workflowModel" 
						    				 	data-options="panelHeight:'auto',editable:false,onSelect:onChangeModel" 
						    				 	style="min-width:120px;"/>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>工作流特性（可选）：</td>
				    					<td>
				    						<span style="margin-right:20px;" class="easyui-tooltip" title="增加额外的初始化步骤，创建工作流后，你可以上传工作流所需要的附件">
					    						<label for="cb_mod_upload"><i class="fa fa-upload" style="margin-right:2px;color:green;"></i>上传附件</label>
					    						<input type="checkbox" value="true" name="workflowModUpload" id="cb_mod_upload">
				    						</span>
				    						
				    						<span style="margin-right:20px;" class="easyui-tooltip" title="在执行正式处理步骤时，系统将对所有有权进行处理的用户发送通知">
					    						<label for="cb_mod_notify"><i class="fa fa-envelope-o" style="margin-right:2px;color:green;"></i>系统通告</label>
					    						<input type="checkbox" value="true" name="workflowModNotify" id="cb_mod_notify" checked="checked">
				    						</span>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		
				    		<div style="margin:5px;padding:10px;border:1px solid #eee;">
					    		<div id="phasesPreview" class="easyui-panel"
								        style="padding:10px;height:auto;"
								        data-options="border:false">
								    <p>选择工作流模型，在此处预览步骤</p>
								</div>
							</div>
						</div>
			    	</div>
				</div>
		    </div>
	    </form>
	</div>
	
	<g:render template="js/detailCreate.js"></g:render>
	
	</body>
	
</html>
