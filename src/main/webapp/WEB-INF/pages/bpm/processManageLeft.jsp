<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>流程管理</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
<script type="text/javascript">
Ext.require([
    'Ext.tree.Panel'
]);
Ext.onReady(function(){
	var store = Ext.create('Ext.data.TreeStore', {
	    root: {
	    	 text: "流程管理树",
		     expanded: true,
		     id:"0",
		     children: [{
	                text: '流程模版管理',
	                leaf: true,
	                id:"1"
	            }, {
	                text: '流程监控',
	                leaf: true,
	                id:"2"
	            }, {
	                text: '流程运行基础数据管理',
	                leaf: false,
	                id:"3",
	                children: [{
		            	 text: '流程模版分类管理',
			             leaf: true,
			             id:"32"
		            },{
		            	 text: '表单地址管理',
			             leaf: true,
			             id:"33"
		            }]
	            }]
	    }
	});

	var treePanel=Ext.create('Ext.tree.Panel', {
	    rootVisible: false,
	    border:false,
	    
	    store:store,
	    listeners:{
	    	afterrender:function(obj,node, records, successful){
	    		var node=store.getNodeById("1");
	    		treePanel.getSelectionModel().select(node);
	        },
	        itemclick:function(obj, record, item, index, e, eOpts ){
	          var id=record.get("id");
        	  var src=parent.window.frames['iframeRight'].location.href;
	           if(id=="1"){
        		 if(src.indexOf("toProcessTemplateManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toProcessTemplateManage.do";
        	      }
	          }else if(id=="2"){
        		 if(src.indexOf("toProcessListenerManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toProcessListenerManage.do";
        	      } 
        	  }else if(id=="32"){
        	    if(src.indexOf("toProcessCategoryManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toProcessCategoryManage.do";
        	      } 
        	  }else if(id=="33"){
        	    if(src.indexOf("toProcessFormManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toProcessFormManage.do";
        	      } 
        	  }
        	 }
        	   
	      }
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
