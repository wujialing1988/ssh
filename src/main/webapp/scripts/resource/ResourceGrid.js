/**
 * 定义资源Model
 * */
Ext.define("resourceModel",{
	extend:"Ext.data.Model",
	fields:[
	    {name: "id"}, 
	    {name: "resourceName"},
		{name: "code"},
		{name: "resourceTypeId"},
		{name: "resourceTypeName"},
		{name: "resourceTypeValue"},
		{name: "resourceTypeDictCode"},
		{name: "href"},
		{name: "hrefTarget"},
		{name: "iconUrl"},
		{name: "createDate"},
		{name: "parentResourceId"},
		{name: "parentResourceName"},
		{name: "remarks"}
	]
});
/**
 * 定义资源数据源
 * */
var resourceStore=Ext.create("Ext.data.Store", {
	model:"resourceModel",
	proxy : {
		type : "format",
		url : basePath + "/resource/getResourceList.action"
	}
});
/**
 * 定义资源grid
 */
var resourceGrid = Ext.create("Ext.grid.Panel", {
	title : '资源管理',
	region : "center",
	bbar : Ext.create("Ext.PagingToolbar", {
		store : resourceStore
	}),
	selModel : Ext.create("Ext.selection.CheckboxModel"),
	store : resourceStore,
	columns : [
	    {xtype: "rownumberer",width:60,text:'序号',align:"center"},
	    {header: "id",dataIndex: "id",hidden: true},
	    {header: "parentResId",dataIndex: "parentResourceId",hidden: true},
	    {header: "上级",width: 200,dataIndex: "parentResourceName"},
	    {header: "名称",width: 200,dataIndex: "resourceName"},
		{header: "类型",width: 200,dataIndex: "resourceTypeName",},
		{header: "编码",width: 200,dataIndex: "code"},
		{header: "URL",width: 200,dataIndex: "href"},
		{header: "描述",width: 200,dataIndex: "remarks"}   
	],
	tbar : [ '->', {
		xtype : 'button',
		text : SystemConstant.addNextBtnText,
		iconCls : 'add-button',
		id : 'addResource',
		handler : function() {
			addResource();
		}
	}, {
		xtype : 'button',
		id : 'updateResource',
		text : SystemConstant.modifyBtnText,
		disabledExpr : "$selectedRows != 1",// $selected 表示选中的记录数不等于1
		disabled : true,
		iconCls : 'edit-button',
		handler : function() {
			updateResource();
		}
	}, {
		xtype : 'button',
		text : SystemConstant.deleteBtnText,
		disabled : true,
		disabledExpr : "$selectedRows == 0",
		iconCls : 'delete-button',
		handler : function() {
			deleteResource();
		}
	} ]
});

/**
 * 添加资源方法
 */
var addResource = function() {
	parentResourceWin.setTitle(SystemConstant.addBtnText);
	var basicForm = parentResourceWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath + '/resource/addResource.action';
	parentResourceTypeStore.load();
	basicForm.findField('resourceCode').setDisabled(false);
	if(selectNode.raw.nodeId!=0){
		basicForm.findField('resource.resource.id').setValue(selectNode.raw.nodeId);
		basicForm.findField('resource.resource.resourceName').setValue(selectNode.raw.text);
		basicForm.findField('parentResourceName').setVisible(true);
	}else{
		basicForm.findField('parentResourceName').setVisible(false);
	}
	parentResourceWin.show();
};
/**
 * 修改资源方法
 * */
var updateResource = function() {
	parentResourceWin.setTitle(SystemConstant.modifyBtnText);
	var row = resourceGrid.getSelectionModel().getSelection()
	var resourceId = row[0].data.id;
	var basicForm = parentResourceWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath + '/resource/updateResource.action';
	parentResourceTypeStore.load();
	basicForm.findField('resource.id').setValue(resourceId);
	basicForm.load({
		url : basePath + '/resource/getResourceById.action',
		params : {
			resourceId : resourceId
		}
	});
	if(row[0].data.parentResourceId!=0){
		basicForm.findField('parentResourceName').setVisible(true);
	}else{
		basicForm.findField('parentResourceName').setVisible(false);
	}
	basicForm.findField('resourceCode').setDisabled(true);
	parentResourceWin.show();
};
/**
 * 删除资源方法
 * */
var deleteResource = function(){
	var rows = resourceGrid.getSelectionModel().getSelection();
	var ids = "";
	for (var i = 0; i < rows.length; i++) {
		ids += (rows[i].data.id + ",");
	}
	ids = ids.substring(0, ids.length - 1);
	
	Ext.Ajax.request({
		url : basePath+'/resource/isCanDelete.action',
		params : {resourceIds: ids},
		success : function(res, options) {
			 var data = Ext.decode(res.responseText);
			 if(data.success){
				 Ext.Msg.confirm(SystemConstant.alertTitle, "确认删除所选资源吗？", function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : basePath + '/resource/deleteResource.action',
								params : {
									resourceIds : ids
								},
								success : function(res, options) {
									var data = Ext.decode(res.responseText);
									if (data.success) {
										treePanel.getStore().reload({  
					                        node:treePanel.getRootNode(),
					                        callback: function () {  
					                        }  
					                    });
										resourceStore.loadPage(1);
										Ext.Msg.showTip(data.msg);
									} else {
										Ext.Msg.showError(data.msg);
									}
								},
								failure : sshframe.FailureProcess.Ajax
							});
						}
					});
			 }else{
			 	Ext.MessageBox.show({
					title: SystemConstant.alertTitle,
					msg: data.msg,
					buttons: Ext.MessageBox.OK,
					icon: Ext.MessageBox.INFO
				});
			 	return false;
			}
		}
	});
};
