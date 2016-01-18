<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	（1）、字符串显示到页面！<br>
	你好！${user}！<br>
	（2）、判断语句！<br>
	<#if random gte 90>
	优秀！
	<#elseif random gte 80>
	良好！
	<#else>
	一般！	
	</#if><br>
	（3）、list页面遍历！<br>
	<#list lst as dizhi >
	<b>${dizhi.country}</b> <br/>
	</#list>

</body>
</html>