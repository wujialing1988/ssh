<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>字典管理</title>
<link href="" rel="SHORTCUT ICON" />
<style type="text/css">
  .x-form-layout-table{
	table-layout: fixed;
  }
</style>
</head>
<body>
	<script type="text/javascript">
	var required = '<span style="color:red;font-weight:bold" data-qtip="Required">*</span>';
	
	Ext.onReady(function() {
		Ext.QuickTips.init();
		//自动引入其他需要的js
		Ext.require(["Ext.container.*",
		             "Ext.grid.*", 
		             "Ext.toolbar.Paging", 
		             "Ext.form.*",
					 "Ext.data.*" ]);
		//建立Model模型对象
		Ext.define("Dict",{
			extend:"Ext.data.Model",
			fields:[
				{name: "id"}, 
				{name: "dictionaryName"}, 
				{name: "parentName"}, 
				{name: "parentId"},
				{name: "levelOrder"},
				{name: "dictionaryValue"},
				{name: "dictionaryCode"}
			]
		});
		
		//建立数据Store
		var dictStore=Ext.create("Ext.data.Store", {
	        pageSize: SystemConstant.commonSize,
	        model:"Dict",
	        remoteSort:true,
			proxy: {
	            type:"ajax",
	            actionMethods: {
                	read: 'POST'
           		},
			    url: "${ctx}/dict/getDictList.action",
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
		var sm=Ext.create("Ext.selection.CheckboxModel",{
			injectCheckbox:1,
	    	listeners: {
		        selectionchange: function(){
		        	var c = dictGrid.getSelectionModel().getSelection();
				 	if(c.length > 0){
						Ext.getCmp('delDicBtn').setDisabled(false);
				 	}else{
					 	Ext.getCmp('delDicBtn').setDisabled(true);
				 	}
				 	if(c.length == 1){
					 	Ext.getCmp('updateDicBtn').setDisabled(false);
				 	}else{
					 	Ext.getCmp('updateDicBtn').setDisabled(true);
				 	}
		        }
			}
	    });
		
		var cm=[
				{header:"序号",xtype: "rownumberer",width:60,align:"center",menuDisabled: true,sortable :false},
	            {header: "ID", width: 70, dataIndex: "id", hidden:true, menuDisabled: true, sortable :false},
	            {header: "字典名称",width: 200,dataIndex: "dictionaryName",menuDisabled: true,sortable :false},
	            {header: "字典类型",width: 200,dataIndex: "parentName",menuDisabled: true,sortable :false},
	            {header: "字典值",width: 200,dataIndex: "dictionaryValue",menuDisabled: true,sortable :false},
	            {header: "字典编码",width: 200,dataIndex: "dictionaryCode",menuDisabled: true,sortable :false},
	            {header: "等级或排序",width: 200,dataIndex: "levelOrder",menuDisabled: true,sortable :false}
	         ];
		
		var typeNameStore = Ext.create('Ext.data.Store', {
		     model: 'Dict',
		     proxy: {
		         type: 'ajax',
		         actionMethods: {
                     read: 'POST'
                 },
		         url: '${ctx}/dict/getDictTypes.action',
		         reader: {
		             type: 'json'
		         }
		     },
		     autoLoad: true,
		     listeners:{
	     		load:function(store, records){
	     			var obj = {dictionaryCode:'', dictionaryName:'全部'};
                    store.insert(0, obj);
	     		}
	     	}
		});
		
		var typeStoreForAdd = Ext.create('Ext.data.Store', {
            model: 'Dict',
            proxy: {
                type: 'ajax',
                actionMethods: {
                    read: 'POST'
                },
                url: '${ctx}/dict/getDictTypes.action',
                reader: {
                    type: 'json'
                }
            },
		    autoLoad: true
       });
		
		//grid组件
		var dictGrid =  Ext.create("Ext.grid.Panel",{
			title:'字典管理',
			border:false,
			columnLines: true,
			layout:"fit",
			region: "center",
			width: "100%",
			height: document.body.clientHeight,
			id: "dictGrid",
			bbar:  Ext.create("Ext.PagingToolbar", {
				store: dictStore,
				displayInfo: true,
				displayMsg: SystemConstant.displayMsg,
				emptyMsg: SystemConstant.emptyMsg
			}),
			columns:cm,
	        selModel:sm,
	     	forceFit : true,
			store: dictStore,
			autoScroll: true,
			stripeRows: true,
			tbar: ['字典名称',
			{
				id: 'dictName',
				stripCharsRe : /^\s+|\s+$/g, // 禁止输入空格
				labelWidth: 70,
				xtype: 'textfield'
			},'&nbsp;字典类型',
			{
				id:'typeCombox',
				xtype: 'combobox',
				queryMode: 'remote',
				//queryCaching:false,
				labelWidth: 70,   
				store: typeNameStore,
				displayField: 'dictionaryName',
				valueField: 'dictionaryCode',
				listeners:{
	            	afterrender:function(combox,eOpts){
	            		combox.select('');
	            	}
	            }
			},
			{
				id:'searchDicBtn',
				xtype:'button',
				disabled:false,
				text:'查询',
				iconCls:'search-button',
				handler:function(){
					var proxy = dictStore.getProxy();
					proxy.setExtraParam("dictName", Ext.getCmp("dictName").getValue());
					proxy.setExtraParam("dictType", Ext.getCmp("typeCombox").getValue());
					dictStore.loadPage(1);
				}
			},'->',
			{
				id:'addDicBtn',
				xtype:'button',
				disabled:false,
				text:'添加',
				iconCls:'add-button',
				handler:function(){
					createAddDictInfo();
				}
			},
			{
				id:'updateDicBtn',
				xtype:'button',
				text:'修改',
				disabled:true,
				iconCls:'edit-button',
				handler:function(){
					createUpdateDictInfo();
				}
			},
			{
				id:'delDicBtn',
				xtype:'button',
				text:'删除',
				disabled:true,
				iconCls:'delete-button',
				handler:function(){
					var ck = Ext.getCmp('dictGrid').getSelectionModel().getSelection();
					var itemsArray = new Array();
					for(var i=0;i<ck.length;i++){
						itemsArray.push(ck[i].data.id);
					}
					var dictIds = itemsArray.toString();
					Ext.Ajax.request({
						url : '${ctx}/dict/isCanDelete.action',
						params : {ids: dictIds},
						success : function(res, options) {
							 var data = Ext.decode(res.responseText);
							 if(data.success){
								 Ext.Msg.confirm(SystemConstant.alertTitle,"确认删除所选字典数据吗？",function(btn) {
			                        if (btn == 'yes') {
			                        	Ext.MessageBox.wait("", "删除字典数据", {
		                                    text:"请稍后..."
		                                });
			                            
			                            Ext.Ajax.request({
			                                url : '${ctx}/dict/deleteDict.action',
			                                params : {ids: dictIds},
			                                success : function(res, options) {
			                                    var result = Ext.decode(res.responseText);
			                                    if(result.success){
			                                    	Ext.MessageBox.hide();
			                                        new Ext.ux.TipsWindow({
	                                                    title: SystemConstant.alertTitle,
	                                                    autoHide: 3,
	                                                    html:result.msg
	                                                }).show();
			                                    }else{
			                                    	Ext.MessageBox.hide();
			                                        Ext.MessageBox.show({
			                                            title: SystemConstant.alertTitle,
			                                            msg: result.msg,
			                                            buttons: Ext.MessageBox.OK,
			                                            icon: Ext.MessageBox.INFO
			                                        });
			                                    }
			                                    dictStore.loadPage(1);
			                                }
			                            });
			                        }
			                    });
							 }else{
							 	//dictStore.loadPage(1);
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
			}]
		});
		dictStore.load({params:{start:0,limit:SystemConstant.commonSize}});
		
		Ext.create("Ext.container.Viewport", {
		    layout: "border",
			items: [dictGrid]
		});
		
		//添加字典信息窗口哦
		var createAddDictInfo = function(){
			var dictForm = Ext.create("Ext.form.Panel", {
				layout: 'form',
				bodyStyle :'padding:15px 10px 0 0',
				border: false,
				labelAlign: 'right',
				fieldDefaults: {
		            labelWidth: 100,
		        	labelAlign: 'right'
		        },
		        defaults: {
			        anchor: '60%'
			    },
			    defaultType: 'textfield',
			    items: [{
			        fieldLabel: 'ID',
			        name: 'typeId',
			        value:null,
			        hidden:true,
			        width: 100,
			        allowBlank: true
			    }, 
			    {
	                id:'selectItem',
			    	fieldLabel:'请选择',
	                xtype:'radiogroup',
	                columns:2,
	                name:'selectItem',
	                items:[{
	                	id:'type',
	                    xtype:'radiofield', 
	                    boxLabel :'类型',
	                    inputValue:'0',
	                    name:'dictionary.flag'
	                },{
	                	id:'data',
	                    xtype:'radiofield',
	                    boxLabel :'数据',
	                    inputValue:'1',
	                    checked:true,
	                    name:'dictionary.flag'
	                }],
	                listeners:{
	                	change:function(){
	                		var ss = Ext.getCmp("selectItem").getChecked()[0].inputValue;
	                    	if(ss == "0"){
	                    		Ext.getCmp('typeName').setVisible(false);
	                    		Ext.getCmp('typeCode').setVisible(true);
	                    		Ext.getCmp('dicName').setVisible(false);
	                    		Ext.getCmp('dicCode').setVisible(false); 
	                    		Ext.getCmp('typeNameText').setVisible(true);
	                    		
	                    		Ext.getCmp('typeNameText').setDisabled(false);
	                    		Ext.getCmp('typeCode').setDisabled(false);
	                    		Ext.getCmp('typeName').setDisabled(true);
	                    		Ext.getCmp('dicName').setDisabled(true);
	                    		Ext.getCmp('dicCode').setDisabled(true); 
	                    	}else{
	                    		Ext.getCmp('typeName').setVisible(true);
	                    		Ext.getCmp('typeCode').setVisible(false);
	                    		Ext.getCmp('dicName').setVisible(true);
	                    		Ext.getCmp('dicCode').setVisible(true); 
	                    		Ext.getCmp('typeNameText').setVisible(false);
	                    		
	                    		Ext.getCmp('typeNameText').setDisabled(true);
	                    		Ext.getCmp('typeCode').setDisabled(true);
	                    		Ext.getCmp('typeName').setDisabled(false);
	                    		Ext.getCmp('dicName').setDisabled(false);
	                    		Ext.getCmp('dicCode').setDisabled(false); 
	                    	}
	                    }
	                }
			    }, 
			    {
			    	id:'typeName',
			        fieldLabel: '类型名称',
			        xtype: 'combobox', 
			        name: 'dictionary.parentId',
			        disabled:false,
			        hidden:false,
			        editable:false,
			        queryMode: 'remote',
			        displayField: 'dictionaryName',
					valueField: 'id',
			        maxLength:25,
			        width:100,
			        store: typeStoreForAdd,
			        allowBlank: false
			    }, 
			    {
			    	id:'typeNameText',
			        fieldLabel: '类型名称',
			        name: 'dictionary.parentName',
			        readOnly:false,
			        disabled:true,
			        hidden:true,
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符',
			        maxLength:25,
			        width:100,
			        allowBlank: false
			    },
			    {
			    	id:'typeCode',
			    	fieldLabel: '类型编码',
			    	name: 'dictionary.dictionaryCode',
			    	regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
			    	regexText : '不能包含特殊字符',
			    	maxLength:50,
			    	minValue:1,
			    	disabled:true,
			    	hidden:true,
			    	width: 100,
			    	allowBlank: false,
			    	validator: function(value){
						var returnObj = null;
						$.ajax({
							url : '${ctx}/dict/validateDict.action',
							data:{dictField : 'dictCode', value : value},
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
						return returnObj;
					}
			    },
			    {
			    	id: 'dicName',
			        fieldLabel: '字典名称',
			        name: 'dictionary.dictionaryName',
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符',
					maxLength:25,
			        width: 100,
			        allowBlank: false
			    }, 
			    {
			    	id: 'dicCode',
			    	fieldLabel: '字典编码',
			    	name: 'dictionary.dictionaryCode',
			    	regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
			    	regexText : '不能包含特殊字符',
			    	maxLength:50,
			    	minValue:1,
			    	width: 100,
			    	allowBlank: false,
			     	validator: function(value){
						var returnObj = null;
						$.ajax({
							url : '${ctx}/dict/validateDict.action',
							data:{dictField:'dictCode', value:value},
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
						return returnObj;
					} 
			    },
			    {
			        fieldLabel: '字典值',
			        name: 'dictionary.dictionaryValue',
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符',
			        maxLength:50,
			        minValue:1,
			        width: 100,
			        allowBlank: false
			    },
			    {
			        fieldLabel: '排序',
			        name: 'dictionary.levelOrder',
			        maxLength:8,
			        regex : /^[0-9]*[1-9][0-9]*$/,
					regexText : '请输入正整数',
			        width: 100,
			        allowBlank: false
			    }]
			});
			
			var dictWin=Ext.create("Ext.window.Window",{
				title: '添加',
				resizable: false,
				buttonAlign:"center",
			  	height: 250,
			    width: 350,
			    layout: 'fit',
			    closeAction : 'destroy',
			    modal : true,
			    items: [dictForm],
			    buttons:[{
					    text: SystemConstant.saveBtnText,
				    	handler: function(){
				    		if(dictForm.form.isValid()){
		    				    Ext.MessageBox.wait("", "添加字典数据", {
									text:"请稍后..."
								});
				    			dictForm.form.submit({
				    				url:"${ctx}/dict/addDict.action",
			    				    success : function(form, action) {
			    					    new Ext.ux.TipsWindow({
											title: SystemConstant.alertTitle,
											autoHide: 3,
											html:action.result.msg
										}).show();
			    					    
			    					    dictStore.load();
			    					    dictWin.close();
			    					    Ext.MessageBox.hide();
			    				   },
			    				   failure : function(form,action){
			    					    Ext.MessageBox.show({
			    						    title:'提示信息',
			    						    msg:action.result.msg,
			    						    buttons: Ext.Msg.YES,
			    						    modal : true,
			    						    icon: Ext.Msg.ERROR
			    					    });
			    					    
			    					    dictStore.load();
			    					    dictWin.close();
			    					    Ext.MessageBox.hide();
			    				    }
				    			});
			 				}
		                }
					},{
					    text: '关闭',
		                handler: function(){
		                	dictWin.close();
		                }
				}]
			 }).show();
		};
		
		//修改字典信息
		var createUpdateDictInfo = function(){
			var row = dictGrid.getSelectionModel().getSelection();
			var tname = row[0].get('dictionaryName');
			var dname = row[0].get('dictionaryName');
			var dictForm = Ext.create("Ext.form.Panel", {
				layout: 'form',
				bodyStyle :'padding:15px 10px 0 0',
				border: false,
				labelAlign: 'right',
				fieldDefaults: {
		            labelWidth: 100,
		        	labelAlign: 'right'
		        },
		        defaults: {
			        anchor: '80%'
			    },
			    defaultType: 'textfield',
			    items: [
			    {
			        fieldLabel: 'ID',
			        name: 'dictionary.id',
			        value:row[0].get('id'),
			        hidden:true,
			        width: 100,
			        allowBlank: true
			    }, 
			    {
			    	id: 'typeName',
			        fieldLabel: '类型名称',
			        xtype: 'combobox',
			        name: 'dictionary.parentId',
			        disabled:false,
			        readOnly:false,
			        editable:false,
			        displayField: 'dictionaryName',
					valueField: 'id',
			        width: 100,
			        allowBlank: false,
			        queryMode: 'remote',
			        store: typeStoreForAdd,
					listeners:{
						beforerender:function(){
							if(row[0].get('parentId') == null || row[0].get('parentId') == ''){
								Ext.getCmp('typeName').setDisabled(true);
								Ext.getCmp('typeName').setVisible(false);
								Ext.getCmp('dicName').setDisabled(true);
								Ext.getCmp('dicName').setVisible(false);
								Ext.getCmp("flagName").setValue('0');
							}else{
								Ext.getCmp("flagName").setValue('1');
								Ext.getCmp('typeNameText').setDisabled(true);
								Ext.getCmp('typeNameText').setVisible(false);
							}
						}	
					}
			    },
			    {
			    	id:'flagName',
			        name: 'dictionary.flag',
			        hidden:true
			    },
			    {
			    	id:'typeNameText',
			        fieldLabel: '类型名称',
			        name: 'dictionary.parentName',
			        value:row[0].get('dictionaryName'),
			        readOnly:false,
			        disabled:false,
			        hidden:false,
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符',
			        maxLength:25,
			        width:100,
			        allowBlank: false
			    }, 
			    {
			    	id: 'typeCode',
			    	fieldLabel: '类型编码',
			        name: 'dictionary.dictionaryCode',
			        value:row[0].get('dictionaryCode'),
			        disabled:true,
			    	hidden:true,
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符',
			        readOnly:true,
			        width: 100,
			        allowBlank: false
			    },
			    {
			    	id: 'dicName',
			        fieldLabel: '字典名称',
			        name: 'dictionary.dictionaryName',
			        value:row[0].get('dictionaryName'),
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符',
			        width: 100,
			        maxLength:25,
			        allowBlank: false
			    },
			    {
			    	id: 'dicCode',
			    	fieldLabel: '字典编码',
			        name: 'dictionary.dictionaryCode',
			        value:row[0].get('dictionaryCode'),
			        disabled:true,
			        regex : new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符！',
			        readOnly:true,
			        width: 100,
			        allowBlank: false
			    },
			    {
			        fieldLabel: '字典值',
			        name: 'dictionary.dictionaryValue',
			        value:row[0].get('dictionaryValue'),
			        regex :  new RegExp('^([\u4E00-\u9FFF]*-*\\w*)*$'),
					regexText : '不能包含特殊字符！',
			        width: 100,
			        maxLength:50,
			        minValue:1,
			        allowBlank: false
			    },
			    {
			        fieldLabel: '排序',
			        name: 'dictionary.levelOrder',
			        value:row[0].get('levelOrder'),
			        regex : /^[0-9]*[1-9][0-9]*$/,
					regexText : '请输入正整数',
			        width: 100,
			        maxLength:8,
			        allowBlank: false
			    }]
			 });
			
			var dictWin=Ext.create("Ext.window.Window",{
				title: '修改',
				resizable: false,
				buttonAlign:"center",
			  	height: 250,
			    width: 350,
			    modal:true,
			    layout: 'fit',
			    closeAction : 'destroy',
			    items: [dictForm],
			    listeners:{
			    	afterrender:function(){
			    		typeStoreForAdd.load(function(){
			    			Ext.getCmp('typeName').setValue(row[0].get('parentId'));
			    		});
			    	}
			    },
			    buttons:[
			    	{
					    text: SystemConstant.saveBtnText,
				    	handler: function(){
				    		if(dictForm.form.isValid()){
				    			Ext.MessageBox.wait("", "修改字典数据", 
									{
										text:"请稍后..."
									}
								);
								dictForm.form.submit({
									url:"${ctx}/dict/updateDict.action",
									success : function(form, action) {  
			    					   Ext.MessageBox.hide();
			    					   //清除选中行;
			    					   dictGrid.getSelectionModel().deselectAll();
			    					   //Ext.getCmp("dictGrid").getSelectionModel().clearSelections();
			    					   new Ext.ux.TipsWindow(
											{
												title: SystemConstant.alertTitle,
												autoHide: 3,
												html:action.result.msg
											}
										).show();
			    					   
			    					    dictWin.close();
			    					    dictStore.load();
			    				   },
								   failure:function(form, action){
							            Ext.getCmp("dictGrid").getSelectionModel().clearSelections();
										Ext.MessageBox.show({
										title: SystemConstant.alertTitle,
										msg: action.result.msg,
										buttons: Ext.MessageBox.OK,
										icon: Ext.MessageBox.ERROR
										});
										Ext.MessageBox.hide();
										dictWin.close();
										dictStore.load();
									}
								});
		 					}
	          			}
					},
					{
				    text: '关闭',
		                handler: function(){
		                	dictWin.close();
		                }
					}
				]
			 }).show();
			
		};
		
	});
	</script>
</body>
</html>