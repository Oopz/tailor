<script type="text/javascript">
$(function(){
    // TODO: 以后添加阶段箭头，参考Raphael.js
    /*
    var paper=Raphael(10, 50, 320, 200);
    var path=paper.arrow(1,1,100,100,10);
    path.attr("stroke", "#00CCFF");
    path.attr("stroke-width","2");
    */
    
    $('.workflowList').find('select[name="workflowModel"]').combobox();

    if($('.workflowList').find('li').length==0) {
    	addWorkflow();
   	}
});

function addWorkflow() {
	$('.workflowTemplate').clone(true, true).removeClass('workflowTemplate').appendTo($('.workflowList')).show().find('select').combobox();
}

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
	
	if($.trim(param.projectName)=='') {
		$.messager.alert('提示','请输入业务单名称','info');
		return;
	}

	for(var i=0; i<$('#detailForm input[type="file"]').length; i++) {
		var fileInput=$('#detailForm input[type="file"]')[i];
		var MAX_SIZE=1024*1024*4;
		if(fileInput.files && fileInput.files[0]) {
			if(fileInput.files[0].size > MAX_SIZE) {
				$.messager.alert('提示','上传的单个附件不能超过 '+formatSize(MAX_SIZE),'info');
				return;
			}
		}
	}
	
	// send request
	if($('#detailForm').form('validate')) {
		$('#detailForm').form('submit',{
			url:"${createLink(action:'dataSaveProject')}?html",//必须用html, 因为在IE下ajaxForm+json会出现弹下载框
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
					goList();
				}else{
					$.messager.alert('错误',data.message,'error');
				}
		    },
		    onLoadError:function() {
		    	hideProgress();
		    }
		});
	}

	return false;
}

function goList() {
	window.location.href="${createLink('action':'projects')}";
}


/*
 * 文件处理
 */
var fileIdxCounter=0;
function addMoreFile(form) {
	var accordions = $(form).find('.easyui-accordion');//panels
	
	accordions.accordion('add', {
		title: '新文件',
		content: [
			'<div style="padding:5px;">',
				'<input name="projectAccessories.'+fileIdxCounter+++'" type="file" onchange="return onFileChange(this);"/>',
				'<img class="projectFilePreview projectFilePreview_IE_image" src="${resource(dir:'images',file:'blank.png')}" style="display:none;max-height:600px;max-width:600px;"/>',
				'<div style="padding:5px;text-align:right;">',
					'<label name="uploadSize" style="margin-right:15px;color:#777;font-size:10px;"></label>',
					'<a href="#" onclick="return clearFile(this);">清空</a>',
				'</div>',
			'</div>'].join(''),
		collapsed: false,
		collapsible: false
	});
}

function clearFile(which) {
	$(which).parent().prev().hide();
	var newOne=$(which).parent().prev().prev().clone();
	$(which).parent().prev().prev().replaceWith(newOne);
	$(which).prev().empty();
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

        	$(input).next().next().find('[name="uploadSize"]').html('上传附件大小: '+formatSize(input.files[0].size));
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

/*
 * 杂项
 */
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