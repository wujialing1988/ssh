<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>流程管理</title>
<link rel="stylesheet" type="text/css" href="${ctx}/styles/icons.css" />
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
Ext.namespace('processForm');
processForm.manage=function(){
  return {
     setGrid:function(grid){
       this.grid=grid;
         },	 
       addProcessForm:function(){
    	   var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
		 var addProcessForm = Ext.create(Ext.form.FormPanel,{
            bodyPadding:'10 20 0 0',
			border :false,
		    layout : 'vbox',
		    fieldDefaults:{
                      labelAlign: 'right',
                      msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                      labelWidth:80
                      },
		    defaultType:'textfield',
		    defaults:{
		      	allowBlank:false,
		      	width:300,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		    },
		    items:[{
		    	xtype:'hidden',
		    	id:'addProcessNodeIds',
		    	name:'activitiForm.adaptationNode'
		    },{
		    	xtype:'hidden',
		    	id:'addCategoryIds',
		    	name:'categoryIds'
		    },{
		        fieldLabel:'表单名称',
		        name:'activitiForm.formName',
		        maxLength: 180,
		        vtype:'inputCharFilter',
		        blankText : '表单名称不能为空'
		    },{
		        fieldLabel:'表单地址',
		        name:'activitiForm.formUrl',
		        maxLength: 180,
		        vtype:'inputCharFilter',
		        blankText : '表单地址不能为空'
		    },{
		    	border:false,
		    	layout:'hbox',
	    		xtype: 'fieldcontainer',
	    		defaults:{
		      	allowBlank:false,
		      	width:270,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		       },
		    	items:[{
			    fieldLabel:'适用种类',
			    id:'addCatatoryNames',
			    xtype:'textfield',
			    readOnly:true,
			    allowBlank:false,
			    //beforeLabelTextTpl: required,
			    blankText : '适用种类不能为空'
		        },
		        {
		        	xtype : 'box',
		        	html : '<img src="${ctx}/images/icons/addCanAnalysisEvent.png" title="选择种类"  style="cursor: pointer;margin: -1 0 0 6;" onclick="processForm.manage.chooseCategory(\'addCatatoryNames\',\'addCategoryIds\');"/>'
			     }]
		    },{
		    	border:false,
		        layout:'hbox',
	    		xtype: 'fieldcontainer',
	    		defaults:{
		      	allowBlank:false,
		      	width:270,
		      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		       },
		    	items:[
					{
					    fieldLabel:'适用节点',
					    id:'addProcessNodeNames',
					    xtype:'textfield',
					    readOnly:true,
					    allowBlank:false,
					    blankText : '适用节点不能为空'
		    	  },{
		        	columnWidth:.1,
		        	xtype : 'box',
		        	html : '<img src="${ctx}/images/icons/addCanAnalysisEvent.png" title="选择节点"  style="cursor: pointer;margin: -1 0 0 6;" onclick="processForm.manage.chooseProcessNode(\'addProcessNodeNames\',\'addProcessNodeIds\');"/>'
			     }]
		    },
		    
		    {
		        fieldLabel:'表单描述',
		        xtype:"textareafield",
		        name:'activitiForm.description',
		        vtype:'inputCharFilter',
		        maxLength:450,
		        height:100,
		        allowBlank:true
		    }]
		});

		var win = new Ext.Window({
			title: '添加表单地址',
	        closable:true,
	        width:360,
	        height:300,
	        modal:true,
	        plain:true,
	        layout:"fit",
	        resizable:false,
	        closeAction : 'destroy',
	        items: [
              addProcessForm
	        ],
	        buttonAlign:'center', 
	    	buttons:[{
    	    text:'保存',
	    	    handler:function(){
	    	    if(!addProcessForm.getForm().isValid()){
	        	    	return;
	        	    }
		        	    
	    	addProcessForm.getForm().submit({
	                url:'${ctx}/bpm/addActivitiForm.do',
	                 waitTitle:"请等待...",
	    		     waitMsg:"正在提交...",
	                success:function(form,action){
	                    new Ext.ux.TipsWindow({
                            title: SystemConstant.alertTitle,
                            autoHide: 3,
                            html:action.result.msg
                        }).show();
	                    processForm.manage.grid.getStore().loadPage(1);
	                    win.close();
              	    },
	              	failure:function(form,action){
	                 	Ext.Msg.alert("提示",action.result.msg);
	                 	Ext.MessageBox.show({
                            title: SystemConstant.alertTitle,
                            msg: action.result.msg,
                            buttons: Ext.MessageBox.OK,
                            icon: Ext.MessageBox.ERROR
                        });
	              	}
                });
			  }
    	      },{
    	       	text:'重置',
    	       	hidden:true,
    	       	handler : function(){
    	       		addProcessForm.getForm().reset();
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
		chooseProcessNode:function(objName,objId){
				    	var choosenNodes=new Array();
				    	var treePanel=Ext.create('Ext.tree.Panel', {
				    	    autoScroll: true,
				    	    border:false,
				    	    rootVisible: false,
				    	    store: Ext.data.StoreManager.lookup('flowNodeStore'),
				    	    listeners:{
	         		    		'checkchange':function(node, checked) {
	         		    			if(checked&&Ext.Array.indexOf(choosenNodes,node)==-1){
	         		    				choosenNodes.push(node);
	         		    			}
	         		    			if(!checked){
	         		    			Ext.Array.remove(choosenNodes,node);
	         		    			}
	         					}
		         			}
				    	})
				    	var win = new Ext.Window({
							title: '选择节点',
					        closable:true,
					        width:300,
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
					    	      if(choosenNodes.length<1){
					    	          Ext.MessageBox.show({
	                                      title: SystemConstant.alertTitle,
	                                      msg: '请选择节点！',
	                                      buttons: Ext.MessageBox.OK,
	                                      icon: Ext.MessageBox.INFO
	                                  });
					    	    	  return;
					    	      }
					    	      var ids=[];
					    	      var names=[];
					    	      for(var i=0;i<choosenNodes.length;i++){
					    	    	  var node=choosenNodes[i];
					    	    	  ids.push(node.get('nodeId'));
					    	    	  names.push(node.get('text'));
					    	      }
					    	      Ext.getCmp(objName).setValue(names.join(","));
					    	      Ext.getCmp(objId).setValue(ids.join(","));
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
						Ext.data.StoreManager.lookup('flowNodeStore').load();
				    },
		chooseCategory:function(objName,objId){
			    var choosenNodes=new Array();
				var treePanel=Ext.create('Ext.tree.Panel', {
				    	    autoScroll: true,
				    	    border:false,
				    	    rootVisible: false,
				    	    store: Ext.data.StoreManager.lookup('categoryStore'),
				    	    listeners:{
	         		    		'checkchange':function(node, checked) {
	         		    			if(checked&&Ext.Array.indexOf(choosenNodes,node)==-1){
	         		    				choosenNodes.push(node);
	         		    			}
	         		    			if(!checked){
	         		    			    Ext.Array.remove(choosenNodes,node)
	         		    				
	         		    			}
	         					}
		         			}
				    	})
				    	var win = new Ext.Window({
							title: '选择种类',
					        closable:true,
					        width:300,
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
					    	      if(choosenNodes.length<1){
					    	          Ext.MessageBox.show({
	                                      title: SystemConstant.alertTitle,
	                                      msg: '请选择种类！',
	                                      buttons: Ext.MessageBox.OK,
	                                      icon: Ext.MessageBox.INFO
	                                  });
					    	    	  return;
					    	      }
					    	      var ids=[];
					    	      var names=[];
					    	      for(var i=0;i<choosenNodes.length;i++){
					    	    	  var node=choosenNodes[i];
					    	    	  ids.push(node.get('nodeId'));
					    	    	  names.push(node.get('text'));
					    	      }
					    	      Ext.getCmp(objName).setValue(names.join(","));
					    	      Ext.getCmp(objId).setValue(ids.join(","));
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
			            Ext.data.StoreManager.lookup('categoryStore').load();
				    },
		updateProcessForm:function(){
	            if(processForm.manage.grid.getSelectionModel().getSelection().length<=0){
		    			    Ext.MessageBox.show({
                                title: SystemConstant.alertTitle,
                                msg: '请选择一条数据修改！',
                                buttons: Ext.MessageBox.OK,
                                icon: Ext.MessageBox.INFO
                            });
							return;
		   			}
	    	    		
		   			if(processForm.manage.grid.getSelectionModel().getSelection().length>1){
	    				Ext.MessageBox.show({
                            title: SystemConstant.alertTitle,
                            msg: '只能选择一条数据修改！',
                            buttons: Ext.MessageBox.OK,
                            icon: Ext.MessageBox.INFO
                        });
						return;
		   			}
		   			 var record=processForm.manage.grid.getSelectionModel().getSelection()[0];

			   		 var str="";
			   		 var categoryIds=""; 
		   			 if(record.get("categories")){
		   				 var categories=record.get("categories");
		   				for(var i=0;i<categories.length;i++){
							if(i==categories.length-1){
								str=str+categories[i].name;
								categoryIds=categoryIds+categories[i].categoryId;
							}else{
							  str=str+categories[i].name+",";
							  categoryIds=categoryIds+categories[i].categoryId+",";
							}
						}
		   			 }
		   			var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
					 var updateProcessForm = new Ext.form.FormPanel({
						    bodyPadding:'10 20 0 0',
							border :false,
						    layout : 'vbox', 
						     fieldDefaults:{
                            labelAlign: 'right',
                            msgTarget : 'side',//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
                            labelWidth:80
                           },
						    defaultType:'textfield',
						    defaults:{
						        width:300,
						      	allowBlank:false,
						      	msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
						    },
						    items:[{
						    	xtype:'hidden',
						    	value:record.get("id"),
						    	name:'activitiForm.id'
						    },{
						    	xtype:'hidden',
						    	id:'updateProcessNodeIds',
						    	value:record.get("adaptationNode"),
						    	name:'activitiForm.adaptationNode'
						    },{
						    	xtype:'hidden',
						    	id:'updateCategoryIds',
						    	value:categoryIds,
						    	name:'categoryIds'
						    },{
						        fieldLabel:'表单名称',
						        name:'activitiForm.formName',
						        maxLength: 180,
						        value:record.get("formName"),
						        vtype:'inputCharFilter',
						        blankText : '表单名称不能为空'
						    },{
						        fieldLabel:'表单地址',
						        name:'activitiForm.formUrl',
						        maxLength: 180,
						        value:record.get("formUrl"),
						        vtype:'inputCharFilter',
						        blankText : '表单地址不能为空'
						    },{
						    	border:false,
						    	layout:'hbox',
						    	defaults:{
		                       	allowBlank:false,
		                       	//beforeLabelTextTpl: required,
		      	                width:270,
		      	                msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		                        },
					    		xtype:'fieldcontainer',
						    	items:[
										{
										    fieldLabel:'适用种类',
										    id:'updateCatatoryNames',
										    xtype:'textfield',
										    readOnly:true,
										    value:str,
										    allowBlank:false,
										    blankText : '适用种类不能为空'
										}
										,{
						        	xtype : 'box',
						        	html : '<img src="${ctx}/images/icons/addCanAnalysisEvent.png" title="选择种类"  style="cursor: pointer;margin: -1 0 0 6;" onclick="processForm.manage.chooseCategory(\'updateCatatoryNames\',\'updateCategoryIds\');"/>'
							     }]
						       },
						    {
						    	border:false,
						    	layout:'hbox',
						    	defaults:{
		                       	allowBlank:false,
		                       	//beforeLabelTextTpl: required,
		      	                width:270,
		      	                msgTarget : 'side'//在该组件的下面显示错误提示信息   取值为'qtip','side','title','under'
		                        },
					    		xtype:'fieldcontainer',
						    	items:[
										{
										 fieldLabel:'适用节点',
										 id:'updateProcessNodeNames',
										 xtype:'textfield',
										 readOnly:true,
										 value:record.get("adaptationName"),
										 allowBlank:false,
										 blankText : '适用节点不能为空'
						    	},{
						        	xtype : 'box',
						        	html : '<img src="${ctx}/images/icons/addCanAnalysisEvent.png" title="选择节点"  style="cursor: pointer;margin: -1 0 0 6;" onclick="processForm.manage.chooseProcessNode(\'updateProcessNodeNames\',\'updateProcessNodeIds\');"/>'
							     }]
						    },
						    {
						        fieldLabel:'表单描述',
						        xtype:"textarea",
						        name:'activitiForm.description',
						        vtype:'inputCharFilter',
						        value:record.get("description"),
						        height:100,
						        maxLength:450,
						        allowBlank:true
						    }]
						});

						var win = new Ext.Window({
							title: '修改表单地址',
					        closable:true,
					        width:360,
					        height:300,
					        modal:true,
					        plain:true,
					        layout:"fit",
					        resizable:false,
					        closeAction : 'destroy',
					        items: [
                               updateProcessForm
					        ],
					        buttonAlign:'center', 
					    	buttons:[{
					    		text:'保存',
					    	    handler:function(){
						    		if(!updateProcessForm.getForm().isValid()){
					        	    	return;
					        	    }
						        	    
						    		updateProcessForm.getForm().submit({
						                url:'${ctx}/bpm/updateActivitiForm.do',
						                 waitTitle:"请等待...",
	    		                         waitMsg:"正在提交...",
						                success:function(form,action){
						                    new Ext.ux.TipsWindow({
	                                            title: SystemConstant.alertTitle,
	                                            autoHide: 3,
	                                            html:action.result.msg
	                                        }).show();
						                    var store=Ext.data.StoreManager.lookup('processFormStore');
						                    store.loadPage(1);
						                    win.close();
					              	    },
						              	failure:function(form,action){
					              	    	Ext.MessageBox.show({
			                                      title: SystemConstant.alertTitle,
			                                      msg: action.result.msg,
			                                      buttons: Ext.MessageBox.OK,
			                                      icon: Ext.MessageBox.ERROR
			                                  });
						              	}
					                });
					    		}
				    	    },{
				    	       	text:'重置',
				    	       	hidden:true,
				    	       	handler : function(){
				    	       		updateProcessForm.getForm().reset();
				    	    	}
				    	    },{
				    	       	text:'关闭',
				    	       	handler:function(){
				    	    		win.close();
				    	    	}
					    	}]
					    });
						win.show();
					}
						,
				    deleteProcessForm:function(){
				    	var ids=[];
				    	var records=processForm.manage.grid.getSelectionModel().getSelection();
				    	  Ext.each(records,function(record){
				    		ids.push(record.get("id"));
				    	  });
				    	  
				    		if(ids.length==0){
				    		    Ext.MessageBox.show({
                                    title: SystemConstant.alertTitle,
                                    msg: '选择要删除的表单地址！',
                                    buttons: Ext.MessageBox.OK,
                                    icon: Ext.MessageBox.INFO
                                });
					       		return;
				    		}

				    		Ext.MessageBox.confirm('信息提示：', '确认要删除这'+records.length+'条数据?', function(btn){
				   	       		if(btn == 'yes'){
				   	       		var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"正在提交，请等待..."});
			                     myMask.show();
				    	    		Ext.Ajax.request({
			 	   	       			url: '${ctx}/bpm/deleteActivitiForm.do',
			 	   	       	    	params: {
			 	   	       	    		ids : ids.toString()
			 	   	       	    	},
			 	   	       	    	success: function(response, opts) {
			 	   	       	    	    myMask.hide();
			 	   	       	    		var result = Ext.decode(response.responseText);
			 		   	       	    	var flag = result.success;
			 					 	 	if(flag){
			 					 	 	     new Ext.ux.TipsWindow({
	                                            title: SystemConstant.alertTitle,
	                                            autoHide: 3,
	                                            html:'删除表单地址成功!'
	                                        }).show();
			 					 	 	     processForm.manage.grid.getStore().loadPage(1);
			 					 	    }else{
			 					 	      Ext.MessageBox.show({
		                                      title: SystemConstant.alertTitle,
		                                      msg: result.msg,
		                                      buttons: Ext.MessageBox.OK,
		                                      icon: Ext.MessageBox.INFO
		                                  });
			 						 	}
			 	   	       	    	},
			    	 	           failure : function(response) { 
			    	 	             myMask.hide();
			    	 	            Ext.MessageBox.show({
	                                      title: SystemConstant.alertTitle,
	                                      msg: '系统繁忙，请稍后再试！',
	                                      buttons: Ext.MessageBox.OK,
	                                      icon: Ext.MessageBox.INFO
	                                  });
			    	 	           }
			    	       	    	});
				   	       	    }
				   	       	});
				   	       	
					 }
      }
}();
Ext.onReady(function(){
    Ext.define('processFormModel', {
     extend: 'Ext.data.Model',
     fields: [
      {name:'id',type:'int'},
	  {name:'formUrl',type:'string'},
	  {name:'formName',type:'string'},
	  {name:'categories',type:'categories'},
	  {name:'description',type:'string'},
	  {name:'adaptationNode',type:'string'},
	  {name:'adaptationName',type:'string'}
     ]
   });
 
  Ext.define('category', {
    extend: 'Ext.data.Model',
    fields: [
             {name: 'nodeId',type: 'string'}, 
             {name: 'id',type: 'string',mapping:'nodeId'},
             {name: 'text',type: 'string'}, 
             {name: 'parentId',type: 'int'}, 
             {name: 'type',type: 'string'}, 
             {name: 'sort',type: 'int'}, 
             {name: 'description',type: 'string'}
             ]
   });
   
 Ext.create('Ext.data.TreeStore', {
    model: 'category',
    storeId:'categoryStore',
    nodeParam:'nodeId',
    autoLoad:false,
    clearOnLoad :true,
    proxy: {
        type: 'ajax',
        extraParams:{checkedFlag:true},
        reader:{
                 type: 'json'
              },
         folderSort: true,
         sorters: [{
                    property: 'nodeId',
                    direction: 'DESC'
         }],
        url : '${ctx}/bpm/getCategoryTree.do'
    },
    root: {
          expanded: true,
          id:"0"
          }
  }); 
   
   
 Ext.create('Ext.data.TreeStore', {
    model: 'category',
    storeId:'flowNodeStore',
    nodeParam:'nodeId',
    clearOnLoad :true,
    autoLoad:false,
    proxy: {
        type: 'ajax',
        extraParams:{checkedFlag:true},
        reader:{
                 type: 'json'
              },
         folderSort: true,
         sorters: [{
                    property: 'nodeId',
                    direction: 'DESC'
         }],
        url :'${ctx}/bpm/getFlowNodeByCheck.do'
    },
    root: {
          expanded: true,
          id:"0"
          }
    });
  
  
Ext.create('Ext.data.JsonStore', {
    clearRemovedOnLoad:true,
    clearOnPageLoad:true,
    autoDestory:true,
    buffered:false,
    storeId:'processFormStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
     storeObj.removeAll(false);
     }
    },
    pageSize: SystemConstant.commonSize,
    model: 'processFormModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
     
        url:'${ctx}/bpm/getActivitiFormByPage.do',
        
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});


var grid=Ext.create('Ext.grid.Panel', {
     title:"表单地址管理",
     store: Ext.data.StoreManager.lookup('processFormStore'),
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
      listeners:{'render': function(g) {    
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
             		},
       itemdblclick: function(grid,record, e){
       	var id = record.get("id");
       	var href="${ctx}/bpm/toViewActivitiForm.do?id="+id;
       	var win = new Ext.Window({
       		title:'查看表单地址',
       		width:400,
            height:280,
       		plain: true,
       		bodyStyle:'background-color:white',
              	modal:true,
              	maximizable : true,
              	closable : true, 
               html:"<iframe width='100%' height='100%' frameborder='0' scrolling='auto'  src='"+href+"'></iframe>",
              	buttonAlign:'center',
              	buttons: [{
                  	text: '关闭',
                  	handler: function(){
              			win.close();
                  	}
          		}]
          	});
       	   
              		   	        	win.show();
       }
              				},
     dockedItems:[
               {
                      xtype:'toolbar',
                    items:[
                     {
           		        	xtype:'hidden',
           		        	id:'queryCategoryId'
           		        },{
           		        	xtype:'hidden',
           		        	id:'queryFlowNodeId'
           		        },
             '&nbsp;分类',
             {
              xtype:'treepicker',
              displayField:'text',
              value:'0',
              rootVisible: true,
              id:'queryCategoryTree',
              width:180,
              listeners:{
	              select:function(view, record, node, rowIndex, e){
	                  Ext.getCmp("queryCategoryId").setValue(record.get('nodeId'));
	              }
              },
              store:new Ext.data.TreeStore({
               clearOnLoad :true,
               model: 'category',
               nodeParam:'nodeId',
               proxy: {
                type: 'ajax',
                extraParams:{checkedFlag:false},
                reader: {
                     type: 'json'
                    },
              url : '${ctx}/bpm/getCategoryTree.do'
         },
        root: {
            expanded: true,
            text:'全部',
            id:'0',
            nodeId:'0'
            }
          })
	      },
	       '&nbsp;表单名称',
			   { 
				   xtype:'textfield',
				   stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
				   id:'queryFormName',
				   width:150
			   },
			    '&nbsp;适用节点',
             {
             
              xtype:'treepicker',
              width:150,
              id:'queryFlowNodeTree',
              displayField:'text',
              value:'none',
              rootVisible: true,
              listeners:{
                 select:function(view, record, node, rowIndex, e){
                   Ext.getCmp("queryFlowNodeId").setValue(record.get('nodeId'));
               }
              },
              store:new Ext.data.TreeStore({
               clearOnLoad :true,
               model: 'category',
               nodeParam:'nodeId',
               proxy: {
                type: 'ajax',
                extraParams:{checkedFlag:false},
                reader: {
                     type: 'json'
                    },
              	url :'${ctx}/bpm/getFlowNodeByCheck.do'
         },
        root: {
            expanded: true,
            text:'全部',
            id:'none',
            nodeId:'none'
            }
          })
	      },
	         {
	    	 text :   "查询", 
	    	 iconCls: "search-button", 
	    	 handler:function(){
	    	 var proxy=grid.getStore().getProxy( );
	    	 proxy.setExtraParam("categoryId",Ext.getCmp("queryCategoryId").getValue());
	    	 proxy.setExtraParam("adaptationNode",Ext.getCmp("queryFlowNodeId").getValue());
	    	 proxy.setExtraParam("formName",Ext.getCmp("queryFormName").getValue());
             grid.getStore().load();
               
            } 
	   	  },
		   {
		    	text :   "重置", 
		    	 	hidden:true,
		    	iconCls: "reset-button", 
		    	handler:function(){
		    	  Ext.getCmp("queryCategoryId").setValue();
				  Ext.getCmp("queryFlowNodeId").setValue();
				  Ext.getCmp("queryFormName").setValue();
				  Ext.getCmp('queryFlowNodeTree').setValue("");
				  Ext.getCmp('queryCategoryTree').setValue("");
	          } 
		    }, '->',
    	   	{
				text : "添加",
    	    	iconCls: "add-button",
    	    	id:'add',
    	    	handler:function(){
    	    	  processForm.manage.addProcessForm();
    	    	}
    	   	},
    	   	{
				text : "修改",
    	    	iconCls: "edit-button",
    	    	id:'update',
    	    	disabled:true,
    	    	handler:function(){
    	    	    processForm.manage.updateProcessForm();
    	    	}
    	   	},
    	   	{
    	    	text : "删除",
    	    	iconCls: "delete-button",
    	    	disabled:true,
    	    	id:'delete',
    	    	handler:function(){
    	    	    processForm.manage.deleteProcessForm();
    	    	}
           	}]
       }],
     bbar: {
                xtype: 'pagingtoolbar',
               pageSize: SystemConstant.commonSize,
                store: Ext.data.StoreManager.lookup('processFormStore'),
                displayInfo: true
       },
        columns: {
         items: [
                 {header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},   
                 {header:'表单名称',dataIndex:'formName',sortable:false,menuDisabled:true},
	             {header:'表单地址',dataIndex:'formUrl',sortable:false,menuDisabled:true},
	             {header:'分类',dataIndex:'categories',sortable:false,menuDisabled:true,renderer:function(categories, cellmeta, record, rowIndex, columnIndex, store){
								var str="";	
								for(var i=0;i<categories.length;i++){
									if(i==categories.length-1){
										str=str+categories[i].name
									}else{
		                            	str=str+categories[i].name+",";;
									}
								}
								return str;
	               }},
				{
				header:'适用节点',dataIndex:'adaptationName',sortable:false,menuDisabled:true},
				{  
				 header:'操作',
				 xtype:'actioncolumn',
				 width:50,
				 hidden:true,
				 items: [{
				 icon: '${ctx}/images/icons/view.gif',  // Use a URL in the icon config
				 tooltip: '预览界面',
				 handler: function(grid, rowIndex, colIndex) {
				 var rec = grid.getStore().getAt(rowIndex);
				  var formUrl=rec.get("formUrl");
				  var href="${ctx}/bpm/"+formUrl+"?viewFlag=true";
	              var win = new Ext.Window({
	               title: '查看表单地址',
			       closable:true,
			       width:650,
			       height:380,
			       modal:true,
			       autoScroll:true,
			       plain:true,
			       layout:"fit",
			       resizable:false,
			       html:"<iframe width='100%' height='100%' frameborder='0' scrolling='auto'  src='"+href+"'></iframe>",
			       buttonAlign:'center', 
			   	buttons:[{
		   	       	text:'关闭',
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
    }
});

processForm.manage.setGrid(grid);
grid.getStore().load();

new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[grid]
	});
});

</script>
</head>
<body>
</body>
</html>
