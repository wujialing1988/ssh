<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>个人中心</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
 	<script type="text/javascript">
 	Ext.onReady(function(){
 		var hrefLeft='${ctx}/bpm/toPersonManageLeft.do';
 		var hrefRight='${ctx}/bpm/toPersonTaskManage.do';
 		new Ext.Viewport({
 		    layout: 'border',
 		    items: [{
 		        region: 'west',
 		   	    title:"个人中心",
 		        width: 200,
 		        xtype:'panel',
 		        collapsible: true,
 		        collapseMode:"mini",
 		        split: true,
 		        border:false,
 		        boxMinWidth:200,
 		        minWidth:200,
 		        maxWidth:200,
 		        html:"<iframe width='100%' height='100%' frameborder='0' scrolling='no' name='iframeLeft' src='"+hrefLeft+"'></iframe>"
 						
 		    },{
 		        region: 'center',
 		        border:false,
 		        layout:'fit',
 		        items: {
 		        	border:false,
 		            html:"<iframe width='100%' height='100%' frameborder='0' scrolling='no' name='iframeRight' src='"+hrefRight+"'></iframe>"
 		        }
 		    }]
 		});
 	});
 	</script>
</head>
<body>

</body>
</html>
