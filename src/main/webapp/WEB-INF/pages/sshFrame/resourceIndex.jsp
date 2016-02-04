<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>资源管理</title>
<link href="" rel="SHORTCUT ICON" />
<script type="text/javascript" src="${ctx}/scripts/resource/TreeGrid.js"></script>
<script type="text/javascript" src="${ctx}/scripts/resource/ResourceStore.js"></script>
<script type="text/javascript" src="${ctx}/scripts/resource/ResourceGrid.js"></script>
<script type="text/javascript" src="${ctx}/scripts/resource/ResourceWin.js"></script>
</head>
<body>
<script type="text/javascript">
</script>
<script type="text/javascript">
	var existflag = true;
	var selectNode = null;
	Ext.onReady(function() {
		Ext.create("Ext.container.Viewport", {
			layout : "border",
			border : true,
			renderTo : Ext.getBody(),
			items : [ treePanel, {
				region : 'center',
				layout : 'fit',
				border : false,
				items : [ resourceGrid ]
			} ]
		});
	});
</script>
</body>
</html>