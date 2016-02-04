Ext.define("orgModel",{
	extend:"Ext.data.Model",
	fields:[
			{name: "id"}, 
			{name: "orgName"},
			{name: "parentOrgId"}, 
			{name: "parentOrgName"},
			{name: "orgTypeDictCode"},
			{name: "orgType"},
			{name: "orgCode"}
		]
});
var orgStore=Ext.create("Ext.data.Store", {
    model:"orgModel",
	proxy: {
        type:"format",
	    url: basePath+"/org/getOrgList.action"
    }
});

var orgGrid = Ext.create("Ext.grid.Panel", {
	title : '组织管理',
	region : "center",
	bbar : Ext.create("Ext.PagingToolbar", {
		store : orgStore
	}),
	selModel : Ext.create("Ext.selection.CheckboxModel"),
	store : orgStore,
	columns : [
	    {xtype: "rownumberer",width:60,text:'序号',align:"center"},
	    {header: "id",dataIndex: "id",hidden: true},
	    {header: "parentOrgId",dataIndex: "parentOrgId",hidden: true},
	    {header: "上级",width: 200,dataIndex: "parentOrgName"},
	    {header: "名称",width: 200,dataIndex: "orgName"},
	    {header: "类型",width: 200,dataIndex: "orgType",sortable :false,menuDisabled: true},
        {header: "编码",width: 200,dataIndex: "orgCode"}
	],
	tbar : [ '->', {
		xtype : 'button',
		text : SystemConstant.addNextOrgBtnText,
		iconCls : 'add-button',
		id : 'addOrg',
		handler : function() {
			addOrg();
		}
	}, {
		xtype : 'button',
		id : 'updateOrg',
		text : SystemConstant.modifyBtnText,
		disabledExpr : "$selectedRows != 1",// $selected 表示选中的记录数不等于1
		disabled : true,
		iconCls : 'edit-button',
		handler : function() {
			updateOrg();
		}
	}, {
		xtype : 'button',
		text : SystemConstant.deleteBtnText,
		id:'deleteOrg',
		disabled : true,
		disabledExpr : "$selectedRows == 0",
		iconCls : 'delete-button',
		handler : function() {
			deleteOrg();
		}
	},{
		text:"组织导出",
		id:"userExport",
		iconCls: "export-button",
		handler: function(){
			Ext.MessageBox.wait("", "导出数据", 
					{
						text:"请稍后..."
					}
				);
			$('#exportOrgs').submit();
			Ext.MessageBox.hide();
			
		}
	} ]
});
var addOrg = function() {
	orgWin.setTitle(SystemConstant.addBtnText);
	var row = orgGrid.getSelectionModel().getSelection();
	var basicForm = orgWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath + '/org/addOrg.action';
	orgTypeStore.load();
	if(row!=''){
		basicForm.findField('org.organization.id').setValue(row[0].data.parentOrgId);
		basicForm.findField('org.organization.orgName').setValue(row[0].data.parentOrgName);
	}else{
		basicForm.findField('org.organization.id').setValue(selectNode.raw.nodeId);
		basicForm.findField('org.organization.orgName').setValue(selectNode.raw.text);
	}
	basicForm.findField('org.orgCode').setDisabled(false);
	orgTypeStore.load(function(records){
		if(records.length>0){
	    	Ext.getCmp("addOrgSelectionId").setValue(records[0].get("dictCode"));
	    }
	});
	orgWin.show();
};
var updateOrg = function() {
	orgWin.setTitle(SystemConstant.modifyBtnText);
	var row = orgGrid.getSelectionModel().getSelection();
	var orgId = row[0].data.id;
	var basicForm = orgWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath + '/org/updateOrg.action';
	basicForm.findField('org.id').setValue(orgId);
	basicForm.load({
		url : basePath + '/org/getOrgById.action',
		params : {
			orgId : orgId
		}
	});
	basicForm.findField('org.orgCode').setDisabled(true);
	orgWin.show();
};
var deleteOrg = function(){
	var rows = orgGrid.getSelectionModel().getSelection();
	var ids = "";
	for (var i = 0; i < rows.length; i++) {
		ids += (rows[i].data.id + ",");
	}
	ids = ids.substring(0, ids.length - 1);
	Ext.Msg.confirm(SystemConstant.alertTitle, "确认删除所选组织及其子组织吗？", function(btn) {
		if (btn == 'yes') {
			Ext.Ajax.request({
				url : basePath + '/org/deleteOrg.action',
				params : {
					orgIds : ids
				},
				success : function(res, options) {
					var data = Ext.decode(res.responseText);
					if (data.success) {
						treePanel.getStore().reload({  
	                        node:treePanel.getRootNode(),
	                        callback: function () {  
	                        }  
	                    });
						orgStore.loadPage(1);
						Ext.Msg.showTip(data.msg);
					} else {
						Ext.Msg.showError(data.msg);
					}
				},
				failure : sshframe.FailureProcess.Ajax
			});
		}
	});
};