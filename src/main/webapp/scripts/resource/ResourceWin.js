/***
 * 添加/修改资源
 * */
var parentResourceForm=Ext.create("Ext.form.Panel", {
		layout: 'form',
		bodyStyle :'padding:15px 10px 0 0',
		border: false,
		labelAlign: 'right',
		fieldDefaults: {
            labelWidth: 60,
        	labelAlign: 'right'
        },
        defaults: {
	        anchor: '60%'
	    },
	    defaultType: 'textfield',
	    items: [{
	    	name : 'resource.id',
	    	hidden:true
	    },{
	        id:'hiddenResourceCode',
	        name: 'hiddenResourceCode',
	        hidden:true
	    },{
	    	fieldLabel: '上级资源id',
	        id:'parentResourceIdd',
	        name: 'resource.resource.id',
	        hidden:true
	    },{
	    	fieldLabel: '上级',
	        id:'parentResourceName',
	        name: 'resource.resource.resourceName',
	        disabled:true,
	        width: 100,
	        hidden:true
	    },{
	    	xtype: 'combobox',
	        fieldLabel: '类型',
	        name: 'resource.resourceType',
	        id:'parentResourceId',
	        store: parentResourceTypeStore,
	        valueField: 'dictionaryCode',
	        displayField: 'dictionaryName',
	        editable:false,
	        queryMode: 'remote',
	        width: 100,
	        allowBlank: false
	    },{
	        fieldLabel: '名称',
	        name: 'resource.resourceName',
	        width: 100,
	        maxLength:20,
	        vtype:'filterHtml',
	        allowBlank: false,
	        validateOnChange:false,
	        validator : function(value) {
	        	var type = null;
	        	var basicForm = parentResourceWin.down('form').getForm();
	        	var rId= basicForm.findField('resource.id').getValue();
	        	if(rId!=''){
	        		var type = 'update';
	        	}
	        	var returnObj = null;
	        	$.ajax({
	        		url : basePath + '/resource/validateResourceProperties.action',
	        		data : {
	        			key : '0',
	        			value : value,
	        			parentId : selectNode.raw.nodeId,
	        			validatorType:type,
	        			resourceId:rId
	        		},
	        		cache : false,
	        		async : false,
	        		type : "POST",
	        		dataType : 'json',
	        		success : function(result) {
	        			if (!result.valid) {
	        				returnObj = result.reason;
	        			} else {
	        				returnObj = true;
	        			}
	        		}
	        	});
	        	return returnObj;
	        }
	    },{
	        fieldLabel: 'URL',
	        name: 'resource.href',
	        width: 100,
	        maxLength:50,
	        vtype:'filterHtml',
	        allowBlank: false,
	        validateOnChange:false,
	        validator: function(value){
	        	var returnObj = null;
	        	var type = null;
	        	var basicForm = parentResourceWin.down('form').getForm();
	        	var rId= basicForm.findField('resource.id').getValue();
	        	if(rId!=''){
	        		var type = 'update';
	        	}
				$.ajax({
					url : basePath+'/resource/validateResourceProperties.action',
					data:{
						key:'2',
						value:value,
						parentId:selectNode.raw.nodeId,
						validatorType:type,
	        			resourceId:rId
					},
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
	    },{
	        fieldLabel: '编码',
	        name: 'resource.code',
	        id:'resourceCode',
	        vtype:'filterHtml',
	        width: 100,
	        maxLength:30,
	        allowBlank: false,
	        validateOnChange:false,
	        validator: function(value){
				var returnObj = null;
				var type = null;
	        	var basicForm = parentResourceWin.down('form').getForm();
	        	var rId= basicForm.findField('resource.id').getValue();
	        	if(rId!=''){
	        		var type = 'update';
	        	}
				$.ajax({
					url : basePath+'/resource/validateResourceProperties.action',
					data:{
						key:'1',
						value:value,
						parentId:selectNode.raw.nodeId,
						validatorType:type,
	        			resourceId:rId
					},
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
	    },{
	        fieldLabel: '排序',
	        name: 'resource.disOrder',
	        width: 100,
	        xtype: 'numberfield',
	        minValue:0,
	        maxValue:999
	    },{
	        fieldLabel: '描述',
	        name: 'resource.remarks',
	        vtype:'filterHtml',
	        maxLength:500,
	        xtype : 'textareafield',
	        width: 100
	    }]
	 });
var parentResourceWin = Ext.create("Ext.window.Window", {
	height : 350,
	width : 380,
	items : [parentResourceForm],
	buttons : [ {
		text : SystemConstant.yesBtnText,
		handler : function() {
			if (parentResourceForm.form.isValid()) {
				parentResourceForm.form.submit({
					success : function(form, action) {
						treePanel.getStore().reload({  
	                        node:treePanel.getRootNode(),
	                        callback: function () {  
	                        }  
	                    });
						resourceStore.loadPage(1);
						parentResourceWin.close();
						Ext.Msg.showTip(action.result.msg);
					},
					failure : function(form, action) {
						Ext.Msg.showError(action.result.msg);
					}
				});
			}
		}
	}, {
		text : SystemConstant.closeBtnText,
		handler : function() {
			parentResourceWin.close();
		}
	} ]
});



