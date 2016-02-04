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
		                text: '待办任务',
		                leaf: true,
		                id:"1"
		            }, {
		                text: '已办任务',
		                leaf: true,
		                id:"2"
		            }, 
		            {
		            	  text: '已发任务',
			               leaf: true,
			               id:"3"	
		            }
		            /* , {
		                text: '委托授权',
		                hidden:true,
		                leaf: true,
		                id:"4"
		            } */
		            ]
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
        		 if(src.indexOf("toPersonTaskManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toPersonTaskManage.do";
        	      }
	          }else if(id=="2"){
        		 if(src.indexOf("toPersonDoneTaskManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toPersonDoneTaskManage.do";
        	      } 
        	  }else if(id=="3"){
        	    if(src.indexOf("toPersonApplyManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toPersonApplyManage.do";
        	      } 
        	  }else if(id=="4"){
        	    if(src.indexOf("toPersonDelegateManage.do")==-1){
        		    parent.window.frames['iframeRight'].location.href="${ctx}/bpm/toPersonDelegateManage.do";
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
