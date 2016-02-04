Ext.define('roleTypeModel', {
    extend: 'Ext.data.Model',
    fields: [
             {name: 'id'},
             {name: 'dictionaryName'},
             {name: 'dictionaryCode'}
    ]
});	
var roleTypeStore=Ext.create('Ext.data.Store',{
	model : 'roleTypeModel',
	proxy : {
		type : 'format',
		url : basePath + '/dict/getDictListByTypeCode.action',
		extraParams : {
			dictTypeCode : "ROLETYPE"
		}
	},
	autoLoad : true
});

sshframe.role.RoleForm = Ext.create("Ext.form.Panel", {
	layout : 'form',
	bodyStyle : 'padding:15px 10px 0 0',
	border : false,
	labelAlign : 'right',
	fieldDefaults : {
		labelWidth : 60,
		labelAlign : 'right'
	},
	defaults : {
		anchor : '70%',
		width : 100
	},
	defaultType : 'textfield',
	items : [ {
		id:'roleId',
		name : 'roleId',
		hidden : true
	}, {
		fieldLabel : '角色类型',
		name : 'roleType',
		xtype : 'combobox',
		allowBlank : false,
		queryMode : 'remote',
		valueField : 'dictionaryCode',
		displayField : 'dictionaryName',
		store : roleTypeStore
	},{
		fieldLabel : '角色名称',
		name : 'roleName',
		vtype:'filterHtml',
		maxLength : 20,
		allowBlank : false,
		validator: function(value){
			var returnObj = null;
			var id=Ext.getCmp("roleId").getValue();
			$.ajax({
				url : 'validateRole.action',
				data:{roleName : value,roleId:id},
				cache : false,
				async : false,
				type : "POST",
				dataType : 'json',
				success : function (result){
					if(!result.valid){
						returnObj = result.reason;
					}else{
						returnObj = true;
					}
				}
			});
			return returnObj;
		}
	}, {
		fieldLabel : '角色编码',
		name : 'roleCode',
		allowBlank : false,
		maxLength : 50,
		vtype:'filterHtml',
		validator: function(value){
			var returnObj = null;
			var id=Ext.getCmp("roleId").getValue();
			$.ajax({
				url : 'validateRole.action',
				data:{roleCode : value,roleId:id},
				cache : false,
				async : false,
				type : "POST",
				dataType : 'json',
				success : function (result){
					if(!result.valid){
						returnObj = result.reason;
					}else{
						returnObj = true;
					}
				}
			});
			return returnObj;
		}
	}, {
		fieldLabel : '角色描述',
		name : 'description',
		vtype:'filterHtml',
		maxLength : 50,
		xtype : 'textareafield'
	} ]
});

sshframe.role.RoleWin = Ext.create("Ext.window.Window", {
	height : 250,
	width : 380,
	items : [ sshframe.role.RoleForm ],
	buttons : [ {
		text : '确定',
		handler : function() {
			
			if (sshframe.role.RoleForm.form.isValid()) {
				sshframe.role.RoleForm.form.submit({
					success : function(form, action) {
						Ext.Msg.showTip(action.result.msg);
						sshframe.role.RoleStore.loadPage(1);
						sshframe.role.RoleWin.close();
					},
					failure : function(form, action) {
						Ext.Msg.showError(action.result.msg);
					}
				});
			}
		}
	}, {
		text : '关闭',
		handler : function() {
			sshframe.role.RoleWin.close();
		}
	} ]
});
