<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<%@include file="../common/css.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>待办任务管理</title>
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
Ext.namespace('personTask');
personTask.manage=function(){
  return {
         setGrid:function(grid){
         this.grid=grid;
         },
         setUnDisposeWin:function(unDisposeWin){
           this.unDisposeWin=unDisposeWin;
         },
         updateTask:function(rowIndex){
    	   var row = personTask.manage.grid.getStore().getAt(rowIndex);
		   var updateForm=Ext.create(Ext.form.Panel,{
	    		layout:'vbox',
	    		 bodyPadding:'SystemConstant.commonSize 20 0 0',
	    		fieldDefaults:{
                     labelAlign: 'right',
                     msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                     labelWidth:80
                   },
	    	    border:false,
		       items:[
		        {
			         layout:"hbox",
			         width:500,
			         border:false,
                     fieldDefaults:{
                     labelAlign: 'right',
                     msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                     labelWidth:80
                     },
               items:[{
                    	xtype:"hidden",
                    	name:"taskId",
                    	value:row.get("taskId")
                    },
                    {
                       fieldLabel :"任务人员姓名",
						blankText:"姓名不能为空",
						xtype:"textfield",
						id:"updateTaskUserName",
						name:"userName",
						allowBlank:false,
						value:row.get("assigneeName"),
						readOnly:true
                    },{
 					    	blankText:"id不能为空",
 					    	fieldLabel: '任务人员id',
 						    allowBlank:false,
 						    name:"userId",
 						    id:"updateTaskUserId",
 						    xtype:"textfield",
 						    value:row.get("assignee"),
 						   readOnly:true
                       },
                       {
                       text:"选择人员",
  					    xtype:"button",
  					    handler:function(){
   						var  userGrid= personTask.manage.createUserPanel();
		                var win = new Ext.Window({
				        title: '人员选择',
		                closable:true,
		                width:500,
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
   				         	Ext.Msg.alert(SystemConstant.alertTitle, '请选择需要设置的人员！');
   	          	         	return;
   			          	   }
   			    		if(records.length>1){
   			      		 Ext.Msg.alert(SystemConstant.alertTitle, '只能选择一个人员！');
   	          	  		 return;
   			  			 }
   			  			var userId = records[0].get("username");
   			   			if(userId==Ext.getCmp("updateTaskUserId").getValue()){
   			   			 Ext.Msg.alert(SystemConstant.alertTitle,'不能修改给当前人！');
   	          				return;
   							}
   						win.close();
   						Ext.getCmp("updateTaskUserId").setValue(userId);
   						Ext.getCmp("updateTaskUserName").setValue(records[0].get("realname"));
   			
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
             },
             {
			         layout:"hbox",
			         width:500,
			         border:false,
                     fieldDefaults:{
                     labelAlign: 'right',
                     msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                     labelWidth:80
                     },
                     items:[{
                      fieldLabel:"业务表单地址",
	   					blankText:"地址不能为空",
	   				     allowBlank:false,
				         vtype:'inputCharFilter',
				         maxLength:200,
	   					 name:"formUrl",
	   					 xtype:"textfield",
	   					value:row.get("formUrl")
                       }, {
                               fieldLabel:"任务名称",
		   						blankText:"任务名称不能为空",
		   						allowBlank:false,
		   						name:"taskName",
					        	vtype:'inputCharFilter',
					        	maxLength:100,
		   						xtype:"textfield",
		   						value:row.get("name")
                       }]
                     }
             ]  
		  })
		  var win = new Ext.Window({
	   	        title: '修改任务',
		        closable:true,
		        width:550,
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
			        
	    	 updateForm.getForm().submit({
	               url:'${ctx}/bpm/updateTask.do',
	                waitTitle:"请等待...",
	        		waitMsg:"正在提交...",
	                success:function(form,action){
	           	       	if(action.result.success){
	           	       	Ext.Msg.alert(SystemConstant.alertTitle,  action.result.msg);
	               	        win.close();
	               	        personTask.manage.grid.getStore().loadPage(1);
	           	        }
	          	    },
	              	failure:function(form,action){
	              		Ext.Msg.alert(SystemConstant.alertTitle, action.result.msg);
			              }
				        });
		    		}
	    	    }]
			})
			win.show(); 
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
		        {header: "部门",width: 200,dataIndex: "orgName",menuDisabled: true},
            	{header: "登录名",width: 200,dataIndex: "username",menuDisabled: true},
            	{header: "姓名",width: 200,dataIndex: "realname",menuDisabled: true},
            	{header: "手机",width: 200,dataIndex: "mobileNo",menuDisabled: true},
            	{header: "固话",width: 200,dataIndex: "phoneNo",menuDisabled: true},
            	{header: "邮箱",width: 200,dataIndex: "email",menuDisabled: true}
            	
		],
		dockedItems: [
		   {
		        xtype:'toolbar',
		        items:[
		        '用户名',
		         {
		          id:"queryUserName",
		          xtype:'textfield'
		         },
		        {
	    	    text :   "查询", 
	    	    iconCls: "search-button", 
	    	    handler:function(){
	    	      var proxy=userGrid.getStore().getProxy( );
	    	      proxy.setExtraParam("userName",Ext.getCmp("queryUserName").getValue());
                  userGrid.getStore().loadPage(1);
	    	     }
	    	   },
		      {
		    	text :   "重置", 
		    	hidden:true,
		    	iconCls: "reset-button", 
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
      moveTask:function(taskId,assignee){
        	   var userGrid=personTask.manage.createUserPanel();
			    var win = new Ext.Window({
					title: '移交任务人员选择',
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
			        		var selects=userGrid.getSelectionModel().getSelection();
			    			if(!records||selects.length<=0){
			    				Ext.Msg.alert(SystemConstant.alertTitle, '请选择需要设置的任务人员！');
			    	          	return;
			    			}
			    			if(selects.lengh>1){
			    			Ext.Msg.alert(SystemConstant.alertTitle, '只能选择一个人员！');
			    	          	return;
			    			}
			    			
			    			var userId = records[0].get("username");
			    			if(userId==assignee){
			    			     Ext.Msg.alert(SystemConstant.alertTitle,  '不能移交给自己！');
			    	          	return;
			    			}
			    			  var myMask = new Ext.LoadMask(win, {msg:"正在提交,请稍后...!"});
                                  myMask.show();
			    			Ext.Ajax.request({ 
			    	 	 		url:'${ctx}/bpm/moveTask.do',
			    	 	 		params:{taskId:taskId,userId:userId},
			    	 	        success : function(res ,options) {
			    	 	 		var objs= Ext.decode(res.responseText);
                                  myMask.hide();
                                  if(objs.success){
                                		win.close();
                                		Ext.Msg.alert(SystemConstant.alertTitle,  '设置成功！');
                                	    personTask.manage.grid.getStore().loadPage(1);
                                  }else{
                                     Ext.Msg.alert(SystemConstant.alertTitle, objs.msg);
                                  }
			    	 			}, 
			    	 	        failure : function(response) { 
			    	 	           myMask.hide();
			    	 	           Ext.Msg.alert(SystemConstant.alertTitle, '系统繁忙，请稍后再试！');
			    	 	        }
			    	 		}); 
			        	}
			        },{
			        	text:"关闭",
			        	handler:function(){
			        		win.close();
			        	}
			        }]
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
				},
		dealshow : function(selectRows)
				{
				    var formPanel = Ext.create('Ext.form.Panel',
				        {
				            frame : false,
				            layout : 'fit',
				            bodyPadding : 0,
				            region : 'east',
				            border : 0,
				            border : false,
				            layout : 'column',
				            bodyStyle : 'padding:10px 10px 10px 10px',
				            fieldDefaults :
					            {
					                labelWidth : 80,
					                labelAlign : 'right',
					                anchor : '100%'
					            },
				            items : 
				            	[
					                {
					                    layout : 'form',
					                    columnWidth : 1,
					                    border : false,
					                    padding : 5,
					                    items : 
					                    	[
					                        	{
							            			xtype:"hidden",
							            			name:"taskId"
							            		},
							            		{
							            			xtype:"hidden",
							            			name:"pass",
							            			value:'true'
							            		},
							            		{
							            			xtype:"hidden",
							            			name:"opinion"
							            		},
							            		{
								            		xtype:"hidden",
								            		name:"processInstanceId"
							            	    },
							            	    {
							            	 		xtype:"hidden",
							            			name:"businessId"
							            		},
							            		{
					            			 		xtype:"hidden",
					            					name:"baseType"
					            				},
					            				{
					            					xtype:"hidden",
					            					name:"realType"
					            	  			},
					            	  			{
					                                fieldLabel : '审批结果',
					                                id : 'approval',
					                                xtype : 'combo',
					                                allowBlank : false,
					                                value:0,
					                                store : Ext.create('Ext.data.ArrayStore',
						                                {
						                                    fields : ['value', 'display'],
						                                    data : [
						                                        [0, "通过"],
						                                        [1, "拒绝"],
						                                        [2, "驳回"]
						                                    ]
						                                }
					                               	),
					                               	editable : false, // 设置为只可选择，不可编辑
					                                queryMode : 'local', // 本地数据时使用'local'
					                                displayField : 'display',
					                                valueField : 'value'
					            	  			},
					                        	{ 
						                         	fieldLabel:'审批意见',
						            		    	xtype:'textarea',
						            		    	id:"initOpinion",
						            		    	allowBlank:true,
						        	                anchor:'90%',
						            		        blankText : '意见不能为空',
						            		        maxLength:350,
						            		        vtype:'inputCharFilter',
						            		    	name:"initOpinion"
					            				}
					                        ]
				            		}
				               	]
				        }
				    );
				    
				    
				    var myWin_deal = Ext.create('Ext.window.Window',
				        {
				            title : '审批',
				            id : 'myWin_deal',
				            closable : true,
				            resizable : false,
				            buttonAlign : "center",
				            width : 600,
				            modal : true,
				            layout : 'fit',
				            constrain : true, //设置只能在窗口范围内拖动
				            closeAction : 'destroy',
				            items : [formPanel],
				            buttons : 
				            	[
				            		{
				            			text : '确认',
					                    id : 'DisagreeBtn',
					                    handler : function()
									    {	
									    	if(!formPanel.getForm().isValid()){
									    		return;
									    	}
									    	
									    	Ext.MessageBox.wait("", "提交数据", 
			    									{
			    										text:"请稍后..."
			    									}
			    							);
									    	
									    	var errorTest = "";
									    	for(var i = 0 ; i < selectRows.length ; i++){
									    		var row = selectRows[i];
									    		
									    		var pass = "";
									    		var opinion = "";
									    		var url = '${ctx}/bpm/compeleteTask.do';
									    		
									    		if(Ext.getCmp("approval").getValue() == 0){
									    			pass = true;
									    			opinion = "通过 "+Ext.getCmp("initOpinion").getValue();
										    	}else if(Ext.getCmp("approval").getValue() == 1){
										    		pass = "false";
										    		opinion = "拒绝 "+Ext.getCmp("initOpinion").getValue();
										    	}else if(Ext.getCmp("approval").getValue() == 2){
										    		pass = "bohui";
										    		url = '${ctx}/bpm/rejectTaskForApply.do';
										    		opinion = "驳回 "+Ext.getCmp("initOpinion").getValue();
										    	}
									    		
									    		Ext.Ajax.request(
								    				{  
								    					//被用来向服务器发起请求默认的url  
								    					url : url,  
								    					//请求时发送后台的参数,既可以是Json对象，也可以直接使用“name = value”形式的字符串  
								    					params : {  
								    						pass : pass,
								    						opinion : opinion,
								    						taskId : row.get("taskId"),
								    						processInstanceId : row.get("processInstanceId"),
								    						businessId : row.get("businessId"),
								    						baseType :row.get("categoryCode"),
								    						realType : row.get("topCategoryCode")
								    					},  
								    					//请求时使用的默认的http方法  
								    					method : "post",
								    					success : function(compeleteTaskRes, options) {
								    						var compeleteTaskResult = Ext.decode(compeleteTaskRes.responseText);
								    						if(!compeleteTaskResult.success){
							    								errorTest += compeleteTaskResult.msg;
									    					}
								    						if(i==selectRows.length){
								    							refleshToDoTask();
								    							if(errorTest != ""){
										                    		Ext.MessageBox.show(
									    							   {
											    						   title:'提示信息',
											    						   msg:errorTest,
											    						   buttons: Ext.Msg.YES,
											    						   modal : true,
											    						   icon: Ext.Msg.ERROR
											    					   }
								    							   );
										                    	}
								    						}
								    					}
								    				}
								    			);
									    		
									    	}
									    	Ext.MessageBox.hide();
									    }
				            		},
				            		{
				            			text : '关闭',
					                    id : 'BackBtn',
					                    handler : function ()
						                    {	
					                    		myWin_deal.close();
						                    }
				            		}
				            	]
				        }
				    ).show();
				}
    }
}();
Ext.onReady(function(){
	   Ext.QuickTips.init();
	   Ext.require(["Ext.container.*",
		             "Ext.grid.*", 
		             "Ext.toolbar.Paging", 
		             "Ext.form.*",
					 "Ext.data.*" ]);
       Ext.define("userModel",{
		extend:"Ext.data.Model",
		fields:[
			{name:"id"},
			{name:"orgName"},
			{name:"username"},
			{name:"realname"},
			{name:"mobileNo"},
			{name:"phoneNo"},
			{name:"shortNo"},
			{name: "email"}
		]
	});
   Ext.define('personTaskModel', {
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
       	{name:'businessId',type:'String'},
       	{name:'categoryCode',type:'string'},
       	{name:'topCategoryCode',type:'string'},
       	{name:'categoryId',type:'int'},
       	{name:'topCategoryId',type:'int'},
       	{name:'formUrl',type:'string'},
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
    storeId:'personTaskStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
      storeObj.removeAll(false);
     }
    },
    pageSize:SystemConstant.commonSize,
    model: 'personTaskModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
        url:'${ctx}/bpm/getToDoTaskListByPage.do',
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});

//定义复选框
var sm = Ext.create("Ext.selection.CheckboxModel",
    {
        injectCheckbox : 1,
        listeners :
        {
            "selectionchange" : function (win)
            {
                var selectRows = grid.getSelectionModel().getSelection();
                
                /* if (selectRows && selectRows.length == 1)
                {
                    Ext.getCmp("approvalGrid").setDisabled(false);
                }
                else
                {
                    Ext.getCmp("approvalGrid").setDisabled(true);
                } */
                
                if (selectRows && selectRows.length)
                {
                    Ext.getCmp("approvalGrid").setDisabled(false);
                }
                else
                {
                    Ext.getCmp("approvalGrid").setDisabled(true);
                } 
            }
        }
    }
);

var grid=Ext.create('Ext.grid.Panel', {
     store: Ext.data.StoreManager.lookup('personTaskStore'),
     selModel : sm,
     forceFit:true,
     border : false,
     //loadMask: true,
     columnLines:true,
     stripeRows : true,
     dockedItems:[/* {
         xtype:'toolbar',
         items:[
             '事项名称',
			{
			 xtype:'textfield',
			 id:'processName',
			 width:150
			},
			{
			 xtype:'textfield',
			 hidden:true,
			 id:'taskOwnerName',
			 width:150
			}]
		   }, */
    	{
		     xtype:"toolbar",
			   items:[
			          '事项名称',
						{
						 xtype:'textfield',
						 id:'processName'
						},'任务名',
						{
							 xtype:'textfield',
							 id:'taskName'
							},
			       '创建日期',
			       { xtype: 'dateTimePicker',width:150,id:'taskStartTime', maxDate : 'taskStartEndTime',dateFmt : 'yyyy-MM-dd HH:mm:ss'},
				   	'至',
				   { xtype: 'dateTimePicker',width:150,id:'taskStartEndTime', minDate : 'taskStartTime',dateFmt : 'yyyy-MM-dd HH:mm:ss'},
					{
						text :   "查询", 
						iconCls: "search-button", 
						handler:function(){
							if(!Ext.getCmp('taskStartTime').isValid()||!Ext.getCmp('taskStartEndTime').isValid()){
								return;
							}
						 	var proxy=grid.getStore().getProxy( );
						 	proxy.setExtraParam("processName",Ext.getCmp("processName").getValue());
						 	proxy.setExtraParam("taskName",Ext.getCmp("taskName").getValue());
						 // proxy.setExtraParam("taskOwnerName",Ext.getCmp("taskOwnerName").getValue());
						 	proxy.setExtraParam("taskStartTime",Ext.getCmp('taskStartTime').getValue());
						 	proxy.setExtraParam("taskStartEndTime",Ext.getCmp('taskStartEndTime').getValue());
						    grid.getStore().loadPage(1);
						} 
		   	    	},
				    '->',
		            {
		                text : '审批',
		                iconCls : "edit-button",
		                id : 'approvalGrid',
		                disabled : true,
		                handler : function ()
		                {
		                	var selectRows = grid.getSelectionModel().getSelection();
		                	personTask.manage.dealshow(selectRows)
		                }
		            }
		   	    ]
	       }
		],
		bbar: {
	        xtype: 'pagingtoolbar',
	        pageSize: SystemConstant.commonSize,
	        store: Ext.data.StoreManager.lookup('personTaskStore'),
	        displayInfo: true
		},
     	columns: {
	        items: [
            	{header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false,draggable:false},
            	{header:'标题',dataIndex:'businessTitle',sortable:false,menuDisabled:true,width:100,draggable:false,
                    renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
                        return  "<span title='"+value+"'>"+value+"</span>";
                    }
                },
            	{header:'流程名',dataIndex:'processName',sortable:false,menuDisabled:true,width:100,draggable:false,
     		 		renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                	return  "<span title='"+value+"'>"+value+"</span>";
	      			}
				},
 			 	{header:'类别',dataIndex:'processType',sortable:false,menuDisabled:true,width:50,draggable:false,
	      			renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	      				return  "<span title='"+value+"'>"+value+"</span>";
	       			}
	      		},
 				{header:'任务名',dataIndex:'name',sortable:false,menuDisabled:true,width:100,draggable:false,
					renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
						return  "<span title='"+value+"'>"+value+"</span>";
					}
	     		},
 				{header:'承办人',dataIndex:'assigneeName',sortable:false,menuDisabled:true,width:70,draggable:false,
					renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
						return  "<span title='"+value+"'>"+value+"</span>";
					}
 				},
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
								 personTask.manage.viewProcessListener(row.get("processInstanceId"),"monitor");
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
		 		                var businessId=row.get("businessId");
		 		                window.open( "${ctx}/"+formUrl+"?businessId="+businessId+"&view=true" , "_blank");
			                }
			            }
	            ],
					align:'center'
				},
				{header:'创建日期',dataIndex:'createTime',
					sortable : false,menuDisabled:true,
					width:150,draggable:false,
				renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
						return  "<span title='"+value+"'>"+value+"</span>";
	          		}
				}
	        
	        ]
    }
});

personTask.manage.setGrid(grid);

grid.getStore().load({params:{start:0,limit:SystemConstant.commonSize}});

new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[grid]
	});
});

function refleshToDoTask(){
			Ext.getCmp('myWin_deal').close();
			personTask.manage.grid.getStore().load();
}
</script>
</head>
<body>
</body>
</html>
