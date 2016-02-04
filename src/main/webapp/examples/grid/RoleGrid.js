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
		url : "roleListData.json"
	},
	autoLoad:true
})

Ext.onReady(function() {
	Ext.QuickTips.init();
	/**
	 * 定义Grid
	 */
	sshframe.role.RoleGrid = Ext.create("Ext.grid.Panel", {
		title : '角色管理',
		renderTo: 'grid-example',
		region : "center",
		resizable:{
		    handles: 's' //只向下（南：south）拖动改变列表的高度
		},
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
			dataIndex : "id",
			hidden : true
		}, {
			header : "角色名称",
			dataIndex : "roleName"
		}, {
			header : "角色编码",
			dataIndex : "roleCode"
		}, {
			header : "描述",
			dataIndex : "description"
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
				alert('查询条件为：'+button.prev().getValue());
			}
		}, '->', {
			xtype : 'button',
			text : '添加',
			iconCls : 'add-button',
			handler : function() {
				alert('添加');
			}
		}, {
			xtype : 'button',
			text : '修改',
			disabledExpr : "$selectedRows != 1 || $roleCode=='admin'",// $selected 表示选中的记录数不等于1
			disabled : true,
			iconCls : 'edit-button',
			handler : function() {
				alert('修改')
			}
		}, {
			xtype : 'button',
			text : '删除',
			disabled : true,
			disabledExpr : "$selectedRows == 0  || $roleCode=='admin'",
			iconCls : 'delete-button',
			handler : function() {
				alert('删除');
			}
		} ]
	})
});
