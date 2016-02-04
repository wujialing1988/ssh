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
<link href="${ctx}/scripts/swfupload/UploadPanel.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${ctx}/scripts/swfupload/swfupload.js"></script>
<script type="text/javascript" src="${ctx}/scripts/swfupload/UploadPanel.js"></script>

</head>
<body>

	<script type="text/javascript">
	Ext.onReady(function() {
		
		var attachPanel = Ext.create('Ext.grid.UploadPanel',{
			addFileBtnText : '选择文件',
			uploadBtnText : '上传',
			removeBtnText : '移除所有',
			cancelBtnText : '取消上传',
			file_post_name:'uploadAttach',
			file_size_limit : 100,//MB
			file_types:'*.*',//限制格式 如“txt;doc,docx”，用英文分号隔开
			upload_url : '${ctx}/attach/addAttach.action',
			//attachGroupId:'8af2c99e5281b059015281b631360001',
			onUploadSuccess:function(newAttachGroupId){
				alert(newAttachGroupId);
			}
		});
		
		Ext.QuickTips.init();  
	    new Ext.Window({  
	        width : 650,  
	        title : '附件上传',  
	        height : 300,  
	        layout : 'fit',  
	        items : [  
				attachPanel
	        ]  
	    }).show();  
		
	});
	

	
	</script>
</body>
</html>