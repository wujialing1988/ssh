/**
 * 定义常规数据信息form表单
 */
Ext.define("sshframe.examples.framePage.PlanUserGroupModel", {
	extend : "Ext.data.Model",
	fields : [{
			name : 'id',
			type : 'string'
		},{
			name : 'code', //计划员组编码
			type : 'string'
		}, {
			name : 'description', //计划员组描述
			type : 'string'
		}]
});

sshframe.examples.framePage.PlanUserGroupStore = Ext.create('Ext.data.Store', {
	model : 'sshframe.examples.framePage.PlanUserGroupModel',
	pageSize: 5,
	proxy : {
		type : "format",
		url :basePath + '/examples/getPlanUserGrouListByPage.action'
	},
	autoLoad:true
});

Ext.define("sshframe.examples.framePage.EquipmentClassModel", {
	extend : "Ext.data.Model",
	fields : [{
			name : 'id',
			type : 'string'
		},{
			name : 'code', //设备分类编码
			type : 'string'
		}, {
			name : 'description', //设备分类描述
			type : 'string'
		}, {
			name : 'isDisabled', //设备分类状态
			type : 'string'
		}]
});

sshframe.examples.framePage.EquipmentClassStore = Ext.create('Ext.data.Store', {
	model : 'sshframe.examples.framePage.EquipmentClassModel',
	pageSize: 5,
	proxy : {
		type : "format",
		url :basePath + '/examples/getEquipmentClassList.action'
	},
	autoLoad:true
});

sshframe.examples.FramePageForm = Ext.create('Ext.form.Panel', { 
	items: [{
		layout : 'form',
		columnWidth : 0.5,
		border : false,
		items : [{
			    fieldLabel : '设备ID',
				name : 'equipment.id',
				xtype : 'hidden'
			}, {
				fieldLabel : '设备编码',
				name : 'equipment.deviceCode',
				xtype : 'textfield'
			}, {
				fieldLabel : '计划员组',
				name : 'equipment.planUserGroup.id',
				xtype : 'querySelectCombo',
				store :sshframe.examples.framePage.PlanUserGroupStore,
				valueField : 'id',
				displayField : 'description'
			},{
				fieldLabel : '购置日期',
				name : 'equipment.purchaseDate',
				id:'purchaseDate',
				maxDate:'startRunDate',
				allowBlank : false,
				xtype : "dateTimePicker",
				dateFmt : 'yyyy-MM-dd'
			},{
				fieldLabel : '是否可用',
				name : 'equipment.isDisabled',
				xtype : 'textfield'
			}
		]
	}, {
		layout : 'form',
		columnWidth : 0.5,
		items : [{
			fieldLabel : '设备名称',
			name :'equipment.deviceName',
			xtype : 'textfield'
		}, {
			fieldLabel : '设备分类',
			name : 'equipment.equipmentClass.id',
			xtype : 'querySelectGrid',
			valueField : 'id',
			displayField : 'description',
			store :sshframe.examples.framePage.EquipmentClassStore,
			pathByUrl :basePath + '/examples/getEquClassById.action',
			columnsMap : {
				"code":"分类编码",
				"description":"分类描述",
				"isDisabled":{ text: '设备状态', dataIndex: 'isDisabled', width: 60,renderer:function(val){
						if(val==1){
							 return '<div class="color_green">启用</div>';
						}else{
							 return '<div class="color_red">停用</div>';
						}
					}
				}
			}
		},{
			fieldLabel : '投运日期',
			name : 'equipment.startRunDate',
			id:'startRunDate',
			minDate:'purchaseDate',
			xtype : "dateTimePicker",
			dateFmt : 'yyyy-MM-dd'
		}]
	}]
});

/**
 * 生成添加修改页面
 */

sshframe.examples.FramePageWin= Ext.create("Ext.window.Window.BasicWindow", {
	width : 600,
	items : [sshframe.examples.FramePageForm]
});

/*sshframe.examples.FramePageWin= Ext.create("Ext.window.Window", {
	width : 600,
	items : [sshframe.examples.FramePageForm],
	buttons : [ {
		text : SystemConstant.saveBtnText,
		handler : function() {
			if (sshframe.examples.FramePageForm.isValid()) {
				sshframe.examples.FramePageForm.submit({
					success : function(form, action) {
						if(action.result.success){
							Ext.Msg.showTip(action.result.msg);
							sshframe.examples.FramePageStore.loadPage(1);
							sshframe.examples.FramePageWin.close();
						} else{
							Ext.Msg.showError(action.result.msg);
						}
					},
					failure : function(form, action) {
						Ext.Msg.showError(action.result.msg);
					}
				});
			}
		}
	},  {
		text : SystemConstant.closeBtnText,
		handler : function() {
			sshframe.examples.FramePageWin.close();
		}
	}]
});*/