<script type="text/javascript">
$(function(){
    // TODO: 以后添加阶段箭头，参考Raphael.js
    /*
    var paper=Raphael(10, 50, 320, 200);
    var path=paper.arrow(1,1,100,100,10);
    path.attr("stroke", "#00CCFF");
    path.attr("stroke-width","2");
    */
});

function submitSaveWorkflow() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		if(param[n.name] instanceof Array) {
			param[n.name].push(n.value);
		}else if(null != param[n.name]){
			param[n.name]=[param[n.name], n.value];
		}else{
			param[n.name]=n.value;
		}
	});
	
	if($.trim(param.workflowName)=='') {
		$.messager.alert('提示','请输入工作流名称','info');
		return;
	}
	
	if(param.workflowModel=='') {
		$.messager.alert('提示','请选择工作流模型','info');
		return;
	}
	
	// send request
	if($('#detailForm').form('validate')) {
		showProgress();
		$.ajax({
			url: "${createLink(action:'dataSaveWorkflow')}?json",
			type: "post",
			traditional: true,
			data: param
		}).done(function(data,textStatus,jqXHR) {
	    	hideProgress();
			if(data.state=="success") {
				if(data.data.workflowCurrentPhase && data.data.workflowCurrentPhase.phaseIndex < 0) {//初始化步骤则跳入详细页面
					window.location.href="${createLink('action':'detailUpdate')}/"+data.data.id;
				}else{
					goList();
				}
			}else{
				$.messager.alert('错误',data.message,'error');
			}
		}).fail(function(jqXHR,textStatus,errorThrown) {
			hideProgress();
		});
	}
}

function goList() {
	window.location.href="${createLink('action':'index')}";
}

function onChangeModel(record) {
	$("#phasesPreview").panel('refresh','${createLink(action:'modelPhases')}/'+record.value);
	$("#phasesPreview").panel("resize");
	//console.log(record);
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