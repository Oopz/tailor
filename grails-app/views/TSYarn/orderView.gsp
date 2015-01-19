<%@ page contentType="text/html;charset=UTF-8"%>
<div class="easyui-panel" data-options="fit:true,border:false" style="padding:10px;text-align:center;background:#eee;">
	<div style="display: inline-block; width: 600px;">
		<div class="easyui-panel" 
			style="background: #fff; padding: 20px;">
			<table style="width: 100%;">
				<tr>
					<td style="min-width:80px;">编号：</td>
					<td>${bean?.orderNumber?.encodeAsHTML()}</td>
				</tr>
				<tr>
					<td>类型：</td>
					<td>${bean?.orderType=='in'?'进货单':'出货单'}</td>
				</tr>
				<tr>
					<td>${bean?.orderType=='in'?'供应商':'收货单位'}：</td>
					<td>${bean?.orderContact?.encodeAsHTML()}</td>
				</tr>
				<tr>
					<td>日期：</td>
					<td><g:formatDate date="${bean?.orderDate}"/></td>
				</tr>
				<tr>
					<td>明细：</td>
					<td>
						<table style="width:100%;word-break:break-all;">
							<tr>
								<th style="width:60px;">纱种</th>
								<th style="width:60px;">纱支</th>
								<th style="width:60px;">色号</th>
								<th style="width:60px;">缸号</th>
								<th style="width:40px;">重量</th>
								<th style="width:40px;">件数</th>
								<th>备注</th>
							</tr>
							
							<g:each in="${bean?.orderYarnLogs}">
								<tr>
									<td>${it.logYarn?.yarnType?.encodeAsHTML()}</td>
									<td>${it.logYarn?.yarnCount?.encodeAsHTML()}</td>
									<td>${it.logYarn?.yarnHue?.encodeAsHTML()}</td>
									<td>${it.logYarn?.yarnJar?.encodeAsHTML()}</td>
									<td>${it.logWeight}</td>
									<td>${it.logTotal}</td>
									<td>${it.logMemo?.encodeAsHTML()}</td>
								</tr>
							</g:each>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: center; padding-top: 20px;">
						<a href="${createLink('action':'reportStockio',id:bean?.id,params:['type':bean?.orderType])}" target="_blank" 
							class="easyui-linkbutton" data-options="iconCls:'icon-print'">打印</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
</div>

