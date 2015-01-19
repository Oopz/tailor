<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
		<style type="text/css" media="screen">
		.phase{
			vertical-align:top;
			display:block;
			/*width:800px;*/
			min-height:80px;
			border:1px solid #eee;
			border-radius:4px;
			padding:5px;
			/*margin-right:40px;*/
			margin-bottom:80px;
		}
		.phaseBox {margin:10px;/*width:330px;float:left;*/}
		.phaseDetail {
			overflow:auto;
			word-break: break-all;
			padding:10px;
			margin-right:15px;
			margin-left:15px;
			border-radius: 4px;
			box-shadow: 2px 2px 4px #ccc;
			border: 1px solid #ccc;
		}
		.phase .phaseRow {
			margin:5px;
			height:1.5em;
		}
		.phaseHighlight_2 {
			border-width:2px;
			border-color:#e00;
			box-shadow:3px 3px 1px #ccc;
		}
		.phaseHighlight_1 {
			border-width:2px;
			border-color:#00e;
			box-shadow:3px 3px 1px #ccc;
		}
		.phaseHighlight_1 .ctitle {
			font-weight:bold;
		}
		.phaseFilePreview {
			max-width:100%;
		}
		.phaseFilePreview_IE_image {
			filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);
		}
		</style>
	</head>
	<body>
	
	<div class="easyui-layout" id="mainFrame" data-options="fit:true" style="background:#eee;">
		<form method="post" id="detailForm" enctype="multipart/form-data">
			<input type="hidden" name="id" value="${bean?.id}"/>
			<input type="hidden" name="version" value="${bean?.version}"/>
		    
		    <div data-options="region:'center',border:true">
			    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
				    <div data-options="region:'north',split:false,border:false" style="height:36px;background:#E0ECFF;padding:3px 20px;border-bottom-width:1px;">
					    <div style="padding:0px;text-align:right;">
					        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" onclick="goList();">返回</a>
					        <g:if test="${bean?.workflowCurrentPhase?.phaseAssignee?.id==currentUser?.id
								|| (bean?.workflowCurrentPhase?.phaseAssignee == null && bean?.workflowCurrentPhase?.phaseParticipants?.collect{it.id}?.contains(currentUser?.userRole?.id))}">
						        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-cancel',plain:true" onclick="openDialog('back');">返回上一步</a>
						        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-ok',plain:true" onclick="openDialog('next');">执行下一步</a>
					        </g:if>
					    </div>
				    </div>
				    
			    	<div data-options="region:'center',border:false">
			    		<div style="margin:5px;padding:10px;border:1px solid #eee;">
				    		<g:render template="js/projectInfo.template" model="['project':project]"></g:render>
			    		</div>
			    		
			    		<!-- 目前附件已经移至project  所以隐藏这段 -->
			    		<div style="margin:5px;padding:10px;border:1px solid #eee;display:none;">
			    			<table style="width:100%;">
			    				<tr>
			    					<td style="width:30%;">附件：</td>
			    					<td>
										<div class="easyui-panel" data-options="border:false">
											<div class="easyui-accordion" data-options="multiple:true,border:true" style="border-bottom-width:0;">
												<g:each in="${bean?.workflowAccessories}">
													<div title="${it?.fileOriginName?.encodeAsHTML()}" data-options="collapsed:false,collapsible:false" 
														style="overflow:auto;padding:10px;">
														<div>
															<a href="${createLink(uri:"/file/${it.fileName?.encodeAsHTML()}/${it.fileOriginName?.encodeAsHTML()}",absolute:true)}" 
																target="_blank">
																<g:if test="${it.fileType?.startsWith('image/')}">
																	<img src="${createLink(uri:"/file/${it.fileName?.encodeAsHTML()}/${it.fileOriginName?.encodeAsHTML()}",absolute:true)}"
																		alt="${it?.fileOriginName?.encodeAsHTML()}" 
																		style="max-width:100%;">
																</g:if>
																<g:else>
																	文件：${it?.fileOriginName?.encodeAsHTML()}
																</g:else>
															</a>
														</div>
														
														<g:if test="${bean?.workflowCurrentPhase?.phaseType=='upload'}">
															<div style="padding:5px;text-align:right;">
																<input type="checkbox" name="deletedAccessories" value="${it?.fileName}" id="cb_del_${it.id}" />
																<label for="cb_del_${it.id}">删除</label>
															</div>
														</g:if>
													</div>
												</g:each>
											</div>
											
											<g:if test="${bean?.workflowCurrentPhase?.phaseType=='upload'}">
												<div class="easyui-panel" data-options="fit:false" style="border-top-width:0;padding:10px;text-align:center;">
													<a id="addFileBtnBar" href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" 
														onclick="addMoreFile($(this).parents('form').first());return false;">添加更多附件...</a>
												</div>
											</g:if>
										</div>
			    					</td>
			    				</tr>
			    			</table>
			    		</div>
			    		
		    			<div id="phaseBox" class="phaseBox">
		    				<g:each in="${bean?.workflowPhases}" var="phase">
			    				<span id="phase-${phase?.id}" class="phase ${bean?.workflowCurrentPhase?.id==phase?.id ? 'phaseHighlight_1':''} ${phase?.phaseRejected?'phaseHighlight_2':''}">
			    					<div class="ctitle" style="border-bottom:1px solid #eee;text-align:center;">
		    							<g:if test="${phase?.phaseRejected}">
		    								<span class="fa-stack fa-lg">
												<i class="fa fa-file-o fa-stack-1x"></i>
												<i class="fa fa-ban fa-stack-1x" style="color:red;"></i>
											</span>
		    							</g:if>
		    							<g:elseif test="${bean?.workflowCurrentPhase?.id==phase?.id}">
		    								<span class="fa-stack">
												<i class="fa fa-pencil-square-o fa-lg" style="color:blue;"></i>
											</span>
		    							</g:elseif>
		    							<g:elseif test="${phase?.phaseFinished}">
		    								<span class="fa-stack">
												<i class="fa fa-check-square-o fa-lg" style="color:green;"></i>
											</span>
		    							</g:elseif>
		    							<g:else>
		    								<span class="fa-stack">
												<i class="fa fa-file-o fa-1x"></i>
											</span>
		    							</g:else>
		    							
			    						<g:if test="${phase?.phaseIndex>=0}">
			    							${bean?.workflowName?.encodeAsHTML()} - 步骤 - ${phase?.phaseIndex}
			    						</g:if>
			    						<g:else>初始化步骤</g:else>
			    					</div>
			    					<div class="phaseRow">执行步骤：${phase?.phaseName}</div>
		    						<div class="phaseRow">执行角色：${phase?.phaseParticipants?.collect{it.roleName}?.join(', ')}</div>
		    						<div class="phaseRow">指定用户：
			    						<g:if test="${phase.phaseAssignee}">
		    								<i class="fa fa-user" style="margin-right:2px;color:blue;"></i>
		    								[${phase?.phaseAssignee?.username}] ${phase?.phaseAssignee?.userAlias}
			    						</g:if>
			    						<g:else>
			    							<i class="fa fa-users" style="margin-right:2px;color:green;"></i>
			    							该角色的所有用户
			    						</g:else>
		    						</div>
		    						
				    				<div class="phaseDetail">
				    					<g:if test="${phase?.phaseFields}">
							    		<!-- 列出当前步骤的参数 Begin -->
							    		<g:if test="${bean?.workflowCurrentPhase?.id==phase?.id}">
							    			<g:set var="fieldsReadonly" value="false" scope="page"></g:set>
							    		</g:if>
							    		<g:else>
							    			<g:set var="fieldsReadonly" value="true" scope="page"></g:set>
							    		</g:else>
							    		
							    		<table style="width:100%;">
											<g:each in="${phase?.phaseFields?.sort{it?.fieldIndex}}" var="field">
												<tr style="height:24px;">
													<td style="width:120px;white-space:nowrap;">${field?.fieldName?.encodeAsHTML()}：</td>
													<td>
														<g:if test="${field?.fieldType=='input'}">
															<span class="combo" style="width:320px;">
																<!-- 用g:textField就不用encodeAsHTML()了 -->
																<g:textField name="fieldValue-${field?.id}" style="width:316px;"
																	class="combo-text easyui-validatebox" 
																	value="${field?.fieldValueString}" 
																	readonly="${fieldsReadonly}"
																	disabled="${fieldsReadonly}"
																	data-options="required:false,validType:['length[1,1000]','plain']"/>
															</span>
														</g:if>
														<g:elseif test="${field?.fieldType=='number'}">
															<g:textField name="fieldValue-${field?.id}" 
																class="easyui-numberspinner" 
																value="${field?.fieldValueFloat}"
																disabled="${fieldsReadonly}"
																data-options="precision:2" style="width:80px;" />
														</g:elseif>
														<g:elseif test="${field?.fieldType=='boolean'}">
															<g:select name="fieldValue-${field?.id}" from="${[['id':'true','text':'是'],['id':'false','text':'否']]}" 
																optionKey="id" optionValue="text"
															 	value="${field?.fieldValueBoolean}"
															 	readonly="${fieldsReadonly}"
															 	disabled="${fieldsReadonly}"
															 	class="easyui-combobox"
															 	data-options="panelHeight:'auto',editable:false" 
															 	style="min-width:80px;"/>
														</g:elseif>
														<g:elseif test="${field?.fieldType=='textbox'}">
															<g:textArea name="fieldValue-${field?.id}" 
																value="${field?.fieldValueString}"
																readonly="${fieldsReadonly}"
																disabled="${fieldsReadonly}"
																cols="80" rows="10" 
																style="border:1px solid #95B8E7;"></g:textArea>
														</g:elseif>
														<g:elseif test="${field?.fieldType=='date'}">
															<g:textField name="fieldValue-${field?.id}" 
																class="easyui-datebox" 
																data-options="editable:false,buttons:HC_DATEBOX_BUTTONS" 
																value="${formatDate(format:'yyyy-MM-dd',date:field?.fieldValueDate)}"
																readonly="${fieldsReadonly}"
																disabled="${fieldsReadonly}"
																style="width:160px;" />
														</g:elseif>
														<g:else>
															&lt;未知的类型&gt;
														</g:else>
													</td>
												</tr>
											</g:each>
										</table>
										<!-- 列出当前步骤的参数 End -->
										</g:if>
										<g:else>
											<label style="color:#777;">无自定义参数</label>
										</g:else>
				    				</div>
			    					
			    					<div style="border-top:1px solid #ccc;margin-top:5px;">
				    					<g:if test="${phase.phaseOwner}">
				    						<div class="phaseRow">
					    						<span style="margin-right:20px;">操作用户：[${phase?.phaseOwner?.username}] ${phase?.phaseOwner?.userAlias}</span>
					    						<span>操作备注：${phase?.phaseComment}</span>
				    						</div>
				    					</g:if>
				    					<g:if test="${phase.phaseExcutedDate}">
				    						<div class="phaseRow">操作日期：<g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${phase?.phaseExcutedDate}"/></div>
				    					</g:if>
			    					</div>
			    				</span>
		    				</g:each>
		    			</div>
			    		
			    	</div>
				</div>
		    </div>
		</form>
	</div>

	<div class="easyui-dialog" style="padding:10px;width:420px;" id="phaseCommentDialog"
		data-options="title:'操作备注',buttons:'#phaseCommentBtn',modal:true,closed:true">
		<form id="phaseCommentForm">
			<div style="margin-bottom:5px;">
				操作类型：<span id="phaseSubmitType">N/A</span>
			</div>
			
			<div>
				操作备注：<span class="combo" style="width:320px;">
					<input name="phaseComment" style="width:316px;"
						class="combo-text easyui-validatebox" 
						value=""
						data-options="required:false,validType:['length[1,1000]','plain']"/>
				</span>
			</div>
		</form>
	</div>
	<div id="phaseCommentBtn">
		<a href="#" class="easyui-linkbutton" id="submitButton">
			<i class="fa fa-check" style="font-size:16px;margin-right:2px;color:green;"></i>提交
		</a>
		<a href="#" class="easyui-linkbutton" onclick="$('#phaseCommentDialog').dialog('close');return false;">
			<i class="fa fa-times" style="font-size:16px;margin-right:2px;color:red;"></i>关闭
		</a>
	</div>
	
	
	<g:render template="js/detailUpdate.js" model="['workflow':bean]"></g:render>
	
	</body>
	
</html>
