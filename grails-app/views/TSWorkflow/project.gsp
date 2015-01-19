<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
		<style>
		.workflowList {list-style:upper-roman;}
		.workflowList > li{min-height:2.5em;border-bottom: 1px dashed #ccc;margin-bottom: 20px;}
		.projectFilePreview {
			max-width:100%;
		}
		.projectFilePreview_IE_image {
			filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);
		}
		</style>
	</head>
	<body>
	
	<div class="easyui-layout" id="mainFrame" data-options="fit:true" style="background:#eee;">
		<form method="post" id="detailForm" enctype="multipart/form-data">
			<input type="hidden" name="id" value="${project?.id}">
		
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
				    					<td>业务单号：</td>
				    					<td>
				    						<label>
					    						<g:if test="${project?.id}">${project?.projectNumber}</g:if>
					    						<g:else>&lt;新建&gt;</g:else>
				    						</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>业务单名称：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="projectName" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${project?.projectName}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>客户名称：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="projectCustomer" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${project?.projectCustomer}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>公司款号：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="projectInnerNumber" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${project?.projectInnerNumber}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>客户款号：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="projectOuterNumber" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${project?.projectOuterNumber}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>色组：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="projectColors" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${project?.projectColors}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>款式描述：</td>
				    					<td>
											<span class="combo" style="width:320px;">
												<input name="projectDesc" style="width:316px;"
													class="combo-text easyui-validatebox" 
													value="${project?.projectDesc}"
													data-options="required:false,validType:['length[1,1000]','plain']"/>
											</span>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>下单数：</td>
				    					<td>
											<g:textField name="projectAmount" 
												class="easyui-numberspinner" 
												value="${project?.projectAmount}"
												data-options="precision:0" style="width:80px;" />
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>成衣交期：</td>
				    					<td>
											<input name="projectDate1" class="easyui-datebox" data-options="editable:false,buttons:HC_DATEBOX_BUTTONS" 
												value="${formatDate(format:'yyyy-MM-dd',date:project?.projectDate1)}"
												style="width:160px;" />
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>要求面料交期：</td>
				    					<td>
											<input name="projectDate2" class="easyui-datebox" data-options="editable:false,buttons:HC_DATEBOX_BUTTONS" 
												value="${formatDate(format:'yyyy-MM-dd',date:project?.projectDate2)}"
												style="width:160px;" />
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>附件：</td>
				    					<td>
											<div class="easyui-panel" data-options="border:false">
												<div class="easyui-accordion" data-options="multiple:true,border:true" style="border-bottom-width:0;">
													<g:each in="${project?.projectAccessories}">
														<div title="${it?.fileOriginName?.encodeAsHTML()}" data-options="collapsed:false,collapsible:false" 
															style="overflow:auto;padding:10px;">
															<div>
																<a href="${createLink(uri:"/file/${it.fileName?.encodeAsHTML()}/${it.fileOriginName?.encodeAsHTML()}",absolute:true)}" 
																	target="_blank">
																	<g:if test="${it.fileType?.startsWith('image/')}">
																		<img src="${createLink(uri:"/file/${it.fileName?.encodeAsHTML()}/${it.fileOriginName?.encodeAsHTML()}?size=600",absolute:true)}"
																			alt="${it?.fileOriginName?.encodeAsHTML()}" 
																			style="max-height:600px;max-width:600px;"><!-- max-width:100%; -->
																	</g:if>
																	<g:else>
																		文件：${it?.fileOriginName?.encodeAsHTML()}
																	</g:else>
																</a>
															</div>
															
															<div style="padding:5px;text-align:right;">
																<input type="checkbox" name="deletedAccessories" value="${it?.fileName}" id="cb_del_${it.id}" />
																<label for="cb_del_${it.id}">删除</label>
															</div>
														</div>
													</g:each>
												</div>
												<div class="easyui-panel" data-options="fit:false" style="border-top-width:0;padding:10px;text-align:center;">
													<a id="addFileBtnBar" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" 
														onclick="addMoreFile($(this).parents('form').first());return false;">添加更多附件...</a>
												</div>
											</div>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    		
				    		<div style="margin:5px;padding:10px;border:1px solid #eee;">
				    			<ul class="workflowList">
				    				<g:each in="${project?.projectWorkflows?.sort{it.id}}" var="workflow">
										<g:render template="js/workflow.template" model="['asTemplate':false, 'models':models, 'bean':workflow, 'noModel':true, 'noDelete':true]"></g:render>
				    				</g:each>
				    			</ul>
				    			
				    			<div style="text-align:center;">
				    				<a href="#" onclick="addWorkflow();return false;">点击添加工作流</a>
				    			</div>
							</div>
						</div>
			    	</div>
				</div>
		    </div>
	    </form>
	</div>
	
	
	<ul style="display:none;">
		<g:render template="js/workflow.template" model="['asTemplate':true, 'models':models]"></g:render>
	</ul>
    				
    				
	<g:render template="js/project.js"></g:render>
	
	</body>
	
</html>
