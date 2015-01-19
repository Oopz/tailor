
<li class="${asTemplate?'workflowTemplate':''}">
	<div>
		<input type="hidden" name="workflowId" value="${bean?.id}">
	
		工作流模型：
		<g:select name="workflowModel" from="${[['id':'', 'modelName':'-- 选择工作流模型 --']]+models}" 
			optionKey="id" optionValue="modelName"
		 	class="workflowModel" value="${bean?.workflowModel?.id}" readonly="${noModel?true:false}" hasDownArrow="${noModel?false:true}"
		 	data-options="panelHeight:'auto',editable:false" 
		 	style="min-width:120px;"/>
		 
		&nbsp;&nbsp;&nbsp;&nbsp;
		
		工作流名称：
		<span class="combo" style="width:320px;">
			<input name="workflowName" style="width:316px;"
				class="combo-text easyui-validatebox" 
				value="${bean?.workflowName}"
				data-options="required:false,validType:['length[1,1000]','plain']"/>
		</span>	
		
		&nbsp;&nbsp;&nbsp;&nbsp;
		<g:if test="${noDelete?false:true}">
			<a href="#" onclick="$(this).closest('li:not(.workflowTemplate)').remove();return false;">
				<i class="fa fa-times" style="color:red;"></i>
			</a>
		</g:if>
	</div>
</li>
