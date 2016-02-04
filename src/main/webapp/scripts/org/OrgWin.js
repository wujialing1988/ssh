var orgForm=Ext.create("Ext.form.Panel", {
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
	    	name : 'org.id',
	    	hidden:true
	    },{
	    	name: 'hiddenOrgCode',
	    	hidden:true
	    },{
	    	name : 'org.organization.id',
	    	hidden:true
	    },{
	    	fieldLabel: '上级',
	        name: 'org.organization.orgName',
	        disabled:true,
	        width: 100
	    },{
	    	xtype: 'combobox',
	        fieldLabel: '类型',
	        id:'addOrgSelectionId',
	        name: 'org.orgType',
	        store: orgTypeStore,
	        valueField: 'dictionaryCode',
	        displayField: 'dictionaryName',
	        editable:false,
	        queryMode: 'remote',
	        width: 100,
	        allowBlank: false
	    },{
	    	fieldLabel: '名称',
	        name: 'org.orgName',
	        vtype:'filterHtml',
	        width: 100,
	        maxLength:20,
	        allowBlank: false
	        /*validator: function(value){
					var returnObj = null;
					$.ajax({
						url : basePath+'/org/validateOrgProperties.action',
						data:{
							key:'0',
							value:value,
							parentOrgId:selectNode.raw.nodeId
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
*/
	    },{
	    	 fieldLabel: '编码',
	    	 vtype:'filterHtml',
		     name: 'org.orgCode',
		        width: 100,
		        maxLength:30,
		        allowBlank: false,
		        validator: function(value){
						var returnObj = null;
						$.ajax({
							url : basePath+'/org/validateOrgProperties.action',
							data:{key:'1',value:value,parentOrgId:selectNode.raw.nodeId},
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
	        name: 'org.disOrder',
	        width: 100,
	        xtype: 'numberfield',
	        minValue:0,
	        maxValue:999
	    }]
	 });
var orgWin = Ext.create("Ext.window.Window", {
	height : 250,
	width : 380,
	items : [orgForm],
	buttons : [ {
		text : SystemConstant.yesBtnText,
		handler : function() {
			if (orgForm.form.isValid()) {
				orgForm.form.submit({
					success : function(form, action) {
						treePanel.getStore().reload({  
	                        node:treePanel.getRootNode(),
	                        callback: function () {  
	                        }  
	                    });
						orgStore.loadPage(1);
						orgWin.close();
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
			orgWin.close();
		}
	} ]
});


