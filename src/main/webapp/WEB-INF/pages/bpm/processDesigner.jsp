﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>流程模板设计与流程修改</title>
	<script type="text/javascript" src="${ctx}/process/FABridge.js"></script>
    <script type="text/javascript" src="${ctx}/process/FlowDesigner.js"></script>
    <script type="text/javascript">
	window.onload = function(){
		FlowDesigner.addInitCallback("b_FlowDesigner",function(){
			if("${param.operate}"=="add"){
			FlowDesigner.add("b_FlowDesigner");
			}else if("${param.operate}"=="modify"){
				FlowDesigner.edit("b_FlowDesigner","${param.processDefineKey}");
			}else if("${param.operate}"=="editInst"){
				FlowDesigner.editInst("b_FlowDesigner","${param.processInstanceId}");
			}
		});
		
	}
	function refleshProcessGrid(){
	  try{
		  parent.opener.refleshProcess("${param.operate}");
		 }catch(e){
		}
	}
  </script>
</head>

<body>

  	<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
			 width="100%" height="100%" style="height:100%"  id="b_FlowDesigner"
			codebase="http://fpdownload.macromedia.com/get/flashplayer/current/swflash.cab">
			<param name="movie" value="${ctx}/process/Designer.swf" />
			<param name="quality" value="high" />
			<param name="flashvars" value="bridgeName=b_FlowDesigner"/>
			<param name="bgcolor" value="#f5f5dc" />
			<param name="allowScriptAccess" value="sameDomain" />
			<embed src="${ctx}/process/Designer.swf" quality="high" bgcolor="#f5f5dc"
				width="100%" height="100%"  align="middle" name="b_FlowDesigner"
				play="true"
				loop="false"
				quality="high"
				allowScriptAccess="sameDomain"
				flashvars="bridgeName=b_FlowDesigner"
				allowFullScreen="true" 
				type="application/x-shockwave-flash"
				pluginspage="http://www.adobe.com/go/getflashplayer">
			</embed>
	</object>
</body>
</html>