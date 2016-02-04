/**
 * 用户管理的添加修改功能
 * @date 20150706
 * @author wujl
 */

Ext.define('sshframe.user.userTypeModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id'},
        {name: 'typeName'}
    ]
	});

Ext.define('sshframe.dict.dictModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id'},
        {name: 'dictionaryCode'},
        {name: 'dictionaryName'},
        {name: 'dictionaryValue'}
    ]
	});

sshframe.user.userTypeStore = Ext.create('Ext.data.Store', {
 	model: 'sshframe.user.userTypeModel',
 	data: [{'id':0, 'typeName':'本地用户'},{'id':1, 'typeName':'中油用户'}]
});

sshframe.user.postStore = Ext.create('Ext.data.Store', {
 	model: 'sshframe.dict.dictModel',
 	proxy: {
  	   type: 'ajax',
  	   url: basePath+'/dict/getDictListByTypeCode.action',
  	   extraParams:{dictTypeCode:"POST"},
   	   reader: {
   	      type: 'json'
  	   }
 	},
 	autoLoad: true
	});

sshframe.user.postTitleStore = Ext.create('Ext.data.Store', {
 	model: 'sshframe.dict.dictModel',
 	proxy: {
  	   type: 'ajax',
  	   url: basePath+'/dict/getDictListByTypeCode.action',
  	   extraParams:{dictTypeCode:"POSTTITLE"},
   	   reader: {
   	      type: 'json'
  	   }
 	},
 	autoLoad: true
	});

sshframe.user.jobStore = Ext.create('Ext.data.Store', {
	model: 'sshframe.dict.dictModel',
	proxy : {
		type : "format", // 自定义的数据代理类型,注意，这里使用的别名。
		extraParams:{dictTypeCode:"JOB"},
		url: basePath+'/dict/getDictPageListByTypeCode.action'
	},
	pageSize: 5,
	autoLoad:true
});

Ext.define('Ext.ux.pagingToolbarOverride', {
	override : 'Ext.PagingToolbar',
	displayInfo : false // 第 {0} - {1} 条，共 {2} 条
});

sshframe.user.jobLevelStore = Ext.create('Ext.data.Store', {
 	model: 'sshframe.dict.dictModel',
 	proxy: {
  	   type: 'ajax',
  	   url: basePath+'/dict/getDictListByTypeCode.action',
  	   extraParams:{dictTypeCode:"JOBLEVEL"},
   	   reader: {
   	      type: 'json'
  	   }
 	},
 	autoLoad: true
	});

sshframe.user.UserForm = Ext.create("Ext.form.Panel", {
	bodyStyle :'padding:5px 30px 0 5px',
	border :false,
	autoScroll : false,
	layout : 'form', 
	items:[{
		layout : 'column',
		border : false,
		baseCls : 'x-plain',
		items : [
			{
				columnWidth : .5,
				layout : 'form',
				baseCls : 'x-plain',
				border : false,
				labelWidth:80,
				defaultType:'textfield',
				defaults:{
					width:180,
					labelAlign:'right'
				},
				items : [
					{
						id:'userId',
						name : 'user.id',
						hidden : true
					},
					{ allowBlank:false,xtype: 'combobox',fieldLabel: '用户类别',name: 'user.type',store: sshframe.user.userTypeStore,valueField: 'id',displayField: 'typeName',typeAhead:false,id:"userType",
						editable:false,emptyText: '用户类别'},
						{ allowBlank:false, id:'addOrgIds', name: 'orgIds',xtype:'hidden'},
						{
							fieldLabel:'组织部门',
							id:'orgNames',
							name:'orgNames',
							labelAlign:'right',
							xtype:'textfield',
							readOnly:true,
							minWidth: 250,
							allowBlank:false,
					 		blankText : '组织部门不能为空',
							listeners:{
								'focus':function(){
									var userId = Ext.getCmp('userId').getValue();
									if(userId && userId != 0){
										chooseOrganization('orgNames','addOrgIds',userId);
									}else{
										chooseOrganization('orgNames','addOrgIds');
									}
									
								}
							}
			},
			{ 
				allowBlank:false, 
				regex : /^[\w.\-\u4e00-\u9fa5]+$/,
		        regexText : '不能包含特殊字符',
		        fieldLabel: '姓名', 
		        name: 'user.realname',
		        emptyText: '真实姓名',
		        maxLength:20
		    },
		    { 
		    	allowBlank:false, 
		    	fieldLabel: '登录名', 
		    	name: 'user.username',
		    	emptyText: '登录名',
              	regex : /^[\w-]{4,16}$/,
              	regexText : '登录名由4到16位数字、字母、下划线、中划线组成，请检查',
              	emptyText: '登录名不能为空',
              	maxLength:16,
              	validator: function(value){
					var returnObj = null;
					if(value == sshframe.user.username){
						return true;
					}else{
						$.ajax({
							url : basePath+'/user/validateUser.action',
							data:{dictField:'username', value:value},
							cache : false,
							async : false,
							type : "POST",
							dataType : 'json',
							success : function (result){
								if(!result.valid){
									returnObj = result.reason;
								}else{
									returnObj = true;
								}
							}
						});
					}
					return returnObj;
				}
			},
			{ 
				allowBlank:false, 
				fieldLabel: '密码',
				maxLength:18,
				minLength:6, 
				name: 'user.password', 
				inputType: 'password',
				minLength:SystemConstant.passwordMinLength,
				regex : /^[^\u4e00-\u9fa5]{0,}$/
				},
				{ fieldLabel: 'ERP ID',regex : /^[\w.\-\u4e00-\u9fa5]+$/,
			        regexText : '不能包含特殊字符',emptyText: '', name: 'user.erpId',maxLength:10},
		        { xtype: 'radiogroup',layout:"column", columns: [40, 40], fieldLabel:'性别',isFormField:true,
    				items:[{
          				xtype:"radio",
          				boxLabel:SystemConstant.gender_male,
          				checked:true,
          				name: "user.gender",
          				inputValue:SystemConstant.gender_male
    				},{
          				xtype:"radio",
         				boxLabel:SystemConstant.gender_female,
          				checked:false,
          				name: "user.gender",
          				inputValue:SystemConstant.gender_female
    				}]
				},
				{ fieldLabel: 'Email',maxLength:50,name: 'user.email', vtype: 'email',regex:/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/},
				{ fieldLabel: '电话号码',maxLength: 12,name: 'user.phoneNo',emptyText: '', regex : /^[\d-]*$/,regexText : '电话号码只能包含数字和“-”，请检查',maxLength:12},
				{ fieldLabel: '出生地',regex : /^[\w.\-\u4e00-\u9fa5]+$/,
			        regexText : '不能包含特殊字符',name: 'user.birthPlace',emptyText: '',maxLength: 50},
			    { xtype: 'dateTimePicker', fieldLabel: '出生日期', name: 'user.birthDay', maxDate : Ext.Date.format(new Date(),"Y-m-d")}
			]
			},
			{
				columnWidth : .5,
				layout : 'form',
				baseCls : 'x-plain',
				border : false,
				labelWidth:80,
				defaultType:'textfield',
				defaults:{
					width:220,
					labelAlign:'right'
				},	
				items : [
					{ fieldLabel: '手机1',name: 'user.mobileNo1',emptyText: '',regex : /^[1][0-9]{10}$/,regexText : '手机号码由数字1开头的11位数字组成，请检查'},
					{ fieldLabel: '手机2',name: 'user.mobileNo2',emptyText: '',regex : /^[1][0-9]{10}$/,regexText : '手机号码由数字1开头的11位数字组成，请检查'},
					{ fieldLabel: '集团短号1',name: 'user.shortNo1',emptyText: '',regex:/^\d{6}$/,regexText:'集团短号由6位数字组成，请检查'},
					{ fieldLabel: '集团短号2',name: 'user.shortNo2',emptyText: '',regex:/^\d{6}$/,regexText:'集团短号由6位数字组成，请检查'},
					{ 
						allowBlank:false, 
						fieldLabel: '确认密码',
						maxLength:18,
						minLength:6,
						name: 'confirmPassword', 
						inputType: 'password',
						minLength:SystemConstant.passwordMinLength,
						regex : /^[^\u4e00-\u9fa5]{0,}$/,
						vtype:"updateValidatePassword",//自定义的验证类型
			    		vtypeText : '确认密码错误，请检查'
		     		},
                	{ 
		     			xtype: 'combobox',
		     			fieldLabel: '职称',
		     			name: 'user.postTitle',
		     			store: sshframe.user.postTitleStore,
		     			valueField: 'dictionaryCode',
		     			displayField: 'dictionaryName',
		     			typeAhead:false,
						editable:false,
						queryMode: 'remote'
					},
					{ xtype: 'combobox',fieldLabel: '职位',name: 'user.post',store: sshframe.user.postStore,valueField: 'dictionaryCode',displayField: 'dictionaryName',typeAhead:false,editable:false,queryMode: 'remote'},
 					{
						fieldLabel : '职务',
						xtype : 'querySelectCombo',
						name : 'user.job',
						store:sshframe.user.jobStore,
						queryParam : 'dictionaryName',
						valueField : 'dictionaryCode',
						displayField : 'dictionaryName',
						pathByUrl :basePath+'/dict/getDictByCode.action',
					},
    				{ xtype: 'combobox',fieldLabel: '职级',name: 'user.jobLevel',store: sshframe.user.jobLevelStore,valueField: 'dictionaryCode',displayField: 'dictionaryName',typeAhead:false,editable:false,queryMode: 'remote'},
    				{ fieldLabel: '排序',name: 'user.disOrder',emptyText: '',regex : /^[0-9]+$/,regexText : '排序号码只能为数字。'}
				]
			}
		]
	}] 
});

Ext.apply(Ext.form.VTypes,{
	updateValidatePassword:function(val,field){//val指这里的文本框值，field指这个文本框组件
		return (val== sshframe.user.UserForm.getForm().findField("user.password").getValue());
	}
});

sshframe.user.UserWin = Ext.create("Ext.window.Window", {
    width : 700,
    height: 360,
	items : [ sshframe.user.UserForm ],
	buttons : [ {
		text : '确定',
		handler : function() {
			if (sshframe.user.UserForm.form.isValid()) {
				sshframe.user.UserForm.form.submit({
					success : function(form, action) {
						Ext.Msg.showTip(action.result.msg);
	                	var store = sshframe.user.userGrid.getStore();
	     				store.loadPage(1);
						sshframe.user.UserWin.close();
					},
					failure : function(form, action) {
						Ext.Msg.showError(action.result.msg);
					}
				});
			}
			sshframe.user.username = '';
		}
	}, {
		text : '关闭',
		handler : function() {
			sshframe.user.UserWin.close();
			sshframe.user.username = '';
		}
	} ]
});
