<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>已办任务管理</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
	<%@ include file="../common/ext.jsp"%>
<script type="text/javascript">
Ext.Loader.setConfig({enabled: true});
Ext.Loader.setPath('Ext.ux', '${ctx}/scripts/extjs/ux');

Ext.require([
                 'Ext.toolbar.Paging',
                 'Ext.ux.ProgressBarPager',
                 'Ext.ux.TreePicker',
                 'Ext.form.*',
                 'Ext.grid.column.Action',
                 'Ext.tree.Panel',
                 'Ext.data.*',
                 'Ext.selection.CheckboxModel',
                 'Ext.tip.QuickTipManager'
             
         ]);
Ext.namespace('personDoneTask');
personDoneTask.manage=function(){
  return {
         setGrid:function(grid){
         this.grid=grid;
         },
         
		   viewTask : function (rowIndex){
		         var row = personDoneTask.manage.grid.getStore().getAt(rowIndex);
					var taskId = row.get("taskId");
					var formUrl=row.get("formUrl");
					var businessId = row.get("businessId");
					var taskStatus = row.get("taskStatus");
					var description = row.get("description");
					var processInstanceId=row.get("processInstanceId");
					var href="";
					if(formUrl.indexOf("?")!=-1){
						href="${ctx}/bpm/"+formUrl+"&view=true&instId="+businessId+"&businessId="+businessId+"&processInstanceId="
						      +processInstanceId+"&taskId="+taskId+"&taskStatus="+taskStatus+"&description="+description;
					}else{
						href="${ctx}/bpm/"+formUrl+"?taskId="+taskId+"&instId="+businessId+"&businessId="+businessId+"&view=true&taskStatus="
								+taskStatus+"&description="+description;	
					}
					
					var win = new Ext.Window({
		    			title:'查看任务',
		    			width:650,
		 		        height:360,
		 		        autoScroll:false,
		    			plain: false,
		    	       	modal:true,
		    	       	maximizable : false,
		    	       	closable :true, 
		    	       	resizable : false,
		    	    	html:"<iframe width='100%' height='100%' frameborder='0' scrolling='auto' name='iframe' src='"+href+"'></iframe>",
		    	       	style : 'background-color: white;padding: 0px;',
		    	       	buttonAlign:'center'
		    	   	});
                  win.show(); 
				},
         viewProcessListener:function(processInstanceId,operate){
					var href="${ctx}/bpm/toProcessListener.do?processInstanceId="+processInstanceId+"&operate="+operate;
					var win = new Ext.Window({
		    			title:'查看流程图',
		    			width:650,
		    			maximizable:true,
		 		        height:360,
		 		        autoScroll:false,
		    			plain: false,
		    	       	modal:true,
		    	       	closable :true, 
		    	    	html:"<iframe width='100%' height='100%' frameborder='0' scrolling='auto' name='iframeProcess' src='"+href+"'></iframe>",
		    	       	style : 'background-color: white;padding: 0px;',
		    	       	buttonAlign:'center'
		    	   	});
		        	win.show();
				}
    };
}();
Ext.onReady(function(){
	Ext.QuickTips.init();
   Ext.define('personDoneTaskModel', {
     extend: 'Ext.data.Model',
     fields: [
        {name:'taskId',type:'string'},
		{name:'owner',type:'string'},
		{name:'name',type:'string'},
		{name:'description',type:'string'},
		{name:'createTime',type:'string'},
		{name:'processName',type:'string'},
		{name:'processType',type:'string'},
		{name:'processInstanceId',type:'string'},
		{name:'taskDefinitionKey',type:'string'},
		{name:'businessId',type:'int'},
		{name:'endTime',type:'string'},
		{name:'durationTime',type:'string'},
		{name:'categoryCode',type:'string'},
       	{name:'topCategoryCode',type:'string'},
		{name:'taskStatus',type:'string'},
		{name:'formUrl',type:'string' },
		{name:'ownerName',type:'string'},
		{name:'assignee',type:'string'},
		{name:'assigneeName',type:'string'},
		{name:'processDefinitionKey',type:'string'},
		{name:'businessTitle',type:'string'}
     ]
   });
 Ext.create('Ext.data.JsonStore', {
    clearRemovedOnLoad:true,
    clearOnPageLoad:true,
    autoDestory:true,
    buffered:false,
    storeId:'personDoneTaskStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
      storeObj.removeAll(false);
     }
    },
    pageSize:SystemConstant.commonSize,
    model: 'personDoneTaskModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
        url:'${ctx}/bpm/getDoneTaskListByPage.do',
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});


var grid=Ext.create('Ext.grid.Panel', {
     store: Ext.data.StoreManager.lookup('personDoneTaskStore'),
     columnLines:true,
     forceFit:true,
     loadMask: true,
     dockedItems:[
                  {
                	  xtype:"toolbar",
                	  items:[
'创建日期',
{ xtype: 'dateTimePicker',width:150,id:'taskStartTime', maxDate : 'taskStartEndTime',dateFmt : 'yyyy-MM-dd HH:mm:ss'},
 	'至',
{ xtype: 'dateTimePicker',width:150,id:'taskStartEndTime', minDate : 'taskStartTime',dateFmt : 'yyyy-MM-dd HH:mm:ss'}
                	         ]
                  },
		    {
	     xtype:"toolbar",
		   items:[
		       '完成日期',
		       	  { xtype: 'dateTimePicker',width:150,id:'taskEndStartTime', maxDate : 'taskEndTime',dateFmt : 'yyyy-MM-dd HH:mm:ss'},
			   	'至',
			   	  { xtype: 'dateTimePicker',width:150,id:'taskEndTime', minDate : 'taskEndStartTime',dateFmt : 'yyyy-MM-dd HH:mm:ss'},
			   	'事项名称',
				{
				 xtype:'textfield',
				 id:'processName'
				},
	             {
	    	    text :   "查询", 
	    	    iconCls: "search-button", 
	    	    handler:function(){
				if(!Ext.getCmp('taskStartTime').isValid()||!Ext.getCmp('taskStartEndTime').isValid()||!Ext.getCmp('taskEndStartTime').isValid()||!Ext.getCmp('taskEndTime').isValid()){
					return;
			     }
	    	  var proxy=grid.getStore().getProxy( );
	    	   proxy.setExtraParam("processName",Ext.getCmp("processName").getValue());
	    	   //proxy.setExtraParam("taskOwnerName",Ext.getCmp("taskOwnerName").getValue());
	    	   proxy.setExtraParam("taskStartTime",Ext.getCmp('taskStartTime').getValue());
	    	   proxy.setExtraParam("taskStartEndTime",Ext.getCmp('taskStartEndTime').getValue());
	    	   proxy.setExtraParam("taskEndStartTime",Ext.getCmp('taskEndStartTime').getValue());
	    	   proxy.setExtraParam("taskEndTime",Ext.getCmp('taskEndTime').getValue());
               grid.getStore().loadPage(1);
              } 
	   	    }]
       }],
     bbar: {
                xtype: 'pagingtoolbar',
                pageSize: SystemConstant.commonSize,
                store: Ext.data.StoreManager.lookup('personDoneTaskStore'),
                displayInfo: true
       },
     columns: {
              items: [
                    {header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},
                    {header:'标题',dataIndex:'businessTitle',sortable:false,menuDisabled:true,width:150,draggable:false,
                        renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
                            return  "<span title='"+value+"'>"+value+"</span>";
                        }
                    },
                    {header:'流程名',dataIndex:'processName',menuDisabled : true,sortable:false,width:100,draggable:false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                   /*  cellmeta.tdAttr = 'data-qtip="' + value + '"';
	     	                    return value; */
                        	  return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
			  			 	{header:'类别',dataIndex:'processType',menuDisabled : true,sortable:false,width:100,draggable:false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
			  			 		return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
			  				{header:'任务名',dataIndex:'name',menuDisabled : true,sortable:false,width:100,draggable:false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
			  					return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
			  				//{header:'委托人',dataIndex:'ownerName',menuDisabled : true,sortable:false,width:150,draggable:false},
			  				//{header:'承办人',dataIndex:'assigneeName',menuDisabled : true,sortable:false,width:150,draggable:false},
			  				{
					  	  	  	header:'流程轨迹',
								xtype: 'actioncolumn',
								width:70,
								items: [
						        	{
						        		iconCls:'flowpath-button',
						                tooltip: '流程监控',
						                handler: function(grid, rowIndex, colIndex) {
						                	var row = grid.getStore().getAt(rowIndex);
											personDoneTask.manage.viewProcessListener(row.get("processInstanceId"),"monitor");
						                }
						            }
				            	],
								align:'center'
							},
							{
					  	  	  	header:'详细信息',
								xtype: 'actioncolumn',
								width:70,
								items: [
						            {
						            	iconCls:'detail-button',
						                tooltip: '详细信息',
						                handler: function(grid, rowIndex, colIndex) {
					 		                var row = grid.getStore().getAt(rowIndex);
					 		                var formUrl=row.get("formUrl");
					 		                var topCategoryCode=row.get("topCategoryCode");
					 		                
					 		                var businessId=row.get("businessId");
					 		                
					 		                window.open( "${ctx}/sczy/pages/workMng/workOrderView.jsp?print="+businessId , "_blank");
					 		                if(topCategoryCode=="ZYYY"){
					 		                	
					 		                }else{
					 		                }
						                }
						            }
				            ],
								align:'center'
							},
			  				{header:'创建日期',dataIndex:'createTime',
								sortable : false,menuDisabled : true,
								width:120,draggable:false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
									return  "<span title='"+value+"'>"+value+"</span>";
		     	          	}
							},
							{header:'完成日期',dataIndex:'endTime',
								sortable : false,menuDisabled : true,
								width:120,draggable:false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
									return  "<span title='"+value+"'>"+value+"</span>";
		     	          	}
							},
							{header:'任务状态',dataIndex:'taskStatus',sortable:false,menuDisabled : true,draggable:false,
								renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
									if(value=="1"){
										 return "<span title ='已完成' style='color:green'>已完成</span>";
									}else if(value=="2"){
										 return "<span title ='未通过' style='color:red'>未通过</span>";
									} 
									
							 }
							},
							{header:'耗时',dataIndex:'durationTime',draggable:false,
								sortable : false,menuDisabled : true,
								width:150,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
									return  "<span title='"+value+"'>"+value+"</span>";
		     	          	}
							},
							{
                                header:'撤销',
                                xtype: 'actioncolumn',
                                width:70,
                                items: [
                                    {
                                        iconCls:'revoke-button',
                                        tooltip: '撤销',
                                        handler: function(grid, rowIndex, colIndex) {
                                            var taskId = grid.getStore().getAt(rowIndex).get('taskId');
                                            dealshow(taskId);
                                        }
                                    }
                                ],
                                align:'center'
                            }
              ]
        }
});

personDoneTask.manage.setGrid(grid);

grid.getStore().load({params:{start:0,limit:SystemConstant.commonSize}});

new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[grid]
	})
});

function dealshow(selectRows)
{
	var url = '${ctx}/bpm/rejectTask.do';
	Ext.Ajax.request(
		{  
			url : url,  
			params : {  
				opinion : "撤销",
				taskId : selectRows
			},  
			//请求时使用的默认的http方法  
			method : "post",
			success : function(compeleteTaskRes, options) {
				var compeleteTaskResult = Ext.decode(compeleteTaskRes.responseText);
				if(compeleteTaskResult.success){
					new Ext.ux.TipsWindow(
					{
							html:compeleteTaskResult.msg
					}
				  ).show();
				}else{
					Ext.MessageBox.show({
						title: SystemConstant.alertTitle,
						msg: compeleteTaskResult.msg,
						buttons: Ext.MessageBox.OK,
						icon: Ext.MessageBox.INFO
					});
				}
			},
			failure : function(form,action) {
				Ext.MessageBox.show({
					title: SystemConstant.alertTitle,
					msg: "撤销任务失败。",
					buttons: Ext.MessageBox.OK,
					icon: Ext.MessageBox.INFO
				});
			}
		}
	);
}

</script>
</head>
<body>
</body>
</html>
