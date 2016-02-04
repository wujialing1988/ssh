/**
 * 日志管理的列表功能，包含功能有 列表、查看功能。 
 * @date 20150706
 * @author wujl
 */

/**
 * 定义角色Model
 */
Ext.define("sshframe.log.logModel",{
	extend:"Ext.data.Model",
	fields:[
		{
			name: "id",
			mapping:"pkLogId"
		}, 
		{
			name: "typeId",
			mapping:"logTypeCode"
		}, 
		{
			name: "typeName",
			mapping:"logTypeText"
		}, 
		{
			name: "userId",
			mapping:"userId"
		}, 
		{
			name: "userName",
			mapping:"userName"
		}, 
		{
			name: "opDate",
			mapping:"opDate"
		},
		{
			name: "ipUrl",
			mapping:"ipUrl"
		},
		{
			name: "opContent",
			mapping:"opContent"
		},
		{name: "realName"}
	]
});

/**
 * 定义Store
 */
sshframe.log.logStore=Ext.create("Ext.data.Store", {
    model:"sshframe.log.logModel",
    proxy: {
        type: "format",
        url: basePath+"/log/getLog.action"
    }
});

/**
 * 定义Grid
 */
sshframe.log.logGrid =  Ext.create("Ext.grid.Panel",{
	title:'日志管理',
	region: "center",
	store: sshframe.log.logStore,
	columns:[
	 		{header:"序号",xtype: "rownumberer",width:60,align:"center"},
	        {header: "操作用户ID",width: 100,dataIndex: "userId",hidden: true},
	        {header: "ID",width: 70,dataIndex: "id",hidden: true,},
	        {header: "typeId",width: 200,dataIndex: "typeId",hidden: true},
	        {header: "日志类型",width: 70,dataIndex: "typeName"},
	        {header: "发生日期",width: 150,dataIndex: "opDate"},
	        {header: "操作用户",width: 80,dataIndex: "userName",
	        	renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	        		var realName = record.get('realName');
	        		return realName+"("+value+")";
	        	}
	        },
	        {header: "链接信息",width: 120,dataIndex: "ipUrl"},
	        {header: "日志内容",width: 400,dataIndex: "opContent",
	        	renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	        		var answerStr = JSON.stringify(value);   
	        		eval(" var g_policy = '"+answerStr+"';");
	        		return  g_policy;
	        	}
	        }
	       ],
	bbar:  Ext.create("Ext.PagingToolbar", {
		store: sshframe.log.logStore
	}),
	tbar: 
	{
        xtype: 'toolbar',
        preventItemsBubble: false,
        items: [
                '开始时间',
                { xtype: 'dateTimePicker',id:'startDate',name:'startDate', maxDate : 'endDate'},
                ' ',
				'结束时间',
				{ xtype: 'dateTimePicker',id:'endDate',name:'endDate', minDate : 'startDate'},
				' ',
				"日志内容",
				{
					xtype:"textfield",
					id:"logContent"
				},{ 
					text: '查询',
				  	iconCls:'search-button',
				  	handler:function(){
				  		var proxy = sshframe.log.logStore.getProxy();
    	   				proxy.setExtraParam("startDate",Ext.getCmp('startDate').getValue());
    	   				proxy.setExtraParam("endDate",Ext.getCmp('endDate').getValue());
    	   				proxy.setExtraParam("logContent",Ext.getCmp('logContent').getValue());
    	   				sshframe.log.logStore.loadPage(1);
    	   				//sshframe.log.logStore.load(proxy);
				  	}
				}
        ]}
		
});
 	
sshframe.log.logGrid.on("itemdblclick",function(gridView, record, item, index, e, eOpts ){
	Ext.create("Ext.window.Window", {
		title:"日志内容",
		height:400,
		width:750,
		modal: true,
		autoScroll: true,
		bodyStyle:"background-color:#FFFFFF",
		html:"<table bgcolor='#FFFFFF'  cellspacing='2' cellpadding='2' >"+
			"<tr><td width='100'>日志类型：</td><td>"+record.get('typeName')+"</td><td width='100'>发生日期：</td><td>"+record.get('opDate').substr(0,19)+"</td></tr>"+
			"<tr><td width='100'>操作用户：</td><td>"+record.get('userName')+"</td><td width='100'>链接信息：</td><td>"+record.get('ipUrl')+"</td></tr>"+
			"<tr><td width='100'>日志内容：</td><td colspan='3'>"+eval("'"+JSON.stringify(record.get('opContent'))+"'")+"</td></tr>"+
			"</table>",
		buttonAlign:'center',
		buttons:[{text:"关闭",handler:function(){
			this.up('window').close();
		}}
		]
	}).show();
});

