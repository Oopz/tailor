<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	
	<body>
	    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
		    <div data-options="region:'north',split:false" style="height:36px;background:#E0ECFF;padding:3px 20px;">
			    <div style="padding:0px;text-align:right;">
			        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" 
			        	onclick="window.location.href='${createLink(controller:'TSPortal',action:'index')}'">返回</a>
			    </div>
		    </div>
		    
		    <div data-options="region:'center',border:true">
				<form method="post" id="detailForm">
				
				<input type="hidden" name="id" value="${bean?.id}">
				
	    		<div style="margin:5px;padding:10px;border:1px solid #eee;">
	    			<table style="width:100%;">
	    				<tr>
	    					<td>发送者：</td>
	    					<td>
	    						${bean?.messageSender?.encodeAsHTML()}
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>类型：</td>
	    					<td>
	    						${bean?.messageType?.encodeAsHTML()}
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>标题：</td>
	    					<td>
	    						${bean?.messageHead?.encodeAsHTML()}
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>内容：</td>
	    					<td>
	    						${bean?.messageBody?.encodeAsHTML()}
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>链接：</td>
	    					<td>
	    						<a href="${bean?.messageLink?.encodeAsHTML()}">点击打开</a>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td>创建时间：</td>
	    					<td>
		    					<g:formatDate format="yyyy-MM-dd HH:mm:ss" date="${bean?.messageDate}"/>
	    					</td>
	    				</tr>
	    			</table>
	    		</div>
	    		</form>
		   			
		    </div>
		</div>
		
	</body>
</html>
