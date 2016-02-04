<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script type="text/javascript" src="${ctx}/scripts/extjs/bootstrap.js"></script>
<script type="text/javascript" src="${ctx}/scripts/extjs/locale/ext-lang-zh_CN.js"></script>
<head>
<title>公司架构系统</title>
</head>
<script language="javascript">
	function getBg(num) {
		for (var id = 0; id <= 8; id++) {
			if (id == num) {
				document.getElementById("topLi_" + id).className = "a_click";
			} else {
				document.getElementById("topLi_" + id).className = "";
			}
		}
	}
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
					parent.window.location.href="${ctx}/toLogin.action";
				}
		},
		failure : function(res,options) { 
		}
	});
}
</script>
<body class="top">
	<div class="top_logo">公司架构系统</div>
	<div class="top_img">
		<span class="top_right"> <input name="" type="button" value=""
			class="top_help" /> <input name="" type="button" value="" onclick="logout();"
			class="top_quit" />
		</span> <span class="top_bot bot2"> <s:if
				test="#session.currentUserName!=null">
    			欢迎您！<s:property value="#session.currentUserName" />！
    		</s:if> <s:if test="#session.currentUserName==null">
    			未登录
    		</s:if>
		</span>
	</div>
	<div class="top_menu">
		<ul>
			<li onclick="getBg(0)" id="topLi_0" class="a_click">
				<a href="${ctx}/toFrameIndex.action" target="mainFrame">首页</a>
			</li>
			<li onclick="getBg(1)" id="topLi_1">
				<a href="${ctx}/user/toUserIndex.action" target="mainFrame">用户管理</a>
			</li>
			<li onclick="getBg(2)" id="topLi_2">
				<a href="${ctx}/org/toOrgIndex.action" target="mainFrame">组织管理</a>
			</li>
			<li onclick="getBg(3)" id="topLi_3">
				<a href="${ctx}/role/toRoleIndex.action" target="mainFrame">角色管理</a>
			</li>
			<li onclick="getBg(4)" id="topLi_4">
				<a href="${ctx}/resource/toResourceIndex.action" target="mainFrame">资源管理</a>
			</li>
			<li onclick="getBg(5)" id="topLi_5">
				<a href="${ctx}/dict/toDictIndex.action" target="mainFrame">字典管理</a>
			</li>
			<li onclick="getBg(6)" id="topLi_6">
				<a href="${ctx}/log/toLogIndex.action" target="mainFrame">日志管理</a>
			</li>
			<li onclick="getBg(7)" id="topLi_7">
				<a href="${ctx}/bpm/toPersonManage.do" target="mainFrame">个人中心</a>
			</li>
			<li onclick="getBg(8)" id="topLi_8">
				<a href="${ctx}/bpm/toProcessManage.do" target="mainFrame">流程管理</a>
			</li>
		</ul>
	</div>
</body>
</html>