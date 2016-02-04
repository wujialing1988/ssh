/**
 * 角色管理的列表功能，包含功能有 列表、添加、修改和删除功能。
 * @date 20150616
 * @author hedaojun
 */

/**
 * 定义角色Model
 */
Ext.define("sshframe.role.roleModel", {
	extend : "Ext.data.Model",
	fields : [{
		name : "roleId",
		type : "int"
	}, {
		name : "roleName"
	}, {
		name : "roleCode"
	}, {
		name : "description"
	} ]
});

/**
 * 定义Store
 */
sshframe.role.RoleStore = Ext.create('Ext.data.Store', {
	model : 'sshframe.role.roleModel',
	proxy : {
		type : "format",
		url : basePath + "/role/getRoleList.action"
	}
});

/**
 * 定义Grid
 */
sshframe.role.RoleGrid = Ext.create("Ext.grid.Panel", {
	title : '角色管理',
	region : "center",
	bbar : Ext.create("Ext.PagingToolbar", {
		store : sshframe.role.RoleStore
	}),
	selModel : Ext.create("Ext.selection.CheckboxModel"),
	store : sshframe.role.RoleStore,
	columns : [ {
		xtype : "rownumberer",
		text : '序号',
		width : 60,
		align : "center"
	}, {
		header : "roleId",
		width : 70,
		dataIndex : "id",
		hidden : true
	}, {
		header : "角色名称",
		width : 200,
		dataIndex : "roleName"
	}, {
		header : "角色编码",
		width : 200,
		dataIndex : "roleCode"
	}, {
		header : "描述",
		width : 200,
		dataIndex : "description"
	}, {
		header : "资源",
		xtype : "actioncolumn",
		align : 'center',
		renderer : function() {},
		items : [ {
			iconCls : "icon-view",
			tooltip : "分配资源",
			handler : function(grid, rindex, cindex) {
				var record = grid.getStore().getAt(rindex);
				//toAddResource(record.get('roleId'));
				toAddResource(record.get('id'));
			}
		} ]
	} ],
	tbar : [ '角色名称', {
		xtype : 'textfield',
		stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
		id : 'inputRoleName'
	}, {
		text : "查询",
		iconCls : "search-button",
		handler : function(button) {
			sshframe.role.RoleStore.getProxy().setExtraParam("roleName", button.prev().getValue());
			sshframe.role.RoleStore.loadPage(1);
		}
	}, '->', {
		xtype : 'button',
		text : '添加',
		iconCls : 'add-button',
		handler : function() {
			sshframe.role.addRole();
		}
	}, {
		xtype : 'button',
		text : '修改',
		disabledExpr : "$selectedRows != 1 || $roleCode=='admin'",// $selected 表示选中的记录数不等于1
		disabled : true,
		iconCls : 'edit-button',
		handler : function() {
			sshframe.role.updateRole();
		}
	}, {
		xtype : 'button',
		text : '删除',
		disabled : true,
		disabledExpr : "$selectedRows == 0  || $roleCode=='admin'",
		iconCls : 'delete-button',
		handler : function() {
			sshframe.role.deleteRole();
		}
	} ]
});

/**
 * 调用后台修改角色
 */
sshframe.role.updateRole = function() {
	sshframe.role.RoleWin.setTitle('修改');
	var row = sshframe.role.RoleGrid.getSelectionModel().getSelection();
	var roleId = row[0].data.id;
	var basicForm = sshframe.role.RoleWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath + '/role/updateRole.action';
	basicForm.findField('roleId').setValue(roleId);
	basicForm.load({
		url : basePath + '/role/getRoleById.action',
		params : {
			id : roleId
		}
	});
	sshframe.role.RoleWin.show();
};

/**
 * 调用后台添加角色
 */
sshframe.role.addRole = function() {
	sshframe.role.RoleWin.setTitle('添加');
	var basicForm = sshframe.role.RoleWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath + '/role/addRole.action';
	// 设置默认值
	var roleTypeField = basicForm.findField('roleType');
	var typeTreeSelected = Ext.getCmp('typeTree').getSelectionModel().getSelection();
	if (typeTreeSelected) {
		roleTypeField.setValue(typeTreeSelected[0].raw.code);
	}
	else {
		roleTypeField.setValue(roleTypeField.getStore().getAt(0));
	}
	sshframe.role.RoleWin.show();
};

/**
 * 调用后台删除角色
 */
sshframe.role.deleteRole = function() {
	var rows = sshframe.role.RoleGrid.getSelectionModel().getSelection();
	var ids = "";
	for (var i = 0; i < rows.length; i++) {
		ids += (rows[i].data.id + ",");
	}
	ids = ids.substring(0, ids.length - 1);
	
	Ext.Ajax.request({
		url : basePath +'/role/isCanDelete.action',
		params : {ids: ids},
		success : function(res, options) {
			 var data = Ext.decode(res.responseText);
			 if(data.success){
				 Ext.Msg.confirm(SystemConstant.alertTitle, "确认删除这" + rows.length + "条角色信息吗（角色的数据范围等将被一并删除）?", function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : basePath + '/role/deleteRole.action',
								params : {
									ids : ids
								},
								success : function(res, options) {
									var data = Ext.decode(res.responseText);
									if (data.success) {
										Ext.Msg.showTip(data.msg);
										sshframe.role.RoleStore.loadPage(1);
									} else {
										Ext.Msg.showError(data.msg);
									}
								},
								failure : sshframe.FailureProcess.Ajax
							});
						}
					});
			 }else{
				sshframe.role.RoleStore.loadPage(1);
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