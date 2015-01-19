<%@ page contentType="text/html;charset=UTF-8"%>
<div style="padding:5px;">
	<div>
		项：<select class="easyui-combogrid" name="logYarn" style="width:180px" data-options="
	            panelWidth: 400,
	            idField: 'id',
	            textField: 'yarnDisplay',
	           	loader:function(param,success,error){
			        jQuery.ajax({
						url: 'dataListAllYarns?json',
						type: 'post', 
						data: param,
						success: function(data){
							for(var i=0; i < data.rows.length; i++) {
								var tmp=data.rows[i];
								data.rows[i].yarnDisplay = [tmp.yarnType,tmp.yarnCount,tmp.yarnHue].join('/');
							}
							success(data);
						},
						error: function(){error();}
					});
			    },
	            columns: [[
	                {field:'yarnType',title:'纱种',width:80},
	                {field:'yarnCount',title:'纱支',width:80},
	                {field:'yarnHue',title:'色号',width:80},
	                {field:'yarnColor',title:'颜色',width:80},
	                {field:'yarnJar',title:'缸号',width:80},
	                {field:'yarnWeight',title:'库存重量',width:80},
	                {field:'yarnStock',title:'库存件数',width:80},
	                {field:'yarnSpace',title:'仓位'}
	            ]],
	            fitColumns: true
	        ">
	    </select>
		重量：<input name="logWeight" class="easyui-numberspinner logWeight" value="0" data-options="min:0,precision:2" style="width:60px;">
		件数：<input name="logTotal" class="easyui-numberspinner logTotal" value="0" data-options="min:0,precision:0" style="width:60px;">
	</div>
	<div style="margin-top:6px;">
		备注：<span class="combo">
				<input name="logMemo"
				class="combo-text easyui-validatebox"
				data-options="validType:'length[0,1000]'" style="width:360px;"/>
		</span>
	</div>
</div>