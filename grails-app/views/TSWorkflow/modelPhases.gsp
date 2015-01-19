
<style type="text/css" media="screen">
.phase{
	vertical-align:top;
	display:inline-block;
	width:320px;
	min-height:80px;
	border:1px solid #eee;
	padding:5px;
	margin-right:40px;
	margin-bottom:40px;
}
.phase .phaseRow {
	margin:5px;
}
.ctitle {
	font-weight:bold;
}
</style>

<div>
	<g:if test="${bean}">
		<div style="padding:5px;margin-bottom:10px;">
			<i class="fa fa-exclamation-circle" style="color:red;margin-right:2px;font-size:16px;"></i>
			可创建此模型的角色：${bean?.modelCreators?.collect{it?.roleName}.join(', ')}
		</div>
	
		<g:each in="${bean?.modelPhases}" var="phase">
			<span class="phase">
				<div class="ctitle" style="border-bottom:1px solid #eee;text-align:center;">步骤 - ${phase?.phaseIndex}</div>
					<div class="phaseRow">执行步骤：${phase?.phaseName}</div>
					<div class="phaseRow">执行角色：${phase?.phaseParticipants?.collect{it.roleName}?.join(', ')}</div>
					<div class="phaseRow">指定用户：
	    				<g:select name="phaseAssignee" from="${[['id':'', 'display':'该角色的所有用户']] + phase?.assignees}" 
	    					optionKey="id" optionValue="display"
	    				 	class="easyui-combobox phaseAssignee" 
	    				 	data-options="panelHeight:'auto',editable:false"
	    				 	style="min-width:120px;"/>
					</div>
			</span>
		</g:each>
	</g:if>
	<g:else>
		请选择工作流模型
	</g:else>
</div>


