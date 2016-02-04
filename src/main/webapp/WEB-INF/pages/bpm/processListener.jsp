<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>流程监控与模版查看</title>
	<script type="text/javascript" src="${ctx}/process/FABridge.js"></script>
    <script type="text/javascript" src="${ctx}/process/FlowDesigner.js"></script>
    <script type="text/javascript">
	window.onload = function(){
		FlowDesigner.addInitCallback("b_FlowDesigner",function(){
		  if("${param.operate}"=="view"){
				FlowDesigner.see("b_FlowDesigner","${param.processDefineKey}");
			}else if("${param.operate}"=="monitor"){
				FlowDesigner.monitor("b_FlowDesigner","${param.processInstanceId}");
			}
		});
		
	}
	
	
  </script>
</head>

<body style="margin-left:0px;margin-top:0px">
<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
			 width="100%" height="100%" id="b_FlowDesigner"
			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="${ctx}/process/Monitor.swf" />
			<param name="quality" value="high" />
			<param name="flashvars" value="bridgeName=b_FlowDesigner"/>
			<param name="bgcolor" value="#f5f5dc" />
			<param name="allowScriptAccess" value="sameDomain" />
			<embed src="${ctx}/process/Monitor.swf" quality="high" bgcolor="#f5f5dc"
				width="100%" height="100%"  align="middle" name="b_FlowDesigner"
				play="true"
				loop="false"
				quality="high"
				flashvars="bridgeName=b_FlowDesigner"
				allowFullScreen="true" 
				allowScriptAccess="sameDomain"
				type="application/x-shockwave-flash"
				pluginspage="http://www.adobe.com/go/getflashplayer">
			</embed>
	</object>
</body>
</html>