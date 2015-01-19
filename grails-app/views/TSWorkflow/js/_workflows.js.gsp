<script type="text/javascript">
function workflowCurrentHandlerFormatter(value,row,index) {
	if(row.workflowCurrentPhase && row.workflowCurrentPhase.phaseAssignee) {
		return "["+row.workflowCurrentPhase.phaseAssignee.username+"] "+row.workflowCurrentPhase.phaseAssignee.userAlias;
	}if(row.workflowCurrentPhase && row.workflowCurrentPhase.phaseParticipants) {
		return $.map(row.workflowCurrentPhase.phaseParticipants, function(item){
			return item.roleName;
		}).join(", ");
	}else{
		return "";
	}
}

function workflowGraphFormatter(value,row,index) {
	var tmp=[];
	for(var i=0; row.workflowPhases && i<row.workflowPhases.length; i++) {
		// FIXME: 暂时用.replace(/"/g,"")替换双引号 以后再用.text()+.wrapInner()解决
		if(row.workflowCurrentPhase) {
			if(row.workflowCurrentPhase.phaseIndex == row.workflowPhases[i].phaseIndex) {
				tmp.push('<i class="fa fa-circle easyui-tooltip" style="margin-left:5px;color:blue;cursor:pointer;" title="'+row.workflowPhases[i].phaseName.replace(/"/g,"")+'"></i>');
			}else if(row.workflowCurrentPhase.phaseIndex > row.workflowPhases[i].phaseIndex) {
				tmp.push('<i class="fa fa-circle easyui-tooltip" style="margin-left:5px;color:green;cursor:pointer;" title="'+row.workflowPhases[i].phaseName.replace(/"/g,"")+'"></i>');
			}else if(row.workflowPhases[i].phaseRejected){
				tmp.push('<i class="fa fa-circle easyui-tooltip" style="margin-left:5px;color:red;cursor:pointer;" title="'+row.workflowPhases[i].phaseName.replace(/"/g,"")+'"></i>');
			}else{
				tmp.push('<i class="fa fa-circle-thin easyui-tooltip" style="margin-left:5px;cursor:pointer;" title="'+row.workflowPhases[i].phaseName.replace(/"/g,"")+'"></i>');
			}
		}else{//无curentPhase代表改工作流已经结束
			tmp.push('<i class="fa fa-circle-thin easyui-tooltip" style="margin-left:5px;color:green;cursor:pointer;" title="'+row.workflowPhases[i].phaseName.replace(/"/g,"")+'"></i>');
		}
	}

	if(!row.workflowCurrentPhase) {
		tmp.push('<i class="fa fa-check" style="margin-left:5px;color:green;"></i>');
	}
	
	return tmp.join('');
}

function workflowModelFormatter(value,row,index) {
	return value.modelName;
}

function workflowOwnerFormatter(value,row,index) {
	return value.username + "(" + value.userAlias +")";
}

function workflowCurrentPhaseFormatter(value,row,index) {
	if(value != null) {
		if(row.workflowCurrentPhase.phaseIndex >= 0) {
			var msg1="";
			
			for(var i=0; row.workflowPhases && i<row.workflowPhases.length; i++) {
				if(row.workflowCurrentPhase.id==row.workflowPhases[i].id && i>0) {
					msg1="已经完成: <i style='color:green;'>"+row.workflowPhases[--i].phaseName+"</i>";
					break;
				}
			}
			
			var msg2="当前步骤: <i style='color:blue;'>" + value.phaseName+"</i>";// " + (row.workflowCurrentPhase.phaseIndex) +"
			return [msg1,msg2].join('&nbsp;&nbsp;');
		}else{
			return "初始化步骤: " + value.phaseName;
		}
	}else{
		return "<i style='color:#aaa;'><< 已结束 >></i>";
	}
}

function addProvider() {
	window.location.href="${createLink(action:'detailCreate')}";
}

function editProvider() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		var hashPhase='';
		if(row.workflowCurrentPhase){
			hashPhase='#phase-'+row.workflowCurrentPhase.id;
		}
		window.location.href="${createLink(action:'detailUpdate')}/"+row.id + hashPhase;
	}else{
		$.messager.alert('提示','请从表中选择一个要进行操作的工作流','info');
	}
}

function submitDelProvider(id) {
	var row=$("#dg").datagrid('getSelected');
	
	// send request
	showProgress();
	$.ajax({
		url: "${createLink(action:'dataDelWorkflow')}?json",
		type: "post",
		data: {id:id},
	}).done(function(data,textStatus,jqXHR) {
		hideProgress();
		if(data.state=="success") {
			reloadData();
		}else{
			$.messager.alert('错误',data.message,'error');
		}
	}).fail(function(jqXHR,textStatus,errorThrown) {
		hideProgress();
	});
}

function delProvider() {
	var row=$("#dg").datagrid('getSelected');
	if(row) {
		$.messager.confirm('确认', '要删除吗？', function(r){
			if(r) {
				submitDelProvider(row.id);
			}
		});
	}
}

function reloadData() {
	$("#dg").datagrid("reload");
}

function resetFilter() {
	$("#filterForm").form('reset');
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
</script>