<%@ page language="java" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>个人信息</title>
<meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=7,9"/>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
<script type="text/javascript"
	src="${pageContext.request.contextPath }/scripts/my97DatePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${ctx}/scripts/common/SystemConstant.js"></script>
<script type="text/javascript">
var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
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

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget='side';
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
	Ext.define("roleManageModel",{
		extend:"Ext.data.Model",
		fields:[
			{name:'roleName'},
			{name:'roleCode'},
			{name:'description'},
			{name:'roleId',type:'int'}
		]
	});

   


 var userForm = Ext.create("Ext.form.Panel",{
	 id:'userForm',
	 frame: true,
	 title: '个人信息',
	 bodyStyle:"background-color:#ffffff",
	 style: 'margin:0px',
	 enableTabScroll:true, 
	 trackResetOnLoad:true,
	 items:[{
		    layout:'column',
			border : true,
			baseCls : 'x-plain',
			xtype:'fieldset',
			title:'工作信息',
			style:'margin:20px;border:10px solid #B5B8C8',
			enableTabScroll:true, 
			items : [
			   
				{
					columnWidth : .1,
					layout : 'form',
					autoHeight:true, 
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
				},
				{
					columnWidth : .3,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'textfield',
					defaults:{
						width:200,
						labelAlign:'right',
						fieldStyle:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: 0px solid;'
						//fieldStyle:'background-color: #F0F8FF; background-image: none;'
					},
					items : [
	                	{ fieldLabel: '登录名',value:"${CurrentUser.username}",readOnly:true,emptyText: '无数据'},
	                	{ fieldLabel: '员工编号',value:"${CurrentUser.erpId}",readOnly:true,emptyText: '无数据'},
	                	{ fieldLabel: '班组',value:"${CurrentUser.workTeam.teamName}",readOnly:true,emptyText: '无数据'},
	                	{ fieldLabel: '职位',value:"${CurrentUser.post.dictionaryName}",readOnly:true,emptyText: '无数据'},
	                	{ fieldLabel: '职务1',value:"${CurrentUser.job1.dictionaryName}",readOnly:true,emptyText: '无数据'}
	                	
					]
					
				},
				{
					columnWidth : .15,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						{ fieldLabel: '',readOnly:true}
	                	
					]
					
				},
				{
					columnWidth : .3,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'textfield',
					defaults:{
						width:220,
						labelAlign:'right',
						//fieldStyle:'background-color: #F0F8FF; background-image: none;'
						fieldStyle:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: 0px solid;'
					},	
					items : [
							{ fieldLabel: '用户类别',value:"${CurrentUser.type.dictionaryName}",readOnly:true,emptyText: '无数据'},
							{ fieldLabel: '卡号',value:"${CurrentUser.cardCode}",readOnly:true,emptyText: '无数据'},
							{ fieldLabel: '组织部门',name:"orgName",readOnly:true,emptyText: '无数据'},
							{ fieldLabel: '职称',value:"${CurrentUser.postTitle.dictionaryName}",readOnly:true,emptyText: '无数据'},
							{ fieldLabel: '职级',value:"${CurrentUser.jobLevel.dictionaryName}",readOnly:true,emptyText: '无数据'},
							{ fieldLabel: '职务2',value:"${CurrentUser.job2.dictionaryName}",readOnly:true,emptyText: '无数据'}
					]
				},
				{
					columnWidth : .15,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
					
				} 
			]
		},
		{
		    layout:'column',
			border : true,
			baseCls : 'x-plain',
			xtype:'fieldset',
			title:'个人信息',
			style:'margin:20px;border:20px solid #B5B8C8',
			items : [
			   
				{
					columnWidth : .1,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
				},
				{
					columnWidth : .3,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'textfield',
					defaults:{
						width:200,
						labelAlign:'right',
						fieldStyle:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: 0px solid;'
					},
					items : [
	                	{ fieldLabel: '姓名',value:"${CurrentUser.realname}",readOnly:true,emptyText: '无数据'},
	                	{ fieldLabel: '身份证号',value:"${CurrentUser.idCard}",readOnly:true,emptyText: '无数据'},
	                	{ fieldLabel: '出生地',value:"${CurrentUser.birthPlace}",readOnly:true,emptyText: '无数据'}
	                	
	                	
					]
					
				},
				{
					columnWidth : .15,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						{ fieldLabel: '',readOnly:true}
	                	
					]
					
				},
				{
					columnWidth : .3,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'textfield',
					defaults:{
						width:220,
						labelAlign:'right',
						//fieldStyle:'background-color: #F0F8FF; background-image: none;'
						fieldStyle:'background:none; border-right: 0px solid;border-top: 0px solid;border-left: 0px solid;border-bottom: 0px solid;' 
					},	
					items : [
							{ fieldLabel: '性别',value:"${CurrentUser.gender}",readOnly:true,emptyText: '无数据'},
							{ fieldLabel: '出生日期',value:"${CurrentUser.birthDay}",readOnly:true,emptyText: '无数据'}
	        				
					]
				},
				{
					columnWidth : .15,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
					
				} 
			]
		},
		{
		    layout:'column',
			border : true,
			baseCls : 'x-plain',
			xtype:'fieldset',
			title:'联系方式',
			style:'margin:20px;border:20px solid #B5B8C8',
			items : [
			   
				{
					columnWidth : .1,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
				},
				{
					columnWidth : .3,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'textfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
	                	{ fieldLabel: '座机号码',name:'user.phoneNo',maxLength: 12,value:"${CurrentUser.phoneNo}",emptyText: '',regex : /^(\d{3}(-)\d{8})|(\d{4}(-)\d{7})$/,regexText : '固定电话号码格式为：“区号-电话号码”，请检查'},
	                	{ allowBlank:false, fieldLabel: '手机号码1',name:'user.mobileNo1',value:"${CurrentUser.mobileNo1}",emptyText: '',regex : /^[1][0-9]{10}$/,regexText : '手机号码由数字1开头的11位数字组成，请检查'},
	                	{ fieldLabel: '集团短号1',name:'user.shortNo1',value:"${CurrentUser.shortNo1}",emptyText: '',regex:/^\d{6}$/,regexText:'集团短号由6位数字组成，请检查'}
	                	
	                	
					]
					
				},
				{
					columnWidth : .15,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						{ fieldLabel: '',readOnly:true}
	                	
					]
					
				},
				{
					columnWidth : .3,
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
							{ fieldLabel: '电子邮箱',name:'user.email',value:"${CurrentUser.email}", allowBlank:false,emptyText: '',maxLength:50,vtype: 'email',regex:/\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/},
							{ fieldLabel: '手机号码2',name:'user.mobileNo2',value:"${CurrentUser.mobileNo2}",emptyText: '',regex : /^[1][0-9]{10}$/,regexText : '手机号码由数字1开头的11位数字组成，请检查'},
							{ fieldLabel: '集团短号2',name:'user.shortNo2',value:"${CurrentUser.shortNo2}",emptyText: '',regex:/^\d{6}$/,regexText:'集团短号由6位数字组成，请检查'}
							
	        				
					]
				},
				{
					columnWidth : .15,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
					
				} 
			]
		}
		
		],
		listeners:{
			beforerender : function() {    
				Ext.getCmp("userForm").getForm().load({
					url : '${ctx}/bpm/queryUserInfoById.action', //请求的url地址
					params:{userId:"${CurrentUser.userId}"}
				});
    		}  
		} ,
		 buttonAlign : "center",
		 buttons : [ {
		        text :"保存",
		        id:'userSaveBtn',
		        handler : function() {
		        	if(!userForm.form.isValid()){
		        		alert("存在非法数据，请修正之后再做保存!");
	                	return;
	              }
		        	 Ext.MessageBox.wait("", "更新用户信息", 
								{
									text:"请稍后..."
								}
							);
		        	 userForm.form.submit({
     	                url: '${ctx}/bpm/updateUser.do',
     	              
     	                success:function(form,action){
								new Ext.ux.TipsWindow({
									title:SystemConstant.alertTitle,
									html: "更新用户信息成功"
								}).show();
     	                	
     	                	Ext.MessageBox.hide();		
     	                	window.location.reload();
     	                	
                   	    },
     	              	failure:function(form,action){
     	              		Ext.MessageBox.show({
							           title: SystemConstant.alertTitle,
							           msg: '更新用户信息失败！',
							           buttons: Ext.MessageBox.OK,
							           icon: Ext.MessageBox.ERROR
							       });
     	              		
     	              		Ext.MessageBox.hide();		
     	              		
     	              	}
           });
		        }
		    }, {
		        text : "重置",
		        handler : function() {
		        	userForm.form.reset();
		        }
		    }]
	
	 
 });

 
 var userPhoto = Ext.create("Ext.form.Panel",{
	 frame: true,
	 title: '个性设置',
	 bodyStyle:"background-color:#ffffff",
	 style: 'margin:0px',
	 enableTabScroll:true, 
	 items:[{
		    layout:'column',
			border : true,
			baseCls : 'x-plain',
			xtype:'fieldset',
			title:'个性设置',
			style:'margin:20px;border:20px solid #B5B8C8',
			items : [
			   
				{
					columnWidth : .1,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
						{ fieldLabel: '',readOnly:true}
					]
				},
				{
					columnWidth : .35,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'textfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						
					         { xtype : 'fileuploadfield',id :'photoImg',name:'photoImg',emptyText:'请选择大小在500k以内的jpg或者png图像文件',fieldLabel :'个人头像',
					        	 buttonText : '&nbsp;&nbsp;&nbsp;浏览&nbsp;&nbsp;&nbsp;'
	                	       , buttonCfg :  
	                	      {  
	                	         iconCls : 'upload-icon'  
	                	      }/* ,
	                	      validator: function(value){
	                	    	  if(value!=null){
	                	    		  var arr = value.split('.');
		                	    	  if(arr[arr.length-1].toLowerCase()!= 'jpg'&& arr[arr.length-1].toLowerCase() != 'png'){
		                	    	    return '文件不合法！！！';
		                	    	   }else{
		                	    		              return true;
		                	    	   }
		                	    	  }else{
		                	    		  return true;
		                	    	  } 
	                	    	  } */
	                	    	 
					         }
					] 
					
				},
				{
					columnWidth : .1,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					//labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:100
						//labelAlign:'right'
					},
					items : [
						
  						 {
							xtype : 'button',width:70,text: '上传',  
      						 handler: function() {
      							if(userForm.form.isDirty()==true){
      							
      								Ext.MessageBox.show({
       						           title: SystemConstant.alertTitle,
       						           msg: "请先保存之前对个人信息的修改！",
       						           buttons: Ext.MessageBox.OK,
       						           icon: Ext.MessageBox.ERROR
       						      	 });
      								return;
     							}
      							var fileName = Ext.getCmp('photoImg').getValue();
      							
      							if(fileName==null){
      								Ext.MessageBox.show({
      						           title: SystemConstant.alertTitle,
      						           msg: "请选择文件之后再上传！",
      						           buttons: Ext.MessageBox.OK,
      						           icon: Ext.MessageBox.ERROR
      						      	 });
        	 						return;
        	 					}else {
        	 						var arr = fileName.split('.');
        	 						if(arr[arr.length-1].toLowerCase()!= 'jpg'&& arr[arr.length-1].toLowerCase() != 'png'){
        	 							Ext.MessageBox.show({
           						           title: SystemConstant.alertTitle,
           						           msg: "请选择.jpg或者.png文件上传！",
           						           buttons: Ext.MessageBox.OK,
           						           icon: Ext.MessageBox.ERROR
           						      	 });
             	 						return;
            	 					}
        	 					}
        	 						 
    	 					Ext.MessageBox.wait("", "上传附件", 
								{
								text:"请稍后..."
								}
								);
    	 					
    						 userPhoto.form.submit({
    		
            					 url: '${ctx}/bpm/uploadFile.do',
          						   params : {tag: 'photo'},
           					success:function(form,action){
           						
        			 	      	//var flag = action.result.success;
        			 	      	
        			 	      		new Ext.ux.TipsWindow({
										title:SystemConstant.alertTitle,
									html: "上传成功"
									}).show();
        			 	      		Ext.MessageBox.hide();		
                     				window.location.reload();	
             	
       	   				 },
           				failure:function(form,action){
           					Ext.MessageBox.show({
				           title: SystemConstant.alertTitle,
				           msg: action.result.msg,
				           buttons: Ext.MessageBox.OK,
				           icon: Ext.MessageBox.ERROR
				      	 });
           		
           		//Ext.MessageBox.hide();		
           		
           		}
				});
      		 } }
					]
				},
				{
					columnWidth : .35,
					layout : 'form',
					baseCls : 'x-plain',
					border : false,
					labelWidth:80,
					defaultType:'displayfield',
					defaults:{
						width:200,
						labelAlign:'right'
					},
					items : [
						

							{  
   								 xtype: 'box', //或者xtype: 'component', 
   								 //style:'margin-left:100px;',  
   								 width: 100, //图片宽度  
  								  height: 100, //图片高度  
  								  autoEl: {  
      								  tag: 'img',    //指定为img标签  
      								  src:'${ctx}/bpm/previewImg.do?time='+<%=new java.util.Date().getTime()%>+'randoms'
    							}  
							} 

					]
				}
				
			]
		}]
	 
 });
var grid=Ext.create('Ext.panel.Panel', {
	bodyStyle:"background-color:#ffffff;",
	autoScroll:true,  
	items:[userForm,userPhoto]
	
    }
);


new Ext.Viewport({
	bodyStyle:"background-color:#ffffff;",
	enableTabScroll:true,  
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
