<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>日志管理</title>
<script type="text/javascript" src="${ctx}/scripts/log/LogGrid.js"></script>
<style type="text/css">
.x-form-layout-table {
	table-layout: fixed;
}
</style>
</head>
<body>
	<script type="text/javascript">
		Ext.onReady(function() {
			Ext.QuickTips.init();
			Ext.require([ "Ext.container.*", "Ext.grid.*", "Ext.toolbar.Paging", "Ext.form.*", "Ext.data.*" ]);

			Ext.define('treeModel', {
				extend : 'Ext.data.Model',
				fields : [ {
					name : 'nodeId',
					type : 'int'
				}, {
					name : 'parentId',
					type : 'int'
				}, {
					name : 'id',
					type : 'int',
					mapping : 'nodeId'
				}, {
					name : 'text',
					type : 'string'
				} ]
			});
			
			//treepanel
			 var treeStore = Ext.create("Ext.data.TreeStore", {
			        proxy: {
			            type: "ajax",
			            actionMethods: {
			                read: 'POST'
			            },
			            url: "${ctx}/log/getLogType.action"
			        },
			        root: {
			        	text:"日志类型",
			        	nodeId:"0"
			        },
			        listeners: {
                       beforeload: function (ds, opration, opt) {
                           opration.params.code = "LOGTYPE";
                       }
                   }
			    });
			 treeStore.on("load",function(store, node, records){
				 if(node != null && node.raw.nodeId == "0" && node.firstChild){
					 treePanel.getSelectionModel().select(treePanel.getRootNode().firstChild,true);
					 treePanel.fireEvent("itemclick",treePanel.getView(),node.firstChild);
				 }
			 });
						 
			 var treePanel=Ext.create("Ext.tree.Panel", {
			 		title:'日志类型',
			 		layout:'fit',
					width: 200,
					region: "west",
					border: false,
					collapsible: true,
           			split: true,
					collapseMode:"mini",
			       	store: treeStore,
			     	id:"typeTree",
			        useArrows: true,
			        rootVisible : true,
			        dockedItems: [{
			        	xtype: 'toolbar',
						style:"border-top:0px;border-left:0px",
						items:[{
					        iconCls: "icon-expand-all",
					        text:'展开',
							tooltip: "展开所有",
					        handler: function(){ treePanel.expandAll(); },
					        scope: this
					    },{
					        iconCls: "icon-collapse-all",
					        text:'折叠',
					        tooltip: "折叠所有",
					        handler: function(){ treePanel.collapseAll(); },
					        scope: this
					    }]
			        }],
			        listeners:{
			        	"afterrender":function( treePanel, eOpts ){
			        		var path = treePanel.getRootNode().getPath();
			        		treePanel.expandPath(path)
			        	}
			        }
			    });
			 treePanel.on("itemclick",function(view,record,item,index,e,opts){  
			     //获取当前点击的节点  
			      var treeNode=record.raw;  
			      var text=treeNode.text;
			      var id = treeNode.nodeId;
			      if(treeNode.id!="root"){
			    	     sshframe.log.logStore.on('beforeload',function(store,options){
				    	 var new_params = {"type":id};
				    	  Ext.apply(store.proxy.extraParams,new_params);
				      });
 	   				var proxy = sshframe.log.logStore.getProxy();
				      proxy.setExtraParam("startDate",Ext.Date.format(Ext.getCmp('startDate').value,'Y-m-d'));
 	   				  proxy.setExtraParam("endDate",Ext.Date.format(Ext.getCmp('endDate').value,'Y-m-d'));
 	   				  sshframe.log.logStore.loadPage(1);
 	   				  sshframe.log.logStore.load(proxy);
			 	}
		 	});
			 
			 Ext.create("Ext.container.Viewport", {
				layout: "border",
				items: [ treePanel,sshframe.log.logGrid]
			});
			 
		});

	</script>
</body>
</html>