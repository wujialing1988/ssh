
/*var basePath=(function(){
	var href=window.location.href;
	var host=window.location.host;
	var index = href.indexOf(host)+host.length+1; //host结束位置的索引（包含/）
	return href.substring(0,href.indexOf('/',index));
})(window);*/
/**
 * @date 20160121
 * @author zengchao
 */
/**
 * 定义Model
 */
Ext.define("searchBtnModel", {
	extend : "Ext.data.Model",
	fields : [ {
		name : 'id',
		type : 'string'
	},{
		name : 'deviceCode',//设备编码
		type : 'string'
	},{
		name : 'deviceName',//设备名称
		type : 'string'
	},{
		name : 'className',//设备分类
		type : 'string'
	},{
	    name: 'purchaseDate',//购置日期
	    type : 'string'
	}, {
		name : 'planUserGroupName',//计划员组
		type : 'string'
	}, {
		name : 'planUserGroupID',//计划员组外键
		type : 'string'
	},{
		name : 'principal',//责任人
		type : 'string'
	},{
		name : 'isDisabled',
		type : 'int'
	}]
});

/**
 * 定义Store(生成列表的动态数据)
 */
var searchBtnStore = Ext.create('Ext.data.Store', {
	model : searchBtnModel,
	proxy : {
		type : "format",
		url : "../../examples/getEquipmentListByPage.action"
	},
	autoLoad:true
});

/**
 * 定义数据显示列
 */

var searchBtnCm = [{
	xtype : "rownumberer",
	text : "序号",
	width : 40,
	align : "center"
},{
    text: '设备编码',
    dataIndex: 'deviceCode',
    width: 80
},{
    text: '设备名称',
    dataIndex: 'deviceName',
	menuDisabled : true,
	width: 80
},{
    text: '设备分类',
    dataIndex: 'className',
    width: 100
},{
    text: '计划员组',
    dataIndex: 'planUserGroupName',
    width: 80
},{
    text: '购置日期',
    dataIndex: 'purchaseDate',
    width: 120
},{
    text: '投运日期',
    dataIndex: 'startRunDate',
    width: 120
}];
/**
 * 定义Grid(生成列表页面)
 */
Ext.onReady(function() {
	Ext.QuickTips.init();
	var searchBtnGrid = Ext.create("Ext.grid.Panel",{
	    title : '示例',  
	    height:250,
	    region : "center",
		resizable:{
		    handles: 's' //只向下（南：south）拖动改变列表的高度
		},
		renderTo: 'searchBtnGrid-example',
		selModel : Ext.create("Ext.selection.CheckboxModel"),
		store : searchBtnStore,
		columns : searchBtnCm,
		//头部工具条
		tbar:['设备名称',{
				xtype : 'textfield',
				itemId : 'deviceName',
				dataIndex:'deviceCode&deviceName',
				width:90
			},'关键字',{
				xtype : 'textfield',
				itemId : 'keyString',
				width:90
			},{
			    xtype:'searchBtn', //查询按钮
	        }
		 ],
		//底部工具条
	    bbar : Ext.create("Ext.PagingToolbar", {
			    store : searchBtnStore
		})
	}); 
});