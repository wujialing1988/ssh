var basePath=(function(){
	var href=window.location.href;
	var host=window.location.host;
	var index = href.indexOf(host)+host.length+1; //host结束位置的索引（包含/）
	return href.substring(0,href.indexOf('/',index));
})(window);

Ext.Ajax.on('requestcomplete', function(conn, response, options) {
	if (!response) {
		getRootWin().location = basePath + "/toLogin.do";
	} else {
		var de = Ext.decode(response.responseText);
		if(de!=null)//判断是否有返回值 修改时间2015-4-2 李科
		{
			if (de.sessionstatus == 'true') {
				getRootWin().location = basePath + "/toLogin.do";
			}
		}
	}
});

$.ajaxSetup({
	contentType : "application/x-www-form-urlencoded;charset=utf-8",
	complete : function(XMLHttpRequest, textStatus) {
		// 通过XMLHttpRequest取得响应头，sessionstatus
		var sessionstatus = XMLHttpRequest.getResponseHeader("sessionstatus");
		if (sessionstatus == "timeout") {
			// 这里怎么处理在你，这里跳转的登录页面
			getRootWin().location = globalPath + "/toLogin.do";
		}
	}
});

function getRootWin() {
	var win = window;
	while (win != win.parent) {
		win = win.parent;
	}
	return win;
}
