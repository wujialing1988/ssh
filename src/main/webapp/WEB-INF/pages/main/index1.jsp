<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<script type="text/javascript" src="${ctx}/scripts/login/jcookie.js"></script>
<script type="text/javascript" src="${ctx}/scripts/login/isLogin.js"></script>
<!-- <meta http-equiv="x-ua-compatible" content="ie=7" /> -->
<html class="overflow_hidden">
<head>
<title>公司开发架构</title>

<script>

function getIE() {
	if (navigator.appName == "Microsoft Internet Explorer") {
		if (navigator.appVersion.match(/7./i) == '7.') {
			var hMainCol = document.body.offsetHeight;
			document.getElementById("frame_Content").height = hMainCol - 106;
		} else {
		}
	}
}
	
	function topHover_show(id) {
		if (document.getElementById("topLi_" + id).className != "a_click") {
			document.getElementById("top_hover_" + id).style.display = "block";
			document.getElementById("topLi_" + id).className = "li_2";
			document.getElementById("top_menu").style.zIndex = "100";
		} else {
			document.getElementById("top_hover_" + id).style.display = "block";
			document.getElementById("top_menu").style.zIndex = "100";
		}
	}
	function topHover_unShow(id) {
		var topHover = document.getElementById("top_hover_" + id);
		if (document.getElementById("topLi_" + id).className != "a_click") {
			if(topHover) topHover.style.display = "none";
			document.getElementById("topLi_" + id).className = "";
			document.getElementById("top_menu").style.zIndex = "10";
		} else {
			if(topHover) topHover.style.display = "none";
			document.getElementById("top_menu").style.zIndex = "10";
		}
	}
	function getBg(num){
		  var liNum=document.getElementById("top_menu").getElementsByTagName("li");
		  for(var id = 0;id<=(liNum.length-1);id++)
		  {
		    document.getElementById("topLi_"+id).className="";
		  }
		    document.getElementById("topLi_"+num).className=document.getElementById("topLi_"+num).className+"a_click";
			topHover_unShow(num);
			numStr=num;
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
						//parent.window.location.href="${ctx}/toLogin.action";
						isLogOut();
						window.location.href="${ctx}/user/toLogin.action";
					}
			},
			failure : function(res,options) {
				window.location.href="${ctx}/user/toLogin.action";
			}
		});
	}
	/**
	*修改密码
	*/
	  function updatePassWord(){
		var updatePassWordForm=Ext.create("Ext.form.Panel", {
			url:"${ctx}/user/updatePassword.action",
			layout: 'form',
			bodyStyle :'padding:15px 10px 0 0',
			border: false,
			labelAlign: 'right',
			fieldDefaults: {
	            labelWidth: 60,
	        	labelAlign: 'right'
	        },
	        defaults: {
		        anchor: '70%'
		    },
		    defaultType: 'textfield',
		    items: [
	    	{ 
	    		allowBlank:false, 
	    		fieldLabel: '原密码', 
	    		name: 'oldPassword', 
	    		inputType: 'password',
	    		minLength:SystemConstant.passwordMinLength,
	    		regex : /^[^\u4e00-\u9fa5]{0,}$/,
				vtypeText:'密码不对',
				validator: function(value){
					var returnObj = null;
					$.ajax({
						url : '${ctx}/user/validateUser.action',
						data:{value: value, dictField:'password'},
						cache : false,
						async : false,
						type : "POST",
						dataType : 'json',
						success : function (result){
							if(!result.valid){
								returnObj = result.reason;
							}else{
								returnObj = true;
							}
						}
					});
					
					return returnObj;
				}
			}, 
		    {
				allowBlank:false, 
	    		fieldLabel: '新密码', 
	    		name: 'newPassword',
	    		inputType: 'password',
	    		minLength:SystemConstant.passwordMinLength,
	    		maxLength:18,
	    		regex : /^[^\u4e00-\u9fa5]{0,}$/
		    },
		    {
		    	allowBlank:false, 
	    		fieldLabel: '确认密码', 
	    		name: 'newPassword1',
	    		inputType: 'password',
	    		vtype:"updateValidatePassword",//自定义的验证类型
	    		vtypeText : '确认密码错误，请检查'
		    }]
		 });
		 
		updatePassWordWin=Ext.create("Ext.window.Window",{
			title: SystemConstant.updatePwd,
			resizable: false,
			buttonAlign:"center",
		  	height: 180,
		    width: 380,
		    modal:true,
		    bodyStyle: 'background:RGB(255,255,255)',
		    layout: 'fit',
		    closeAction:'destroy',
		    items: [updatePassWordForm],
		    buttons:[{
				    text: SystemConstant.yesBtnText,
			    	handler: function(){
			    		if(updatePassWordForm.form.isValid()){
			    			updatePassWordForm.form.submit({
		    				    success : function(form, action) {
		    					    new Ext.ux.TipsWindow({
										title: SystemConstant.alertTitle,
										autoHide: 3,
										html:action.result.msg
									}).show();
		    					    
		    					    updatePassWordWin.close();
		    					    
		    					    setTimeout(function(){
                                        Ext.Ajax.request({
                                            url : '${ctx}/user/logout.action',
                                            success : function(res ,options) {
                                                var json = Ext.decode(res.responseText);
                                                if(json.success){
                                                    window.location.href="${ctx}/toLogin.action";
                                                }
                                            }
                                        });
                                    },2000);
		    				    },
		    				    failure : function(form,action){
		    					    Ext.Msg.alert(SystemConstant.alertTitle,action.result.msg);
		    					    updatePassWordWin.close();
		    				    }
			    			});
		 				}
	                }
				},{
				    text: '关闭',
	                	handler: function(){
	                		updatePassWordWin.close();
	                }
			}]
		 });
		updatePassWordWin.show();
		Ext.apply(Ext.form.VTypes,{
			updateValidatePassword:function(val,field){//val指这里的文本框值，field指这个文本框组件
				return (val== updatePassWordForm.getForm().findField("newPassword").getValue());
			}
		});
	}
	
	function toHelp(){
		window.open("${ctx}/help/index.htm");
	}
</script>
</head>
<body class="overflow_hidden" onload="getIE();">
	<div class="frame2_top">
		<div class="top_logo">公司开发架构 V 1.6</div>
		<div class="top_img">
			<span class="top_right"> <input name="" type="button" value=""
				class="top_help" onclick="toHelp();" /> <input name="" type="button" value=""
				class="top_quit" onclick="logout();" /></span> <span class="top_bot bot2"> <s:if
					test="#session.currentUserName!=null || #request.currentUserName!=null">
					欢迎您 <s:if test="#session.CurrentUser.type==0"><a href="#" onclick="updatePassWord();">${currentUserName }</a></s:if>
    			<s:else>${currentUserName }</s:else>！
    		</s:if> <s:else>
    			未登录
    		</s:else>
			</span>
		</div>
	</div>
	<div class="top_menu frame2_top_menu" id="top_menu">
		<ul>
			<s:iterator value="menuVos"  status="s">
				<li style="cursor: pointer;" id="topLi_<s:property value="#s.index"/>">
					<s:if test="children==null">
                    <a href="${ctx}/<s:property value="href"/>" onclick="getBg(<s:property value="#s.index"/>)" url="<s:property value="href"/>" target="frame_Center" ><s:property value="name"/></a>
                    </s:if>
                    
                    <s:if test="children!=null">
                    <a href="${ctx}/toCenter.action?id=${id}" onclick="getBg(<s:property value="#s.index"/>)" url="<s:property value="href"/>" target="frame_Center" ><s:property value="name"/></a>
                    </s:if>
				</li>
				
				<!-- 
				<li style="cursor: pointer;" id="topLi_<s:property value="#s.index"/>" <s:if test="children!=null">  onmouseover="topHover_show(<s:property value="#s.index"/>)" onmouseout="topHover_unShow(<s:property value="#s.index"/>)"</s:if>>
                    <s:if test="children==null">
                    <a href="${ctx}/<s:property value="href"/>" onclick="getBg(<s:property value="#s.index"/>)" url="<s:property value="href"/>" target="frame_Center" ><s:property value="name"/></a>
                    </s:if>
                    
                    <s:if test="children!=null">
                    <a href="${ctx}/toCenter.action?id=${id}" onclick="getBg(<s:property value="#s.index"/>)" url="<s:property value="href"/>" target="frame_Center" ><s:property value="name"/></a>
                    <div class="top_m_2" id="top_hover_<s:property value="#s.index"/>" style="z-index:2">
                    <s:iterator value="children">
                        <span><a href="${ctx}/<s:property value="href"/>" onclick="getBg(<s:property value="#s.index"/>)" target="frame_Center" ><s:property value="name"/></a></span>
                    </s:iterator>
                    </div>
                    </s:if>
                </li>
				 -->
		    </s:iterator>
		</ul>
	</div>
	<div id="centerDiv"  class="frame2_content">
		<iframe id="frame_Center" width="100%" height="100%"
			name="frame_Center" frameborder="0" scrolling="auto"
			src="${ctx}/toFrameIndex.action"></iframe>
	</div>
	
	<div class="frame2_bottom">
		<div class="frame2_bottom_txt">
			Copyright&nbsp;&nbsp;2015&nbsp;&nbsp;&nbsp;版权所有：大庆金桥信息技术工程有限公司&nbsp;&nbsp;&nbsp;技术支持：<a
				href="#" target="content">大庆金桥信息技术工程有限公司成都分公司</a>
		</div>
	</div>
</body>
</html>