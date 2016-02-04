<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<html>
<head>
<title>公司架构系统</title>
<script type="text/javascript">
function logout(){
	Ext.Ajax.request({ 
		url : '${ctx}/user/logout.action', 
		params : {					 
		},
		success : function(res ,options) {
			var json = Ext.decode(res.responseText);
				if(json.success==false){
					//Ext.MessageBox.alert(SystemConstant.alertTitle, SystemConstant.logoutError);
				}else{
					window.location.href="${ctx}/toLogin.action";
				}
		},
		failure : function(res,options) { 
		}
	});
}
</script>
</head>
<frameset rows="80,*,25" border="0">
	<frame noresize="noresize" src="${ctx}/toTop.action" scrolling="no">
	<frame name="mainFrame" noresize="noresize" src="${ctx}/toFrameIndex.action">
	<frame noresize="noresize" src="${ctx}/toBottom.action" scrolling="no">
</frameset>
<noframes></noframes>
</html>