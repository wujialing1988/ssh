/**
 * My97日期控件示例
 * @author zengchao
 * @date 2016-01-05
 */
Ext.onReady(function() {
	Ext.define("querySelectComboModel", {
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
			}]
	});

	var querySelectComboStore = Ext.create('Ext.data.Store', {
		model : 'querySelectComboModel',
		pageSize: 5,
		proxy : {
			type : "format",
			url :basePath + '/examples/getEquipmentClassList.action'
		},
		autoLoad:true
	});
	
	var querySelectComboForm = Ext.create('Ext.form.Panel', { 
		renderTo: 'querySelectCombo-example',
		width:600,
		items: [{
			layout : 'form',
			columnWidth : 0.5,
			border : false,
			items : [{
					fieldLabel : '分类',
					id:'classSelect',
					xtype : 'querySelectCombo',
					store:querySelectComboStore,
					queryParam : 'description',
					valueField : 'id',
					displayField : 'description',
					pathByUrl :basePath + '/examples/getEquClassById.action',
					propertyMap : {
						"code":"classCode",
						"description":"classDescription",
						"id":alertCallback
					}
				}
			]
		},{
			layout : 'form',
			columnWidth : 0.5,
			border : false,
			items : [{
					fieldLabel : '分类编码',
					id:'classCode',
					xtype : 'textfield'
				},{
					fieldLabel : '分类名称',
					id:'classDescription',
					xtype : 'textfield'
				}
			]
		}]
	});
});

function alertCallback(a){
	alert('分类id为'+a)
}


function setValueFun(){
	Ext.getCmp('classSelect').setValue('8af2c9a6520f41d201520f46fc8c0001');
}