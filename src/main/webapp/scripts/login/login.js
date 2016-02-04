/**
 * 实现记住密码和自动登录
 * 哥特死亡工业
 * 2014年2月12日
 */
 //判断cookie是否记住用户名、密码、复选框、单选框的状态
$(document).ready(function() {
   if ($.cookie("rmbUser") == "true") {
		$("#rmbUser").attr("checked", true);
        $("#uersName_txt").val($.cookie("userName"));
        $("#password_txt").val($.cookie("passWord"));
        //$("#uersName_txt2").val($.cookie("userName1"));
    }
    if($.cookie("autoUser") == "true"){
    	$("#autoUser").attr("checked", true);
    	//btn_submit();//登录系统
    }
    
    if($.cookie("isLogOut") != "true"){
    	if($.cookie("autoUser") == "true"){
        	$("#autoUser").attr("checked", true);
        	btn_submit();//登录系统
        }
    }
    
    /*if($.cookie("zy") == "true"){
    	$("#zy").attr("checked", true);
    	document.getElementById("login_tr_2").style.display="none";
    	document.getElementById("login_tr_1").style.display="";
    }
    if($.cookie("fzy") == "true"){
    	$("#fzy").attr("checked", true);
    	document.getElementById("login_tr_2").style.display="";
    	document.getElementById("login_tr_1").style.display="none";
    }*/
});
//登录成功后
function loginUserInfo() {
  if (document.getElementById("rmbUser").checked == true) {
        var userName = $("#uersName_txt").val();
        var passWord = $("#password_txt").val();
        $.cookie("rmbUser", "true", { expires: 7 }); // 存储一个带7天期限的 cookie
        //$.cookie("autoUser", "true", { expires: 7 }); // 存储一个带7天期限的 cookie
        $.cookie("userName", userName, { expires: 7 }); // 存储一个带7天期限的 cookie
        $.cookie("passWord", passWord, { expires: 7 }); // 存储一个带7天期限的 cookie
    }else{
    	$.cookie("userName", '', { expires: -1 });
   	 	$.cookie("passWord", '', { expires: -1 });
   		$.cookie("rmbUser", "false", { expires: -1 });
    }
  if(document.getElementById("autoUser").checked == true){
	  $.cookie("autoUser", "true", { expires: 7 });
  }else{
	  $.cookie("autoUser", "false", { expires: -1 });
  }
}
function saveUserInfo(){
	if (document.getElementById("rmbUser").checked == true) {
		 document.getElementById("rmbUser").checked = true;
	}else{
		document.getElementById("autoUser").checked = false;
		/*$.cookie("userName", '', { expires: -1 });
   	 	$.cookie("passWord", '', { expires: -1 });
   		$.cookie("rmbUser", "false", { expires: -1 });
   		$.cookie("autoUser", "false", { expires: -1 });*/
	}
}
//判断是否保存自动登录
function automaticLogin(){
	if (document.getElementById("autoUser").checked == true){
		 document.getElementById("rmbUser").checked = true;
		 //$.cookie("autoUser", "true", { expires: 7 }); // 存储一个带7天期限的 cookie
		// $.cookie("rmbUser", "true", { expires: 7 });
	}else{
	 	//$.cookie("rmbUser", "", { expires: -1 });
		document.getElementById("autoUser").checked = false;
	 	//$.cookie("autoUser", "false", { expires: -1 });
	 	//saveUserInfo();//判断是否保存用户名和密码
	}
}

function automaticIsLogin(){
	document.getElementById("autoUser").checked = false;
	document.getElementById("rmbUser").checked = false;
}

//判断是否保存登录方式
function loginType(){
	if ($("#zy").attr("checked") == "checked"){
		$.cookie("zy", "true", { expires: 7 }); // 存储一个带7天期限的 cookie
		$.cookie("fzy", "false", { expires: -1 });//将该值从cookie中清除
		$.cookie("login_tr_2", "false", { expires: 7 }); // 存储一个带7天期限的 cookie
		$.cookie("login_tr_1", "true", { expires: 7 });
	}
	if ($("#fzy").attr("checked") == "checked"){
		$.cookie("fzy", "true", { expires: 7 }); // 存储一个带7天期限的 cookie
		$.cookie("zy", "false", { expires: -1 });//将该值从cookie中清除
		$.cookie("login_tr_1", "false", { expires: 7 }); // 存储一个带7天期限的 cookie
		$.cookie("login_tr_2", "true", { expires: 7 });
	}
}
//判断是否重新输入用户名
function uptUserName(){
	//$.cookie("rmbUser", "false", { expires: -1 });
	// $.cookie("autoUser", "false", { expires: -1 });
	// $.cookie("userName", '', { expires: -1 });
	 //$.cookie("passWord", '', { expires: -1 });
	 $("#password_txt").val('');
 	document.getElementById("rmbUser").checked = false;
 	document.getElementById("autoUser").checked = false;
}
//判断是否重新输入密码
function uptUserPrd(){
	//$.cookie("rmbUser", "false", { expires: -1 });
	// $.cookie("autoUser", "false", { expires: -1 });
	 //$.cookie("userName", '', { expires: -1 });
	// $.cookie("passWord", '', { expires: -1 });
 	document.getElementById("rmbUser").checked = false;
 	document.getElementById("autoUser").checked = false;
}
