var treePanel = null;
var treeStore = Ext.create("Ext.data.TreeStore", {
    proxy: {
        type: "ajax",
        actionMethods: {
            read: 'POST'
        },
        url: basePath+"/org/getUnitTreeListNotCheck.action"
    },
    root: {
    	text:"组织",
    	nodeId:"0",
    	expanded:true,
    	id:"0"
    },
    listeners: {
        beforeload: function (ds, opration, opt) {
            opration.params.parentId = opration.node.raw.nodeId;
        }
    }
});

treeStore.on("load",function(store, node, records){
	if (selectNode == null && node != null && node.raw.nodeId == "0") {
	treePanel.getSelectionModel().select(node,true);
	treePanel.fireEvent("itemclick",treePanel.getView(),node);
	}
});

treePanel=Ext.create("Ext.tree.Panel", {
	title:'组织信息',
	store: treeStore,
	region: "west",
	layout:'fit',
	width: 200,
	id:"typeTree",
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
	    }
	]
    }],
    listeners:{
    	"afterrender":function( treePanel, eOpts ){
    		var path = treePanel.getRootNode().getPath();
    		treePanel.expandPath(path)
    	},
    	"itemcontextmenu":function(tree, record, item, index, e, eOpts){
	        		selectNode = record;
	        		e.preventDefault();
	        		if(record.raw.nodeId == "0"){
	        			Ext.getCmp("updateOrg").setVisible(false);
	        			Ext.getCmp("deleteOrg").setVisible(false);
	        		}else{
	        			Ext.getCmp("updateOrg").setVisible(true);
	        			Ext.getCmp("deleteOrg").setVisible(true);
	        		}
	        		//materialMenu.showAt(e.getPoint());
    	},
    	'itemmousedown': function( treePanel, record, item, index, e, eOpts ){
        		//currentIndex = record.parentNode.indexOf(record)
        		srcOrgId = record.raw.nodeId;
    	},
    	'itemmove':function( treePanel, oldParent, newParent, index, eOpts ){
    			var targetOrgId = 0;
    			position = "";
							if(index == 0){
									if(newParent.hasChildNodes()){
										var i = 0;
										newParent.eachChild(function(){
											i++;
										});
									}
	    				if(i = 1){
    	    				targetOrgId = newParent.raw.nodeId;
    	    				position = "INNER";
	    				}else{
	    					position = "PREV";
	    					targetOrgId = newParent.getChildAt(index).raw.nodeId;
	    				}
        		}else if(index > 0){
        				position = "NEXT";
        				targetOrgId = newParent.getChildAt(index - 1).raw.nodeId;
        		}
            			$.ajax({
							   			type: "POST",
							   			dateType:'json',
							   			url: basePath+"/org/updateOrgDisOrder.action",
							   			data: {
											   'srcOrgId':srcOrgId,
											   'targetOrgId':targetOrgId,
											   'position':position
							   			}
									}); 
    		}
    
    }
});

treePanel.on("itemclick",function(view,record,item,index,e,opts){  
 //获取当前点击的节点  
  var treeNode = record.raw;  
  var text = treeNode.text;
  var id = treeNode.nodeId;
	  selectNode = record;
	  Ext.getCmp('addOrg').setDisabled(false);
	 
  orgStore.on('beforeload',function(store,options){
	  var new_params = {"parentId":id};
	  Ext.apply(store.proxy.extraParams,new_params);
  });
  orgStore.loadPage(1);
});

