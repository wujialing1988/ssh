<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>前端验证示例</title>
<script type="text/javascript" src="${ctx}/scripts/common/redundancyData.js"></script>
<script type="text/javascript" src="${ctx}/examples/framePage/FramePageGrid.js"></script>
<script type="text/javascript" src="${ctx}/examples/framePage/FramePageWin.js"></script>
</head>
<body>
	 <script type="text/javascript">
		Ext.onReady(function() {
			Ext.create("Ext.container.Viewport", {
				layout : "border",
				items : [sshframe.examples.FramePageGrid]
			});
		});
	</script>
</body>
</html>