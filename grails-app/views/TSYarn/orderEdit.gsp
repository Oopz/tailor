<%@ page contentType="text/html;charset=UTF-8"%>
<div class="easyui-panel" data-options="fit:true,border:false" style="padding:10px;text-align:center;background:#eee;">
	<form method="post">
		<div style="display: inline-block; width: 600px;">
			<div class="easyui-panel" 
				style="background: #fff; padding: 20px;">
				<input type="hidden" name="orderType" value="${params?.type}"/>
				<table style="width: 100%;">
					<tr>
						<td>编号：</td>
						<td>
							<span class="combo">
								<input name="orderNumber"
								class="combo-text easyui-validatebox"
								data-options="required:true,validType:'length[1,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>类型：</td>
						<td>${params?.type=='in'?'进货单':'出货单'}</td>
					</tr>
					<tr>
						<td>${params?.type=='in'?'供应商：':'收货单位：'}</td>
						<td>
							<span class="combo">
								<input name="orderContact"
								class="combo-text easyui-validatebox"
								data-options="required:true,validType:'length[1,1000]'" />
							</span>
						</td>
					</tr>
					<tr>
						<td>日期：</td>
						<td>
							<input name="orderDate"
							class="easyui-datebox"
							data-options="required:true,editable:false" style="width:120px;" />
						</td>
					</tr>
					<tr>
						<td>${params?.type=='in'?'进货项：':'出货项：'}</td>
						<td>
							<div class="easyui-panel" style="width:440px;" data-options="
								border:false">
								<div class="easyui-accordion" data-options="multiple:true,border:true" style="border-bottom-width:0;">
								</div>
								<div class="easyui-panel" data-options="fit:false" style="border-top-width:0;padding:10px;text-align:center;">
									<a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" 
										onclick="addMoreItem($(this).parents('form').first());return false;">添加项...</a>
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

