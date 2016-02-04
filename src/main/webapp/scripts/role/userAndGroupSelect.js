var basePath=(function(){
	var href=window.location.href;
	var host=window.location.host;
	var index = href.indexOf(host)+host.length+1; //host结束位置的索引（包含/）
	return href.substring(0,href.indexOf('/',index));
})(window);	

	function createAddUserInfo(roleId,type){
		//左侧组织树store
		var orgTreeStore1 = Ext.create('Ext.data.TreeStore', {
			  proxy: {
		            type: "ajax",
		            actionMethods: {
		                read: 'POST'
		            },
		            url: basePath +"/org/getOrgTreeList.action"
		        },
		        root: {
		        	text:"组织树形展示",
		        	nodeId:"0"
		        },
		        listeners: {
		            beforeload: function (ds, opration, opt) {
		            	if(opration.node.raw.nodeId!=0){
		            		opration.params.parentId = opration.node.raw.nodeId;
		            	}
		                
		            }
		        }

		    });
		    
		//左侧组织树panel
		orgTreePanelleft = Ext.create(Ext.tree.Panel,{
			title:'组织信息',
	       	store: orgTreeStore1,
	     	id:"orgTreePanelleft",
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
			        handler: function(){ orgTreePanelleft.expandAll(); },
			        scope: this
			    },{
			        iconCls: "icon-collapse-all",
			        text:'折叠',
			        tooltip: "折叠所有",
			        handler: function(){ orgTreePanelleft.collapseAll(); },
			        scope: this
			    }]
	        }],
	        listeners:{
	        	"afterrender":function( treePanel, eOpts ){
	        		var path = treePanel.getRootNode().getPath();
	        		treePanel.expandPath(path);
	        	}
	        }

		});
		
		orgTreeStore1.on("load",function(store, node, record){
			if(node != null && node.raw.nodeId == "0" && node.firstChild){
				orgTreePanelleft.getSelectionModel().select(node.firstChild,true);
				orgTreePanelleft.fireEvent("itemclick",orgTreePanelleft.getView(),node.firstChild);
			}
		});

		orgTreePanelleft.on("itemclick",function(view,record,item,index,e,opts){  
		     //获取当前点击的节点  
		      var treeNode=record.raw;  
		      var nodeId = treeNode.nodeId;
		      orgId = nodeId;
		      var proxy = userRoleStore1.getProxy();
		      proxy.setExtraParam("orgId",nodeId);
		      proxy.setExtraParam("roleId",roleId);
		      userRoleStore1.loadPage(1);
	 	}); 
		
		//建立用户Model
		Ext.define("userModel",{
			extend:"Ext.data.Model",
			fields:[
				{name:"userId",mapping:"userId"},
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
		
		
		 //行选择模型
		  var userSm1=Ext.create("Ext.selection.CheckboxModel",{
					injectCheckbox:1,
			    	listeners: {
				      selectionchange: function(){
				    	  var rows = Ext.getCmp('userPanel1').getSelectionModel().getSelection();
				        	//var c = userPanel1.getSelectionModel().getSelection();
								 	if(rows.length > 0){
										Ext.getCmp('userOK').setDisabled(false);
								 	}else{
									 	Ext.getCmp('userOK').setDisabled(true);
								 	}
				      }
					}
			    });
			  
		  var userCm1=[
						{xtype: "rownumberer",text:"序号",width:60,align:"center"},
		            	{header: "ID",width: 70,align:'center',dataIndex: "userId",hidden: true,menuDisabled: true,sortable:false},
		            	{header: "姓名",width: 200,align:'center',dataIndex: "realname",width:90,menuDisabled: true,sortable:false},
		            	{header: "部门",width: 200,align:'center',dataIndex: "orgName",width:90,menuDisabled: true,sortable:false}
		            	
		            ];
	
		 var userRoleStore1 = Ext.create('Ext.data.Store', {
				pageSize: SystemConstant.commonSize,
	        	model: 'userModel',
				proxy: {
					type: 'ajax',
					extraParams:{roleId:roleId,flag: 'QxUser',roleIdOrRoleMemberId:type},
					actionMethods: {
		                read: 'POST'
		            },
					url: basePath +'/user/getUserList.action',
					reader:{
						type: 'json',
	 	      			root: 'list',
	 	      			totalProperty:"totalSize"
					},
					autoLoad: true 
				}
			});
	
		var userPanel1 = Ext.create(Ext.grid.Panel,{
							title:'用户信息',
			    	   		id: "userPanel1",
			    			stripeRows: true,
			    			border:false,
			    			forceFit:true,
			    			columnLines: true,
			    			autoScroll: true,
			    			store : userRoleStore1,
			    			selModel:userSm1,
			    			columns:userCm1,
			    			tbar:new Ext.Toolbar({
			    				items:[
			    				"姓名",
			    		    	new Ext.form.TextField({
			    		    		stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
			    		    		id:'inputUserName'
			    		    	}),
			    		    	{
			    	    	    	text :   "查询", 
			    	    	    	iconCls: "search-button", 
			    	    	    	handler:function(){
			    	    	    		var proxy = userRoleStore1.getProxy();
			    	    	    		proxy.setExtraParam("userName",Ext.getCmp('inputUserName').getValue());
			    	    	    		userRoleStore1.loadPage(1);
			    	    			} 
			    	    	  }
			    	    	   	]
			    	   	   	}),
			    			bbar:new Ext.PagingToolbar({
			    				pageSize: SystemConstant.commonSize,
			    		        store: userRoleStore1,
			    		        displayInfo: true,
			    		        displayMsg: SystemConstant.displayMsg,
			    		        emptyMsg: SystemConstant.emptyMsg
			    		    })
			    		});
			
	
			    		
		//用户分配角色窗口
		  var userWin1 = Ext.create(Ext.window.Window,{
			          		title:"选择用户",
			          		width:650,
							height:450,
							modal:true,
							resizable:true,
							closeAction:'destroy',
							layout:'border',
							items:[orgTreePanelleft,{
									region:'center',
									layout:'fit',
									border:false,
									items:[userPanel1]
							}],
							buttonAlign : 'center',
							buttons:[{
								id:'userOK',
								text:'确定',
								disabled:true,
								handler:function(){
									Ext.MessageBox.wait("", "数据查询中", {
		                                text:"请稍后..."
		                            });
									
									var rows = Ext.getCmp('userPanel1').getSelectionModel().getSelection();
									var userIds = '';
									for(var i=0; i<rows.length; i++){
										if(i < rows.length-1){
											userIds+=rows[i].get("id")+",";
						    			}else {
						    				userIds+=rows[i].get("id");
						    			}
									}
									var ajaxUrl = '';
									var params ;
									if(type =='scope'){
										ajaxUrl = basePath + '/role/addDataScopeOfUser.action';
										params = {roleMemeberId: roleId,userIds: userIds};
									}else{
										ajaxUrl = basePath + '/role/addRoleMemberOfUser.action',
										params = {roleId: roleId,userIds: userIds};
									}
									Ext.Ajax.request({
										url :ajaxUrl ,
										params : params,
										success : function(res, options) {
											var data = Ext.decode(res.responseText);
											if(data.success){
												new Ext.ux.TipsWindow(
														{
															title : SystemConstant.alertTitle,
															autoHide : 3,
															html : data.msg
														}).show();
												userWin1.close();
												Ext.MessageBox.hide();
												if(type =='scope'){
													Ext.getCmp('scopeUserPanel').getStore().loadPage(1);
												}else{
													userRoleStore.loadPage(1);
												}
												
											}else{
												Ext.MessageBox.hide();
											 	Ext.MessageBox.show({
													title: SystemConstant.alertTitle,
													msg: data.msg,
													buttons: Ext.MessageBox.OK,
													icon: Ext.MessageBox.ERROR
												});
											 	return false;
											}
										},failure : function(res){
											Ext.MessageBox.show({
												title:'提示信息',
												msg:'用户添加失败！',
												buttons: Ext.Msg.YES,
												modal : true,
												icon: Ext.Msg.ERROR
					  					    });
											
											Ext.MessageBox.hide();
											userWin1.close();
										}
									});
								}	
							},{
								text:'取消',handler:function(){
								userWin1.close();
							}}
							]
			}).show();
			
	}
	
function creatAddGroupInfo(roleId){
	
	//建立群组Model模型对象
	Ext.define("groupModel1",{
		extend:"Ext.data.Model",
		fields:[
			{name: "id",mapping:"id"}, 
			{name: "groupName"},
			{name: "remark"}
			]
	});
	//行选择模型
	var groupSm1=Ext.create("Ext.selection.CheckboxModel",{
			injectCheckbox:1,
	    	listeners: {
		      selectionchange: function(){
		    	var rows = Ext.getCmp('groupPanel1').getSelectionModel().getSelection();
				 	if(rows.length > 0){
						Ext.getCmp('groupOK').setDisabled(false);
				 	}else{
					 	Ext.getCmp('groupOK').setDisabled(true);
				 	}
		      }
			}
	    });
	
	var groupCm1=[
					{xtype: "rownumberer",text:"序号",width:60,align:"center"},
	            	{header: "ID",width: 70,align:'center',dataIndex: "id",hidden: true,menuDisabled: true,sortable:false},
	            	{header: "名称",width: 200,align:'center',dataIndex: "groupName",width:90,menuDisabled: true,sortable:false},
	            	{header: "描述",width: 200,align:'center',dataIndex: "remark",width:90,menuDisabled: true,sortable:false}
	            ];
	
	//建立groupStore
  	var groupStore1 = Ext.create('Ext.data.Store', {
		pageSize: SystemConstant.commonSize,
      	model: 'groupModel1',
		proxy: {
			type: 'ajax',
			extraParams:{roleId:roleId,flag: 'QxGroup'},
			actionMethods: {
                read: 'POST'
            },
			url: basePath+'/group/getGroupList.action',
			reader:{
				type: 'json',
	      			root: 'list',
	      			totalProperty:"totalSize"
			}
		}
	});
  	var groupPanel1 = Ext.create(Ext.grid.Panel,{
   		id: "groupPanel1",
		stripeRows: true,
		forceFit:true,
		border:false,
		columnLines: true,
		autoScroll: true,
		store : groupStore1,
		selModel:groupSm1,
		columns:groupCm1,
		bbar:new Ext.PagingToolbar({
	        store: groupStore1,
	        displayInfo: true,
	        pageSize: SystemConstant.commonSize,
	        displayMsg: SystemConstant.displayMsg,
	        emptyMsg: SystemConstant.emptyMsg
	    }),
	    tbar: [
				"名称",{
			    stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
				xtype:'textfield',
				width: 150,   
				labelWidth: 70,
				id:'groupName'
	    	},
	    	{
   	    	text :   "查询", 
   	    	iconCls: "search-button", 
   	    	handler:function(){
   	    		groupStore1.getProxy().setExtraParam("groupName",Ext.getCmp('groupName').getValue());
   	    		groupStore1.loadPage(1);
   			} 
	    	}
		]
	}); 
  	
  //群组分配角色窗口
	  var groupWin = Ext.create(Ext.window.Window,{
		          		title:"选择群组",
		          		width:650,
						height:450,
						modal:true,
						resizable:true,
						closeAction:'destroy',
						layout:'fit',
						items:[groupPanel1],
						buttonAlign : 'center',
						buttons:[{
							id:'groupOK',
							text:'确定',
							disabled:true,
							handler:function(){
								Ext.MessageBox.wait("", "数据查询中", {
	                                text:"请稍后..."
	                            });
								
								var rows = Ext.getCmp('groupPanel1').getSelectionModel().getSelection();
								var groupIds = '';
								for(var i=0; i<rows.length; i++){
									if(i < rows.length-1){
										groupIds+=rows[i].get("id")+",";
					    			}else {
					    				groupIds+=rows[i].get("id");
					    			}
								}
								Ext.Ajax.request({
									url : basePath + '/role/addRoleMemberOfGroup.action',
									params : {roleId: roleId,groupIds: groupIds},
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
											groupWin.close();
											groupStore.loadPage(1);
										}else{
										 	Ext.MessageBox.show({
												title: SystemConstant.alertTitle,
												msg: data.msg,
												buttons: Ext.MessageBox.OK,
												icon: Ext.MessageBox.ERROR
											});
										 	return false;
										}
									},failure : function(res){
										Ext.MessageBox.show({
											title:'提示信息',
											msg:'群组添加失败！',
											buttons: Ext.Msg.YES,
											modal : true,
											icon: Ext.Msg.ERROR
				  					    });
										
										Ext.MessageBox.hide();
										groupWin.close();
									}
								});
						}},
						{text:'取消',handler:function(){
							groupWin.close();
						}}
						]
		}).show();
	  groupStore1.loadPage(1);
}
	