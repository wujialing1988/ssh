/**
 * 用户管理的列表功能，包含功能有 列表、查看功能。 
 * @date 20150706
 * @author wujl
 */

/**
 * 定义用户Model
 */
Ext.define("sshframe.user.roleManageModel",{
					extend:"Ext.data.Model",
					fields:[
						{name:'roleName'},
						{name:'roleCode'},
						{name:'description'},
						{name:'roleId',type:'int'}
					]
				});

Ext.define("sshframe.user.permissionManageModel",{
					extend:"Ext.data.Model",
					fields:[
						{name:'resourceName'},
						{name:'code'},
						{name:'resourceType'},
						{name:'remarks'},
						{name:'resourceId',type:'int'}
					]
				});

Ext.define("sshframe.user.userModel",{
	extend:"Ext.data.Model",
	fields:[
		{name:"id",mapping:"id"},
		{name:"orgName"},
		{name:"username"},
		{name:"password"},
		{name:"realname"},
		{name:"gender"},
		{name:"mobileNo1"},
		{name:"mobileNo2"},
		{name:"phoneNo"},
		{name:"shortNo1"},
		{name:"shortNo2"},
		{name:"idCard"},
		{name:"birthPlace"},
		{name:"erpId"},
		{name:"orgId"},
		{name:"isDeleted"},
		{name:"disOrder"},
		{name:"type"},
		{name: "post"},
		{name: "postDictCode"},
		{name: "postTitle"},
		{name: "jobDictCode"},
		{name: "job"},
		{name: "jobLevelDictCode"},
		{name: "jobLevel"},
		{name: "email"},
		{name: "isDisabled"},
		{name: "birthDay"}
	]
});

/**
 * 定义Store
 */
sshframe.user.userStore=Ext.create("Ext.data.Store", {
    pageSize: SystemConstant.commonSize,
    model:"sshframe.user.userModel",
    remoteSort:true,
    
	proxy: {
        type:"ajax",
        actionMethods: {
                read: 'POST'
            },
	    url: basePath+"/user/getUserList.action",
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

var cm=[
			{xtype: "rownumberer",text:"序号",width:60,align:"center"},
        	{header: "ID",align:'left',dataIndex: "userId",hidden: true},
        	{header: "部门",align:'left',dataIndex: "orgName",width:90},
        	{header: "登录名",align:'left',dataIndex: "username",width:90},
        	{header: "姓名",align:'left',dataIndex: "realname",width:90},
        	{header: "ERPID",align:'left',dataIndex: "erpId",width:90},
        	{header: "职务",align:'left',dataIndex: "job",width:90},
        	{header: "用户类别",align:'left',dataIndex: "type",width:90,
        		renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
        			if (value == 0) {
        				return '本地用户';
        			}
        			else {
        				return '中油用户';
        			}
        		}        		
        	},
        	{header: "性别",dataIndex: "gender",width:50},
        	{header: "手机1",align:'left',dataIndex: "mobileNo1",width:90},
        	{header: "集团短号1",align:'left',dataIndex: "shortNo1",width:90},
        	{header: "禁用",dataIndex: "",width:50,
        		renderer:function(value, cellmeta, record, rowIndex, columnIndex, store){
					var isLockup = record.get('isDisabled');
					if(isLockup == null || typeof(isLockup) == "undefined"){
						return ;
					}
					var userId = record.get('id');
					if(isLockup == 0){
						return '<img title="点击锁定用户" src="'+basePath+'/images/icons/unlock.gif" style="cursor: pointer" onclick="sshframe.user.lockupUser(\''+userId+'\')"/>';
					}else if(isLockup == 1){
						return '<img title="点击解锁用户" src="'+basePath+'/images/icons/lock.gif" style="cursor: pointer" onclick="sshframe.user.lockupUser(\''+userId+'\')"/>';
					}
				},
				align:'center'
        	}
        ];
/**
 * 定义Grid
 */
sshframe.user.userGrid =  Ext.create("Ext.grid.Panel",{
	title:'用户管理',
	width: "100%",
	maxHeight:900,
	id: "userGrid",
	region: "center",
	bbar:  Ext.create("Ext.PagingToolbar", {
		store: sshframe.user.userStore
	}),
    selModel:Ext.create("Ext.selection.CheckboxModel"),
	store: sshframe.user.userStore,
	columns:cm,
	listeners:{
		'render': function(g) {
			 sshframe.user.userStore.loadPage(1);
         }  
	},
	tbar: [
	"姓名",
					{	
    						xtype:'textfield',
    						stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
    		    			id:'inputSearchName'
    		    		
    		    	},
    		    	{
    	    	    	text :   "查询", 
    	    	    	iconCls: "search-button", 
    	    	    	handler:function(){
    	    	    		var proxy = sshframe.user.userStore.getProxy();
    	   					proxy.setExtraParam("userName",Ext.getCmp('inputSearchName').getValue());
    	   					sshframe.user.userStore.loadPage(1);
    	    			} 
    	    	   	},
		"->",
		{
			text:SystemConstant.addBtnText,
			id:"addUser",
			iconCls: "add-button",
			handler: function(){
				sshframe.user.addUser();
			}
		},
		{
			text:SystemConstant.modifyBtnText,
			id:"updateUser",
			disabled: true,
			disabledExpr : "$selectedRows != 1",
			iconCls: "edit-button",
			handler:function(){
				var rows = sshframe.user.userGrid.getSelectionModel().getSelection();
				cUserIsExist(rows[0].get('id'));
			}
		},
		{
			text:SystemConstant.deleteBtnText,
			id:"deleteUser",
			disabled:true,
			disabledExpr : "$selectedRows == 0",
			iconCls: "delete-button",
			handler:function(){
				sshframe.user.deleteUser();
			}
		},
		{
			text:'Excel',
			id:'excelGroupBtn',
    	   	iconCls:'excel-button',
    	   	xtype:'splitbutton',
    	   	menu:[
    	   		{
					text:SystemConstant.importUserInfoBtnText,
					id:"userImport",
					iconCls: "import-button",
					handler: function(){
						importUserWin.show();
					}
				},
				{
					text:SystemConstant.exportUserInfoBtnText,
					id:"userExport",
					iconCls: "export-button",
					handler: function(){
						
						Ext.MessageBox.wait("", "导出数据", {
							text:"请稍后..."
						});
						
						$('#exportUsers').submit();
						Ext.MessageBox.hide();
						
					}
				},
    			{
    	   			text:SystemConstant.downloadUserInfoImportTemplateBtnText,
    	   			id:'userImortTemplateDownload',
    	   			iconCls:'excel-button',
    	   			handler:function(){
    	   				$('#downloadType').val('user');
    	   				$('#downloadExcel').submit();
    	   			}
    			}
    	   	]
    	},
    	{
			text:SystemConstant.resetPwd,
			id:"userResetPwd",
			iconCls: "resetPwd",
			hidden:false,
			disabled:true,
			disabledExpr : "$selectedRows != 1",
			handler: function(){
				sshframe.user.resetPwd();
			}
		},
		{
			text : SystemConstant.synchronizeBtnText, 
			iconCls: "refresh-button",
			id: "synchronizeUserInfoBtn", 
			handler:function(){
				sshframe.user.synchronizeUser();
			}
		}
	]
});

	//锁定/解锁用户
	sshframe.user.lockupUser = function (userId){
		if(userId == currentUserId ){
	        Ext.Msg.showInfo("不允许禁用/解禁用户本身！");
	        return false;
	    }
		
     	Ext.Ajax.request({
        	url: basePath+'/user/updateUserEnable.action',
     		params: {
     	   		userId: userId
     	   	},
     		success: function(response, opts) {
     	      	var result = Ext.decode(response.responseText);
     	      	var flag = result.success;
     	      	if(flag){
     	      		refreshUserGrid();
     	      		Ext.Msg.showTip(result.msg);
     	      	}else{
     	      		Ext.Msg.showInfo(result.msg);
     	      	}
     	   	}
    	});
	};
	
	//重置密码
	sshframe.user.resetPwd =function(){
		var rows = sshframe.user.userGrid.getSelectionModel().getSelection();
		if(rows.length > 0){
			if(rows[0].get('type') != 0){
				Ext.Msg.showInfo('非本地用户不能重置密码');
				return;
			}
	        
	        Ext.Msg.confirm('系统提示','你确定要将这'+rows.length+'条数据密码重置为'+ SystemConstant.defaultPassword +'吗?',function(btn){
	            if(btn=='yes'){
	                var userIds = new Array();
	                for(var i=0;i<rows.length;i++){
	                    var row=rows[i];
	                    userIds.push(row.get('id'));
	                }
	                Ext.Ajax.request({
	                    url: basePath+'/user/resetUserPassword.action',
	                    params: {
	                        userIds: userIds
	                    },
	                    success: function(response, opts) {
	                        var result = Ext.decode(response.responseText);
	                        var flag = result.success;
	                        if(flag){
	                            refreshUserGrid();
	                            Ext.Msg.showTip(result.msg);
	                            if(rows[0].get('id') == currentUserId){
	                            	setTimeout(function(){
	                            		Ext.Ajax.request({
	                                        url : basePath+'/user/logout.action',
	                                        success : function(res ,options) {
	                                            var json = Ext.decode(res.responseText);
	                                            if(json.success){
	                                                parent.window.location.href=basePath+"/toLogin.action";
	                                            }
	                                        }
	                                    });
	                            	},2000);
	                            }
	                        }else{
	                            Ext.Msg.showInfo(result.msg);
	                        }
	                    }
	                });
	            }
	        });
		}
	};
	
	importUserWin = new Ext.Window({
		title: '用户导入',
		closable:true,
		width:400,
		closeAction:'hide',
		height:150,
		modal:true,
		resizable:false,
		layout :"fit",
		buttonAlign:'center',
		html:'<form id="importUserFormDom" style="padding: 25 0 0 50" action="'+basePath+'/user/importUser.action" method="post" enctype="multipart/form-data">'+
		     'EXCEL文件：<input type="file" name="uploadAttach" id="uploadAttach" onchange="javascript:$(\'#filename\').val(this.value);"></input><br />'+
			 '<span id="uploadTip" style="color: red;"></span>'+
			 '<input type="hidden" name="filename" id="filename"></input>'+
			 '</form>',
       buttons:[{
    	   text:SystemConstant.uploadBtnText,
           handler:importUserInfo
       },{
    	   text:SystemConstant.closeBtnText,
    	   handler:function(){
    	   	 importUserWin.hide();
    	   }
       }]
	});
 	
	function importUserInfo(){
		if($('#uploadAttach').val()=="" || null==$('#uploadAttach').val()){
			$('#uploadTip').text('请先选择Excel文件');
			setTimeout("$('#uploadTip').text('')",1500);
			return;
		}
		
		var fileURL = $('#uploadAttach').val();
		var type = fileURL.substring(fileURL.lastIndexOf(".")+1).toLowerCase();
		if (type != 'xls' && type != 'xlsx') {
			Ext.Msg.showInfo('文件格式错误,支持[.xls或.xlsx]结尾的excel格式！');
			$('#uploadAttach').val('');
			return;
		}
		
		Ext.MessageBox.wait("", "导入数据", {
			text:"请稍后..."
		});
		
		Ext.Ajax.request({
			url:basePath+'/user/importUser.action',
	        isUpload:true,   
	        form:'importUserFormDom',
	        success:function(response, opts){
	 	      	var result = Ext.decode(response.responseText);
	 	      	var flag = result.msg;
	 	      	if(flag == "importSuccess"){
	 	      		Ext.MessageBox.hide();
	 	      		Ext.Msg.showTip('用户导入成功');
	 	      		importUserWin.hide();
	 	      		sshframe.user.userGrid.getStore().load();
	 	      	}else{
	 	      		Ext.Msg.showError(flag);
	 	      	}
	        } 
		});
	}

	//刷新用户列表
	function refreshUserGrid(){
		var store = sshframe.user.userGrid.getStore();
		store.load();
	}

	/**
	 * 调用后台同步用户
	 */
	sshframe.user.synchronizeUser = function(){
		  Ext.Msg.confirm(SystemConstant.alertTitle,"同步将会删除现有数据，确定要同步吗？",function(btn) {
			  	if (btn == 'yes') {
			  		Ext.MessageBox.wait("", "同步用户数据", {
						text:"请稍后..."
					});
			  		
					Ext.Ajax.request({
						timeout:600000000,
						url:basePath+'/user/synchronizeUserInfo.action',   
						success:function(response, opts){
							var data = Ext.decode(response.responseText);
							Ext.MessageBox.hide();
							if(data.success){
								Ext.Msg.showTip(data.msg);
								sshframe.user.userStore.load();
								orgTreeStore2.load();
							}else{
								Ext.Msg.showInfo(data.msg);
							}
						}
					});
			  	}
		  });
	};

	//在点击修改按钮之前，判断当前用户是否存在
	function cUserIsExist(userId){
		Ext.Ajax.request({
			url: basePath+'/user/userIsExist.action',
		 		params: { 
		 	   		userId: userId
		 	   	},
				success: function(response, opts) {
			      	var result = Ext.decode(response.responseText);
			      	var flag = result.success;
			      	if(!flag){
			      		Ext.Msg.showInfo("用户不存！");
			      	}else{
			      		//打开修改窗口
			      		sshframe.user.updateUser(userId);
			      	}
			   	}
		});
	}

	/**
	 * 调用后台删除用户
	 */
	sshframe.user.deleteUser = function() {
	 	var rows = sshframe.user.userGrid.getSelectionModel().getSelection();
	 	if(rows.length <= 0){
	 		Ext.Msg.showInfo('请先选择要删除的数据');
			return;
	 	}
	 	
	 	Ext.Msg.confirm(SystemConstant.alertTitle,SystemConstant.deleteMsgStart+rows.length+SystemConstant.deleteMsgEnd,function(btn){
	 		if(btn=='yes'){
	 			var userIds = "";
				if(rows.length==1){
					if(rows[0].get('id') == currentUserId ){
						Ext.Msg.showInfo('不允许删除用户本身');
						return;
					}
					userIds = rows[0].get('id');
				}else{
					for(var i=0;i<rows.length;i++){
						userIds += ',' + rows[i].get('id');
						if(rows[i].get('id') == currentUserId ){
							Ext.Msg.showInfo('不允许删除用户本身');
							return;
						}
					}
					userIds = userIds.substring(1);
				}
				
				$.post(basePath+'/user/deleteUser.action', {userIds : userIds},
				function(data){
					var result = Ext.decode(data);
					if (result.success) {
						Ext.Msg.showTip(result.msg);
						sshframe.user.userStore.loadPage(1);
					}
					else {
						Ext.Msg.showInfo(result.msg);
					}
				});
				
				/*
				Ext.Ajax.request({
					url: basePath+'/user/isCanDelete.action',
				 		params: { 
				 	   		userId: userIds
				 	   	},
						success: function(response, opts) {
					      	var result = Ext.decode(response.responseText);
					      	var flag = result.success;
					      	if(!flag){
					      		Ext.Msg.showInfo(result.msg);
					      	}else{
					      		$.post(basePath+'/user/deleteUser.action', {userIds : userIds},
	    						function(data){
									Ext.Msg.showTip('删除用户成功');
									sshframe.user.userStore.loadPage(1);
	    						});
					      	}
					   	}
				});
				*/
				
	 		}
	 	});
	};


	/**
	 * 调用后台添加用户
	 */
	sshframe.user.addUser = function() {
		sshframe.user.UserWin.setTitle('添加');
		var basicForm = sshframe.user.UserWin.down('form').getForm();
		basicForm.reset();
		basicForm.url = basePath+'/user/addUser.action';
		basicForm.findField('user.password').setVisible(true);
		basicForm.findField('confirmPassword').setVisible(true);
		basicForm.findField('user.password').setDisabled(false);
		basicForm.findField('confirmPassword').setDisabled(false);
		basicForm.findField('user.username').setDisabled(false);
		basicForm.findField('user.type').setValue(0);
		
		sshframe.user.UserWin.show();
	};
	
	
	/**
	 * 调用后台修改用户
	 */
	sshframe.user.updateUser = function(userId) {
		sshframe.user.UserWin.setTitle('修改');
		var basicForm = sshframe.user.UserWin.down('form').getForm();
		basicForm.reset();
		basicForm.url = basePath + '/user/updateUser.action';
		basicForm.findField('user.id').setValue(userId);
		basicForm.findField('user.password').setVisible(false);
		basicForm.findField('confirmPassword').setVisible(false);
		basicForm.findField('user.password').setDisabled(true);
		basicForm.findField('confirmPassword').setDisabled(true);
		basicForm.findField('user.username').setDisabled(true);
		
		basicForm.load({
			url : basePath + '/user/getUserByIdForUpdate.action',
			params : {
				id : userId
			},success :function(form, action){
				var response = Ext.decode(action.response.responseText);
				if(response.success){
					sshframe.user.username = response.data['user.username'];
				}
			}
		});
		
		
		sshframe.user.UserWin.show();
	};
