<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	</head>
	<body>
		<div id="processDefinitionDetailsDiv" style="width: 100%;height: 100%;background-color: white;overflow: auto;">
		<table width="100%"  cellpadding="0" cellspacing="1" border="0">
			<tr>
				<td colspan="4" style="height:28px;border:1px dotted #999;white-space:nowrap;text-align: center;"><b>流程定义基本信息</b></td>
			</tr>
			<tr>
				<td style="height:28px;white-space:nowrap;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left; width: 20%;">流程模版ID：</td>
				<td style="height:28px;text-align: left; border-left: #999 1px dotted;border-bottom: #999 1px dotted;width: 30%;">${activitiDefineTemplate.id}</td>
				<td style="height:28px;white-space:nowrap;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left;; width: 20%;">流程模版名称：</td>
				<td style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left; width: 30%;">${activitiDefineTemplate.name}</td>
			</tr>
			<tr>
				<td colspan="1" style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;white-space:nowrap;text-align: left;; width: 20%;">流程模版真实系统名称：</td>
				<td colspan="3" style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left; width: 30%;">${activitiDefineTemplate.realName}</td>
				<tr>
				<td style="height:28px;white-space:nowrap;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left;; width: 20%;">流程模版key值：</td>
				<td style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left; width: 30%;">${activitiDefineTemplate.processDefineKey}</td>
				<td style="height:28px;white-space:nowrap;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left;; width: 20%;">流程模版种类名称：</td>
				<td style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left; width: 30%;">${activitiDefineTemplate.categoryName}</td>
				</tr>
			<tr>
			
				<td colspan="1" style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;white-space:nowrap;text-align: left;; width: 20%;">流程模版相对路径：</td>
				<td colspan="3" style="height:28px;border-left: #999 1px dotted;border-bottom: #999 1px dotted;text-align: left; width: 30%;">${activitiDefineTemplate.url}</td>
			</tr>
		</table>
		</div>
		
	</body>
</html>
