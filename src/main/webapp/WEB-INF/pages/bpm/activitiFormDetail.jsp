<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
	<head>
		 <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	</head>
	<body>
		<div style="width: 100%;height: 100%;background-color: white;overflow: auto;">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size: 12px;font-family: '宋体', 'sans-serif'; border:0px;margin:0px;">
		 		<tr>
		      		<td width="20%" style="border:1px dotted #999;height:28px;text-align:right; padding-right:5px;">
						表单名称：
					</td>
				    <td colspan="3" width="30%" style="border-top: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;">
						${activitiForm.formName}&nbsp;
					</td>
		  		</tr>
		 		<tr>
		      		<td width="20%" style="border-left: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;height:28px;text-align:right; padding-right:5px;">
						表单地址：
					</td>
				    <td colspan="3" style="border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;">
						${activitiForm.formName}&nbsp;
					</td>
		  		</tr>
                
				<tr>
					<td style="height:28px;border-left: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;text-align:right; padding-right:5px;">
						适用种类：
					</td>
				    <td colspan="3" style="border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;">
						<c:if test="${activitiForm.categories!=null}">
						<c:forEach var="cate" items="${activitiForm.categories}">
						<c:out value="${cate.name}"></c:out>
						</c:forEach>
						</c:if>
						&nbsp;					
					</td>
				</tr>
					<tr>
					<td style="height:28px;border-left: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;text-align:right; padding-right:5px;">
						适用节点：
					</td>
				    <td colspan="3" style="border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;">
				          ${activitiForm.adaptationNode}&nbsp;
						&nbsp;					
					</td>
				</tr>
				</tr>
					<tr>
					<td style="height:28px;border-left: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;text-align:right; padding-right:5px;">
						描述：
					</td>
				    <td colspan="3" style="border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;">
				          ${activitiForm.description}&nbsp;
						&nbsp;					
					</td>
				</tr>
			</table>
		</div>
	</body>
</html>
