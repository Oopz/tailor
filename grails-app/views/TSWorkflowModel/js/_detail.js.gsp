<script type="text/javascript">
var initData=${beanJson ?: 'null'};
var phaseIndex=0;

$(function(){
	addPhase(true);
	if(initData){
		for(var i=0; i < initData.modelPhases.length; i++) {
			addPhase(false, initData.modelPhases[i]);
		}
	}else if(phaseIndex==0){
		addPhase();
	}
    
    $('.item').draggable({
        revert:true,
        proxy:function(source){
        	return $(source).clone().appendTo('#mainFrame');
		},
        onStartDrag:function(){
            $(this).draggable('options').cursor = 'not-allowed';
            $(this).draggable('proxy').css('z-index',10);
        },
        onStopDrag:function(){
            $(this).draggable('options').cursor='move';
        }
    });
    
    // TODO: 以后添加阶段箭头，参考Raphael.js
    /*
    var paper=Raphael(10, 50, 320, 200);
    var path=paper.arrow(1,1,100,100,10);
    path.attr("stroke", "#00CCFF");
    path.attr("stroke-width","2");
    */
});

function addRole(which, name, id){
    var dg = $(which).find('.phasecontent');
    
    var data = dg.datagrid('getData');
    function add(){
        for(var i=0; i< data.total; i++){
            var row = data.rows[i];
            if (row.id == id){
            	// existed
                return;
            }
        }
        data.total += 1;
        data.rows.push({
        	id: id,
            name:name
        });
    }
    add();
    dg.datagrid('loadData', data);
}

function addField(phase, idx, fieldName, fieldType) {
    $tr=$('<tr>');
    $td_1=$('<td>').appendTo($tr);
    $td_1.text('属性');
    
    $td_2=$('<td>').appendTo($tr);
    $input=$('<input style="line-height:20px;border:1px solid #ccc;width:115px;">').appendTo($td_2);
    $input.addClass('extraInputs');
    $input.attr('name', 'phaseAttrs-name-'+idx);
    $input.attr('placeholder', '名称');
    fieldName && $input.val(fieldName);
    
    $select=$('<select style="margin-left:5px;">').appendTo($td_2);
    $select.addClass('extraSelects');
    $select.attr('name', 'phaseAttrs-type-'+idx);
    $select.append('<option value="input">单行文本</option>');
    $select.append('<option value="boolean">布尔值</option>');
    $select.append('<option value="number">数值</option>');
    $select.append('<option value="textbox">文本框</option>');
    $select.append('<option value="date">日期</option>');
    fieldType && $select.val(fieldType);
    //$select.combobox({editable:false,panelHeight:'auto',hasDownArrow:true});
    
    $td_3=$('<td>').appendTo($tr);
    $('<a href="#">X</a>').appendTo($td_3).bind('click', function(){
	    $(this).parents('tr').first().remove();
	    return false;
	});
    
	$(phase).find('[name="fields"]').append($tr);
}

function addPhase(isInit, phaseData) {
	var phase=$('#phaseTemplate').clone().removeAttr('id').addClass('phase').appendTo('#phaseBox');
	
	$(phase).find(".easyui-validatebox").validatebox();

    // 角色table
    $(phase).find('.phasecontent').datagrid({
        singleSelect:true,
        showFooter:true,
        onRowContextMenu:function(e, rowIndex, rowData) {
        	e.preventDefault();
        	$(this).datagrid('deleteRow', rowIndex);
        }
    });
    
	if(isInit) {
		$(phase).find('.phaseIndex').html('创建');
		$(phase).find('input[name="phaseIndex"]').val(0);
		$(phase).find('.removeBtn').hide();
		$(phase).find('.phaseNameTd').html('工作流名称');
		if(initData) {
			$(phase).find('input[name="phaseName"]').val(initData.modelName);
			for(var i=0; i < initData.modelCreators.length; i++) {
        		addRole(phase, initData.modelCreators[i].roleName, initData.modelCreators[i].id);
        	}
		}
		$(phase).find('.roletable').hide();//上段是legacy,创建阶段不需要角色,可隐藏
	}else{
		++phaseIndex;
		$(phase).find('.phaseIndex').html(phaseIndex);
		$(phase).find('input[name="phaseIndex"]').val(phaseIndex);
	}

	// 添加属性的button
	if(phaseIndex > 0) {
	    $(phase).find('[name="addFieldBtn"]').attr('data-index', phaseIndex).bind('click', function(){
	       	// phase, phaseIndex
	       	addField(phase, $(this).data('index'));
	    	return false;
		});
	}else {
		$(phase).find('[name="addFieldBtn"]').replaceWith('&lt;工作流起始阶段&gt;');
	}

    // 添加d&d事件
    if(phaseIndex > 0) {
	    $(phase).droppable({
	        onDragEnter:function(e,source){
	            $(source).draggable('options').cursor='auto';
	            $(this).removeClass('dropLeave').addClass('dropHover');
	        },
	        onDragLeave:function(e,source){
	            $(source).draggable('options').cursor='not-allowed';
	            $(this).removeClass('dropHover').addClass('dropLeave');
	        },
	        onDrop:function(e,source){
	            $(this).removeClass('dropHover').addClass('dropLeave');
	            
	            var name = $(source).find('span:eq(0)').html();
	            var id = $(source).find('input[name="id"]').val();
	            addRole(this, name, id);
	        }
	    })/*.bind('contextmenu', function(e){
	    	e.preventDefault();
	    })*/;
    }
    
    if(phaseData) {
		$(phase).find('input[name="phaseName"]').val(phaseData.phaseName);
		for(var i=0; i < phaseData.phaseParticipants.length; i++) {
        	addRole(phase, phaseData.phaseParticipants[i].roleName, phaseData.phaseParticipants[i].id);
		}
		for(var i=0; phaseData.phaseFields && i< phaseData.phaseFields.length; i++) {
			addField(phase, phaseIndex, phaseData.phaseFields[i].fieldName, phaseData.phaseFields[i].fieldType);
		} 
    }
    
}

function removePhase(which) {
	if($('#phaseBox').find('.phase').length > 2) {
		$(which).parents('.phase').first().remove();
	}else{
		$.messager.alert('提示','至少存在一个流阶段','info');
	}
}

function savePhase() {
	$("#phaseForm").empty();
	
	if(initData) {
		var phaseId=initData.id;
		$("<input name='id'>").val(phaseId).appendTo("#phaseForm");
	}

	var phases=$(".phase");
	for(var i=0; i < phases.length; i++) {
		var p=phases[i];
		var phaseIndex=$(p).find('input[name="phaseIndex"]').val();
		var phaseName=$(p).find('input[name="phaseName"]').val();
		
		$("<input name='phaseIndex'>").val(phaseIndex).appendTo("#phaseForm");
		$("<input name='phaseName'>").val(phaseName).appendTo("#phaseForm");
		
	    var dg = $(p).find('.phasecontent');
	    var participants = $.map(dg.datagrid('getData').rows, function(item){return item.id;}).join(",");
		$("<input name='phaseParticipants'>").val(participants).appendTo("#phaseForm");
		
		if(""==$.trim(phaseName)) {
			$.messager.alert('提示','每个阶段名称不能空','info');
			return;
		}
		if(""==participants && phaseIndex != 0) {//起始阶段不需要角色
			$.messager.alert('提示','每个阶段的参与角色至少为一人','info');
			return;
		}
	}
	phases.find('.extraInputs').clone(true).appendTo("#phaseForm");
	phases.find('.extraSelects').each(function(){
		$(this).clone(true).val($(this).val()).appendTo("#phaseForm");
	})
	
	$("#phaseForm").form('submit',{
		url:"${createLink(action:'dataSaveWorkflow')}?json",
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
	    }
	});
}

function goList() {
	window.location.href="${createLink('action':'index')}";
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