<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>附件管理</title>
<link href="" rel="SHORTCUT ICON" />
<link href="${ctx}/swfupload/UploadPanel.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${ctx}/swfupload/swfupload.js"></script>
<script type="text/javascript" src="${ctx}/swfupload/UploadPanel.js"></script>

</head>
<body>
<form action="${ctx}/attach/addAttach.action" method="post" enctype="multipart/form-data"></form>

	<script type="text/javascript">
	Ext.onReady(function() {
		var attachPanel = Ext.create('Ext.ux.uploadPanel.UploadPanel',{
			title : '附件上传',
			addFileBtnText : '选择文件',
			uploadBtnText : '上传',
			removeBtnText : '移除所有',
			cancelBtnText : '取消上传',
			file_post_name:'Filedata',
			file_size_limit : 1,//MB
			file_types:'txt;doc,docx',//限制格式 如“txt;doc,docx”，用英文分号隔开
			upload_url : '${ctx}/attach/addAttach.action'
		});
		Ext.create("Ext.container.Viewport", {
			layout: "border",
			items: [attachPanel]
		});
	});
	</script>
</body>
</html>