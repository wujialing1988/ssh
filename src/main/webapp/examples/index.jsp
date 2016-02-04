<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/pages/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@include file="/WEB-INF/pages/common/ext.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>通用控件示例</title>
 	<script type="text/javascript">
 	Ext.onReady(function(){
 		var hrefLeft='${ctx}/examples/left.jsp';
 		var hrefRight='${ctx}/examples/right.html';
 		new Ext.Viewport({
 		    layout: 'border',
 		    items: [{
 		        region: 'west',
 		        width: 250,
 		        split: true,
 		        title:'通用控件',
 		        border:false,
 		        collapsible: true,
 		        collapseMode:"mini",
 		        boxMinWidth:200,
 		        minWidth:200,
 		        maxWidth:300,
 		        html:"<iframe width='100%' height='100%' frameborder='0' scrolling='no' name='iframeLeft' src='"+hrefLeft+"'></iframe>"
 		    },{
 		        region: 'center',
 		        border:false,
 		        layout:'fit',
 		       overflowY : "auto",
 		        items: {
 		        	border:false,
 		            html:"<iframe width='100%' frameborder='0'  height='100%' name='iframeRight' src='"+hrefRight+"'></iframe>"
 		        }
 		    }]
 		});
 	});
 	</script>
</head>
<body>

</body>
</html>
