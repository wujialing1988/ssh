<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<script type="text/javascript" src="${ctx}/scripts/login/jcookie.js"></script>
<script type="text/javascript" src="${ctx}/scripts/login/login.js"></script>
<script type="text/javascript" src="${ctx}/scripts/login/isLogin.js"></script>
<title>公司开发架构</title>
<script language="javascript" type="text/javascript">
	$(document).ready(function(){
		// document.onkeydown = showKeyDown;
		$("#uersName_txt").keyup(function(evt) {
			if((evt.keyCode || evt.which) == 13){
				$("#password_txt").val("");
				$("#password_txt").focus();
		    }
		});
		
		$("#password_txt").keyup(function(evt) {
			evt = (evt) ? evt : window.event;
			if((evt.keyCode || evt.which) == 13){
				btn_submit();
		    }
		});
	});
	
	function doClickStyle(obj,objclassname){
 		document.getElementById(obj).className=objclassname;
	}
	function setFocus()
	{
  		document.getElementById('uersName_txt').focus();
	}
	function changeLogin(idd){
		document.getElementById("login_tr_1").style.display="none";
		document.getElementById("login_tr_2").style.display="none";
		document.getElementById(idd).style.display="table-row";
		loginType();
	}
	function btn_submit(){
		/* var userName= null;
		if($.cookie("zy") == "true"){
			userName = document.getElementById('uersName_txt').value;
    	}
    	if($.cookie("fzy") == "true"){
			userName = document.getElementById('uersName_txt2').value;
    	} */
		
		Ext.Ajax.request({ 
			url : '${ctx}/user/login.do', 
			params : {					 
   					username:document.getElementById('uersName_txt').value,
   					passWord:document.getElementById('password_txt').value
			},
			success : function(res ,options) {
				var json = Ext.decode(res.responseText);
					if(json.success==false){
						if(json.msg=='0'){
							document.getElementById('cr').innerHTML=SystemConstant.userIsExist; 
							//Ext.MessageBox.alert(SystemConstant.alertTitle, SystemConstant.userIsExist); 
							automaticIsLogin();
							return;
						}
						if(json.msg=='1'){
							document.getElementById('cr').innerHTML=SystemConstant.userDisable; 
							//Ext.MessageBox.alert(SystemConstant.alertTitle, SystemConstant.userDisable); 
							automaticIsLogin();
							return;
						}
						if(json.msg=='2'){
							document.getElementById('cr').innerHTML=SystemConstant.userResourcesFailure; 
							//Ext.MessageBox.alert(SystemConstant.alertTitle, SystemConstant.userResourcesFailure); 
							automaticIsLogin();
							return;
						}
						if(json.msg=='3'){
							document.getElementById('cr').innerHTML=SystemConstant.theSystemIsBusy; 
							//Ext.MessageBox.alert(SystemConstant.alertTitle, SystemConstant.theSystemIsBusy);
							automaticIsLogin();
							return; 
						}else{
							document.getElementById('cr').innerHTML=json.msg; 
							automaticIsLogin();
							
						}
					}else{
						//样式3
						//window.location.href="${ctx}/toJG.action";
						//样式1
						log1();
						loginUserInfo();
						window.location.href="${ctx}/user/toMain.action";
					}
			},
			failure : function(res,options) { 
			}
		});
	}
</script>
<head>
</head>
<body class="login2" onload="setFocus()">
	<div class="login2_bg">
		<div class="login2_title">
			公司开发架构&nbsp;<span class="span_SUB">V 1.6</span>
		</div>
		<table border="0" cellpadding="0" cellspacing="2" class="login_2">
			<tr>
				<td width="77">用户名：</td>
				<td width="164">
					<input name="" id="uersName_txt" type="text"
					tabIndex="1" class="login2_text"
					onfocus="doClickStyle('uersName_txt','onfocus_login2_text')"
					onblur="doClickStyle('uersName_txt','login2_text')" onChange="uptUserName();" />
				</td>
				<td width="70" rowspan="2" align="right">
					<input name="input" tabIndex="3" type="button" class="button_2" onclick="btn_submit();" value="" />
				</td>
			</tr>
			<tr>
				<td height="26">密&nbsp;&nbsp;&nbsp;&nbsp;码：</td>
				<td><input name="" id="password_txt" type="password" 
					tabIndex="2" class="login2_text"
					onfocus="doClickStyle('password_txt','onfocus_login2_text')"
					onblur="doClickStyle('password_txt','login2_text')" onChange="uptUserPrd();"/></td>
			</tr>
			<tr>
				<td height="26">&nbsp;</td>
				<td height="26" colspan="2"><input type="checkbox"
					name="rmbUser" value="" id="rmbUser" class="checkbox_input"
					onclick="saveUserInfo();"/>记住密码&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="autoUser" value="" id="autoUser" class="checkbox_input" 
					onclick="automaticLogin();" />自动登录</td>
			</tr>
			<tr>
				<td height="26">&nbsp;</td>
				<td height="26" colspan="2"><span class="color_red" id="cr"></span></td>
			</tr>
		</table>
	</div>
</body>
</html>