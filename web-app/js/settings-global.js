

window.HC_CALANDAR_BUTTONS=$.extend([], $.fn.datetimebox.defaults.buttons);
HC_CALANDAR_BUTTONS.splice(2, 0, {
	text: '清空',
	handler: function(target){
		$(target).datetimebox('setValue','');
	}
});

window.HC_DATEBOX_BUTTONS=$.extend([], $.fn.datebox.defaults.buttons);
HC_DATEBOX_BUTTONS.splice(1, 0, {
	text: '清空',
	handler: function(target){
		$(target).datebox('setValue','');
	}
});

function goto(href) {
	window.location.href=href;
}
		

if (typeof jQuery !== 'undefined') {
	$.extend($.fn.validatebox.defaults.rules, {
	    plain: {
	        validator: function(value, param){
	            return !/<|>/ig.test(value);
	        },
	        message: '文本不能含有符号 < 或 >'
	    },
	    password: {
	        validator: function(value, param){
	            return !/ /ig.test(value);
	        },
	        message: '密码不能含有空格'
	    }
	});

	$(document).ajaxError(function(event, jqXHR, ajaxSettings, thrownError) {
		if(jqXHR.status == 401) {
			//window.location.href="${createLink(absolute:'true')}";
			window.location.reload();
		}
	});
	
	$(function(){
		// bind filter enter event
		$('#filterForm input').keypress(function (e) {
			if (e.which == 13) {
				e.preventDefault();
				$('#filterForm #filterSubmit').click();
			}
		});
		
		// set hightcharts
		if(window.Highcharts) {
			Highcharts.setOptions({
				global: {
					useUTC: false
				},
	            credits: {
	                enabled: false
	            }
			});
		}
	});
}