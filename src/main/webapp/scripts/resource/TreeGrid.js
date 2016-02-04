/**
 * 定义资源树store
*/
var treeStore = Ext.create("Ext.data.TreeStore", {
	proxy : {
		type : "ajax",
		actionMethods : {
			read : 'POST'
		},
		url : basePath+ '/resource/getResourceByParentId.action'
	},
	root : {
		text : "资源",
		nodeId : "0",
		expanded:true
	},
	listeners : {
		beforeload : function(ds, opration, opt) {
			opration.params.parentResId = opration.node.raw.nodeId;
		}
	}
});
/*
* 定义资源树load事件
**/
treeStore.on("load", function(store, node, records) {
	if (selectNode == null && node != null && node.raw.nodeId == "0") {
		treePanel.getSelectionModel().select(node, true);
		treePanel.fireEvent("itemclick", treePanel.getView(), node);
	}
}); 
/*
* 定义资源树panel
**/
var treePanel = Ext.create("Ext.tree.Panel", {
	title : '资源信息',
	region : "west",
	width : 200,
	store : treeStore,
	rootVisible : true,
	id : "typeTree",
	dockedItems : [ {
		xtype : 'toolbar',
		style : "border-top:0px;border-left:0px",
		items : [ {
			iconCls : "icon-expand-all",
			text : '展开',
			tooltip : "展开所有",
			handler : function() {
				treePanel.expandAll();
			},
			scope : this
		}, {
			iconCls : "icon-collapse-all",
			text : '折叠',
			tooltip : "折叠所有",
			handler : function() {
				treePanel.collapseAll();
			},
			scope : this
		} ]
	} ],
	listeners : {
		"itemcontextmenu" : function(tree, record, item, index, e, eOpts) {
			selectNode = record;
			e.preventDefault();
			if (record.raw.nodeId == "0") {
				Ext.getCmp("updateResource").setVisible(false);
				Ext.getCmp("deleteResource").setVisible(false);
			}
		},
		"afterrender" : function(treePanel, eOpts) {
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
     selectNode=record;
     resourceStore.on('beforeload',function(store,options){
   	  var new_params = {"parentResId":id};
   	  Ext.apply(store.proxy.extraParams,new_params);
     });
     resourceStore.loadPage(1);
});
