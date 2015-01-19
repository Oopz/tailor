<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main"/>
		<title></title>
		<style type="text/css" media="screen">
		.roleItem{
			padding:5px;
		}
		.roleItem:HOVER {
			background: #eee;
		}
        .item{
			text-align:left;
            display:block;
            width:min-200px;
            text-decoration:none;
        }
        .item img{
        	vertical-align:middle;
        	max-width:128px;
        	max-height:24px;
            border:none;
        }
        .cart{
            float:right;
            position:relative;
            /*width:260px;*/
            height:48px;
            background:#ccc;
            padding:0px 10px;
        }
        
        .dropLeave {
        	background:#fff;
        }
        .dropHover {
        	background:#efefef;
        }
        
        .ctitle{
            text-align:center;
            color:#555;
            font-size:18px;
            padding:5px;
        }
        .csubtitle {
            text-align:center;
            color:#555;
            font-size:12px;
            padding:2px;
            border-bottom:1px solid #eee;
        }
		</style>
	</head>
	<body>
	
	<div class="easyui-layout" id="mainFrame" data-options="fit:true" style="background:#eee;">
	    <div data-options="region:'west',split:false" style="width:240px;">
	        <ul style="list-style:none;padding:0;margin:0;">
	        	<g:each in="${roles}" var="role">
		            <li class="roleItem">
		                <a href="#" class="item">
		                    <img src="${resource(dir: 'images', file: 'user.png')}"/>
		                    <span>${role?.roleName}</span>
		                    <input type="hidden" name='id' value='${role?.id}' />
		                </a>
		            </li>
	        	</g:each>
	        </ul>
	    </div>
	    
	    <div data-options="region:'center',border:true">
		    <div class="easyui-layout" data-options="fit:true" style="background:#eee;">
			    <div data-options="region:'north',split:false,border:false" style="height:36px;background:#E0ECFF;padding:3px 20px;border-bottom-width:1px;">
				    <div style="padding:0px;text-align:right;">
				        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-back',plain:true" onclick="goList();">返回</a>
				        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="addPhase();">添加阶段</a>
				        <a href="#" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="savePhase();">保存</a>
				    </div>
			    </div>
			    
		    	<div data-options="region:'center',border:false">
				    <div style="margin:5px;padding:10px;border:1px solid #eee;">
				    	说明：
				    	<br>1.流程执行顺序将按序号进行
				    	<br>2.右键点击角色以删除该角色
				    </div>
				    
		    		<div id="phaseBox"></div>
		    	</div>
			</div>
	    </div>
	    
	    <div style="display:none;">
		    <div id="phaseTemplate" style="display:inline-block;width:420px;min-height:200px;border:1px solid #eee;margin:5px;vertical-align:top;">
		    
		        <div class="ctitle">流阶段 - 
		        	<span class="phaseIndex">N/A</span>
		        	&nbsp;&nbsp;&nbsp;&nbsp;
		        	<span class="removeBtn" style="font-size:12px;"><a href="#" onclick="removePhase(this);return false;">删除</a></span>
		        </div>
		        
		        <div style="border-top-width:1px;border-bottom-width:1px;border-color:#eee;border-style:solid;border-left:none;border-right:none;margin-bottom:10px;">
		        	<table style="width:100%;">
		        		<tbody name="fields">
			        		<tr>
			        			<td class="phaseNameTd" style="width:100px;">名称：</td>
			        			<td>
									<span class="combo" style="width:320px;">
										<input name="phaseName" style="width:318px;"
											class="combo-text easyui-validatebox" 
											data-options="required:false,validType:['length[1,1000]','plain']"/>
									</span>
								</td>
								<td></td>
			        		</tr>
		        		</tbody>
		        		<tfoot>
			        		<tr>
			        			<td colspan="3" style="text-align:center;">
			        				<a href="#" name="addFieldBtn">添加流程数据</a>
			        			</td>
			        		</tr>
		        		</tfoot>
		        	</table>
		        	
		        	<input type="hidden" name="phaseIndex"/>
		        </div>
		        
		        <div class="roletable">
			        <div class="csubtitle">（拖动角色到这里，右键点击移除角色）</div>
			        <table class="phasecontent" fitColumns="true" style="height:auto;" data-options="border:false">
			            <thead>
			                <tr>
			                    <th field="name" width=140>参与角色</th>
			                </tr>
			            </thead>
			        </table>
		        </div>
		    </div>
	    </div>
	</div>
	
	<form method="post" id="phaseForm" style="display:none;">
	</form>
	
	<g:render template="js/detail.js" model="beanJson"></g:render>
	
	</body>
	
</html>
