/**
 * 实现记住密码和自动登录
 * 哥特死亡工业
 * 2014年2月12日
 */
 
//注销系统后不能再自动登录
function isLogOut(){
	var date = new Date();
	date.setTime(date.getTime() + (0.1 * 60 * 1000));
	$.cookie('isLogOut', 'true', { expires: date });
	//$.cookie("isLogOut", "true"); // 存储一个带7天期限的 cookie
}
//点击登录后，即可实现自动登录
function log1(){
	$.cookie("isLogOut", "false", { expires: 7 }); // 存储一个带7天期限的 cookie
}
