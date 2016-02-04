﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<%@include file="../common/css.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>已发任务</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
	<script type="text/javascript" src="${ctx}/scripts/common/SystemConstant.js"></script>
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
Ext.namespace('personApply');
personApply.manage=function(){
  return {
    setGrid:function(grid){
        this.grid=grid;
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
   Ext.define('personApplyModel', {
     extend: 'Ext.data.Model',
     fields: [
        {name:'processInstanceId',type:'String'},
		{name:'userName',type:'string'},
		{name:'userId',type:'String'},
		{name:'startTime',type:'String'},
		{name:'endTime',type:'String'},
		{name:'processStatus',type:'String'},
		{name:'processName',type:'string'},
		{name:'durationTime',type:'String'}
     ]
   });
 Ext.create('Ext.data.JsonStore', {
    clearRemovedOnLoad:true,
    clearOnPageLoad:true,
    autoDestory:true,
    buffered:false,
    storeId:'personApplyStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
      storeObj.removeAll(false);
     }
    },
    pageSize:SystemConstant.commonSize,
    extraParams:{
     processCreateUserId:'${user.username}'
    },
    model: 'personApplyModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
        url:'${ctx}/bpm/getProcessInstanceByPage.do',
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});


var grid=Ext.create('Ext.grid.Panel', {
     store: Ext.data.StoreManager.lookup('personApplyStore'),
     columnLines:true,
     forceFit:true,
     loadMask: true,
     /* selType:'cellmodel',
     selModel: {
     		//injectCheckbox:1,
      listeners : {
				"selectionchange" : function(win) {
					if (grid.getSelectionModel().getSelection().length != 0) { //选择了的行
						if(grid.getSelectionModel().getSelection().length==1){
							Ext.getCmp('view').setDisabled(false);
						}else{
							Ext.getCmp('view').setDisabled(true);
						}
					}else{
				      Ext.getCmp('view').setDisabled(true);
					}
				}
			},
        pruneRemoved: true
      }, */
     dockedItems:[
		    {
	     xtype:"toolbar",
		   items:[
           '事项名称',
			{
			xtype:'textfield',
			id:'processName'
			 },
			'发起时间',
			{ xtype: 'dateTimePicker',width:90,id:'processStartTime', maxDate : 'processStartEndTime'},
			   	'至',
			{ xtype: 'dateTimePicker',width:90,id:'processStartEndTime', minDate : 'processStartTime'},
		       '结束时间',
		    { xtype: 'dateTimePicker',width:90,id:'processEndStartTime', maxDate : 'processEndTime'},
			   	'至',
			{ xtype: 'dateTimePicker',width:90,id:'processEndTime', minDate : 'processEndStartTime'},
			   	 ,
	           {
	    	   text :   "查询", 
	    	   iconCls: "search-button", 
	    	   handler:function(){
				if(!Ext.getCmp('processStartTime').isValid()||!Ext.getCmp('processStartEndTime').isValid()||!Ext.getCmp('processEndStartTime').isValid()||!Ext.getCmp('processEndTime').isValid()){
					return;
			   }
	    	   var proxy=grid.getStore().getProxy( );
	    	   proxy.setExtraParam("processName",Ext.getCmp("processName").getValue());
	    	   proxy.setExtraParam("processStartTime",Ext.util.Format.date(Ext.getCmp('processStartTime').getValue(),'Y-m-d H:i:s'));
	    	   proxy.setExtraParam("processStartEndTime",Ext.util.Format.date(Ext.getCmp('processStartEndTime').getValue(),'Y-m-d H:i:s'));
	    	   proxy.setExtraParam("processEndStartTime",Ext.util.Format.date(Ext.getCmp('processEndStartTime').getValue(),'Y-m-d H:i:s'));
	    	   proxy.setExtraParam("processEndTime",Ext.util.Format.date(Ext.getCmp('processEndTime').getValue(),'Y-m-d H:i:s'));
               grid.getStore().load();
              } 
	   	    },
		   {
		    	text :   "重置", 
		    	iconCls: "reset-button", 
		    	hidden:true,
		    	handler:function(){
		    	Ext.getCmp('processName').setValue();
				Ext.getCmp('processCreateUserName').setValue();
				Ext.getCmp('processStartTime').reset();
				Ext.getCmp('processStartEndTime').reset();
				Ext.getCmp('processEndStartTime').reset();
				Ext.getCmp('processEndTime').reset();
	          } 
		    } ,'->',
		    	{
					text : "查看",
	    	    	iconCls: "icon-sendReview",
	    	    	id:'view',
	    	    	hidden:true,
	    	    	disabled:true,
	    	    	handler:function(){
	    				   		if(grid.getSelectionModel().getSelection().length<=0){
	    				    				Ext.Msg.alert(SystemConstant.alertTitle, SystemConstant.chooseOneInfo+SystemConstant.viewInfo+"!");
	    									return;
	    				   		}
	    				   		if(grid.getSelectionModel().getSelection().length>1){
	    				   		    Ext.Msg.alert(SystemConstant.alertTitle, SystemConstant.onlyOneInfo+SystemConstant.viewInfo+"!");
    									return;
    				   			}
	    				   		var record=grid.getSelectionModel().getSelection()[0];
	    				   		
	    						var processInstanceId = record.get("processInstanceId");
	    						if(processInstanceId==null||Ext.String.trim(processInstanceId)== ''){
	    						     Ext.Msg.alert(SystemConstant.alertTitle, SystemConstant.onlyOneInfo+SystemConstant.notApproveInfo+"!");
	    						    return;
	    				    	}
	    						var operate="monitor";
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
	    	   	}]
			}],
     bbar: {
                xtype: 'pagingtoolbar',
                pageSize: SystemConstant.commonSize,
                store: Ext.data.StoreManager.lookup('personApplyStore'),
                displayInfo: true
       },
     columns: {
              items: [       {header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false,draggable:false,menuDisabled: true,sortable :false},   
                            {header:'流程名',flex:2,dataIndex:'processName',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
                            	return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},/* 
						 	{header:'类别',dataIndex:'processType',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
						 		 cellmeta.tdAttr = 'data-qtip="' + value + '"';
		     	                    return value;
	     	          	}}, */
							{header:'流程发起人名称',flex:1,dataIndex:'userName',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
								return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
							{header:'流程发起人ID',flex:1,dataIndex:'userId',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
								return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
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
                                        personApply.manage.viewProcessListener(row.get("processInstanceId"),"monitor");
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
							{header:'发起时间',flex:1,dataIndex:'startTime',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
								return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
							{header:'结束时间',flex:1,dataIndex:'endTime',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
								return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
							{header:'流程状态',flex:1,dataIndex:'processStatus',sortable:true,draggable:false,menuDisabled: true,sortable :false,
								renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
									if(value==0){
										return  "<span style='color:orange' title='正在运行'>正在运行</span>";
									}else if(value==1){
										return  "<span style='color:green' title='已完成'>已完成</span>";
									}else {
										return  "<span style='color:red' title='未通过'>未通过</span>";
									}
							 }
							},
							{header:'耗时',flex:1,dataIndex:'durationTime',sortable:true,draggable:false,menuDisabled: true,sortable :false,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
								return  "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
	     	          	{
                            header:'重新发起',
                            xtype: 'actioncolumn',
                            width:70,
                            items: [
                                {
                                    iconCls:'release-button',
                                    tooltip: '重新发起',
                                    handler: function(grid, rowIndex, colIndex) {
                                        var processInstanceId = grid.getStore().getAt(rowIndex).get('processInstanceId');
                                        dealshow(processInstanceId);
                                    }
                                }
                            ],
                            align:'center'
                        }
     ]
    }
});

personApply.manage.setGrid(grid);

grid.getStore().load({params:{start:0,limit:SystemConstant.commonSize}});

new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[grid]
	});
});

function dealshow(selectRows)
{
	var url = '${ctx}/bpm/rejectTaskToFirstNode.do';
	Ext.Ajax.request(
		{  
			url : url,  
			params : {  
				opinion : "重新发起",
				processInstanceId : selectRows
			},  
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

function updateProcessInstance(processInstanceId,operate){
	window.open("${ctx}/bpm/toProcessDesigner.do?processInstanceId="+processInstanceId+"&operate="+operate,"_blank");
}

function sendEmail(processInstanceId){
	Ext.Msg.confirm('系统提示','确认要发邮件吗?',function(btn){
		if(btn=='yes'){
			Ext.MessageBox.wait("", "邮件发送中",{text:"请稍后..."});
			Ext.Ajax.request({
				url : '${ctx}/bpm/sendEmailToCurrentCheckUser.action',
				params : {processInstanceId: processInstanceId},
				success : function(response, options) {
					Ext.MessageBox.hide();
					var result = Ext.decode(response.responseText);
			      	var flag = result.success;
			      	if(flag){
			      		new Ext.ux.TipsWindow({
								title:SystemConstant.alertTitle,
								html: result.msg
							}).show();
			      	}else{
			      		Ext.MessageBox.show({
					    	title: SystemConstant.alertTitle,
					        msg: result.msg,
					        buttons: Ext.MessageBox.OK,
					        icon: Ext.MessageBox.ERROR
					    });
			      	}
				}
		    }); 
		}
	});
}

</script>
</head>
<body>
</body>
</html>
