<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
	</head>
	
	<body>
		<div class="easyui-layout" data-options="fit:true">
			<div region="west" style="width:280px;background:none;border-right-width:10px;border-right-color:#eee;overflow:visible;" border="false">
				<div class="easyui-panel" title="公告" style="background:#f3eeaf;padding:5px;" data-options="border:true">
					<div style="text-align:left;">
				    	<div><a href="#">Place Holder</a></div>
				    	<div><a href="#">Place Holder</a></div>
				    	<div><a href="#">Place Holder</a></div>
				    	<div><a href="#">Place Holder</a></div>
				    	<div><a href="#">Place Holder</a></div>
				    	<div><a href="#">Place Holder</a></div>
			    	</div>
			    </div>
			    
			    <br/>
			    
				<div class="easyui-panel" title="提示" style="background:#f3eeaf;padding:5px;" data-options="border:true">
					<div style="text-align:left;">
						<i class="fa fa-warning" style="color:red;margin-right:2px;"></i>点击消息标题，查看详细内容
			    	</div>
			    </div>
			</div>
			
			<div region="center" style="background:#eaeaea;">
				<div class="easyui-panel" title="您当前收到的所有消息" data-options="fit:true,border:false">
					<table class="easyui-datagrid" style="width:650px;height:auto"
							fit="true" border="false"
							nowrap="false" rownumbers="true"
							pagination="true"
							singleSelect="true"
							fitColumns="true"
							idField="id" url="${createLink(action:'dataListMyTasks')}"
						    data-options="
						    	fit:true,
						    	pageSize:50,pageList:[10,50,100]
							">
						<thead>
							<tr>
								<th field="messageDateFull" width="180">创建时间</th>
								<th field="messageRead" width="60" align="center" formatter="messageReadFormatter">已读</th>
								<th field="messageType" width="60" align="center">类型</th>
								<th field="messageSender" width="60" align="center">发送者</th>
								<th field="messageHead" width="400" align="center" formatter="messageHeadFormatter">标题</th>
							</tr>
						</thead>
					</table>
				</div>
			</div>
		</div>
		
		
		
		
		
	</body>
	
<r:script>
function messageHeadFormatter(value,row,index) {
	return '<a href="${createLink(action:'viewTask')}/'+row.id+'">'+value+'</a>';
}

function messageReadFormatter(value,row,index) {
	if(value==true) {
		return '<i class="fa fa-check" style="color:green;"></i>';
	}else{
		return '<i class="fa fa-exclamation" style="color:red;"></i>';
	}
}

$(function(){
});
</r:script>
	
</html>
