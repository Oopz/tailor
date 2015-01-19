<html debug="true">
<head>
	<title><g:message code="springSecurity.login.title"/></title>
	
	<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery-1.11.2.min.js')}"></script>
	<script type="text/javascript" src="${resource(dir: 'js', file: 'jquery-migrate-1.2.1.js')}"></script>
	
	<r:layoutResources />
	
	<script type="text/javascript" src="${resource(dir: 'js/bootstrap-3.2.0/js', file: 'bootstrap.min.js')}"></script>
		
	<link rel="stylesheet" href="${resource(dir: 'js/bootstrap-3.2.0/css', file: 'bootstrap.min.css')}" type="text/css">
	<link rel="stylesheet" href="${resource(dir: 'js/bootstrap-3.2.0/css', file: 'bootstrap-theme.min.css')}" type="text/css">
		
	<link rel="stylesheet" type="text/css" href="${resource(dir: 'css/font-awesome/css', file: 'font-awesome.min.css')}">
	
</head>

<body style="background:#f8f8f8;padding:0;margin:0;">

<div class="container" style="margin-top:40px;">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="login-panel panel panel-default">
                <div class="panel-heading" style="background:#fff;">
					<div style="overflow:hidden;width:288px;height:70px;display:inline-block;margin-left:10px;position:relative;text-align:center;">
						<img src="${resource(dir: 'images', file: 'logo.png')}" alt="供暖系统" style="height:70px;"/>
					</div>
                    <%--<h3 class="panel-title">Please Sign In</h3>--%>
                </div>
                <div class="panel-body">
					<g:if test='${flash.message}'>
						<div class="form-group has-error">
							<label class='control-label'>${flash.message}</label>
						</div>
					</g:if>
					<form action='${postUrl}' method='POST' id='loginForm' autocomplete='on'>
                        <fieldset>
                            <div class="form-group">
                            	<!-- Last login as: ${session['SPRING_SECURITY_LAST_USERNAME']} -->
								<input class="form-control" placeholder="<g:message code="springSecurity.login.username.label"/>" 
									type='text' name='j_username' id='username' value='admin' autofocus/>
                            </div>
                            <div class="form-group">
								<input class="form-control" placeholder="<g:message code="springSecurity.login.password.label"/>" 
									type='password' name='j_password' id='password' value='admin' />
                            </div>
                            <div class="form-group">
								<select class="form-control" name="maxSessionInactive">
									<option value="${30*60}">非活跃会话失效时间: 30 分钟</option>
									<option value="${60*60}">非活跃会话失效时间: 1 小时</option>
									<option value="${2*60*60}" selected="selected">非活跃会话失效时间: 2 小时</option>
									<option value="${6*60*60}">非活跃会话失效时间: 6 小时</option>
								</select>
							</div>
                            
                            <%--<div class="checkbox">
                                <label for='${rememberMeParameter}'>
                                    <input name="${rememberMeParameter}" id='${rememberMeParameter}' 
                                    	type="checkbox" value="Remember Me" <g:if test='${hasCookie}'>checked='checked'</g:if>/>
                                    <g:message code="springSecurity.login.remember.me.label"/>
                                </label>
                            </div>--%>
                            
                            <!-- Change this to a button or input when using this as a form -->
                            <input type="submit" class="btn btn-lg btn-success btn-block" value="${message(code: "springSecurity.login.button")}"/>
                        </fieldset>
                    </form>
                    
                    <div style="text-align:center;margin-top:20px;cursor: default;color: #777;font-size: 11px;">
                    	<span class="glyphicon glyphicon-flash" style="margin-right:5px;"></span>Presented By Oopz, 2015
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<g:javascript library="application"/>

<script type='text/javascript'>
	<!--
	(function() {
		if($.browser.msie) {
			$(document.body).html('目前不支持IE，请使用Chrome或其它支持HTML5的浏览器');
		}
				
		document.forms['loginForm'].elements['j_username'].focus();
	})();
	// -->
</script>

<r:layoutResources />
</body>
</html>
