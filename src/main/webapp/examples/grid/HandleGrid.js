/**
 * 常用列表，包括操作按钮，查询隐藏列。
 * @date 20150716
 * @author zengchao
 */

//grid的定义
var data = [
    ['一部门', '装置1', '2015-04-25','同意', 1],
	['二部门', '装置2', '2015-04-26','拒绝', 3],
	['二部门', '装置3', '2015-04-28','同意', 3],
	['三部门', '装置4', '2015-04-29','拒绝', 4]
];
//定义数据模型
Ext.define('dataModel',
{
    extend : 'Ext.data.Model',
    fields : [
        {
            name : 'a',
            type : 'string',
			
        },
        {
            name : 'b',
            type : 'string'
        },
        {
            name : 'c',
            type : 'string'
        },
        {
            name : 'd',
            type : 'string'
        },
        {
            name : 'e',
            type : 'int'
        },
        {
            name : 'f',
            type : 'string'
        }
    ]
}
);
//定义去数据的store
var mystore = new Ext.data.ArrayStore(
    {
        model : 'dataModel',
        data : data
    }
);
//定义表头
	
var cm = [
    {
        xtype : "rownumberer",
        text : "序号",
        align : "center",
		width:40
    },
    {
        text : '部门',
		dataIndex : 'a',
        width : 120
    },
    {
        text : '装置',
        dataIndex : 'b',
        width : 120
    },
	{
        text : '创建时间',
        dataIndex : 'c',
        width : 120
    },
	{
        text : '状态',
        dataIndex : 'd',
        width : 120
    },
	{
        text : '备注',
        dataIndex : 'e',
        width : 120
    },
	{
		text : '操作',
		width : 80,
		xtype : "actioncolumn",
		items : [{
				iconCls : 'download-button',
				tooltip : "下载",
				showExpr:'$d=="同意"&&$e==3'//为d=同意并且e=3
			},
			{
				iconCls : 'add-button',
				tooltip : "添加",
				showExpr:'$d=="同意"||$e==3'//为d=同意或者e=3
			},
			{
				iconCls : 'delete-button',
				tooltip : "删除",
				showExpr:'$e>1'//e大于1
			},
			{
				iconCls : 'edit-button',
				tooltip : "修改",
				showExpr:'$e!=3'//e不等于3
			}
		]
	}
];

Ext.onReady(function() {
//定义表格grid
var myGrid = new Ext.grid.Panel(
    {
        title:'常规列表',
		renderTo: 'grid-example',
		region : "center",
		resizable:{
		    handles: 's' //只向下（南：south）拖动改变列表的高度
		},
		overflowX: 'hidden',
		autoScroll: false,
		store: mystore,
		columns:cm,
		selModel : Ext.create("Ext.selection.CheckboxModel"),
        tbar : ['部门',{  
			    xtype : 'combo',
                width : 90,
				dataIndex: 'a',
                store : Ext.create('Ext.data.ArrayStore',
                {
                    fields : ['value', 'display'],
                    data : [[1, "一部门"], [2, "二部门"], ['all', "全部"]]
                }
                ),
                displayField : 'display',
                valueField : 'value',
				value:'all'
		   },'装置',{  
			    xtype : 'combo',
                width : 90,
				dataIndex: 'a&b',
                store : Ext.create('Ext.data.ArrayStore',
                {
                    fields : ['value', 'display'],
                    data : [[1, "装置1"], [2, "装置2"], ['all', "全部"]]
                }
                ),
                displayField : 'display',
                valueField : 'value',
				value:'all'
		   },
            {
			    xtype:'searchBtn'
            },
            '->',{
                text : '添加',
                iconCls : "add-button"
            }
        ],
        //底部工具条
        bbar : Ext.create('Ext.PagingToolbar',
        {
            store : mystore
        }
        )
    }
);
});
