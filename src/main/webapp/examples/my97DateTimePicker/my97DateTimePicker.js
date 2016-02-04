/**
 * My97日期控件示例
 * @author zengchao
 * @date 2016-01-05
 */
Ext.onReady(function() {
	var my97DateTimePickerForm1 = Ext.create('Ext.form.Panel', { 
		renderTo: 'my97DateTimePicker-example1',
		width:500,
		items: [{
			layout : 'form',
			columnWidth : 0.5,
			border : false,
			items : [{
					fieldLabel : '开始时间',
					xtype : "dateTimePicker",
					dateFmt : 'yyyy-MM-dd HH:mm:ss',
					id:'purchaseDate',
					maxDate:'startRunDate'
				}
			]
		}, {
			layout : 'form',
			columnWidth : 0.5,
			items : [{
				fieldLabel : '结束时间',
				xtype : "dateTimePicker",
				dateFmt : 'yyyy-MM-dd HH:mm:ss',
				id:'startRunDate',
				minDate:'purchaseDate'
			}]
		}]
	});
	
	var my97DateTimePickerForm2 = Ext.create('Ext.form.Panel', { 
		renderTo: 'my97DateTimePicker-example2',
		width:800,
		items: [{
			layout : 'form',
			columnWidth : 0.3,
			border : false,
			items : [{
					fieldLabel : '不早于时间',
					xtype : "dateTimePicker",
					dateFmt : 'yyyy-MM-dd',
					maxDate:'2016-01-11'

				}
			]
		}, {
			layout : 'form',
			columnWidth : 0.3,
			items : [{
				fieldLabel : '不晚于时间',
				xtype : "dateTimePicker",
				dateFmt : 'yyyy-MM-dd HH:mm:ss',
				minDate:'2016-01-11'
			}]
		}, {
			layout : 'form',
			columnWidth : 0.3,
			items : [{
				fieldLabel : '同时满足',
				xtype : "dateTimePicker",
				dateFmt : 'yyyy-MM-dd HH:mm:ss',
				minDate:'2016-01-11',
				maxDate:'2016-01-22'
			}]
		}]
	});
	
	
	var my97DateTimePickerForm3 = Ext.create('Ext.form.Panel', { 
		renderTo: 'my97DateTimePicker-example3',
		width:500,
		items: [{
			layout : 'form',
			columnWidth : 0.5,
			border : false,
			items : [{
					fieldLabel : '选择后回调',
					xtype : "dateTimePicker",
					dateFmt : 'yyyy-MM-dd',
					allowBlank : false,
					changedCallback:alertCallback
				}
			]
		}]
	});
	
	var my97DateTimePickerForm4 = Ext.create('Ext.form.Panel', { 
		renderTo: 'my97DateTimePicker-example4',
		width:800,
		items: [{
			layout : 'form',
			columnWidth : 0.3,
			border : false,
			items : [{
					fieldLabel : '年',
					xtype : "dateTimePicker",
					dateFmt : 'yyyy年'
				},{
					fieldLabel : '年月日',
					xtype : "dateTimePicker",
					dateFmt : 'yyyy-MM-dd'
				},
			]
		}, {
			layout : 'form',
			columnWidth : 0.3,
			items : [{
				fieldLabel : '月',
				xtype : "dateTimePicker",
				dateFmt : 'M月'
			},{
				fieldLabel : '年月日时分秒',
				xtype : "dateTimePicker",
				dateFmt : 'yyyy-MM-dd HH:mm:ss'
			}]
		}, {
			layout : 'form',
			columnWidth : 0.3,
			items : [{
				fieldLabel : '年月',
				xtype : "dateTimePicker",
				dateFmt : 'yyyy年MM月'
			},{
				fieldLabel : '时分秒',
				xtype : "dateTimePicker",
				dateFmt : 'HH:mm:ss'
			}]
		}]
	});
});

function alertCallback(){
	alert('这是日期选择后的回调')
}