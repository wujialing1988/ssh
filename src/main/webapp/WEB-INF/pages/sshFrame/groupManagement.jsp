<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head> 
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>群组管理</title>
<link href="" rel="SHORTCUT ICON" />
<script type="text/javascript" src="${ctx}/scripts/extjs/ux/TreePicker.js"></script>
<style type="text/css">
  .x-form-layout-table{
	table-layout: fixed;
  }
</style>
</head>
<body>

	<script type="text/javascript">
		Ext.onReady(function() {
			Ext.QuickTips.init();
			//自动引入其他需要的js
			Ext.require(["Ext.container.*",
			             "Ext.grid.*", 
			             "Ext.toolbar.Paging", 
			             "Ext.form.*",
						 "Ext.data.*"]);
			
		 	Ext.define("Group",{
				extend:"Ext.data.Model",
				fields:[
					{name: "id",mapping:"id"}, 
					{name: "groupName",mapping:"groupName"}, 
					{name: "remark",mapping:"remark"}
				]
			});	
		 	
		 	//群组id
		 	var groupId = "";
		 	var informationGrid;
		 	
			var informationCloumns=[
					{header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},
					{header: "ID",width: 70,dataIndex: "id",hidden: true,menuDisabled: true,sortable :false},
					{header: "名称",width: 100,dataIndex: "groupName",menuDisabled: true,sortable :false,
						renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                        cellmeta.tdAttr = 'data-qtip="' + value + '"';
	                        return value;
	                    }
					},
					{header:"描述",width:200,dataIndex:"remark",menuDisabled: true,sortable :false,
						renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                        cellmeta.tdAttr = 'data-qtip="' + value + '"';
	                        return value;
	                    }
					}
		         ]; 
			
			var informationStore=Ext.create("Ext.data.Store", {
		        pageSize: SystemConstant.commonSize,
		        model:"Group",
		        remoteSort:true,
				proxy: {
		            type:"ajax",
		            extraParams:{groupId:groupId},
		            actionMethods: {
	                	read: 'post'
	           		},
				    url: "${ctx}/group/getGroupList.action",
				    reader: {
					     totalProperty: "totalSize",
					     root: "list"
				    },
		        simpleSortMode :true
		        },
		        sorters:[{
		            property:"id",
		            direction:"ASC"
		        }],
		        listeners:{
		        	beforeload:function(){
		        		if(informationGrid){
		        			c = informationGrid.getSelectionModel().getSelection();
		        			if(c.length > 0){
				        		informationGrid.getSelectionModel().deselectAll();
		        			}
		        		}
		        	}
		        }
			});
			
			var informationSm = Ext.create("Ext.selection.CheckboxModel",{
				id:'checkboxmodel',
				injectCheckbox:1,
		    	listeners: {
			      	selectionchange: function(){
			        	var c = informationGrid.getSelectionModel().getSelection();
			        	var b = groupMemberGrid.getSelectionModel().getSelection();
			        	/*i f(informationStore.getCount() < 0){
			        		Ext.getCmp('updateGroupBtn').setDisabled(true);
			        	} */
			        	if(c.length > 0){
							Ext.getCmp('delGroupBtn').setDisabled(false);
					 	}else{
					 		var proxy1 = groupMemberStore.getProxy();
						    proxy1.setExtraParam("groupId","");
					 		groupMemberStore.loadPage(1); 
						 	Ext.getCmp('delGroupBtn').setDisabled(true);
					 	}
					 	if(c.length > 0 && c.length < 2){
					 		Ext.getCmp('addUserBtn').setDisabled(false);
					 		Ext.getCmp('orgTreePanel').setDisabled(false);
						 	Ext.getCmp('updateGroupBtn').setDisabled(false);
						 	Ext.getCmp('groupMemberGrid').setDisabled(false);
					 	}else{
					 		Ext.getCmp('addUserBtn').setDisabled(true);
					 		Ext.getCmp('orgTreePanel').setDisabled(true);
						 	Ext.getCmp('updateGroupBtn').setDisabled(true);
						 	Ext.getCmp('groupMemberGrid').setDisabled(true);
					 	}
					 	if(c.length > 1 && b.length>0){
					 		Ext.getCmp('delUserBtn').setDisabled(true);
					 	}else if(c.length > 1 && b.length==0){
					 		Ext.getCmp('delUserBtn').setDisabled(true);
					 	}else if(c.length == 1 && b.length>0){
					 		Ext.getCmp('delUserBtn').setDisabled(false);
					 	}
					 	
					 	if(c.length == 1){
					 		groupId = c[0].get("id");
						    var proxy1 = groupMemberStore.getProxy();
						    proxy1.setExtraParam("groupId",groupId);
					 		groupMemberStore.loadPage(1);
					 		var proxy = orgTreeStore.getProxy();
						   	proxy.setExtraParam("groupId",groupId);
						   	orgTreeStore.load();
					 	}
					 	
			      	}
				}
		    });
			
			informationGrid =  Ext.create("Ext.grid.Panel",{
				title:'群组管理',
				border:false,
				columnLines: true,
				layout:"fit",
				region: "west",
				width: 430,
				height: document.body.clientHeight,
				id: "informationGrid",
				bbar:  Ext.create("Ext.PagingToolbar", {
					store: informationStore,
					displayInfo: true,
					displayMsg: SystemConstant.displayMsg,
					emptyMsg: SystemConstant.emptyMsg
				}),
				columns:informationCloumns,
		        selModel:informationSm,
		     	forceFit : true,
				store: informationStore,
				autoScroll: true,
				stripeRows: true,
				tbar: ['名称',
				{
					id: 'groupName',
					stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
 					labelWidth: 70,   
					xtype: 'textfield'
				},{
					id:'searchBtn',
					xtype:'button',
					disabled:false,
					text:'查询',
					iconCls:'search-button',
					handler:function(){
						var proxy = informationStore.getProxy();
						proxy.setExtraParam("groupName",Ext.getCmp("groupName").getValue());
						informationStore.load(function(){
							informationGrid.getSelectionModel().selectRange(0,0);
							var proxy1 = groupMemberStore.getProxy();
						    proxy1.setExtraParam("groupId",groupId);
							groupMemberStore.loadPage(1);
						});
					}
				},'->',
				{
					id:'addGroupBtn',
					xtype:'button',
					disabled:false,
					text:'添加',
					iconCls:'add-button',
					handler:function(){
						addGroupInfo();
					}
				},
				{
					id:'updateGroupBtn',
					xtype:'button',
					text:'修改',
					disabled:true,
					iconCls:'edit-button',
					handler:function(){
						updateGroupInfo();
					}
				},
				{
					id:'delGroupBtn',
					xtype:'button',
					text:'删除',
					disabled:true,
					iconCls:'delete-button',
					handler:function(){
						delGroupInfo();
					}
				}],
				listeners:{
					'afterrender':function(){
						informationStore.on("load",function(){
							if(informationStore.getCount() > 0){
								informationGrid.getSelectionModel().selectRange(0,0);
								var row = informationGrid.getSelectionModel().getSelection();
								groupId = row[0].get("id");
							}
    					});
    				}
				}
			});		
			informationStore.loadPage(1);
			
			addGroupInfo = function(){
				var groupForm=Ext.create("Ext.form.Panel",{
					layout: 'form',
					bodyStyle :'padding:15px 20px',
					border: false,
					labelAlign: 'right',
					fieldDefaults: {
			            labelWidth: 80,
			        	labelAlign: 'right'
			        },
			        defaults: {
				        anchor: '60%'
				    },
				    defaultType: 'textfield',
				    items:[{
				    	fieldLabel:'名称',
	                    id:'groupNameText',
	                    name:'group.groupName',
	                    maxLength: 20,
	                    maxLenghtText:'用户名超出长度限制20',
	                    blankText:'名称不能为空',
	                    regex : /^[\w.\-\u4e00-\u9fa5]*$/,
	                    regexText : "输入内容不能包含空格和特殊字符！",
	                    validationDelay:500,
	                    allowBlank:false,
	                    validator : function(value){
	                    	var returnObj = null;
	                    		$.ajax({
		                            data:{groupName:value},
		                            url : '${ctx}/group/validateGroupName.action',
		                            cache : false,
		                            async : false,
		                            type : "post",
		                            dataType : 'json',
		                            success : function (result){
		                                if(!result.valid){
		                                	returnObj = result.reason;
		                                }else{
		                                	returnObj = true;
		                                }
		                            }
		                        });
	                    	return returnObj;
	                    }
				    },{
				    	fieldLabel:'描述',
	                    id:'groupRemarkText',
	                    name:'group.remark',
	                    maxLength: 500,
	                    maxLenghtText:'备注超出长度限制500',
	                    xtype : 'textareafield',
	                    regex : /^[\w.\- , ，。.\u4e00-\u9fa5]*$/,
	                    regexText : "输入内容不能包含特殊字符！",
	                    allowBlank:true
				    }],
				    listeners:function(){
				    	
				    }
				});
				
				var groupWin = Ext.create("Ext.window.Window",{
					title: '添加群组',
					resizable: false,
					buttonAlign:"center",
				  	height: 200,
				    width: 400,
				    modal:true,
				    layout: 'fit',
				    closeAction : 'destroy',
				    items: [groupForm],
				    buttons:[{
				    	text: SystemConstant.saveBtnText,
				    	handler: function(){
				    		if(groupForm.form.isValid()){
				    			groupForm.form.submit({
				    				url:"${ctx}/group/addGroup.action",
			    				   	success : function(form, action) {
			    					   new Ext.ux.TipsWindow({
											title: SystemConstant.alertTitle,
											autoHide: 3,
											html:action.result.msg
										}
									).show();
			    					   //informationStore.loadPage(1); 
			    					   informationStore.load();
			    					   groupWin.close();
			    				   },
			    				   failure : function(form,action){
			    					   Ext.MessageBox.show({
			    						   title:'提示信息',
			    						   msg:action.result.msg,
			    						   buttons: Ext.Msg.YES,
			    						   modal : true,
			    						   icon: Ext.Msg.ERROR
			    					   });
			    					  // informationStore.loadPage(1);
			    					  informationStore.load(); 
			    					  groupWin.close();
			    					   Ext.MessageBox.hide();
			    				   }
				    			});
				    			
				    		}
				    	}
				    },{
				    	text: '关闭',
		                handler: function(){
		                	groupWin.close();
		                }
				    }]
				}).show();
			};
			
			updateGroupInfo = function(){
				var row = informationGrid.getSelectionModel().getSelection();
				var groupName = row[0].get('groupName');
				var groupForm=Ext.create("Ext.form.Panel",{
					layout: 'form',
					bodyStyle :'padding:15px 20px',
					border: false,
					labelAlign: 'right',
					fieldDefaults: {
			            labelWidth: 80,
			        	labelAlign: 'right'
			        },
			        defaults: {
				        anchor: '60%'
				    },
				    defaultType: 'textfield',
				    items:[{
				    	xtype:'hidden',
				    	name:'group.id',
				    	value:row[0].get("id")
				    },{
				    	fieldLabel:'名称',
	                    id:'groupNameText',
	                    name:'group.groupName',
	                    value:row[0].get("groupName"),
	                    maxLength: 20,
	                    maxLenghtText:'用户名超出长度限制20',
	                    blankText:'名称不能为空',
	                    regex : /^[\w.\-\u4e00-\u9fa5]*$/,
	                    regexText : "输入内容不能包含空格和特殊字符！",
	                    //beforeLabelTextTpl: required,
	                    validationDelay:500,
	                    allowBlank:false,
	                    validator : function(value){
	                    	var returnStr = null;
	                    	if(value == groupName){
	                    		return true;
	                    	}else{
	                    		$.ajax({
		                            data:{groupName:value},
		                            url : '${ctx}/group/validateGroupName.action',
		                            cache : false,
		                            async : false,
		                            type : "post",
		                            dataType : 'json',
		                            success : function (result){
		                                if(!result.valid){
		                                	returnStr = result.reason;
		                                }else{
		                                	returnStr = true;
		                                }
		                            }
		                        });
	                    	}
	                    	return returnStr;
	                    }
	                    
				    },{
				    	fieldLabel:'描述',
	                    id:'groupRemarkText',
	                    name:'group.remark',
	                    value:row[0].get("remark"),
	                    maxLength: 500,
	                    maxLenghtText:'备注超出长度限制500',
	                    xtype : 'textareafield',
	                    regex : /^[\w.\- , ，。.\u4e00-\u9fa5]*$/,
	                    regexText : "输入内容不能包含特殊字符！",
	                    allowBlank:true
				    }],
				    listeners:function(){
				    	
				    }
				});
				
				var groupWin = Ext.create("Ext.window.Window",{
					title: '修改群组',
					resizable: false,
					buttonAlign:"center",
				  	height: 200,
				    width: 400,
				    modal:true,
				    layout: 'fit',
				    closeAction : 'destroy',
				    items: [groupForm],
				    buttons:[{
				    	text: SystemConstant.saveBtnText,
				    	handler: function(){
				    		if(groupForm.form.isValid()){
				    			groupForm.form.submit({
				    				url:"${ctx}/group/updateGroup.action",
			    				   	success : function(form, action) {
			    					   Ext.getCmp("informationGrid").getSelectionModel().clearSelections();
			    					   new Ext.ux.TipsWindow({
											title: SystemConstant.alertTitle,
											autoHide: 3,
											html:action.result.msg
										}
									).show();
			    					   //informationStore.loadPage(1); 
			    					   informationStore.load();
			    					   groupWin.close();
			    				   },
			    				   failure : function(form,action){
			    					   Ext.MessageBox.show({
			    						   title:'提示信息',
			    						   msg:action.result.msg,
			    						   buttons: Ext.Msg.YES,
			    						   modal : true,
			    						   icon: Ext.Msg.ERROR
			    					   });
			    					   //informationStore.loadPage(1);
			    					   informationStore.load();
			    					   groupWin.close();
			    					   Ext.MessageBox.hide();
			    				   }
				    			});
				    			
				    		}
				    	}
				    },{
				    	text: '关闭',
		                handler: function(){
		                	groupWin.close();
		                }
				    }]
				}).show();
			};
			
			delGroupInfo = function(){
				var rows = Ext.getCmp("informationGrid").getSelectionModel().getSelection();
				var ids = '';
				for(var i = 0; i < rows.length; i++){
	    			if(i < rows.length-1){
	    				ids+=rows[i].get("id")+",";
	    			}else {
	    				ids+=rows[i].get("id");
	    			}
	    		}
				
				Ext.Ajax.request({
                    url : '${ctx}/group/isCanDelete.action',
                    params : {ids: ids},
                    success : function(res, options) {
                         var data = Ext.decode(res.responseText);
                         if(data.success){
                        	 Ext:Ext.Msg.confirm(SystemConstant.alertTitle,'确认删除所选群组吗？',function(btn) {
                                 if (btn == 'yes') {
                                     Ext.MessageBox.wait("", "删除群组", {
                                         text:"请稍后..."
                                     });
                                     
                                     Ext.Ajax.request({
                                         url : '${ctx}/group/deleteGroup.action',
                                         params : {ids: ids},
                                         success : function(res, options) {
                                             Ext.getCmp("informationGrid").getSelectionModel().clearSelections();
                                             var result = Ext.decode(res.responseText);
                                             if(result.success){
                                                 Ext.MessageBox.hide();
                                                 new Ext.ux.TipsWindow({
                                                     title: SystemConstant.alertTitle,
                                                     autoHide: 3,
                                                     html:result.msg
                                                 }).show();
                                                 informationStore.load(function(){
                                                     informationGrid.getSelectionModel().selectRange(0,0);
                                                     var proxy1 = groupMemberStore.getProxy();
                                                     proxy1.setExtraParam("groupId",groupId);
                                                     groupMemberStore.loadPage(1);
                                                 });
                                             }else{
                                                 Ext.MessageBox.hide();
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
                         }else{
                            Ext.MessageBox.show({
                                title: SystemConstant.alertTitle,
                                msg: data.msg,
                                buttons: Ext.MessageBox.OK,
                                icon: Ext.MessageBox.INFO
                            });
                        }
                    }
                });
		    };
			
			
			Ext.define("GroupMember",{
				extend:"Ext.data.Model",
				fields:[
					{name: "id"},
					{name: "userId"},
					{name: "realname"},
					{name: "orgName"},
					{name: "erpId"},
					{name: "email"},
					{name: "orgCode"}
				]
			});		
		 	
			var groupMemberCloumns=[
					{header:"序号",xtype:"rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},
					{header: "用户ID",width: 70,dataIndex: "userId",hidden: true,menuDisabled: true,sortable :false},
					{header: "用户名",width: 100,dataIndex: "realname",menuDisabled: true,sortable :false,
						renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                        cellmeta.tdAttr = 'data-qtip="' + value + '"';
	                        return value;
	                    }
					},
					{header: "所在组织",width: 100,dataIndex: "orgName",menuDisabled: true,sortable :false,
						renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                        cellmeta.tdAttr = 'data-qtip="' + value + '"';
	                        return value;
	                    }
					},
					{header: "ERP",width: 100,dataIndex: "erpId",menuDisabled: true,sortable :false,
						renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                        cellmeta.tdAttr = 'data-qtip="' + value + '"';
	                        return value;
	                    }
					},
					{header: "邮箱",width: 100,dataIndex: "email",menuDisabled: true,sortable :false,
						renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
	                        cellmeta.tdAttr = 'data-qtip="' + value + '"';
	                        return value;
	                    }
					}
		         ]; 
			
			var groupMemberStore=Ext.create("Ext.data.Store", {
		        pageSize: SystemConstant.commonSize,
		        model:"GroupMember",
				proxy: {
		            type:"ajax",
		            extraParams:{groupId:groupId},
		            actionMethods: {
	                	read: 'post'
	           		},
				    url: "${ctx}/group/getGroupMemberList.action",
				    reader: {
					     totalProperty: "totalSize",
					     root: "list"
				    },
		        simpleSortMode :true
		        }
			});
			
			var groupMemberSm = Ext.create("Ext.selection.CheckboxModel",{
				showHeaderCheckbox :true,
				injectCheckbox:1,
		    	listeners: {
			      	selectionchange: function(){
			        	var c = groupMemberGrid.getSelectionModel().getSelection();
					 	if(c.length > 0){
							Ext.getCmp('delUserBtn').setDisabled(false);
					 	}else{
						 	Ext.getCmp('delUserBtn').setDisabled(true);
					 	} 
			      	}
				}
		    });
			
			var groupMemberGrid =  Ext.create("Ext.grid.Panel",{
				border:false,
				columnLines: true,
				layout:"fit",
				width: "100%",
				height: document.body.clientHeight,
				id: "groupMemberGrid",
				bbar:  Ext.create("Ext.PagingToolbar", {
					store: groupMemberStore,
					displayInfo: true,
					displayMsg: SystemConstant.displayMsg,
					emptyMsg: SystemConstant.emptyMsg
				}),
				columns:groupMemberCloumns,
		        selModel:groupMemberSm,
		     	forceFit : true,
				store: groupMemberStore,
				autoScroll: true,
				stripeRows: true,
				tbar: ['用户名',
				{
					id: 'userName',
					stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
 					labelWidth: 70,   
					xtype: 'textfield'
				},'&nbsp;',{
					xtype:'button',
					disabled:false,
					text:'查询',
					iconCls:'search-button',
					handler:function(){
						var proxy = groupMemberStore.getProxy();
						proxy.setExtraParam("realname",Ext.getCmp("userName").getValue());
						proxy.setExtraParam("groupId",groupId);
						groupMemberStore.loadPage(1);
					}
				},'->',
				{
					id:'addUserBtn',
					xtype:'button',
					disabled:false,
					text:'添加',
					iconCls:'add-button',
					handler:function(){
						addUser(groupId);
					}
				},
				{
					id:'delUserBtn',
					xtype:'button',
					text:'删除',
					disabled:true,
					iconCls:'delete-button',
					handler:function(){
						var rows = informationGrid.getSelectionModel().getSelection();
						if(rows.length > 1){
							Ext.MessageBox.show({
								title:'提示信息',
								msg:'请选择群组成员！',
								buttons: Ext.Msg.YES,
								modal : true,
								icon: Ext.Msg.INFO
	  						});
							return;
						}
						delUser(groupId);
					}
				}]
			});		
			
			function addUser(groupId){
				var treeStore = Ext.create("Ext.data.TreeStore", {
			        proxy: {
			            type: "ajax",
			            actionMethods: {
			                read: 'POST'
			            },
			            url: "${ctx}/org/getOrgTreeList.action"
			        },
			        root: {
			        	text:"组织树形展示",
			        	nodeId:"0"
			        },
			        listeners: {
			            beforeload: function (ds, opration, opt) {
			                opration.params.parentId = opration.node.raw.nodeId;
			            }
			        }
			    });
				var treePanel=Ext.create("Ext.tree.Panel", {
			 		title:'组织信息',
			       	store: treeStore,
			     	id:"typeTree",
			        height: document.body.clientHeight,
			        width: 200,
			        useArrows: true,
			        rootVisible : false,
					region: "west",
					border: false,
					collapsible: true,
					split: true,
					collapseMode:"mini",
			        dockedItems: [{
			        	xtype: 'toolbar',
						style:"border-top:0px;border-left:0px",
						items:[{
					        iconCls: "icon-expand-all",
					        text:'展开',
							tooltip: "展开所有",
					        handler: function(){ treePanel.expandAll(); },
					        scope: this
					    },{
					        iconCls: "icon-collapse-all",
					        text:'折叠',
					        tooltip: "折叠所有",
					        handler: function(){ treePanel.collapseAll(); },
					        scope: this
					    }]
			        }]
			    });
				
				treeStore.on("load",function(store, node, record){
					if(node != null && node.raw.nodeId == "0" && node.firstChild){
						treePanel.getSelectionModel().select(node.firstChild,true);
						treePanel.fireEvent("itemclick",treePanel.getView(),node.firstChild);
					}
				});
				
				treePanel.on("itemclick",function(view,record,item,index,e,opts){  
				     //获取当前点击的节点  
				      //selectNode=record;
				      var treeNode=record.raw;  
				      var nodeId = treeNode.nodeId;
				      orgId = nodeId;
				      var proxy = userStore.getProxy();
				      proxy.setExtraParam("orgId",nodeId);
				      proxy.setExtraParam("groupId",groupId);
				      userStore.loadPage(1);
			 	}); 
					
				//建立用户Model
				Ext.define("userModel",{
					extend:"Ext.data.Model",
					fields:[
						{name:"id"},
						{name:"orgName"},
						{name:"username"},
						{name:"realname"},
						{name:"orgId"}
					 ]
				});
				
				//行选择模型
				var userSm = Ext.create("Ext.selection.CheckboxModel",{
					injectCheckbox:1,
				    listeners: {
					    selectionchange: function(){
					    	var c = userPanel.getSelectionModel().getSelection();
					    	if(c.length > 0){
								Ext.getCmp('addUserInfo').setDisabled(false);
							}else{
								Ext.getCmp('addUserInfo').setDisabled(true);
						    }
					    }
					}
				 });	  
				    
			     var userCm=[
		              {xtype: "rownumberer",text:"序号",width:60,align:"center"},
		              {header: "ID",width: 70,align:'center',dataIndex: "id",hidden: true,menuDisabled: true,sortable:false},
		              {header: "姓名",width: 200,align:'center',dataIndex: "realname",width:90,menuDisabled: true,sortable:false},
		              {header: "组织",width: 200,align:'center',dataIndex: "orgName",width:90,menuDisabled: true,sortable:false},
		              {header: "组织id",width: 70,align:'center',dataIndex: "orgId",hidden: true,menuDisabled: true,sortable:false}
			     ];

				 var userStore = Ext.create('Ext.data.Store', {
						pageSize: SystemConstant.commonSize,
			        	model: 'userModel',
			        	autoLoad:false,
						proxy: {
							type: 'ajax',
							actionMethods: {
				                read: 'POST'
				            },
							url: "${ctx}/group/getUserList.action",
							reader:{
								type: 'json',
			 	      			root: 'list',
			 	      			totalProperty:"totalSize"
							}
						}
					});

				var userPanel = Ext.create(Ext.grid.Panel,{
					title:'用户信息',
			   		id: "userPanel",
					stripeRows: true,
					border:false,
					region: "center",
					forceFit:true,
					columnLines: true,
					autoScroll: true,
					store : userStore,
					selModel:userSm,
					columns:userCm,
					tbar:new Ext.Toolbar({
	    				items:[
			    				"姓名",
			    		    	new Ext.form.TextField({
			    		    		width:'135',
			    		    		stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
			    		    		id:'inputUserName'
			    		    	}),
			    		    	{
			    	    	    	text :   "查询", 
			    	    	    	iconCls: "search-button",
			    	    	    	handler:function(){
			    	    	    		var proxy = userStore.getProxy();
			    	    	    		proxy.setExtraParam("userName",Ext.getCmp('inputUserName').getValue());
			    	    	    		userStore.loadPage(1);
			    	    			}
			    	    	    }]
			    	   	   	}),
					bbar:new Ext.PagingToolbar({
						pageSize: SystemConstant.commonSize,
				        store: userStore,
				        displayInfo: true,
				        displayMsg: SystemConstant.displayMsg,
				        emptyMsg: SystemConstant.emptyMsg
				    })
				});
					
				var userWin = Ext.create(Ext.window.Window,{
					title:"选择用户",
					width:650,
					height:450,
					resizable:true,
					modal:true,
					closeAction:'destroy',
					layout:'border',
					items:[treePanel,userPanel],
					buttonAlign : 'center',
					buttons:[{
						text:'确定',
						id:'addUserInfo',
						disabled:true,
						handler:function(){
							Ext.MessageBox.wait("", "数据查询中", {
                                text:"请稍后..."
                            });
							
							var rows = userPanel.getSelectionModel().getSelection();
				    		var ids = '';
				    		for(var i = 0; i < rows.length; i++){
				    			if(i < rows.length-1){
				    				ids+=rows[i].get("id")+",";
				    			}else {
				    				ids+=rows[i].get("id");
				    			}
				    		}
				    		
				    		Ext.Ajax.request({
			                    url:"${ctx}/group/addGroupMemberUser.action",
			                    method:'post',
			                    params: {userIds:ids,orgId:orgId,groupId:groupId},
			                    success: function(res){
			                  	  var data = Ext.decode(res.responseText);
			                  	  if(data.success){
				                  	  new Ext.ux.TipsWindow({
				                  		  title: SystemConstant.alertTitle,
				                  		  autoHide: 3,
				                  		  html:data.msg
				                  	  }).show();
				                  	  groupMemberStore.loadPage(1);
			                  	  }else{
					                   Ext.MessageBox.show({
											title:'提示信息',
											msg:data.msg,
											buttons: Ext.Msg.YES,
											modal : true,
											icon: Ext.Msg.INFO
				  					   });
			                  	  }
			                  	  
			                  	   Ext.MessageBox.hide();
			                  	   userWin.close();
								},failure : function(res){
									var data = Ext.decode(res.responseText);
									Ext.MessageBox.show({
										title:'提示信息',
										msg:data.msg,
										buttons: Ext.Msg.YES,
										modal : true,
										icon: Ext.Msg.ERROR
			  					    });
									
									Ext.MessageBox.hide();
									userWin.close();
								}
				    		});
						}
					},
					{
				    	text: '取消',
		                handler: function(){
		                	userWin.close();
		                }
		            }]
				}).show();
			}
			
			delUser = function (groupId){
				if(groupId=="" || groupId==null){
					Ext.MessageBox.show({
						title:'提示信息',
						msg:'请先选择群组！',
						buttons: Ext.Msg.YES,
						modal : true,
						icon: Ext.Msg.INFO
					});
					return;
				}
				var rows = groupMemberGrid.getSelectionModel().getSelection();
				var userIds = '';
				for(var i = 0; i < rows.length; i++){
	    			if(i < rows.length-1){
	    				userIds+=rows[i].get("userId")+",";
	    			}else {
	    				userIds+=rows[i].get("userId");
	    			}
	    		}
	    		
    			Ext.Msg.confirm('系统提示','你确定要删除这'+rows.length+'条数据',function(btn){
    				if(btn=='yes'){
    					Ext.Ajax.request({
    						url:'${ctx}/group/deleteGroupMemberUser.action',
    						method:'post',
                            params: {groupId:groupId,userIds:userIds},
    						success:function(res){
    							var data = Ext.decode(res.responseText);
    							if(data.success){
    								new Ext.ux.TipsWindow({
                                           title: SystemConstant.alertTitle,
                                           autoHide: 3,
                                           html:data.msg
                                       }).show();
    								
    								groupMemberStore.loadPage(1);
    							}
    							else {
    								Ext.MessageBox.show({
                                        title:'提示信息',
                                        msg:data.msg,
                                        buttons: Ext.Msg.YES,
                                        modal : true,
                                        icon: Ext.Msg.ERROR
                                    });
    							}
    						},
    						failure: function(){
    							var data = Ext.decode(res.responseText);
    							Ext.MessageBox.show({
									title:'提示信息',
									msg:data.msg,
									buttons: Ext.Msg.YES,
									modal : true,
									icon: Ext.Msg.ERROR
		    					});
                            }
    					});
    				}
    			});
			};			
			
			//组织树Model
			Ext.define('treeModel', {
    			extend: 'Ext.data.Model',
    			fields: [
             		{name: 'nodeId'},
             		{name: 'parentId'},
             		{name: 'id',mapping:'nodeId'},
            		{name: 'text'},
            		{name: 'leaf'},
            		{name: 'checked'}
            		]
   			});
			
			var orgTreeStore = Ext.create('Ext.data.TreeStore', {
			    model: 'treeModel',
			    nodeParam:'parentId',
			    autoLoad:false,
			    border:false,
			    clearOnLoad :true,
			    proxy: {
			        type: 'ajax',
			        params:{groupId:groupId},
			        reader:{
			                 type: 'json'
			              },
			         folderSort: true,
			         sorters: [{
			                    property: 'nodeId',
			                    direction: 'DESC'
			         }],
			        url :'${ctx}/group/getOrgForTree.action'
			    },
			    root: {
			          expanded: true,
			          id:"0"
					}
			    });
		    
				var orgTreePanel = Ext.create(Ext.tree.Panel,{
					title:'组织信息',
	          		id : 'orgTreePanel',
	          		width:'100%',
	          		height:'100%',
					layout:'fit',
					region: "east",
					border:false,
            		split: true,
					autoScroll: true,
					rootVisible: false,
					store: orgTreeStore,
					listeners:{
						'checkchange':	function(node,checked,eOpts){
							if(checked == true){
								var orgIds=node.data.id;
								Ext.Ajax.request({
									url : '${ctx}/group/addGroupMemberDept.action',
									params : {orgIds:orgIds,groupId:groupId},
									success : function(res){
										var result = Ext.decode(res.responseText);
										if(result.success){
											var data = Ext.decode(res.responseText);
											new Ext.ux.TipsWindow(
													{
														title: SystemConstant.alertTitle,
														autoHide: 3,
														html:data.msg
													}
											).show();
										}else{
											var data = Ext.decode(res.responseText);
											Ext.MessageBox.show({
												title: SystemConstant.alertTitle,
												msg: data.msg,
												buttons: Ext.MessageBox.OK,
												icon: Ext.MessageBox.INFO
											});
										}
									}
								});
							}else{
								var orgIds=node.data.id;
								Ext.Ajax.request({
									url : '${ctx}/group/deleteGroupMemberDept.action',
									params : {orgIds:orgIds,groupId:groupId},
									success : function(res){
										var result = Ext.decode(res.responseText);
										if(result.success){
											var data = Ext.decode(res.responseText);
											new Ext.ux.TipsWindow(
													{
														title: SystemConstant.alertTitle,
														autoHide: 3,
														html:data.msg
													}
											).show();
										}else{
											var data = Ext.decode(res.responseText);
											Ext.MessageBox.show({
												title: SystemConstant.alertTitle,
												msg: data.msg,
												buttons: Ext.MessageBox.OK,
												icon: Ext.MessageBox.INFO
											});
										}
									}
								});
							}
							
						}
			        }
				});

			var tabPanel = Ext.create('Ext.tab.Panel', {
			    layout:'fit',
				region: 'center',
				listeners:{
					tabchange:function(tabPanel, newCard, oldCard){
						if(newCard.title == "组织"){
			        		var proxy = orgTreeStore.getProxy();
						   	proxy.setExtraParam("groupId",groupId);
						   	orgTreeStore.load();
						}
					},
					'afterrender':function(){
						informationStore.on("load",function(){
							if(informationStore.getCount() > 0){
								Ext.getCmp('orgTreePanel').setDisabled(false);
								Ext.getCmp('addUserBtn').setDisabled(false);
								Ext.getCmp('delGroupBtn').setDisabled(false);
								Ext.getCmp('updateGroupBtn').setDisabled(false);
							}else{
								Ext.getCmp('orgTreePanel').setDisabled(true);
								Ext.getCmp('addUserBtn').setDisabled(true);
								Ext.getCmp('delGroupBtn').setDisabled(true);
								Ext.getCmp('updateGroupBtn').setDisabled(true);
							}
						});
					}
				},
			    items: [{
			        title: '用户',
			        layout:'fit',
			        items:[groupMemberGrid]
			    }, {
			        title: '组织',
			        layout:'fit',
			        items:[orgTreePanel]
			    }],
			    tabBar : { 
			    	height : 25,  
			    	defaults : {  
			    		height : 25  
			    	}  
			    }
			});
			
			 Ext.create("Ext.container.Viewport", {
				layout: "border",
				border: true,
				renderTo: Ext.getBody(),
				items: [informationGrid,tabPanel]
			});
		});
	</script>
</body>
</html>