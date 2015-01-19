
<script type="text/javascript">
$(function(){
	$('#addFileBtnBar').trigger('click');
	
    // TODO: 以后添加阶段箭头，参考Raphael.js
    /*
    var paper=Raphael(10, 50, 320, 200);
    var path=paper.arrow(1,1,100,100,10);
    path.attr("stroke", "#00CCFF");
    path.attr("stroke-width","2");
    */
});

function openDialog(dialogType) {
	if(dialogType=='back') {
		$('#phaseSubmitType').html('返回上一步');
		$('#submitButton').unbind('click').bind('click', function(){
			backPhase();
			return false;
		});
	}else{
		$('#phaseSubmitType').html('执行下一步');
		$('#submitButton').unbind('click').bind('click', function(){
			nextPhase();
			return false;
		});
	}
	$('#phaseCommentDialog').dialog('open');
}

function nextPhase() {
	var param={};
	$('#phaseCommentForm').serializeArray().map(function(n){
		//非常重要，为了避免$.param可能产生的中文乱码问题，用插入元素的方式替代
		var element=$('#detailForm').find("[name='"+n.name+"']")[0] || $('<input name="'+n.name+'">').appendTo($('#detailForm'));
		$(element).val(n.value);
	});
	
	// send request
	if($('#phaseCommentForm').form('validate')) {
		$('#detailForm').form('submit',{
			url:"${createLink(action:'dataWorkflowNextPhase')}?html",//必须用html, 因为在IE下ajaxForm+json会出现弹下载框
			onSubmit:function() {
				var isValid = $(this).form('validate');
				if (isValid){
					showProgress();
				}
				return isValid;
			},
		    success:function(data){
		    	hideProgress();
		    	var data = eval('(' + data + ')');  // change the JSON string to javascript object
				if(data.state=="success") {
					if(data.data.workflowCurrentPhase && data.data.workflowCurrentPhase.phaseIndex < 0) {//初始化步骤则跳入详细页面
						window.location.href="${createLink('action':'detailUpdate')}/"+data.data.id;
					}else{
						goList();
					}
				}else{
					$.messager.alert('错误',data.message,'error');
				}
		    },
		    onLoadError:function() {
		    	hideProgress();
		    }
		});
	}
}


function backPhase() {
	var param={};
	$('#detailForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	$('#phaseCommentForm').serializeArray().map(function(n){
		param[n.name]=n.value;
	});
	
	// send request
	if($('#phaseCommentForm').form('validate')) {
		if($('#detailForm').form('validate')) {
			showProgress();
			$.ajax({
				url: "${createLink(action:'dataWorkflowBackPhase')}?json",
				type: "post",
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
}

function goList() {
	window.location.href="${createLink('action':'workflows', 'params':[id:workflow?.workflowProject?.id])}";
}

var fileIdxCounter=0;
function addMoreFile(form) {
	var accordions = $(form).find('.easyui-accordion');//panels
	
	accordions.accordion('add', {
		title: '新文件',
		content: [
			'<div style="padding:5px;">',
				'<input name="workflowAccessories.'+fileIdxCounter+++'" type="file" onchange="return onFileChange(this);"/>',
				'<img class="phaseFilePreview phaseFilePreview_IE_image" src="${resource(dir:'images',file:'blank.png')}" style="display:none;"/>',
				'<div style="padding:5px;text-align:right;"><a href="#" onclick="return clearFile(this);">移除</a></div>',
			'</div>'].join(''),
		collapsed: false,
		collapsible: false
	});
	
}

function clearFile(which) {
	$(which).parent().prev().hide();
	var newOne=$(which).parent().prev().prev().clone();
	$(which).parent().prev().prev().replaceWith(newOne);
	return false;
}

function onFileChange(which) {
	readFile(which);
}

function readFile(input) {
    if (input.files && input.files[0] && /image\//ig.test(input.files[0].type)) {
        var reader = new FileReader();
        
        reader.onload = function (e) {
        	$(input).next().attr('src', e.target.result);
            $(input).next().show();
        }

        reader.readAsDataURL(input.files[0]);
    }else if(input.value && $(input).next()[0].filters) {// IE
    	// IE部分参考 http://it.oyksoft.com/post/974/
    	
    	var newPreview = $(input).next()[0];
        input.select();
        var filePath=document.selection.createRange().text;
    	newPreview.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = filePath;
        $(input).next().show();
        
        newPreview.style.width = newPreview.offsetWidth + 'px';
        newPreview.style.height = newPreview.offsetHeight + 'px';
        
    }else{
    	$(input).next().hide();
    }
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