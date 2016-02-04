<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
	<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
<script type="text/javascript">
Ext.namespace('processCategory');
Ext.require([
    'Ext.form.*',
    'Ext.tree.Panel',
    'Ext.data.*',
    'Ext.tip.QuickTipManager'
]);

var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';

processCategory.manage=function(){
  return {
              setTree:function(tree){
                this.tree=tree;
             },
     chooseCategory:function(codeId){
       var chooseNode=null;
       var store = Ext.create('Ext.data.TreeStore', {
       model: 'category',
       nodeParam:'nodeId',
      proxy: {
        extraParam:{
           checkFlag:true
        },
        type: 'ajax',
        reader:{
                 type: 'json'
              },
         folderSort: true,
         sorters: [{
                    property: 'nodeId',
                    direction: 'DESC'
         }],
         url : '${ctx}/bpm/getOrgTreeForBpm.do'
     },
    root: {
          id:"0"
          }
  });

   var treePanel=Ext.create('Ext.tree.Panel', {
       autoScroll: true,
       store: store,
       border:false,
       allowDeselect:true,
       tbar:new Ext.Toolbar({
		    style:'border-top:0px;border-left:0px',
		    items:[
				{	
                  xtype:'button',
                  text:"刷新",
					iconCls : "x-btn-text x-tbar-loading",
					handler : function (){
				    treePanel.getStore().load();
			     }
		  },
	   	'->',
	   	 {
            iconCls: 'icon-expand-all',
			tooltip: '展开所有',
            handler: function(){
             treePanel.getRootNode().expand(true); 
             }
         },
        '-',
        {
            iconCls: 'icon-collapse-all',
            tooltip: '折叠所有',
            handler: function(){ 
              treePanel.getRootNode().collapseChildren();
             }
         }]
	    }),
        listeners:{
          checkchange:function(node,checked){
             if(chooseNode&&chooseNode!=node){
                 chooseNode.set('checked',false);
              }
              if(checked){
                  chooseNode=node;
                }else{
                   chooseNode=null;
               }  
            
           }
         },
       rootVisible: false
         });
      var win = new Ext.Window({
							title: '选择编码',
					        closable:true,
					        autoScroll:true,
					        width:340,
					        height:300,
					        modal:true,
					        plain:true,
					        layout:"fit",
					        resizable:false,
					        items: [
                             treePanel
					        ],
					        buttonAlign:'center', 
					    	buttons:[{
					    		text:'确定',
					    	    handler:function(){
					    	      if(chooseNode==null){
					    	       Ext.Msg.alert(SystemConstant.alertTitle, '请选择种类编码!');
					    	       return;
					    	      }
					    	      Ext.getCmp(codeId).setValue(chooseNode.get("type"));
					    	      win.close();
					    	    
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
      addCategory:function(record){
					    var sort = 0;
			        	var curNode = record;
			        	var hideflag=false;
			        	if(curNode == null){
			        		curNode = this.tree.getRootNode();
			        	}
			        	
			        	if(curNode==this.tree.getRootNode()){
			        	    hideflag=true;
			        	}
						var child  = curNode.firstChild;
						while(child){
							sort++;
							child = child.nextSibling;
						}
						
						var addCategoryForm = Ext.create(Ext.form.FormPanel,{
						    bodyPadding: 10,
							border :false,
						    layout : 'vbox', 
						    fieldDefaults: {
                            labelAlign: 'right',
                            msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                            width:260,
                            labelWidth: 80
                            },
						    defaultType:'textfield',
						    defaults:{
						      	allowBlank:false
						    },
						    items:[{
						        xtype:'hidden',
						        name:'category.parentId',
						        value: curNode.get('nodeId')
						    },{
						        xtype:'hidden',
						        name:'category.code'
						    },{
						        xtype:'hidden',
						        name:'category.sort',
						        value: sort
						    }
						    ,{
						        fieldLabel:'种类名称',
						        name:'category.name',
						        maxLength: 100,
						        vtype:'inputCharFilter',
						        blankText : '种类名称不能为空'
						    },{
						      border:false,
						      xtype:'fieldcontainer',
						      fieldLabel:'基础种类编码',
						      hidden:hideflag,
						      layout: 'hbox',
						      items:[
						      {
						        blankText : '种类编码不能空' ,
						        maxLength: 100,
						        id:'addCategoryCode',
						        width:143,
						        allowBlank:hideflag,
						        readOnly:true,
						        xtype:'textfield',
						        regex:/^[a-zA-Z]+(([a-zA-Z]|[0-9])*|(([a-zA-Z]|[0-9]|-)*([a-zA-Z]|[0-9])+))$/,
						        regexText:'必须是以字母开头可包含数字的字符串以及-和字符或数字结尾'
						      },{
						        	xtype : 'box',
						        	html : '<img src="${ctx}/images/icons/addCanAnalysisEvent.png" title="选择种类编码"  style="cursor: pointer;margin: -1 0 0 6;" onclick="processCategory.manage.chooseCategory(\'addCategoryCode\');"/>'
							     }
						      ]
						     },{
						        fieldLabel:'种类编码',
						        id:'baseCategoryCode',
						        maxLength: 100,
						        allowBlank:!hideflag,
						        hidden:!hideflag,
						       regex:/^[a-zA-Z]+(([a-zA-Z]|[0-9])*|(([a-zA-Z]|[0-9]|-)*([a-zA-Z]|[0-9])+))$/,
						      regexText:'必须是以字母开头可包含数字的字符串以及-和字符或数字结尾',
						        blankText : '种类编码不能为空'
						      },{
						        maxLength: 100,
						        allowBlank:true,
						        fieldLabel:'扩展种类编码',
						        id:'extraCategoryCode',
						        hidden:hideflag,
						        xtype:'textfield',
						        regex:/^[a-zA-Z]+(([a-zA-Z]|[0-9])*|(([a-zA-Z]|[0-9]|-)*([a-zA-Z]|[0-9])+))$/,
						        regexText:'必须是以字母开头可包含数字的字符串以及-和字符或数字结尾'
						     },{
						        fieldLabel:'种类描述',
						        xtype:"textarea",
						        name:'category.description',
						        vtype:'inputCharFilter',
						        maxLength:500,
						        allowBlank:true
						    }]
						});

						var win = new Ext.Window({
							title: '添加种类',
					        closable:true,
					        width:320,
					        height:250,
					        modal:true,
					        plain:true,
					        layout:"fit",
					        resizable:false,
					        closeAction : 'destroy',
					        items: [
                             addCategoryForm
					        ],
					        buttonAlign:'center', 
					    	buttons:[{
					    		text:'保存',
					    	    handler:function(){
					    	        if(hideflag){
					    	          addCategoryForm.getForm().findField('category.code').setValue(Ext.getCmp('baseCategoryCode').getValue()); 
					    	        }else{
					    	         if(Ext.String.trim(Ext.getCmp('extraCategoryCode').getValue())==""){
					    	          addCategoryForm.getForm().findField('category.code').setValue(Ext.getCmp('addCategoryCode').getValue()); 
					    	         }else{
					    	           addCategoryForm.getForm().findField('category.code').setValue(Ext.getCmp('extraCategoryCode').getValue()+"_"+Ext.getCmp('addCategoryCode').getValue()); 
					    	          }
					    	        }
						    		if(!addCategoryForm.getForm().isValid()){
					        	    	return;
					        	    }   
						    		addCategoryForm.getForm().submit({
						                url:'${ctx}/bpm/addCategory.do',
						                success:function(form,action){
						                    new Ext.ux.TipsWindow({
                                                title:SystemConstant.alertTitle,
                                                html: action.result.msg
                                            }).show();
						                    processCategory.manage.tree.getStore().load();
						                    win.close();
					              	    },
						              	failure:function(form,action){
					              	    	Ext.Msg.alert("提示",action.result.msg);
						              	}
					                });
					    		}
				    	    },{
				    	       	text:'重置',
				    	       	handler : function(){
				    	       		addCategoryForm.getForm().reset();
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
			   updateCategory : function (record){
				   var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
			        	var curNode = record;
			        	var hideflag=false;
			        	if(curNode.get('parentId') == 0){
			        	    hideflag=true;
			        	}
			        	
			        	var updateCategoryForm = new Ext.form.FormPanel({
			        		bodyPadding: 10,
						    border :false,
						    layout : 'vbox', 
						    fieldDefaults: {
                            labelAlign: 'right',
                            width:260,
                            msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                            labelWidth: 80
                            },
						    defaultType:'textfield',
						    defaults:{
						      	allowBlank:false,
						      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
						    },
						    items:[{
						        xtype:'hidden',
						        name:'category.categoryId',
						        value: curNode.get('nodeId')
						    },{
						        xtype:'hidden',
						        name:'category.parentId',
						        value: curNode.get('parentId')
						    },{
						        xtype:'hidden',
						        name:'category.code',
						        value: curNode.get('type')
						    },{
						        xtype:'hidden',
						        name:'category.sort',
						        value: curNode.get('sort')
						    },{
						        fieldLabel:'种类名称',
						        name:'category.name',
						        value : curNode.get('text'),
						        
						        vtype:'inputCharFilter',
						        maxLength:100,
						        blankText : '种类名称不能为空' 
						    },{
						      border:false,
						      xtype:'fieldcontainer',
						      fieldLabel:'基础种类编码',
						      hidden:hideflag,
						      layout: 'hbox',
						      items:[
						      {
						        blankText : '种类编码不能空' ,
						        maxLength: 100,
						        id:'updateCategoryCode',
						         width:143,
						        allowBlank:hideflag,
						        readOnly:true,
						        xtype:'textfield',
						        regex:/^[a-zA-Z]+(([a-zA-Z]|[0-9])*|(([a-zA-Z]|[0-9]|-)*([a-zA-Z]|[0-9])+))$/,
						        regexText:'必须是以字母开头可包含数字的字符串以及-和字符或数字结尾'
						      },{
						        	xtype : 'box',
						        	html : '<img src="${ctx}/images/icons/addCanAnalysisEvent.png" title="选择种类编码"  style="cursor: pointer;margin: -1 0 0 6;" onclick="processCategory.manage.chooseCategory(\'updateCategoryCode\');"/>'
							     }
						      ]
						     },{
						        fieldLabel:'种类编码',
						        id:'baseCategoryCode',
						        maxLength: 100,
						        allowBlank:!hideflag,
						        hidden:!hideflag,
						         regex:/^[a-zA-Z]+(([a-zA-Z]|[0-9])*|(([a-zA-Z]|[0-9]|-)*([a-zA-Z]|[0-9])+))$/,
						        regexText:'必须是以字母开头可包含数字的字符串以及-和字符或数字结尾',
						        blankText : '种类编码不能为空'
						      },{
						        maxLength: 100,
						        allowBlank:true,
						        fieldLabel:'扩展种类编码',
						        id:'extraCategoryCode',
						        hidden:hideflag,
						        xtype:'textfield',
						        regex:/^[a-zA-Z]+(([a-zA-Z]|[0-9])*|(([a-zA-Z]|[0-9]|-)*([a-zA-Z]|[0-9])+))$/,
						        regexText:'必须是以字母开头可包含数字的字符串以及-和字符或数字结尾'
						     },{
						        fieldLabel:'种类描述',
						        xtype:"textarea",
						        name:'category.description',
						        value : curNode.get('description'),
						        vtype:'inputCharFilter',
						        maxLength: 500,
						        allowBlank:true
						    }],
						    listeners:{
						      afterrender:function(obj){
						        if(hideflag){
						          Ext.getCmp('baseCategoryCode').setValue(curNode.get('type'));
						        }else{
						          if(curNode.get('type')){
						           var index=curNode.get('type').lastIndexOf('_');
						           if(index==-1){
						             Ext.getCmp('updateCategoryCode').setValue(curNode.get('type'));
						             
						           }else{
						            var str=curNode.get('type');
						            Ext.getCmp('extraCategoryCode').setValue(str.substring(0,index));
						            Ext.getCmp('updateCategoryCode').setValue(str.substring(index+1));
						           }
						          }
						        }
						      }
						    }
						    
						});

			        	var win = new Ext.Window({
							title: '修改种类',
					        closable:true,
					        width:320,
					        height:250,
					        modal:true,
					        plain:true,
					        layout :"fit",
					        resizable:false,
					        closeAction : 'destroy',
					        items: [
								updateCategoryForm
					        ],
					        buttonAlign:'center', 
					    	buttons:[{
					    		text:'保存',
					    	    handler:function(){
					    	     if(hideflag){
					    	          updateCategoryForm.getForm().findField('category.code').setValue(Ext.getCmp('baseCategoryCode').getValue()); 
					    	        }else{
					    	         if(Ext.String.trim(Ext.getCmp('extraCategoryCode').getValue())==""){
					    	          updateCategoryForm.getForm().findField('category.code').setValue(Ext.getCmp('updateCategoryCode').getValue()); 
					    	         }else{
					    	          updateCategoryForm.getForm().findField('category.code').setValue(Ext.getCmp('extraCategoryCode').getValue()+"_"+Ext.getCmp('updateCategoryCode').getValue()); 
					    	          }
					    	         }
						    		if(!updateCategoryForm.getForm().isValid()){
					        	    	return;
					        	    }
						    		updateCategoryForm.getForm().submit({
						                url:'${ctx}/bpm/updateCategory.do',
						                 success:function(form,action){
						                	 var result = Ext.decode(action.response.responseText);
							                  new Ext.ux.TipsWindow({
													title:SystemConstant.alertTitle,
													html: result.msg
												}).show();
						                    win.close();
						                    //Ext.Msg.alert("提示",action.result.msg);
						                    var model=processCategory.manage.tree.getSelectionModel();
						                	model.deselect(model.getSelection());
						                	processCategory.manage.tree.getStore().load();
					              	    },
						              	failure:function(form,action){
					              	    	 //Ext.Msg.alert("提示",action.result.msg);
					              	    	 var result = Ext.decode(action.response.responseText);
											Ext.MessageBox.show({
												title: SystemConstant.alertTitle,
												msg: result.msg,
												buttons: Ext.MessageBox.OK,
												icon: Ext.MessageBox.ERROR
											});
						              	}
					                });
					    		}
				    	    },{
				    	       	text:'重置',
				    	       	handler : function(){
				    	    		updateCategoryForm.getForm().reset();
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
	       deleteCategory : function (record){
			        	var curNode = record;
			        	Ext.MessageBox.confirm('信息提示：', '确认要删除'+curNode.get('text')+'吗?', function(btn){
			           	    if (btn == 'yes'){
			           	    var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"正在提交，请等待..."});
			                myMask.show();
			           	   	Ext.Ajax.request({
			           	    	   	url: '${ctx}/bpm/deleteCategory.do',
			           	    	   	params: { ids: curNode.get('nodeId') },
			           	    	 	success: function(response, opts) {
			           	    	 	     myMask.hide();
			           	    	      	var result = Ext.decode(response.responseText);
			           	    	      	var flag = result.success;
			           	    	      	if(flag){
				           	    	      	new Ext.ux.TipsWindow({
	                                            title:SystemConstant.alertTitle,
	                                            html: result.msg
	                                        }).show();
			           	    	      	    processCategory.manage.tree.getStore().load();
			           	    	      	 }  else {
			           	    	      		Ext.Msg.alert("提示",result.msg);
			           	    	      	}
			           	    	   	}, 
			    	 	           failure : function(response) { 
			    	 	           myMask.hide();
			    	 	           Ext.Msg.alert(SystemConstant.alertTitle, '系统繁忙，请稍后再试！');
			    	 	           }
			           	    	});
			           	    }
			           	});
			        },
	     viewCategory : function(record){
			        	var win = new Ext.Window({
							title: '查看种类',
					        closable:true,
					        width:340,
					        height:190,
					        modal:true,
					        plain:false,
					        autoScroll : true,
					        bodyStyle: 'background-color: white;',
					        layout :"fit",
					        resizable:false,
					        buttonAlign:'center', 
					    	buttons:[{
				    	       	text:'关闭',
				    	       	handler:function(){
				    	    		win.close();
				    	    	}
					    	}]
					    });

			        	win.show();

			        	var tpl = new Ext.XTemplate( 
			       			'<table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size: 12px;font-family: \'宋体\', \'sans-serif\'; border:0px;margin:0px;line-height:23px;">',
			       			'<tr>',
			       			'<td width="25%" style="border:1px dotted #999;text-align:right; padding-right:5px;padding-top:5px;padding-bottom:5px;">',
			       		    '种类名称：', 
			       			'</td>',
			       			'<td width="75%" style="border-top: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;padding-top:5px;padding-bottom:5px;">',
			       		    '{name}&nbsp;', 
			       			'</td>',
			       			'</tr>',
			       			'<tr>',
			       			'<td style="border-left: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;text-align:right; padding-right:5px;padding-top:5px;padding-bottom:5px;">',
			       		    '种类编码：', 
			       		    '</td>',
			       			'<td style="border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;padding-top:5px;padding-bottom:5px;">',
			       		    '{code}&nbsp;', 
			       		    '</td>',
			       			'</tr>',
			       			'<tr>',
			       			'<td valign="top" style="border-left: #999 1px dotted;border-right: #999 1px dotted;border-bottom: #999 1px dotted;text-align:right; padding-right:5px;padding-top:5px;padding-bottom:5px;">',
			       		    '描述：', 
			       		    '</td>',
			       			'<td style="border-right: #999 1px dotted;border-bottom: #999 1px dotted;padding-left:5px;padding-top:5px;padding-bottom:5px;">',
			       		    '{remarks}&nbsp;', 
			       		    '</td>',
			       			'</tr>',
			       			'<table>' 
			       		); 

			        	var curNode =record;
						var data = new Object();
						data.name = curNode.get('text');
						data.code = curNode.get('type');
						data.remarks = curNode.get('description');
						tpl.overwrite(win.body, data); 
			        }
   }
}();
Ext.onReady(function(){
   Ext.tip.QuickTipManager.init();
   Ext.define('category', {
    extend: 'Ext.data.Model',
    fields: [
             {name: 'nodeId',type: 'string'}, 
             {name: 'id',type: 'string',mapping:'nodeId'},
             {name: 'text',type: 'string'}, 
             {name: 'parentId',type: 'int'}, 
             {name: 'type',type: 'string'},  
             {name: 'description',type: 'string'}
             ]
   });
   
    var store = Ext.create('Ext.data.TreeStore', {
    model: 'category',
    nodeParam:'nodeId',
    clearOnLoad:true,
    clearRemovedOnLoad:true,
    remoteSort:true,
    proxy: {
        type: 'ajax',
        reader:{
                 type: 'json'
              },
        url : '${ctx}/bpm/getCategoryTree.do'
    },
    root: {
          expanded: true,
          id:0
          }
  });

   var treePanel=Ext.create('Ext.tree.Panel', {
     title:"分类管理",
     autoScroll: true,
     store: store,
     tbar:new Ext.Toolbar({
		    style:'border-top:0px;border-left:0px',
		    items:[
			/* 	{	
                  xtype:'button',
                  id:"add",
                  text:"刷新",
					iconCls : "x-btn-text x-tbar-loading",
					handler : function (){
				    treePanel.getStore().load();
			     }
		  }, */
		'空白处点击鼠标右键添加分类',
	   	'->',
	   	 {
            iconCls: 'icon-expand-all',
			tooltip: '展开所有',
            handler: function(){
             treePanel.getRootNode().expand(true); 
             }
         },
        '-',
        {
            iconCls: 'icon-collapse-all',
            tooltip: '折叠所有',
            handler: function(){ 
              treePanel.getRootNode().collapseChildren();
             }
        }]
	  }),
    listeners:{
       itemcontextmenu:function(obj, record, item, index,e, eOpts ){
                       var dirMenu = new Ext.menu.Menu({
									items : [
									/* {
										text : "添加种类",
										handler : function() {
											processCategory.manage.addCategory(record);
										}
									}, */{
										text : "修改种类",
										handler : function() {
											processCategory.manage.updateCategory(record);
										}
									},{
										text : "查看种类",
										handler : function() {
											processCategory.manage.viewCategory(record);
										}
									},{
										text : "删除种类",
										handler : function() {
											processCategory.manage.deleteCategory(record);
										}
									}] 
									
								});
								dirMenu.showAt(e.getPoint());
								e.preventDefault( );
    
      },
      containercontextmenu:function(obj, e, eOpts ){
         	var treeMenu =Ext.create('Ext.menu.Menu', {
					items : [{
					text : "添加最上级种类",
					handler : function() {
						         processCategory.manage.addCategory(null);
					             }
				            }]
				});
			treeMenu.showAt(e.getPoint());
			e.preventDefault( );
      }
    },
    rootVisible: false
   });
   
   processCategory.manage.setTree(treePanel);
   
   new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[treePanel]
	});
 });

</script>
</head>
<body>
</body>
</html>
