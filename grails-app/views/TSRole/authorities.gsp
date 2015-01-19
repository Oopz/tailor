<%@ page contentType="text/html;charset=UTF-8"%>
<div class="easyui-layout" data-options="fit:true" style="background:#fff;">
<form method="post">

    <div data-options="region:'north',split:false" style="border-width:0 0 1px 0;height:36px;background:#E0ECFF;padding:3px 20px;">
	    <div style="padding:0px;text-align:right;">
	        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveAuthorities($(this).parents('form').first())">保存</a>
	    </div>
    </div>
    
	<div data-options="region:'center',border:false">
		<input type="hidden" name="id" value="${bean?.id}">
		
		<ul class="easyui-tree" data-options="checkbox:true,lines:true" id="tt">
			<li>
				<span>可用权限</span>
				<ul>
					<li>
						<span>纱仓管理</span>
						<ul>
							<li id="ROLE_YARN" ${!authorities?.contains('ROLE_YARN')?:'checked'}><span>仓库管理</span></li>
							<li id="ROLE_YARN_STOCKIO" ${!authorities?.contains('ROLE_YARN_STOCKIO')?:'checked'}><span>进出仓</span></li>
						</ul>
					</li>
					<li>
						<span>布仓管理</span>
						<ul>
							<li id="ROLE_PIECE" ${!authorities?.contains('ROLE_PIECE')?:'checked'}><span>布仓管理</span></li>
						</ul>
					</li>
					<li>
						<span>面料版管理</span>
						<ul>
							<li id="ROLE_FABRIC" ${!authorities?.contains('ROLE_FABRIC')?:'checked'}><span>面料版管理</span></li>
						</ul>
					</li>
					<li>
						<span>工作流</span>
						<ul>
							<li id="ROLE_WORKFLOW" ${!authorities?.contains('ROLE_WORKFLOW')?:'checked'}><span>工作流</span></li>
							<li id="ROLE_WORKFLOW_DELETE" ${!authorities?.contains('ROLE_WORKFLOW_DELETE')?:'checked'}><span>工作流（删除）</span></li>
						</ul>
						<ul>
							<li id="ROLE_WORKFLOW_MODEL" ${!authorities?.contains('ROLE_WORKFLOW_MODEL')?:'checked'}><span>工作流模型</span></li>
						</ul>
					</li>
					<li>
						<span>系统用户</span>
						<ul>
							<li id="ROLE_EMPLOYEE" ${!authorities?.contains('ROLE_EMPLOYEE')?:'checked'}><span>用户管理</span></li>
						</ul>
						<ul>
							<li id="ROLE_ADMIN" ${!authorities?.contains('ROLE_ADMIN')?:'checked'}><span>角色与权限管理</span></li>
						</ul>
					</li>
				</ul>
			</li>
		</ul>
	</div>
	
</form>
</div>

