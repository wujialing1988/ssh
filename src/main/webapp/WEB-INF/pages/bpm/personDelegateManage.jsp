<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>委托授权</title>
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
Ext.namespace('personDelegate');
personDelegate.manage=function(){
  return {
    setGrid:function(grid){
       this.grid=grid;
       },
       createUserPanel:function(){
	 //建立数据Store
	 var userStore=Ext.create("Ext.data.Store", {
        pageSize: SystemConstant.commonSize,
        model:"userModel",
        remoteSort:true,
        autoLoad:true,
        pageSize:SystemConstant.commonSize,
		proxy: {
            type:"ajax",
		    url: "${ctx}/bpm/getUserListForBpmByPage.action",
		    reader: {
			     totalProperty: "totalSize",
			     root: "list"
		    },
        simpleSortMode :true
        },
        sorters:[{
            property:"userId",
            direction:"ASC"
        }]
	}); 
	var userGrid =  Ext.create("Ext.grid.Panel",{
		columnLines: true,
		bbar:  Ext.create("Ext.PagingToolbar", {
			store: userStore,
			displayInfo: true,
			displayMsg:SystemConstant.displayMsg,
			emptyMsg: SystemConstant.emptyMsg
		}),
        selType:'checkboxmodel',
        selModel: {
        mode:'SINGLE',
        pruneRemoved: true
        },
     	forceFit : true,
		store: userStore,
		autoScroll: true,
		stripeRows: true,
		columns:[
		        {header: "部门",width: 200,dataIndex: "orgName",sortable:false,menuDisabled: true},
            	{header: "登录名",width: 200,dataIndex: "username",sortable:false,menuDisabled: true},
            	{header: "姓名",width: 200,dataIndex: "realname",sortable:false,menuDisabled: true},
            	{header: "手机",width: 200,dataIndex: "mobileNo",sortable:false,menuDisabled: true},
            	{header: "固话",width: 200,dataIndex: "phoneNo",sortable:false,menuDisabled: true},
            	{header: "邮箱",width: 200,dataIndex: "email",sortable:false,menuDisabled: true}
            	
		],
		dockedItems: [
		   {
		        xtype:'toolbar',
		        items:[
		        '用户名',
		         {
		          id:"queryUserName",
		          width:150,
		          xtype:'textfield'
		         },
		        {
	    	    text :   "查询", 
	    	    iconCls: "search-button", 
	    	    handler:function(){
	    	      var proxy=userGrid.getStore().getProxy( );
	    	      proxy.setExtraParam("userName",Ext.getCmp("queryUserName").getValue());
                  userGrid.getStore().load();
	    	     }
	    	   },
		      {
		    	text :   "重置", 
		    	iconCls: "reset-button", 
		    	hidden:true,
		    	handler:function(){
				 Ext.getCmp('queryUserName').setValue();
	          } 
		    }]
	    	}],
				listeners:{
						'render': function(g) {    
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
             		}  
				}
	    });
	    return userGrid;
   },
      addDelegate:function(){
        var addForm=Ext.create(Ext.form.Panel,{
          layout:'vbox',
           border:false,
           bodyPadding:'20 20 0 0',
          fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		    defaults:{
		      	allowBlank:false,
		      	width:300,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		    },
		    items:[{
		        layout:'hbox',
		         bodyPadding:'5 5 0 0',
		         border:false,
		         width:500,
		         fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		      defaults:{
		      	allowBlank:false,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		      },
		        defaultType:'textfield',
		        items:[
		          {
                	  xtype:"hidden",
                	  name:"delegateVo.delegateUserId",
                	  id:"addDelegateUserId"
                  },
                     {
				   		fieldLabel :"开始时间",
				   		xtype:'datefield',
						name:"delegateVo.delegateStartTime",
						format:'Y-m-d  H:i:s',
						id:"addDelegateStartTime",
						blankText:"开始时间不能为空",
						allowBlank:false,
						invalidText:'格式无效，格式必须为例如:2012-01-01 0:0:0'
					},{
				   		fieldLabel:"结束时间",
				   		xtype:'datefield',
						name:"delegateVo.delegateEndTime",
						format:'Y-m-d  H:i:s',
						id:"addDelegateEndTime",
						blankText:"结束时间不能为空",
						allowBlank:false,
						invalidText:'格式无效，格式必须为例如:2012-01-01 0:0:0',
						listeners:{
							"select" :function(DateField,date)
				            {   	 		  		
				        	    if(Ext.util.Format.date(date,'Ymd') < Ext.util.Format.date(Ext.getCmp('addDelegateStartTime').getValue(),'Ymd')){
				        	    	Ext.Msg.alert('提示信息','结束时间必须大于开始时间');        	    	
				        	    	DateField.reset();
				            	}  
				            }
					  }
					}]
		     },{
		      layout:'hbox',
		      defaultType:'textfield',
		      border:false,
		      width:500,
		       bodyPadding:'5 5 0 0',
		      fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		      defaults:{
		      	allowBlank:false,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		      },
		      items:[{
                    	 fieldLabel:"被委托人",
						 readOnly:true,
						 id:"addDelegateUserName",
						 width:350,
						 
						 blankText:"请点击选择人员",
						 allowBlank:false
                     }, 
                     {
                     text:"选择人员",
					 xtype:"button",
					 handler:function(){
		 		 		 var  userGrid= personDelegate.manage.createUserPanel();
		         		 var win = new Ext.Window({
				  			title: '委托人员选择',
				 			closable:true,
							 width:600,
							 height:360,
							 modal:true,
							 plain:true,
							 resizable:false,
							 layout :"fit",
							 buttonAlign:'center', 
							 items: [
							 userGrid
				 			],
							buttons:[{
								text:"确定",
								handler:function(){
								var records = userGrid.getSelectionModel().getSelection();
								if(!records||records.length<=0){
						  		 Ext.Msg.alert(SystemConstant.alertTitle,'请选择需要设置的委托的人员！');
								return;
								}
								if(records.length>1){
								Ext.Msg.alert(SystemConstant.alertTitle,'只能选择一个人员！');
								return;
								}
								var userId = records[0].get("username");
								if(userId=="${user.username}"){
						  	 	 Ext.Msg.alert(SystemConstant.alertTitle,'不能委托给自己！');
									return;
									}
									win.close();
									Ext.getCmp("addDelegateUserId").setValue(userId);
									Ext.getCmp("addDelegateUserName").setValue(records[0].get("realname"));
						
								}
							},{
								text:"关闭",
								handler:function(){
								win.close();
						       }
					       }]
			           });
			           win.show();
					
			        }
			  }]
		   }
		   ]
		});
		
		var win = new Ext.Window({
			title: '添加委托',
			closable:true,
			width:500,
			height:300,
			modal:true,
			plain:true,
			layout:"fit",
			resizable:false,
			items: [
			addForm
			],
			buttonAlign:'center', 
			buttons:[{
				text:'保存',
				handler:function(){
					if(!addForm.getForm().isValid()){
						return;
					}
				if(Ext.getCmp("addDelegateEndTime").getValue().getTime()<Ext.getCmp("addDelegateStartTime").getValue().getTime()){
					Ext.Msg.alert(SystemConstant.alertTitle,'开始时间大于结束时间！');
					return;
				}   
				   addForm.getForm().submit({
					  url:'${ctx}/bpm/addDelegate.do',
							waitTitle:"请等待...",
							waitMsg:"正在提交...",
							success:function(form,action){
								if(action.result.success){
								Ext.Msg.alert(SystemConstant.alertTitle,action.result.msg);
									win.close();
									personDelegate.manage.grid.getStore().reload();
								}
							},
							failure:function(form,action){
							Ext.Msg.alert(SystemConstant.alertTitle,action.result.msg);
							}
						});
				}
			  },{
			    text:'关闭',
				handler:function(){
				win.close();
				}
			  }]
			});
			win.show();
       },
         updateDelegate:function(){
		 var record=personDelegate.manage.grid.getSelectionModel().getSelection()[0];
		  var updateForm=Ext.create(Ext.form.Panel,{
          layout:'vbox',
           border:false,
           bodyPadding:'20 20 0 0',
          fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		    defaults:{
		      	allowBlank:false,
		      	width:300,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		    },
		    items:[{
		        layout:'hbox',
		         bodyPadding:'5 5 0 0',
		         border:false,
		         width:500,
		         fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		      defaults:{
		      	allowBlank:false,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		      },
		        defaultType:'textfield',
		        items:[
		          {
                	  xtype:"hidden",
                	  name:"delegateVo.id",
                	  value:record.get("id")
                  },
                     {
				   		fieldLabel :"开始时间",
				   		xtype:'datefield',
						name:"delegateVo.delegateStartTime",
						format:'Y-m-d H:i:s',
						id:"updateDelegateStartTime",
						blankText:"开始时间不能为空",
						value:record.get("delegateStartTime"),
						allowBlank:false,
						invalidText:'格式无效，格式必须为例如:2012-01-01 01:01:01'
					},{
				   		fieldLabel:"结束时间",
				   		xtype:'datefield',
						name:"delegateVo.delegateEndTime",
						format:'Y-m-d H:i:s',
						id:"updateDelegateEndTime",
						value:record.get("delegateEndTime"),
						blankText:"结束时间不能为空",
						allowBlank:false,
						invalidText:'格式无效，格式必须为例如:2012-01-01 01:01:01',
						listeners:{
							"select" :function(DateField,date)
				            {   	 		  		
				        	    if(Ext.util.Format.date(date,'Ymd') < Ext.util.Format.date(Ext.getCmp('updateDelegateStartTime').getValue(),'Ymd')){
				        	    	Ext.Msg.alert('提示信息','结束时间必须大于开始时间');        	    	
				        	    	DateField.reset();
				            	}  
				            }
					  }
					}]
		     },{
		        layout:'hbox',
		         bodyPadding:'5 5 0 0',
		         border:false,
		         width:500,
		         fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		      defaults:{
		      	allowBlank:false,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		      },
		      items:[{
	   	       xtype:"textfield",
              fieldLabel:"被委托人id", 
              value:record.get("delegateUserId"),
              readOnly:true,
              
    	      id:"updateDelegateUserId",
              name:"delegateVo.delegateUserId"
		   },{
   	       typeAhead: true,
   	       editable:true,
   	       xtype:'combo',
   	       fieldLabel:"标志", 
   	       forceSelection:true,
   	       triggerAction: 'all',
   	       lazyRender:true,
   	       mode: 'local',
   	       name:"delegateVo.delegateStatus",
   	       value:record.get("delegateStatus"),
   	        store: new Ext.data.ArrayStore({
   	        id: 0,
   	        fields: [
   	            'id',
   	            'displayText'
   	        ],
   	         data: [[0, '有效'], [1, '无效']]
   	       }),
   	       valueField: 'id',
   	       displayField: 'displayText'
   	       }]
		},{
		      layout:'hbox',
		      defaultType:'textfield',
		      border:false,
		      width:500,
		       bodyPadding:'5 5 0 0',
		      fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		      defaults:{
		      	allowBlank:false,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		      },
		      items:[{
                    	 fieldLabel:"被委托人",
						 readOnly:true,
						 id:"updateDelegateUserName",
						 width:350,
						 value:record.get("delegateUserName"),
						 blankText:"请点击选择人员",
						 allowBlank:false
                     }, 
                     {
                     text:"选择人员",
					 xtype:"button",
					 handler:function(){
		 		 		 var  userGrid= personDelegate.manage.createUserPanel();
		         		 var win = new Ext.Window({
				  			title: '委托人员选择',
				 			closable:true,
							 width:600,
							 height:360,
							 modal:true,
							 plain:true,
							 resizable:false,
							 layout :"fit",
							 buttonAlign:'center', 
							 items: [
							 userGrid
				 			],
							buttons:[{
								text:"确定",
								handler:function(){
								var records = userGrid.getSelectionModel().getSelection();
								if(!records||records.length<=0){
						  		 Ext.Msg.alert(SystemConstant.alertTitle,'请选择需要设置的委托的人员！');
								return;
								}
								if(records.length>1){
								Ext.Msg.alert(SystemConstant.alertTitle,'只能选择一个人员！');
								return;
								}
								var userId = records[0].get("username");
								if(userId=="${user.username}"){
						  	 	 Ext.Msg.alert(SystemConstant.alertTitle,'不能委托给自己！');
									return;
									}
									win.close();
									Ext.getCmp("updateDelegateUserId").setValue(userId);
									Ext.getCmp("updateDelegateUserName").setValue(records[0].get("realname"));
						
								}
							},{
								text:"关闭",
								handler:function(){
								win.close();
						       }
					       }]
			           });
			           win.show();
					
			        }
			  }]
		   }
		   ]
		});
		
		var win = new Ext.Window({
			title: '修改委托',
			closable:true,
			width:500,
			height:300,
			modal:true,
			plain:true,
			layout:"fit",
			resizable:false,
			items: [
			updateForm
			],
			buttonAlign:'center', 
			buttons:[{
				text:'保存',
				handler:function(){
					if(!updateForm.getForm().isValid()){
						return;
					}
				if(Ext.getCmp("updateDelegateEndTime").getValue().getTime()<Ext.getCmp("updateDelegateStartTime").getValue().getTime()){
					Ext.Msg.alert(SystemConstant.alertTitle,'开始时间大于结束时间！');
					return;
				}   
				   updateForm.getForm().submit({
					  url:'${ctx}/bpm/updateDelegate.do',
							waitTitle:"请等待...",
							waitMsg:"正在提交...",
							success:function(form,action){
								if(action.result.success){
								Ext.Msg.alert(SystemConstant.alertTitle,action.result.msg);
									win.close();
									personDelegate.manage.grid.getStore().reload();
								}
							},
							failure:function(form,action){
							Ext.Msg.alert(SystemConstant.alertTitle,action.result.msg);
							}
						});
				}
			  },{
			    text:'关闭',
				handler:function(){
				win.close();
				}
			  }]
			});
			win.show();
		 },
        deleteDelegate:function(){
		  var records=personDelegate.manage.grid.getSelectionModel().getSelection();
			 if(records.length<1){
			     Ext.Msg.alert(SystemConstant.alertTitle,"请选择要删除的数据！");
			     return;	 
			 } 
		   var ids=[];
		    for(var i=0;i<records.length;i++){
			 ids.push(records[i].get("id"));
		    }
		 Ext.Msg.confirm(SystemConstant.alertTitle,'确认删除'+records.length+'条数据吗？',function(btn,text){
			if(btn=="yes"){
			        var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"正在提交，请等待..."});
			        myMask.show();
			        Ext.Ajax.request({
				    url: '${ctx}/bpm/deleteDelegate.do',
				    params: {
				   	ids : ids.toString()
				  },
				  success: function(response, opts) {
					  var result = Ext.decode(response.responseText);
					  myMask.hide();
					  var flag = result.success;
					  if(flag){
					   Ext.Msg.alert(SystemConstant.alertTitle,result.msg);
					    personDelegate.manage.grid.getStore().reload();
				      }else{
				       Ext.Msg.alert(SystemConstant.alertTitle,result.msg);
				        }
				     }, 
			    	 failure : function(response) { 
			    	  myMask.hide();
			    	 	Ext.Msg.alert(SystemConstant.alertTitle, '系统繁忙，请稍后再试！');
			    	 }
			});
		 };

	    });
	  }
    }
}();
Ext.onReady(function(){
  Ext.define("userModel",{
		extend:"Ext.data.Model",
		fields:[
			{name:"userId"},
			{name:"orgName"},
			{name:"username"},
			{name:"realname"},
			{name:"mobileNo"},
			{name:"phoneNo"},
			{name:"shortNo"},
			{name: "email"}
		]
	});
   Ext.define('personDelegateModel', {
     extend: 'Ext.data.Model',
     fields: [
        {name:'delegateUserId',type:'string'},
 		{name:'delegateUserName',type:'string'},
 		{name:'delegateStartTime',type:'string'},
 		{name:'delegateEndTime',type:'string'},
 		{name:'delegateStatus',type:'int'},
 		{name:'id',type:"int"}
     ]
   });
 Ext.create('Ext.data.JsonStore', {
    clearRemovedOnLoad:true,
    clearOnPageLoad:true,
    autoDestory:true,
    buffered:false,
    storeId:'personDelegateStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
      storeObj.removeAll(false);
     }
    },
    pageSize:20,
    model: 'personDelegateModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
        url:'${ctx}/bpm/getDelegateByPage.do',
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});


var grid=Ext.create('Ext.grid.Panel', {
     title:'委托授权',
     store: Ext.data.StoreManager.lookup('personDelegateStore'),
     forceFit:true,
     loadMask: true,
     selType:'checkboxmodel',
     selModel: {
     		injectCheckbox:1,
      listeners : {
				"selectionchange" : function(win) {
					if (grid.getSelectionModel().getSelection().length != 0) { //选择了的行
						if(grid.getSelectionModel().getSelection().length==1){
							Ext.getCmp('update').setDisabled(false);
							Ext.getCmp('delete').setDisabled(false);
						}else{
							Ext.getCmp('update').setDisabled(true);
							Ext.getCmp('delete').setDisabled(false);
						}
					}else{
					  Ext.getCmp('update').setDisabled(true);
				      Ext.getCmp('delete').setDisabled(true);
					}
				}
			},
        pruneRemoved: true
      },
     dockedItems:[{
         xtype:'toolbar',
         items:[
             '被委托人',
			{
			 xtype:'textfield',
			 id:'delegateUserName',
			 width:150
			},
     		'委托状态',
			{
   	     typeAhead: true,
   	     editable:true,
   	     xtype:'combo',
   	     forceSelection:true,
   	     id:'statusFlag',
   	     width:150,
   	     triggerAction: 'all',
   	     lazyRender:true,
   	     mode: 'local',
   	     store: new Ext.data.ArrayStore({
   	        id: 0,
   	        fields: [
   	            'id',
   	            'displayText'
   	        ],
   	        data: [[1, '有效'], [2, '无效']]
   	    }),
   	    valueField: 'id',
   	    displayField: 'displayText'
     	}]
		   },
		    {
	     xtype:"toolbar",
		   items:[
		       '开始时间',
			   	{
					id:'delegateStartTime',
					format:'Y-m-d',
					xtype:'datefield',
					invalidText:'格式无效，格式必须为例如:2012-01-01',
					width:150
				},
			   	'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;到',
			   	   {
					id:'delegateStartEndTime',
					xtype:'datefield',
					invalidText:'格式无效，格式必须为例如:2012-01-01',
					format:'Y-m-d',
					width:150,
					listeners:{
                     "select" :function(DateField,date)
				            {   	 		  		
				        	    if(Ext.util.Format.date(date,'Ymd') < Ext.util.Format.date(Ext.getCmp('delegateStartTime').getValue(),'Ymd')){
				        	    	Ext.Msg.alert('提示信息','结束时间必须大于开始时间');        	    	
				        	    	DateField.reset();
				            	}  
				            }
					}
				  }
		         ]
			 },
		    {
	     xtype:"toolbar",
		   items:[
		       '结束时间',
			   	{
					id:'delegateEndStartTime',
					format:'Y-m-d',
					xtype:'datefield',
					invalidText:'格式无效，格式必须为例如:2012-01-01',
					width:150
				},
			   	'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;到',
			   	   {
					id:'delegateEndTime',
					xtype:'datefield',
					invalidText:'格式无效，格式必须为例如:2012-01-01',
					format:'Y-m-d',
					width:150,
					listeners:{
                     "select" :function(DateField,date)
				            {   	 		  		
				        	    if(Ext.util.Format.date(date,'Ymd') < Ext.util.Format.date(Ext.getCmp('delegateEndStartTime').getValue(),'Ymd')){
				        	    	Ext.Msg.alert('提示信息','结束时间必须大于开始时间');        	    	
				        	    	DateField.reset();
				            	}  
				            }
					}
				  },
	           {
	    	   text :   "查询", 
	    	   iconCls: "search-button", 
	    	   handler:function(){
				if(!Ext.getCmp('delegateStartTime').isValid()||!Ext.getCmp('delegateStartEndTime').isValid()||!Ext.getCmp('delegateEndStartTime').isValid()||!Ext.getCmp('delegateEndTime').isValid()){
					return;
			   }
	    	   var proxy=grid.getStore().getProxy( );
	    	   proxy.setExtraParam("delegateUserName",Ext.getCmp("delegateUserName").getValue());
	    	   proxy.setExtraParam("statusFlag",Ext.getCmp("statusFlag").getValue());
	    	   proxy.setExtraParam("startTime",Ext.util.Format.date(Ext.getCmp('delegateStartTime').getValue(),'Y-m-d H:i:s'));
	    	   proxy.setExtraParam("startEndTime",Ext.util.Format.date(Ext.getCmp('delegateStartEndTime').getValue(),'Y-m-d H:i:s'));
	    	   proxy.setExtraParam("endStartTime",Ext.util.Format.date(Ext.getCmp('delegateEndStartTime').getValue(),'Y-m-d H:i:s'));
	    	   proxy.setExtraParam("endTime",Ext.util.Format.date(Ext.getCmp('delegateEndTime').getValue(),'Y-m-d H:i:s'));
                grid.getStore().load();
              } 
	   	    },
		   {
		    	text :   "重置", 
		    	iconCls: "reset-button", 
		    	hidden:true,
		    	handler:function(){
		    	 Ext.getCmp('delegateUserName').reset();
				 Ext.getCmp('statusFlag').reset();
				 Ext.getCmp('delegateStartTime').reset();
				 Ext.getCmp('delegateStartEndTime').reset();
				 Ext.getCmp('delegateEndStartTime').reset();
				 Ext.getCmp('delegateEndTime').reset();
	          } 
		    },'->',{
					text : "添加",
	    	    	iconCls: "add-button",
	    	    	id:'add',
	    	    	handler:function(){
	    	    	 personDelegate.manage.addDelegate();
	    	    	}
	    	   	},{
					text : "修改",
	    	    	iconCls: "edit-button",
	    	    	id:'update',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    	    personDelegate.manage.updateDelegate()
	    	    	  }
	    	   	},
	    	   	'-',
	    	   	{
	    	    	text : "删除",
	    	    	iconCls: "delete-button",
	    	    	id:'delete',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    		personDelegate.manage.deleteDelegate();
	    	    	}
	           	}]
			}],
     bbar: {
                xtype: 'pagingtoolbar',
                pageSize: 10,
                store: Ext.data.StoreManager.lookup('personDelegateStore'),
                displayInfo: true//,
                //plugins: new Ext.ux.ProgressBarPager()
       },
     columns: {
              items: [   
              {header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},   
           {header:'被委托人ID',dataIndex:'delegateUserId',sortable:false,menuDisabled : true,width:100},
 	       {header:'被委托人',dataIndex:'delegateUserName',sortable:true,width:100,menuDisabled: true,sortable :false},
 	       {header:'委托开始时间',dataIndex:'delegateStartTime',sortable:true,width:100,menuDisabled: true,sortable :false},
 	       {header:'委托结束时间',dataIndex:'delegateEndTime',sortable:true,width:100,menuDisabled: true,sortable :false},
 	       {header:'委托状态',dataIndex:'delegateStatus',width:100,menuDisabled: true,sortable :false,
 	       		renderer:function(value,metadata,record,rowIndex,colIndex,store){
 					if(value=='1'){
 			 			return '无效';
 		 			}else if(value=='0'){
 			 			return '有效';
 		 			}
 	 			}
 	 		}
     ]
    }
});

personDelegate.manage.setGrid(grid);

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
</script>
</head>
<body>
</body>
</html>
