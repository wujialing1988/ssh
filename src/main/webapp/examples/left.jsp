<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/pages/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@include file="/WEB-INF/pages/common/ext.jsp"%>
<script type="text/javascript" src="leftTreeData.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>通用控件示例</title>
<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
<script type="text/javascript">
Ext.require([
    'Ext.tree.Panel'
]);

Ext.onReady(function(){
	Ext.QuickTips.init();
	var store = Ext.create('Ext.data.TreeStore', lefttreedata);

	var treePanel=Ext.create('Ext.tree.Panel', {
	    border:false,
	    store:store,
	    listeners:{
	        itemclick:function(obj, record, item, index, e, eOpts ){
	          var url = record.raw.url;
	          if(!url) return;
        	  var src=parent.window.frames['iframeRight'].location.href;
        	  if(src.indexOf(url)==-1){
      		    parent.window.frames['iframeRight'].location.href=url;
      	      }
        	 }
	      },
	      tbar:new Ext.Toolbar({
			    style:'border-top:0px;border-left:0px',
			    items:[
				   	'->',
				   	{
			            iconCls: 'icon-expand-all',
						tooltip: '展开所有',
			            handler: function(){ treePanel.getRootNode().expand(true); },
			            scope: this
			        },
			        '-',
			        {
			            iconCls: 'icon-collapse-all',
			            tooltip: '折叠所有',
			            handler: function(){ treePanel.getRootNode().collapse(true); },
			            scope: this
			        }]
		        })
	});
	new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[treePanel]
	})
});
</script>
</head>
<body>
</body>
</html>
