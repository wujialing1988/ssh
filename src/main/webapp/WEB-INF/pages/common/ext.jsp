<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript" src="${ctx}/scripts/common/jquery-1.6.4.min.js"></script>
<script type="text/javascript" src="${ctx}/scripts/common/my97DatePicker/WdatePicker.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/scripts/extjs/resources/css/ext-all.css"/>
<script type="text/javascript" src="${ctx}/scripts/extjs/ext-all.js"></script>
<script type="text/javascript" src="${ctx}/scripts/extjs/locale/ext-lang-zh_CN.js"></script>
<script type="text/javascript" src="${ctx}/scripts/extjs/ux/TipsWindow.js"></script>
<script type="text/javascript" src="${ctx}/scripts/extjs/ux/data/FailureProcess.js"></script>
<script type="text/javascript" src="${ctx}/scripts/common/SystemConstant.js"></script>
<script type="text/javascript" src="${ctx}/scripts/extjs/ux/ExtjsExtend.js"></script>
<script type="text/javascript" src="${ctx}/scripts/extjs/ux/ExtJsExtendVTypes.js"></script>
<script type="text/javascript" src="${ctx}/scripts/common/validSession.js"></script>

<script type="text/javascript" >
var SysContext = {
	<s:if test="#session.currentUserName!=null || #request.currentUserName!=null">
	curentUser : {
		userId:'<s:property value="#session.CurrentUser.id" />',
		username:'<s:property value="#session.CurrentUser.username" />',
		realname:'<s:property value="#session.CurrentUser.realname" />'
	}
	</s:if>
};
</script>