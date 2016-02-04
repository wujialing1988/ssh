/**
 * 列表功能，包含功能有 列表、添加、修改和删除功能。
 * @date 20150916
 * @author zengchao
 */
/*var projectTsshframe=[];
projectTsshframe[xx]='dd'
projectTsshframe[xx]='dd'*/
/**
 * 定义Model
 * 需要改动的地方：
 * 1、Model类型(Model)
 * 2、fields属性值(所有字段信息)
 */
Ext.define("sshframe.examples.FramePageModel", {
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
/*sshframe.examples.FramePageStore = Ext.create('Ext.data.Store', {
	model : Ext.define("sshframe.examples.FramePageModel", {extend : "Ext.data.Model"}),
	listeners: {
        'beforeload' : function (store,operation,eOpts) {
        	var Mystore=store;
        	Ext.Ajax.request({
				url :basePath+"/examples/getEquipmentListByPage.action?start=0&limit=99",
				success : function(res, options) {
					var data = Ext.decode(res.responseText);
					var fieldslist=[];
					Mystore;
					for(var name in data.list[0]){
						fieldslist.push({name : name ,type : 'string'})
					}
					Mystore.model.setFields(fieldslist);
				},
			}); 
        }
    },
	proxy : {
		type : "format",
		url : basePath+"/examples/getEquipmentListByPage.action"
	},
	autoLoad:true
});*/

sshframe.examples.FramePageStore = Ext.create('Ext.data.Store', {
	model : sshframe.examples.FramePageModel,
	proxy : {
		type : "format",
		url : basePath+"/examples/getEquipmentListByPage.action"
	},
	autoLoad:true
});
/**
 * 定义数据显示列
 */

sshframe.examples.FramePageCm = [{
	xtype : "rownumberer",
	text : "序号",
	width : 40,
	align : "center"
},{
    text: '功能单元',
    dataIndex: 'deviceCode',
    xtype:'elementColumn'
},{
    text: '设备编码',
    dataIndex: 'deviceCode',
    width: 120,
    renderer: function(val) {
        return "<a onclick='sshframe.examples.framePageDetail()' class='color_blue'>" + val + "</a>";
    }
},{
    text: '设备名称',
    dataIndex: 'deviceName',
	menuDisabled : true,
    flex: 1
},{
    text: '设备分类',
    dataIndex: 'className',
    width: 100
},{
    text: '计划员组',
    dataIndex: 'planUserGroupName',
    width: 100
},{
    text : '日期',
    columns: [{
        text     : '购置日期',
        width    : 150,
        dataIndex: 'purchaseDate'
    },{
        text     : '投运日期',
        width    : 150,
        dataIndex: 'startRunDate'
    }]
},{
    text: '设备状态',
    dataIndex: 'isDisabled',
    width: 60,
	renderer:function(val){
		if(val==1){
			 return '<div class="color_green">启用</div>';
		}else{
			 return '<div class="color_red">停用</div>';
		}
	}
},{
    text: '操作',
    width: 60,
    width: 100,
    xtype : "actioncolumn",
    items : [{
			iconCls : 'add-button',
			tooltip : "下载",
			showExpr:'$isDisabled==1'
		}
	],	
}];

/**
 * 定义Grid(生成列表页面)
 */
sshframe.examples.FramePageGrid = Ext.create("Ext.grid.Panel",{
    title : '示例',  
	region : 'center', 
	id:'grid',
	selModel : Ext.create("Ext.selection.CheckboxModel"),
	store : sshframe.examples.FramePageStore,
	columns : sshframe.examples.FramePageCm,
	//头部工具条
	tbar:['设备名称',{
			xtype : 'textfield',
			itemId : 'deviceName',
			width:90
		},'关键字',{
			xtype : 'textfield',
			itemId : 'keyString',
			width:90
		},'限定时间',{
			xtype : "dateTimePicker",
			itemId : 'purchaseDate',
			maxDate:'2015-12-07',
			minDate:'2015-12-02',
			dateFmt : 'yyyy-MM-dd',
			width:90
		},{
		    xtype:'searchBtn', //查询按钮
		    //dataIndex:'startRunDate'
        },'->',
		{
			xtype:'addBtn', //添加按钮
			handler:function(){
				//sshframe.examples.addEquipment();
				sshframe.examples.FramePageWin.turnRound(1,basePath+"/examples/addEquipment.action",this);
				sshframe.examples.FramePageWin.show();	
			}
		},
		{
        	xtype:'editBtn',
			disabled:true,
			disabledExpr: '$selectedRows!= 1',
	    },
	    {
			xtype:'deleteBtn', //删除按钮
			disabled:true,
			disabledExpr: '$selectedRows==0',
	    }
	 ],
	//底部工具条
    bbar : Ext.create("Ext.PagingToolbar", {
		    store : sshframe.examples.FramePageStore
	})
}); 


sshframe.examples.addEquipment= function() {
	sshframe.examples.FramePageWin.setTitle('添加');
	var basicForm = sshframe.examples.FramePageWin.down('form').getForm();
	basicForm.reset();
	basicForm.url = basePath+"/examples/addEquipment.action";
	sshframe.examples.FramePageWin.show();
};


/**
 * 调用后台删除
 */
sshframe.examples.deleteEquipment = function() {
	var rows = eam.basic.device.EquipmentGrid.getSelectionModel().getSelection();
	var ids = "";
	for (var i = 0; i < rows.length; i++) {
		ids += (rows[i].data.id + ",");
	}
	ids = ids.substring(0, ids.length - 1);
	Ext.Msg.confirm(SystemConstant.alertTitle, "确认删除这" + rows.length + "条信息吗?", function(btn) {
		if (btn == 'yes') {
			Ext.Ajax.request({
				url : basePath + "/basic/equipment_deleteEquipmentByIds.action",
				params : {
					ids : ids
				},
				success : function(res, options) {
					var data = Ext.decode(res.responseText);
					if(Ext.Msg.showNotInfo(data.msgType, data.msg)){
						if (data.success) {
							Ext.Msg.showTip(data.msg);
							eam.basic.device.EquipmentStore.reload();
						} else {
							Ext.Msg.showError(data.msg);
						}
					}
				},
				failure : sshframe.FailureProcess.Ajax
			});
		}
	});
};

Ext.getCmp('grid').getStore().on('load',function(){  
    mergeCells(Ext.getCmp('grid'),[5,6,7]);  
}); 

var mergeCells = function(grid,cols){
	var arrayTr=document.getElementById(grid.getId()+"-body").firstChild.firstChild.getElementsByTagName('tr');	
	var trCount = arrayTr.length;
	var arrayTd;
	var td;
	var merge = function(rowspanObj,removeObjs){ //定义合并函数
		if(rowspanObj.rowspan != 1){
			arrayTd =arrayTr[rowspanObj.tr].getElementsByTagName("td"); //合并行
			td=arrayTd[rowspanObj.td-1];
			td.rowSpan=rowspanObj.rowspan;
			td.vAlign="middle";				
			Ext.each(removeObjs,function(obj){ //隐身被合并的单元格
				arrayTd =arrayTr[obj.tr].getElementsByTagName("td");
				arrayTd[obj.td-1].style.display='none';							
			});
		}	
	};	
	var rowspanObj = {}; //要进行跨列操作的td对象{tr:1,td:2,rowspan:5}	
	var removeObjs = []; //要进行删除的td对象[{tr:2,td:2},{tr:3,td:2}]
	var col;
	Ext.each(cols,function(colIndex){ //逐列去操作tr
		var rowspan = 1;
		var divHtml = null;//单元格内的数值		
		for(var i=1;i<trCount;i++){  //i=0表示表头等没用的行
			arrayTd = arrayTr[i].getElementsByTagName("td");
			var cold=0;
//			Ext.each(arrayTd,function(Td){ //获取RowNumber列和check列
//				if(Td.getAttribute("class").indexOf("x-grid-cell-special") != -1)
//					cold++;								
//			});
			col=colIndex+cold;//跳过RowNumber列和check列
			if(!divHtml){
				divHtml = arrayTd[col-1].innerHTML;
				rowspanObj = {tr:i,td:col,rowspan:rowspan}
			}else{
				var cellText = arrayTd[col-1].innerHTML;
				var addf=function(){ 
					rowspanObj["rowspan"] = rowspanObj["rowspan"]+1;
					removeObjs.push({tr:i,td:col});
					if(i==trCount-1)
						merge(rowspanObj,removeObjs);//执行合并函数
				};
				var mergef=function(){
					merge(rowspanObj,removeObjs);//执行合并函数
					divHtml = cellText;
					rowspanObj = {tr:i,td:col,rowspan:rowspan}
					removeObjs = [];
				};
				if(cellText == divHtml){
					if(colIndex!=cols[0]){ 
						var leftDisplay=arrayTd[col-2].style.display;//判断左边单元格值是否已display
						if(leftDisplay=='none')
							addf();	
						else
							mergef();							
					}else
						addf();											
				}else
					mergef();			
			}
		}
	});	
};