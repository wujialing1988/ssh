<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>流程监控</title>
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
Ext.namespace('processListener');
processListener.manage=function(){
  return {
    setGrid:function(grid){
       this.grid=grid;
       },
       deleteProcessInstance:function(){
					 var selects=processListener.manage.grid.getSelectionModel().getSelection();
					 
			        var ids=[];
			        for(var i=0;i<selects.length;i++){
			    	  ids.push(selects[i].get("processInstanceId"));
			        }
			    	var length=selects.length;
			       Ext.Msg.show({
			    			   title:SystemConstant.alertTitle,
			    			   msg: SystemConstant.deleteMsg,
			    			   buttons: Ext.Msg.YESNO,
			    			   fn: function(btn, text){
			    				  if(btn=='yes'){
			    				  var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"正在提交,请稍后...!"});
                                  myMask.show();
			    					 	Ext.Ajax.request({
					           	    	   	url: '${ctx}/bpm/deleteProcessInstance.do',
					           	    	   	params: {ids:ids.toString()},
					           	    	 	success: function(response, opts) {
					           	    	      	var result = Ext.decode(response.responseText);
					           	    	      	var flag = result.success;
					           	    	      	if(flag){
						           	    	      	processListener.manage.grid.getStore().reload();
						           	    	      	new Ext.ux.TipsWindow({
			                                            title: SystemConstant.alertTitle,
			                                            autoHide: 3,
			                                            html:result.msg
			                                        }).show();
					           	    	      	} else {
						           	    	      	Ext.MessageBox.show({
					                                      title: SystemConstant.alertTitle,
					                                      msg: result.msg,
					                                      buttons: Ext.MessageBox.OK,
					                                      icon: Ext.MessageBox.INFO
					                                  });
					           	    	      	}
					           	    	      	myMask.hide();
					           	    	   	},
		 	   	       	    	        failure: function(response, opts) {
		 	   	       	    	        myMask.hide();
                                        Ext.MessageBox.show({
                                            title: SystemConstant.alertTitle,
                                            msg: '发起流程失败!',
                                            buttons: Ext.MessageBox.OK,
                                            icon: Ext.MessageBox.ERROR
                                        });
                                      }
					           	   });
			    				   }
			    			   },
			    			   icon: Ext.MessageBox.QUESTION
			    			});


				 }
    }
}();
Ext.onReady(function(){
   Ext.define('processListenerModel', {
     extend: 'Ext.data.Model',
     fields: [
        {name:'processInstanceId',type:'String'},
		{name:'userName',type:'string'},
		{name:'userId',type:'String'},
		{name:'startTime',type:'String'},
		{name:'endTime',type:'String'},
		{name:'processStatus',type:'String'},
		{name:'processName',type:'string'},
		{name:'processType',type:'string'},
		{name:'durationTime',type:'String'},
		{name:'businessTitle',type:'String'}
     ]
   });
 Ext.create('Ext.data.JsonStore', {
    clearRemovedOnLoad:true,
    clearOnPageLoad:true,
    autoDestory:true,
    buffered:false,
    storeId:'processListenerStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
      storeObj.removeAll(false);
     }
    },
    pageSize:20,
    model: 'processListenerModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
        url:'${ctx}/bpm/getAllProcessInstanceByPage.do',
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});


var grid=Ext.create('Ext.grid.Panel', {
     title:'流程监控管理',
     store: Ext.data.StoreManager.lookup('processListenerStore'),
     forceFit:true,
     loadMask: true,
     columnLines: true,
     selType:'checkboxmodel',
     selModel: {
     		injectCheckbox:1,
      listeners : {
				"selectionchange" : function(win) {
					if (grid.getSelectionModel().getSelection().length != 0) { //选择了的行
						if(grid.getSelectionModel().getSelection().length==1){
							var rec = grid.getSelectionModel().getSelection()[0];
							if(rec.get("processStatus") != 0){
								Ext.getCmp('update').setDisabled(true);
							}else{
								Ext.getCmp('update').setDisabled(false);
							}
							Ext.getCmp('delete').setDisabled(false);
							Ext.getCmp('view').setDisabled(false);
						}else{
							Ext.getCmp('update').setDisabled(true);
							Ext.getCmp('delete').setDisabled(false);
							Ext.getCmp('view').setDisabled(true);
						}
					}else{
					  Ext.getCmp('update').setDisabled(true);
				      Ext.getCmp('delete').setDisabled(true);
				      Ext.getCmp('view').setDisabled(true);
					}
				}
			},
        pruneRemoved: true
      },
     dockedItems:[
		    {
	     xtype:"toolbar",
		   items:[
		        '发起时间',
		        { xtype: 'dateTimePicker',width:90,id:'processStartTime', maxDate : 'processStartEndTime'},
			   	'到',
			   	{ xtype: 'dateTimePicker',width:90,id:'processStartEndTime', minDate : 'processStartTime'},
			    '结束时间',
			    { xtype: 'dateTimePicker',width:90,id:'processEndStartTime', maxDate : 'processEndTime'},
				'到',
				{ xtype: 'dateTimePicker',width:90,id:'processEndTime', minDate : 'processEndStartTime'},
			   	]
			 },
		    {
	     xtype:"toolbar",
		   items:[
		             '事项名称',
					{
					 xtype:'textfield',
					 id:'processName'
					},
					'发起人姓名',
					{
					 xtype:'textfield',
					 id:'processCreateUserName'
					},
	           {
	    	   text :   "查询", 
	    	   iconCls: "search-button", 
	    	   handler:function(){
				if(!Ext.getCmp('processStartTime').isValid()||!Ext.getCmp('processStartEndTime').isValid()||!Ext.getCmp('processEndStartTime').isValid()||!Ext.getCmp('processEndTime').isValid()){
					return;
			   }
	    	  var proxy=grid.getStore().getProxy( );
	    	   proxy.setExtraParam("processName",Ext.getCmp("processName").getValue());
	    	   proxy.setExtraParam("processCreateUserName",Ext.getCmp("processCreateUserName").getValue());
	    	   //流程发起的开始时间
	    	   proxy.setExtraParam("processStartTime",Ext.getCmp('processStartTime').getValue());
	    	   //流程发起的结束时间
	    	   proxy.setExtraParam("processStartEndTime",Ext.getCmp('processStartEndTime').getValue());
	    	   //流程结束的开始时间
	    	   proxy.setExtraParam("processEndStartTime",Ext.getCmp('processEndStartTime').getValue());
	    	   //流程结束的截止时间
	    	   proxy.setExtraParam("processEndTime",Ext.getCmp('processEndTime').getValue());
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
		    },
			'->',
	    	   	{
					text : "修改",
	    	    	iconCls: "edit-button",
	    	    	id:'update',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    	    var record=grid.getSelectionModel().getSelection()[0];
	    	    	    if(record.get("processStatus") != 0){
	    	    	    	Ext.Msg.alert(SystemConstant.alertTitle, "该流程已结束，不能");
	    	    	    }
	    	    		updateProcessInstance(record.get("processInstanceId"),"editInst");
	    	    	}
	    	   	},
	    	   	' ',
	    	   	{
	    	    	text : "删除",
	    	    	iconCls: "delete-button",
	    	    	id:'delete',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    		processListener.manage.deleteProcessInstance();
	    	    	}
	           	},
	         	' ',
	    	   	{
					text : "查看",
	    	    	iconCls: "icon-sendReview",
	    	    	id:'view',
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
	    	   	}
			]
			}],
     bbar: {
                xtype: 'pagingtoolbar',
                pageSize: 10,
                store: Ext.data.StoreManager.lookup('processListenerStore'),
                displayInfo: true
       },
     columns: {
              items: [  {header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},
                        {header:'标题',dataIndex:'businessTitle',sortable:false,menuDisabled:true,width:150,draggable:false,
			                  renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
			                      return  "<span title='"+value+"'>"+value+"</span>";
			                  }
			            },
                        {header:'流程名',dataIndex:'processName',width:120,sortable:false,menuDisabled:true,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                return "<span title='"+value+"'>"+value+"</span>";
	     	          	}},
						 	{header:'类别',width:80,dataIndex:'processType',sortable:false,menuDisabled:true,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                    cellmeta.tdAttr = 'data-qtip="' + value + '"';
	     	                    return value;
	     	          	}},
							{header:'发起人',width:65,dataIndex:'userName',sortable:false,menuDisabled:true,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                    cellmeta.tdAttr = 'data-qtip="' + value + '"';
	     	                    return value;
	     	          	}},
							
							{header:'发起时间',width:120,dataIndex:'startTime',sortable:false,menuDisabled:true,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                    cellmeta.tdAttr = 'data-qtip="' + value + '"';
	     	                    return value;
	     	          	}},
							{header:'结束时间',width:120,dataIndex:'endTime',sortable:false,menuDisabled:true,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                    cellmeta.tdAttr = 'data-qtip="' + value + '"';
	     	                    return value;
	     	          	}},
							{header:'状态',width:65,dataIndex:'processStatus',sortable:false,menuDisabled:true,
								renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
									if(value==0){
										cellmeta.tdAttr = 'data-qtip="正在运行"';
									return '正在运行';
									}else if(value==1){
										cellmeta.tdAttr = 'data-qtip="已完成"';
										return '已完成';
									}else {
										cellmeta.tdAttr = 'data-qtip="终止"';
										return '终止';
									}
							 }
							},
							{header:'耗时',width:50,dataIndex:'durationTime',sortable:false,menuDisabled:true,	 renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	     	                    cellmeta.tdAttr = 'data-qtip="' + value + '"';
	     	                    return value;
	     	          	}}
     ]
    },
				listeners:{
						/* 'render': function(g) {    
                 			g.on("itemmouseenter", function(view,record,mode,index,e) {
                 	 			var view = g.getView(); 
                     			g.tip = Ext.create('Ext.tip.ToolTip', {  
                        		target: view.el,
                        		delegate: view.getCellSelector(),
                        		trackMouse: true,
                        		renderTo: Ext.getBody(),
                        		listeners: {   
                            		beforeshow: function updateTipBody(tip) {
                						tip.update(tip.triggerElement.innerHTML);
                            		}  
                        		}  
                    		});  
  
                 		});    
             		}   */
				}
});

processListener.manage.setGrid(grid);

grid.getStore().load({params:{start:0,limit:20}});

new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[grid]
	})
});

function updateProcessInstance(processInstanceId,operate){
	window.open("${ctx}/bpm/toProcessDesigner.do?processInstanceId="+processInstanceId+"&operate="+operate,"_blank");
}

function sendEmail(processInstanceId){
	Ext.Msg.confirm('系统提示','确认要发邮件吗?',function(btn){
		if(btn=='yes'){
			Ext.Ajax.request({
				url : '${ctx}/bpm/sendEmailToCurrentCheckUser.action',
				params : {processInstanceId: processInstanceId},
				success : function(response, options) {
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
					        icon: Ext.MessageBox.INFO
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
