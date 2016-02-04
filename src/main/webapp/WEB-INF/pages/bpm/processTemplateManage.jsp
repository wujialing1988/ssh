<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="../common/taglibs.jsp"%>
<%@include file="../common/ext.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>流程管理</title>
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
Ext.namespace('processTemplate');

processTemplate.manage=function(){
  return {
    setGrid:function(grid){
       this.grid=grid;
    },
    viewActivitiDefineTemplate:function(){
					 var selects=processTemplate.manage.grid.getSelectionModel().getSelection();
					 var length=selects.length;
			    		if(length==0){
                            Ext.MessageBox.show({
                                title: SystemConstant.alertTitle,
                                msg: '选择要查看的流程模板！',
                                buttons: Ext.MessageBox.OK,
                                icon: Ext.MessageBox.INFO
                            });
				       		return;
			    		};
			    		if(length>1){
			    		  Ext.MessageBox.show({
                              title: SystemConstant.alertTitle,
                              msg: '只能选择一条流程模板查看！',
                              buttons: Ext.MessageBox.OK,
                              icon: Ext.MessageBox.INFO
                          });
				          return;
			    		}
			    	 var processDefineKey=selects[0].get("processDefineKey");
			    	 var href="${ctx}/bpm/toProcessListener.do?processDefineKey="+processDefineKey+"&operate=view";
						var win = new Ext.Window({
			    			title:'查看流程图',
			    			width:650,
			    			maximizable:true,
			 		        height:360,
			 		        autoScroll:false,
			    		    y:20,
			    			plain: false,
			    	       	modal:true,
			    	       	closable :true, 
			    	    	html:"<iframe width='100%' height='100%' frameborder='0' scrolling='auto'  src='"+href+"'></iframe>",
			    	       	style : 'background-color: white;padding: 0px;',
			    	       	buttonAlign:'center'
			    	   	});
			        	win.show();
			        	
				 },
    deleteActivitiDefineTemplate:function(){
					    var selects=processTemplate.manage.grid.getSelectionModel().getSelection();
					    var ids=[];
					    if(selects.length<1){
					         Ext.MessageBox.show({
	                              title: SystemConstant.alertTitle,
	                              msg: '请选择要删除的流程模板！',
	                              buttons: Ext.MessageBox.OK,
	                              icon: Ext.MessageBox.INFO
	                          });
				       		 return;
					    }
					    for(var i=0;i<selects.length;i++){
					      ids.push(selects[i].get("id"));
					    }
					    
			    		Ext.MessageBox.confirm('信息提示：', '确认要删除这'+selects.length+'条数据?', function(btn){
			   	       		if(btn == 'yes'){
			   	       		var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"正在提交，请等待..."});
			                myMask.show();
			    	    	Ext.Ajax.request({
		 	   	       			url: '${ctx}/bpm/deleteActivitiDefineTemplate.do',
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
                                            html:'流程定义删除成功!'
                                        }).show();
		 		   	       	    		processTemplate.manage.grid.getStore().loadPage(1);
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
                                      icon: Ext.MessageBox.ERROR
                                  });
			    	 	        }
		    	       	    	});
			   	       	    }
			   	       	});
          },
         startProcess:function(){
                      var selects=processTemplate.manage.grid.getSelectionModel().getSelection();
                   
					  var length=selects.length;
			    		if(length==0){
			    		    Ext.MessageBox.show({
                                title: SystemConstant.alertTitle,
                                msg: '请选择模板发起流程！',
                                buttons: Ext.MessageBox.OK,
                                icon: Ext.MessageBox.INFO
                            });
				       		return;
			    		};
			    		if(length>1){
			    		  Ext.MessageBox.show({
                              title: SystemConstant.alertTitle,
                              msg: '只能选择一条数据发起！',
                              buttons: Ext.MessageBox.OK,
                              icon: Ext.MessageBox.INFO
                          });
				       		return;
			    		 }
			    		 
					    Ext.MessageBox.confirm('信息提示：', '确认发起这'+selects.length+'条数据的流程?', function(btn){
			   	       		if(btn == 'yes'){
			   	       		var myMask = new Ext.LoadMask(Ext.getBody(), {msg:"正在发起流程,请稍后...!"});
                            myMask.show();
			    	    	Ext.Ajax.request({
		 	   	       			url: '${ctx}/bpm/startProcess.do',
		 	   	       	    	params: {
		 	   	       	    		id : selects[0].get("id"),
		 	   	       	    		processType: selects[0].get("categoryName"),
		 	   	       	    		processCode:selects[0].get("processDefineKey"),
		 	   	       	    		processName:  selects[0].get("name"),
		 	   	       	    		businessOrg:2
		 	   	       	    	},
		 	   	       	    	success: function(response, opts) {
		 	   	       	    		var result = Ext.decode(response.responseText);
		 		   	       	    	var flag = result.success;
		 					 	 	if(flag){
			 					 	 	 new Ext.ux.TipsWindow({
	                                         title: SystemConstant.alertTitle,
	                                         autoHide: 3,
	                                         html:'发起流程成功!'
	                                     }).show();
		 		   	       	    		processTemplate.manage.grid.getStore().loadPage(1);
		 					 	    }else{
		 					 	      Ext.MessageBox.show({
	                                      title: SystemConstant.alertTitle,
	                                      msg: result.msg,
	                                      buttons: Ext.MessageBox.OK,
	                                      icon: Ext.MessageBox.INFO
	                                  });
		 						 	}
		 						 	myMask.hide();
		 	   	       	    	 },
		 	   	       	    	  failure: function(response, opts) {
		 	   	       	    	     myMask.hide();
                                     Ext.MessageBox.show({
                                         title: SystemConstant.alertTitle,
                                         msg: '发起流程失败!',
                                         buttons: Ext.MessageBox.OK,
                                         icon: Ext.MessageBox.ERROR
                                     });
                                   }
		    	       	    	});
			   	         	 }
			   	       	 })
			   	      }
      }
}();
Ext.onReady(function(){
   Ext.define('processTemplateModel', {
     extend: 'Ext.data.Model',
     fields: [
       {name:'id',type:'int'},
       {name:'name',type:'string'},
	   {name:'processDefineKey',type:'string'},
	   {name:'categoryName',type:'string'}
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
 Ext.create('Ext.data.JsonStore', {
    clearRemovedOnLoad:true,
    clearOnPageLoad:true,
    autoDestory:true,
    buffered:false,
    storeId:'processTemplateStore',
    autoLoad:false,
    listeners:{
    beforeload:function(storeObj){
      storeObj.removeAll(false);
     }
    },
    pageSize:SystemConstant.commonSize,
    model: 'processTemplateModel',
    proxy: {
        type: 'ajax',
        actionMethods:{read: 'POST'},
        url:'${ctx}/bpm/getActivitiDefineTemplateByPage.do',
        reader: {
            type: 'json',
            totalProperty:'totalSize',
            root: 'list'
        }
    }
});


var grid=Ext.create('Ext.grid.Panel', {
     title:'流程模版管理',
     store: Ext.data.StoreManager.lookup('processTemplateStore'),
     forceFit:true,
     loadMask: true,
     columnLines: true,
     selType:'checkboxmodel',
      selModel: {
		injectCheckbox:1,
		mode:"SINGLE",
      listeners : {
      	
				"selectionchange" : function(win) {

					if (grid.getSelectionModel().getSelection().length != 0) { //选择了的行
						
						Ext.Ajax.request({
				        	url: '${ctx}/bpm/isProcessExist.action',
				         	params: {processDefineKey:grid.getSelectionModel().getSelection()[0].get("processDefineKey")},
				         	success: function(response, opts) {
				         		var result = Ext.decode(response.responseText);
				         		if(result.exists){
				         			//Ext.getCmp('update').setDisabled(true);
				         			//Ext.getCmp('delete').setDisabled(true);
				         		}else{
				         			Ext.getCmp('update').setDisabled(false);
				         			Ext.getCmp('delete').setDisabled(false);
				         		}
				         	}
						});
						
						
						
						if(grid.getSelectionModel().getSelection().length==1){
							Ext.getCmp('update').setDisabled(false);
							Ext.getCmp('delete').setDisabled(false);
							Ext.getCmp('startProcess').setDisabled(false);
							Ext.getCmp('view').setDisabled(false);
						}else{
							Ext.getCmp('update').setDisabled(true);
							Ext.getCmp('delete').setDisabled(false);
							Ext.getCmp('startProcess').setDisabled(true);
							Ext.getCmp('view').setDisabled(true);
						}
					}else{
							Ext.getCmp('update').setDisabled(true);
							Ext.getCmp('delete').setDisabled(true);
							Ext.getCmp('startProcess').setDisabled(true);
							Ext.getCmp('view').setDisabled(true);
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
         	itemdblclick:function(obj, record, item, index, e, eOpts ){
         	
           var id = record.get("id");
           var href="${ctx}/bpm/getActivitiDefineTemplateInfo.do?id="+id;
           var win = new Ext.Window({
  			title:'查看表单地址',
  			width:600,
            height:360,
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
     dockedItems:[{
         xtype:'toolbar',
         items:[
            {
             xtype:'hidden',
             id:'queryCategoryId'
            },
            '&nbsp;分类',
            {
              xtype:'treepicker',
              displayField:'text',
              id:'queryCategoryTree',
              value:'0',
              rootVisible: true,
              width:180,
              listeners:{
                 select:function(view, record, node, rowIndex, e){
                 Ext.getCmp("queryCategoryId").setValue(record.get('nodeId'));
               }
              },
              store:new Ext.data.TreeStore({
               clearOnLoad :true,
               autoLoad:false,
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
         	'&nbsp;名称',
           {
            xtype:'textfield',
            id:'templateName',
	         width:'100'
	       },
	       {
	    	 text :   "查询", 
	    	 iconCls: "search-button", 
	    	 handler:function(){
	    	  var proxy=grid.getStore().getProxy( );
	    	   proxy.setExtraParam("categoryId",Ext.getCmp("queryCategoryId").getValue());
	    	   proxy.setExtraParam("templateName",Ext.getCmp("templateName").getValue());
               grid.getStore().load();
              } 
	   	  },
		   {
		    	text :   "重置", 
		    	iconCls: "reset-button", 
		    	hidden:true,
		    	handler:function(){
		    		Ext.getCmp('templateName').setValue();
		    		Ext.getCmp('queryCategoryId').setValue();
		    		Ext.getCmp("queryCategoryTree").setValue("");
	          } 
		    },
		    '->',
	    	   	{
					text : "添加",
	    	    	iconCls: "add-button",
	    	    	id:'add',
	    	    	handler:function(){
	    	    		addActivitiDefineTemplate("add");
	    	    	}
	    	   	},
	    	   	
	    	   	' ',
	    	   	{
					text : "修改",
	    	    	iconCls: "edit-button",
	    	    	id:'update',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    		updateActivitiDefineTemplate();
	    	    	}
	    	   	},
	    	   	' ',
	    	   	{
	    	    	text : "删除",
	    	    	iconCls: "delete-button",
	    	    	id:'delete',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    		processTemplate.manage.deleteActivitiDefineTemplate();
	    	    	}
	           	},
	         	' ',
	    	   	{
					text : "查看",
	    	    	iconCls: "icon-sendReview",
	    	    	id:'view',
	    	    	disabled:true,
	    	    	handler:function(){
	    	    		processTemplate.manage.viewActivitiDefineTemplate();
	    	    	}
	    	   	}
	    	   	/* ,
	         	'-' */,
	    	   	{
					text : "启动流程",
	    	    	iconCls: "icon-sendReview",
	    	    	id:'startProcess',
					hidden:false,
					disabled:false,
	    	    	handler:function(){
	    	    		processTemplate.manage.startProcess();
	    	    	}
	    	   	}
	        ]
       }],
     bbar: {
                xtype: 'pagingtoolbar',
                pageSize:SystemConstant.commonSize,
                store: Ext.data.StoreManager.lookup('processTemplateStore'),
                displayInfo: true
       },
     columns: {
      items: [
       {header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},
       {header:'名称',dataIndex:'name',sortable:false,menuDisabled:true},
	   {header:'编码',dataIndex:'processDefineKey',sortable:false,menuDisabled:true},
	   {header:'分类',dataIndex:'categoryName',sortable:false,menuDisabled:true} 
     ]
    }
});

processTemplate.manage.setGrid(grid);
grid.getStore().load();
new Ext.Viewport({
		border:false,
		layout:'fit',
		items:[grid]
	})
});

function updateActivitiDefineTemplate(){
                     var selects=processTemplate.manage.grid.getSelectionModel().getSelection();
                   
					 var length=selects.length;
			    		if(length==0){
			    		    Ext.MessageBox.show({
                                title: SystemConstant.alertTitle,
                                msg: '选择要修改的流程模板！',
                                buttons: Ext.MessageBox.OK,
                                icon: Ext.MessageBox.INFO
                            });
				       		return;
			    		};
			    		if(length>1){
			    		    Ext.MessageBox.show({
	                            title: SystemConstant.alertTitle,
	                            msg: '只能选择一条流程模板！',
	                            buttons: Ext.MessageBox.OK,
	                            icon: Ext.MessageBox.INFO
	                        });
				       		return;
			    		}
			    		
			    	 var processDefineKey=selects[0].get("processDefineKey");
	                 window.open("${ctx}/bpm/toProcessDesigner.do?processDefineKey="+processDefineKey+"&operate=modify","_blank");
}

function addActivitiDefineTemplate(operate){
	 window.open("${ctx}/bpm/toProcessDesigner.do?operate="+operate,"_blank");
}


function  refleshProcess(operate){
	 try{
		 processTemplate.manage.grid.getStore().loadPage(1);
	 }catch(e){
		 
	 }
	
} 

</script>
</head>
<body>
</body>
</html>
