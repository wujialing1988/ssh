<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>角色授权</title>
<script type="text/javascript" src="${ctx}/scripts/role/userAndGroupSelect.js"></script>
<link href="" rel="SHORTCUT ICON" />
<style type="text/css">
  .x-form-layout-table{
	table-layout: fixed;
  }
</style>
</head>
<body>
<script type="text/javascript">
		var selectNode=null;
		var checkerHd=false;
		var isExist;
		var roleId;
		Ext.onReady(function() {
			Ext.QuickTips.init();
			//自动引入其他需要的js
			Ext.require([
				"Ext.container.*",
			   "Ext.grid.*", 
			   "Ext.toolbar.Paging", 
			   "Ext.form.*",
				 "Ext.data.*" 
			]);
			//建立Model模型对象
			Ext.define("roleModel",{
				extend:"Ext.data.Model",
				fields:[
					{name: "roleId",type:"int"}, 
					{name: "roleName"},
					{name: "roleCode"},
					{name: "description"}
					]
			});
			//组织树Model
			Ext.define('treeModel', {
    			extend: 'Ext.data.Model',
    			fields: [
             		{name: 'nodeId',type: 'string'}, 
             		{name: 'parentId',type: 'string'}, 
             		{name: 'id',type: 'string',mapping:'nodeId'},
            		{name: 'text',type: 'string'} 
            		]
   			});
			//建立用户Model
   			Ext.define("userModel",{
			extend:"Ext.data.Model",
			fields:[
				{name:"userId",mapping:"userId"},
				{name:"roleMemberId"},
				{name:"orgName"},
				{name:"username"},
				{name:"password"},
				{name:"realname"},
				{name:"gender"},
				{name:"mobileNo"},
				{name:"phoneNo"},
				{name:"shortNo"},
				{name:"idCard"},
				{name:"birthPlace"},
				{name:"erpId"},
				{name:"orgId"},
				{name:"status"},
				{name:"disOrder"},
				{name:"enable"},
				{name:"typeText"},
				{name:"typeValue"},
				{name: "postText"},
				{name: "postValue"},
				{name: "postTitleText"},
				{name: "postTitleValue"},
				{name: "jobText"},
				{name: "jobValue"},
				{name: "jobLevelText"},
				{name: "jobLevelValue"},
				{name: "teamText"},
				{name: "teamValue"},
				{name: "email"},
				{name: "isDeletable"},
				{name: "birthDay"},
				{name: "flag"}
			]
		});
   		//建立群组Model模型对象
		Ext.define("groupModel",{
			extend:"Ext.data.Model",
			fields:[
				{name: "groupId",mapping:"id"}, 
				{name: "roleMemberId"},
				{name: "groupName"},
				{name: "creteDate"},
				{name: "remark"}
				]
		});
	
			//建立数据Store
			roleStore=Ext.create("Ext.data.Store", {
		        pageSize: SystemConstant.commonSize,
		        model:"roleModel",
		        remoteSort:true,
				proxy: {
		            type:"ajax",
		            actionMethods: {
		                read: 'POST'
		            },
				    url: "${ctx}/role/getRoleList.action",
				    reader: {
					     totalProperty: "totalSize",
					     root: "list"
				    },
		        simpleSortMode :true
		        },
		        sorters:[{
		            property:"id",
		            direction:"ASC"
		        }]
			});
			
			//行选择模型
			var roleSm=Ext.create("Ext.selection.CheckboxModel",{
				injectCheckbox:1,
				mode:"SINGLE",
		    	listeners: {
			        selectionchange: function(){
			        	var ck = roleGrid.getSelectionModel().getSelection();
			        	if(ck.length == 1){
			        		Ext.getCmp('userPanel').setDisabled(false);
                            Ext.getCmp('groupPanel').setDisabled(false);
			        		
			        		roleId = ck[0].data.id;
			        		var proxy = userRoleStore.getProxy();
				   		    proxy.setExtraParam("roleId",roleId);
				   		    userRoleStore.loadPage(1);
				   		 	var proxyGroup = groupStore.getProxy();
				   		 	proxyGroup.setExtraParam("roleId",roleId);
				   			groupStore.loadPage(1);
					 	}else{
					 		Ext.getCmp('userPanel').setDisabled(true);
                            Ext.getCmp('groupPanel').setDisabled(true);
					 	}
			        }
				}
		    });
			var cm=[
					{xtype: "rownumberer",text:'序号',width:60,align:"center"},
		            {header: "roleId",width: 70,dataIndex: "id",hidden: true},
		            {header: "角色名称",width: 200,dataIndex: "roleName",menuDisabled: true,sortable :false,
		            	renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
                            cellmeta.tdAttr = 'data-qtip="' + value + '"';
                            return value;
                        }
		            },
		            {header: "角色编码",width: 200,dataIndex: "roleCode",menuDisabled: true,sortable :false,
		            	renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
                            cellmeta.tdAttr = 'data-qtip="' + value + '"';
                            return value;
                        }
		            }
		           ];
			
			//grid组件
			var roleGrid =  Ext.create("Ext.grid.Panel",{
				title:'角色列表',
				id:'roleGrid',
				columnLines: true,
				width:300,
				region: "west",
				layout:"fit",
				height: document.body.clientHeight,
				bbar:  Ext.create("Ext.PagingToolbar", {
					store: roleStore,
					displayInfo: false,
					displayMsg: SystemConstant.displayMsg,
					emptyMsg: SystemConstant.emptyMsg
				}),
		    	selModel:roleSm,
		    	forceFit : true,
				store: roleStore,
				autoScroll: true,
				stripeRows: true,
				columns:cm,
				tbar: [
							"角色名称",
							{	
    						xtype:'textfield',
    		    			id:'inputRoleName'
    		    		
    		    	},
    		    	{
    	    	    	text :   "查询", 
    	    	    	iconCls: "search-button", 
    	    	    	handler:function(){
    	    	    		roleStore.getProxy().setExtraParam("roleName",Ext.getCmp('inputRoleName').getValue());
    	    	    		roleStore.loadPage(1);
    	    			} 
    	    	  }
				]
			});
			roleStore.on("load",function(rs, records){
                if(records.length > 0){
                	var rgSelModel = roleGrid.getSelectionModel();
                	rgSelModel.selectRange(0,0);
                    var rows = rgSelModel.getSelection();
                    roleId = rows[0].get('id');
                }
            });
			roleStore.loadPage(1);
			 
var roleMemberIds;
	//右侧组织树store
	var orgTreeStore = Ext.create('Ext.data.TreeStore', {
	    model: 'treeModel',
	    nodeParam:'parentId',
	    autoLoad:false,
	    border:false,
	    clearOnLoad :true,
	    proxy: {
	        type: 'ajax',
	        extraParams:{roleMemberIds:roleMemberIds},
	        reader:{
	                 type: 'json'
	              },
	         folderSort: true,
	         sorters: [{
	                    property: 'nodeId',
	                    direction: 'DESC'
	         }],
	        url :'${ctx}/role/getRoleOrgForTree.action'
	    },
	    root: {
	          expanded: true,
	          id:"0"
	          }
	    });
    
		//右侧组织树panel
		var orgTreePanelright = Ext.create(Ext.tree.Panel,{
	          		id : 'orgTreePanelright',
	          		width:200,
					layout:'fit',
					//region: "east",
					border:false,
            		split: true,
            		hidden: false,
					autoScroll: true,
					rootVisible: false,
					store: orgTreeStore,
					listeners:{
			        	'checkchange':	function(node,checked,eOpts){
			        		Ext.MessageBox.wait("", "数据范围修改", 
		                        {
		                            text:"请稍后..."
		                        }
		                    );
			        		
			        		var checkedResIds = node.data.id;
							if(checked == true){
								Ext.Ajax.request({
									url : basePath + '/role/addDataScopeOfOrg.action',
									params : {roleMemeberIds: roleMemberIds,orgIds: checkedResIds},
									success : function(res, options) {
										Ext.MessageBox.hide();
										
										var data = Ext.decode(res.responseText);
										if(data.success){
											new Ext.ux.TipsWindow(
													{
														title : SystemConstant.alertTitle,
														autoHide : 3,
														html : data.msg
													}).show();
										}else{
										 	Ext.MessageBox.show({
												title: SystemConstant.alertTitle,
												msg: data.msg,
												buttons: Ext.MessageBox.OK,
												icon: Ext.MessageBox.INFO
											});
										 	return false;
										}
									}
								});
							}else{
								Ext.Ajax.request({
									url : basePath + '/role/deleteDataScopeOfOrg.action',
									params : {roleMemeberIds: roleMemberIds,orgIds: checkedResIds},
									success : function(res, options) {
										Ext.MessageBox.hide();
										
										var data = Ext.decode(res.responseText);
										if(data.success){
											new Ext.ux.TipsWindow(
													{
														title : SystemConstant.alertTitle,
														autoHide : 3,
														html : data.msg
													}).show();
										}else{
										 	Ext.MessageBox.show({
												title: SystemConstant.alertTitle,
												msg: data.msg,
												buttons: Ext.MessageBox.OK,
												icon: Ext.MessageBox.INFO
											});
										 	return false;
										}
									}
								});
							}
	 					}
			        },
					tbar:new Ext.Toolbar({
						style:"border-top:0px;border-left:0px",
						items:[
						{
				            iconCls: "icon-expand-all",
				            text:"展开",
							tooltip: "展开所有",
				            handler: function(){ orgTreePanelright.getRootNode().expand(true); }
				          
				        },{
				            iconCls: "icon-collapse-all",
				            text:"折叠",
				            tooltip: "折叠所有",
				            handler: function(){ orgTreePanelright.collapseAll(); },
				            scope: this
				        }/* ,{
					    	xtype:'button',
							text:"刷新",
							iconCls:"x-btn-text x-tbar-loading",
							handler:function(){
								Ext.MessageBox.wait("", "", 
										{
											text:"请稍后..."
										}
									);
								orgTreePanelright.getStore().load();
								Ext.MessageBox.hide();
							},
							scope: this
			       	   	} */]
			        })
		});

 	//行选择模型
	var userSm=Ext.create("Ext.selection.CheckboxModel",{
			injectCheckbox:1,
	    	listeners: {
		      selectionchange: function(){
		        	var ck = userPanel.getSelectionModel().getSelection();
					 	if(ck.length > 0){
					 		var itemsArray = new Array();
							for(var i=0;i<ck.length;i++){
								itemsArray.push(ck[i].data.roleMemberId);
							}
	        				roleMemberIds = itemsArray.join();
							Ext.getCmp('delUserBtn').setDisabled(false);
					 	}else{
						 	Ext.getCmp('delUserBtn').setDisabled(true);
					 	}
					 	if(ck.length == 1){
					 		var proxy = orgTreeStore.getProxy();
						   	proxy.setExtraParam("roleMemberIds",roleMemberIds);
						    orgTreeStore.load(); 
						    
						    var proxy2 = scopeUserRoleStore.getProxy();
						    proxy2.setExtraParam("roleMemberIds",roleMemberIds);
						    scopeUserRoleStore.load(); 
						    Ext.getCmp('scopeTab').setVisible(true);
					 	}else{
					 		Ext.getCmp('scopeTab').setVisible(false);
					 	}
		      }
			}
	    });
    
  	var userCm=[
				{xtype: "rownumberer",text:"序号",width:60,align:"center"},
            	{header: "ID",width: 70,align:'center',dataIndex: "userId",hidden: true,menuDisabled: true,sortable:false},
            	{header:"RoleMemberId",width: 70,align:'center',dataIndex: "roleMemberId",hidden: true,menuDisabled: true,sortable:false},
            	{header: "姓名",width: 200,align:'center',dataIndex: "realname",width:90,menuDisabled: true,sortable:false},
            	{header: "部门",width: 200,align:'center',dataIndex: "orgName",width:90,menuDisabled: true,sortable:false}
            	
            ];
  	
  	//建立store
  	userRoleStore = Ext.create('Ext.data.Store', {
		pageSize: SystemConstant.commonSize,
      	model: 'userModel',
      	autoLoad:true,
      	remoteSort:true,
		proxy: {
			type: 'ajax',
			extraParams:{roleId:roleId},
			actionMethods: {
                read: 'POST'
            },
			url: '${ctx}/role/getRoleMemberOfUser.action',
			reader:{
				type: 'json',
	      			root: 'list',
	      			totalProperty:"totalSize"
			},
			simpleSortMode :true,
			autoLoad: true 
		},
		sorters:[{
            property:"id",
            direction:"ASC"
        }]
	});

	var userPanel = Ext.create(Ext.grid.Panel,{
	    	   		id: "userPanel",
	    			stripeRows: true,
	    			border:false,
	    			columnLines : false,
	    			forceFit:true,
	    			columnLines: true,
	    			autoScroll: true,
	    			store : userRoleStore,
	    			selModel:userSm,
	    			columns:userCm,
	    			bbar:new Ext.PagingToolbar({
	    				pageSize: SystemConstant.commonSize,
	    		        store: userRoleStore,
	    		        displayInfo: true,
	    		        displayMsg: SystemConstant.displayMsg,
	    		        emptyMsg: SystemConstant.emptyMsg
	    		    }),
	    		    tbar: [
							"姓名",
							{
   						xtype:'textfield',
   		    			id:'realname'
	   		    	},
	   		    	{
	   	    	    	text :   "查询", 
	   	    	    	iconCls: "search-button", 
	   	    	    	handler:function(){
	   	    	    		userRoleStore.getProxy().setExtraParam("realname",Ext.getCmp('realname').getValue());
	   	    	    		userRoleStore.loadPage(1);
	   	    			} 
	   	    	 	 },'->',
 	    	 		 {
	   	    	 		id:'addUserBtn',
						disabled:false,
						xtype:'button',
						text:'添加',
						iconCls:'add-button',
						handler:function(){
							createAddUserInfo(roleId);
						}
					},
					{
						id:'delUserBtn',
						xtype:'button',
						text:'删除',
						disabled:true,
						iconCls:'delete-button',
						handler:function(){
							var ck = Ext.getCmp('userPanel').getSelectionModel().getSelection();
							var itemsArray = new Array();
							for(var i=0;i<ck.length;i++){
								itemsArray.push(ck[i].data.id);
							}
							var idss = itemsArray.toString();
							Ext.Msg.confirm(SystemConstant.alertTitle,"确认删除所选角色成员（用户）数据吗？",function(btn) {
								if (btn == 'yes') {
									Ext.Ajax.request({
										url : '${ctx}/role/deleteRoleMemberOfUser.action',
										params : {ids: idss,roleId: roleId,roleMemberIds: roleMemberIds},
										success : function(res, options) {
											var result = Ext.decode(res.responseText);
											if(result.success){
												new Ext.ux.TipsWindow(
														{
															title: SystemConstant.alertTitle,
															autoHide: 3,
															html:result.msg
														}
												).show();
												userRoleStore.loadPage(1);
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
					}
	    			]
		            
	    		}); 
	
	
	
	//****************************群组tab*************************************//
	//行选择模型
	var groupSm=Ext.create("Ext.selection.CheckboxModel",{
			injectCheckbox:1,
	    	listeners: {
		      selectionchange: function(){
		        	var ck = groupPanel.getSelectionModel().getSelection();
				 	if(ck.length > 0){
			        	var itemsArray = new Array();
						for(var i=0;i<ck.length;i++){
							itemsArray.push(ck[i].data.roleMemberId);
						}
        				roleMemberIds = itemsArray.join();
						Ext.getCmp('delGroupBtn').setDisabled(false);
				 	}else{
					 	Ext.getCmp('delGroupBtn').setDisabled(true);
				 	}
				 	/* if(ck.length == 1){
				 		var proxy = orgTreeStore.getProxy();
					   	proxy.setExtraParam("roleMemberIds",roleMemberIds);
					    orgTreeStore.load(); 
					    
					    var proxy2 = scopeUserRoleStore.getProxy();
					    proxy2.setExtraParam("roleMemberIds",roleMemberIds);
					    scopeUserRoleStore.load(); 
					    Ext.getCmp('scopeTab').setVisible(true);
					    
					    Ext.getCmp('scopeTab').setVisible(true);
				 	}else{
				 		Ext.getCmp('scopeTab').setVisible(false);
				 	} */
		      }
			}
	    });
	
	var groupCm=[
				{xtype: "rownumberer",text:"序号",width:60,align:"center"},
            	{header: "ID",width: 70,align:'center',dataIndex: "id",hidden: true,menuDisabled: true,sortable:false},
            	{header:"RoleMemberId",width: 70,align:'center',dataIndex: "roleMemberId",hidden: true,menuDisabled: true,sortable:false},
            	{header: "名称",width: 200,align:'center',dataIndex: "groupName",width:90,menuDisabled: true,sortable:false},
            	{header: "描述",width: 200,align:'center',dataIndex: "remark",width:90,menuDisabled: true,sortable:false}
            ];
	
	//建立groupStore
  	groupStore = Ext.create('Ext.data.Store', {
		pageSize: SystemConstant.commonSize,
      	model: 'groupModel',
      	autoLoad:true,
      	remoteSort:true,
		proxy: {
			type: 'ajax',
			extraParams:{roleId:roleId},
			actionMethods: {
                read: 'POST'
            },
			url: '${ctx}/role/getRoleMemberOfGroup.action',
			reader:{
				type: 'json',
	      			root: 'list',
	      			totalProperty:"totalSize"
			},
			simpleSortMode :true,
			autoLoad: true 
		},
		sorters:[{
            property:"id",
            direction:"ASC"
        }]
	});
	
  	var groupPanel = Ext.create(Ext.grid.Panel,{    
   		id: "groupPanel",
		stripeRows: true,
		border:false,
		layout:'fit',
		columnLines : false,
		forceFit:true,
		columnLines: true,
		autoScroll: true,
		store : groupStore,
		selModel:groupSm,
		columns:groupCm,
		bbar:new Ext.PagingToolbar({
			pageSize: SystemConstant.commonSize,
	        store: groupStore,
	        displayInfo: true,
	        displayMsg: SystemConstant.displayMsg,
	        emptyMsg: SystemConstant.emptyMsg
	    }),
	    tbar: [
				"名称",
				{	
				xtype:'textfield',
   				id:'name'
	    	},
	    	{
   	    	text :   "查询", 
   	    	iconCls: "search-button", 
   	    	handler:function(){
   	    		groupStore.getProxy().setExtraParam("groupName",Ext.getCmp('name').getValue());
   	    		groupStore.loadPage(1);
   			} 
   	 	 },'->',
	 	 {
   	 		id:'addGroupBtn',
			disabled:false,
			xtype:'button',
			text:'添加',
			iconCls:'add-button',
			handler:function(){
				creatAddGroupInfo(roleId);
				
			}
		},
		{
			id:'delGroupBtn',
			xtype:'button',
			text:'删除',
			disabled:true,
			iconCls:'delete-button',
			handler:function(){
				var ck = Ext.getCmp('groupPanel').getSelectionModel().getSelection();
				var itemsArray = new Array();
				for(var i=0;i<ck.length;i++){
					itemsArray.push(ck[i].data.id);
				}
				var idss = itemsArray.toString();
				Ext.Msg.confirm(SystemConstant.alertTitle,"确认删除所选角色成员（群组）数据吗？",function(btn) {
					if (btn == 'yes') {
						Ext.Ajax.request({
							url : '${ctx}/role/deleteRoleMemberOfGroup.action',
							params : {ids: idss,roleId: roleId,roleMemberIds: roleMemberIds},
							success : function(res, options) {
								var result = Ext.decode(res.responseText);
								if(result.success){
									new Ext.ux.TipsWindow({
										title: SystemConstant.alertTitle,
										autoHide: 3,
										html:result.msg
									}).show();
									//groupStore.loadPage(1);
								}else{
									Ext.MessageBox.show({
										title: SystemConstant.alertTitle,
										msg: result.msg,
										buttons: Ext.MessageBox.OK,
										icon: Ext.MessageBox.INFO
									});
								}
								groupStore.loadPage(1);
							}
						});
					}
				});
			}
		}
		]
	}); 
  	
  //****************************群组tab*************************************//
  
	var panelTab = Ext.create('Ext.tab.Panel', {
		title:'角色成员',
	    layout:'fit',
		region: 'center',
	    activeTab: 0,
	    bodyPadding: 0,
	    tabPosition: 'top',
	    listeners:{
	    	'tabchange':function(tabPanel, newCard, oldCard, eOpts){
	    		var tabId = newCard.id;
	    		if(tabId == 'user'){
	    			userPanel.getSelectionModel().deselectAll();
	    			userRoleStore.loadPage(1); 
	    		}else {
	    			groupPanel.getSelectionModel().deselectAll();
	    			groupStore.loadPage(1);
	    			Ext.getCmp('scopeTab').setVisible(false);
	    		}
	    	}
	    },
	    items: [
	        {
	        	id:'user',
	        	title:'用户',
	        	layout:'fit',
	            items:[
	            	userPanel
	            ]
	        },
	        {
	        	id:'group',
	            title: '群组',
	            layout:'fit',
	            items:[
					groupPanel	
		        ]
	        }
	    ],
	    tabBar : { 
	    	height : 25,  
	    	defaults : {  
	    		height : 25  
	    	}  
	    }
	});
	
	//右侧范围TAB ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~START
	var scopeUserRoleStore = Ext.create('Ext.data.Store', {
		pageSize: SystemConstant.commonSize,
      	model: 'userModel',
      	remoteSort:true,
		proxy: {
			type: 'ajax',
			extraParams:{roleId:roleId},
			actionMethods: {
                read: 'POST'
            },
			url: '${ctx}/role/getDataScopeOfUserByPage.action',
			reader:{
				type: 'json',
	      			root: 'list',
	      			totalProperty:"totalSize"
			},
			simpleSortMode :true,
			autoLoad: true 
		},
		sorters:[{
            property:"id",
            direction:"ASC"
        }]
	});
	var scopeUserPanel = Ext.create(Ext.grid.Panel,{
	    	   		id: "scopeUserPanel",
	    			stripeRows: true,
	    			border:false,
	    			columnLines : false,
	    			forceFit:true,
	    			columnLines: true,
	    			autoScroll: true,
	    			store : scopeUserRoleStore,
	    			selModel:Ext.create("Ext.selection.CheckboxModel",{
	    				injectCheckbox:1,
	    		    	listeners: {
	    			      selectionchange: function(){
	    			        	var ck = scopeUserPanel.getSelectionModel().getSelection();
	    						 	if(ck.length > 0){
	    								Ext.getCmp('delScopeUserBtn').setDisabled(false);
	    						 	}else{
	    							 	Ext.getCmp('delScopeUserBtn').setDisabled(true);
	    						 	}
	    			      }
	    				}
	    		    }),
	    			columns:[
	    						{xtype: "rownumberer",text:"序号",width:60,align:"center"},
	    		            	{header: "ID",width: 70,align:'center',dataIndex: "userId",hidden: true,menuDisabled: true,sortable:false},
	    		            	{header:"RoleMemberId",width: 70,align:'center',dataIndex: "roleMemberId",hidden: true,menuDisabled: true,sortable:false},
	    		            	{header: "姓名",width: 200,align:'center',dataIndex: "realname",width:90,menuDisabled: true,sortable:false},
	    		            	{header: "部门",width: 200,align:'center',dataIndex: "orgName",width:90,menuDisabled: true,sortable:false}
	    		            ],
	    			bbar:new Ext.PagingToolbar({
	    				pageSize: SystemConstant.commonSize,
	    		        store: scopeUserRoleStore,
	    		        displayInfo: true,
	    		        displayMsg: SystemConstant.displayMsg,
	    		        emptyMsg: SystemConstant.emptyMsg
	    		    }),
	    		    tbar: [
							"姓名",
							{	
   						xtype:'textfield',
   		    			id:'scoperealname'
	   		    	},
	   		    	{
	   	    	    	text :   "查询", 
	   	    	    	iconCls: "search-button", 
	   	    	    	handler:function(){
	   	    	    		scopeUserRoleStore.getProxy().setExtraParam("realname",Ext.getCmp('scoperealname').getValue());
	   	    	    		scopeUserRoleStore.loadPage(1);
	   	    			} 
	   	    	 	 },'->',
 	    	 		 {
	   	    	 		id:'addScopeUserBtn',
						disabled:false,
						xtype:'button',
						text:'添加',
						iconCls:'add-button',
						handler:function(){
							createAddUserInfo(roleMemberIds,'scope');
						}
					},
					{
						id:'delScopeUserBtn',
						xtype:'button',
						text:'删除',
						disabled:true,
						iconCls:'delete-button',
						handler:function(){
							var ck = Ext.getCmp('scopeUserPanel').getSelectionModel().getSelection();
							var itemsArray = new Array();
							for(var i=0;i<ck.length;i++){
								itemsArray.push(ck[i].data.id);
							}
							var idss = itemsArray.toString();
							Ext.Msg.confirm(SystemConstant.alertTitle,"确认删除所选数据范围（用户）吗？",function(btn) {
								if (btn == 'yes') {
							Ext.Ajax.request({
								url : basePath + '/role/deleteDataScopeOfUser.action',
								params : {roleMemeberIds: roleMemberIds,userIds: idss},
								success : function(res, options) {
									var data = Ext.decode(res.responseText);
									if(data.success){
										new Ext.ux.TipsWindow(
												{
													title : SystemConstant.alertTitle,
													autoHide : 3,
													html : data.msg
												}).show();
										scopeUserRoleStore.loadPage(1);
									}else{
									 	Ext.MessageBox.show({
											title: SystemConstant.alertTitle,
											msg: data.msg,
											buttons: Ext.MessageBox.OK,
											icon: Ext.MessageBox.INFO
										});
									 	return false;
									}
								}
							});
								}});
						}
					}
	    			]
	    		}); 
	
	var scopeTab = Ext.create('Ext.tab.Panel', {
		id:"scopeTab",
		title:'数据范围',
	    layout:'fit',
		region: "east",
		hidden:true,
		width:300,
	    activeTab: 0,
	    bodyPadding: 0,
	    tabPosition: 'top',
	    items: [{
				id:'scopeOrg',
			    title: '部门',
			    layout:'fit',
			    items:[orgTreePanelright]
			},{
	        	id:'scopeUser',
	        	title:'用户',
	        	layout:'fit',
	            items:[scopeUserPanel]
	        }
	    ],
	    tabBar : { 
	    	height : 25,  
	    	defaults : {  
	    		height : 25  
	    	}  
	    }
	});
	//右侧范围TAB ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~END
	
	Ext.create("Ext.container.Viewport", {
		layout: "border",
		renderTo: Ext.getBody(),
		items: [ 
			roleGrid,scopeTab,panelTab
		]
	});
}); 

</script>
</body>
</html>