<%@ page contentType="text/html;charset=UTF-8"%>
<div class="easyui-panel" data-options="fit:true,border:false" style="padding:10px;text-align:center;background:#eee;">
	<form id="detailForm_${bean?.id}" method="post" enctype="multipart/form-data">
		<div style="display: inline-block; width: 600px;">
			<div class="easyui-panel" 
				style="background: #fff; padding: 20px;">
				<input type="hidden" name="id" value="${bean?.id}"/>
				<table style="width: 100%;">
					<tr>
						<td>编号：</td>
						<td>
							<span class="combo">
								<input name="fabricNumber"
								value="${bean?.fabricNumber?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="required:true,validType:'length[1,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>颜色：</td>
						<td>
							<span class="combo">
								<input name="fabricColor"
								value="${bean?.fabricColor?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>布种：</td>
						<td>
							<span class="combo">
								<input name="fabricType"
								value="${bean?.fabricType?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>成分：</td>
						<td>
							<span class="combo">
								<input name="fabricMaterial"
								value="${bean?.fabricMaterial?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>纱线组成：</td>
						<td>
							<span class="combo">
								<input name="fabricYarn"
								value="${bean?.fabricYarn?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>克重：</td>
						<td>
							<span class="combo">
								<input name="fabricWeight"
								value="${bean?.fabricWeight?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>门幅：</td>
						<td>
							<span class="combo">
								<input name="fabricWidth"
								value="${bean?.fabricWidth?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>织造工厂：</td>
						<td>
							<span class="combo">
								<input name="fabricFactory"
								value="${bean?.fabricFactory?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>工艺明细：</td>
						<td>
							<span class="combo">
								<input name="fabricMemo1"
								value="${bean?.fabricMemo1?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>面料特性简介：</td>
						<td>
							<span class="combo">
								<input name="fabricMemo2"
								value="${bean?.fabricMemo2?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>备注：</td>
						<td>
							<span class="combo">
								<input name="fabricMemo3"
								value="${bean?.fabricMemo3?.encodeAsHTML()}"
								class="combo-text easyui-validatebox"
								data-options="validType:'length[0,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>缩略图：</td>
						<td>
							<div class="easyui-panel" data-options="border:false" style="width:400px;">
								<div class="easyui-accordion" data-options="multiple:true,border:true" style="border-bottom-width:0;">
									<g:each in="${bean?.fabricThumbnail}">
										<div title="${it?.fileOriginName?.encodeAsHTML()}" data-options="collapsed:false,collapsible:false" style="overflow:auto;padding:10px;">
											<div>
												<a href="${createLink(controller:'TSFile',action:'output',id:it.fileName)}" target="_blank">
													<img src="${createLink(controller:'TSFile',action:'output',id:it.fileName)}" style="max-width:100%;max-height:200px;">
												</a>
											</div>
											<div style="padding:5px;text-align:right;">
												<input type="checkbox" name="deletedThumbnails" value="${it?.fileName}" id="cb_del_${it.id}" />
												<label for="cb_del_${it.id}">删除</label>
											</div>
										</div>
									</g:each>
								</div>
								<div class="easyui-panel" data-options="fit:false" style="border-top-width:0;padding:10px;text-align:center;">
									<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" 
										onclick="addMoreFile($(this).parents('form').first());return false;">添加更多缩略图...</a>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="text-align: center; padding-top: 20px;">
							<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save'"
								onclick="saveSampleInfo($(this).parents('form').first());return false;">保存</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
</div>

