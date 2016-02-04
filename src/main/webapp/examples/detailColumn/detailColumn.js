/**
 * My97日期控件示例
 * @author zengchao
 * @date 2016-01-05
 */
Ext.onReady(function() {
	Ext.define('Ext.grid.column.PersonColumn', {
		extend : 'Ext.grid.column.Column',
		text: '姓名',
   	    width:90,
		xtype:'personColumn',
		menuDisabled: true,
		/*renderer : function(val , ctx , record){ 
			var me=this;
			var tdAttrStr='';
			var displayValue=ctx.column.displayValue;
			var value;
			Ext.Ajax.request({
				url : basePath + '/user/getUserByIdForUpdate.action',
				async:false,//设置为同步
				params : {
					id:val
				},
				success : function(response, action) {
					var response = Ext.decode(response.responseText);
					var data=response.data;
					tdAttrStr='部门名称：'+data['orgNames']
					           +'<br/>用户ID：'+data['user.id']
					           +'<br/>ERPID：'+data['user.erpId']
					           +'<br/>性别：'+data['user.gender']
					           +'<br/>实名：'+data['user.realname']
					           +'<br/>用户名：'+data['user.username'];
					value=data[displayValue];
				}
			});
		    ctx.tdAttr = 'data-qtip="' + tdAttrStr+ '"';
		    return value; 
		},*/
		/*focus: function( Ext.Component this, Ext.EventObject The, Object eOpts ){
			
		}*/
		renderer : function(val , ctx , record){ 
			var me=this;
			var column=ctx.column
			var valueField=column.valueField
			column.value=record.get(valueField);
			ctx.tdAttr = 'data-qtip="' + val+ '"';
		    return val; 
		},
		listeners: {
			'mouseOver': function(cm, e, eOpts ){
				var me=this;
				var tdAttrStr='';
				var valueField=me.valueField;
				var val=me.value
				var value;
				Ext.Ajax.request({
					url : basePath + '/user/getUserByIdForUpdate.action',
					async:false,//设置为同步
					params : {
						id:val
					},
					success : function(response, action) {
						var response = Ext.decode(response.responseText);
						var data=response.data;
						tdAttrStr='部门名称：'+data['orgNames']
						           +'<br/>用户ID：'+data['user.id']
						           +'<br/>ERPID：'+data['user.erpId']
						           +'<br/>性别：'+data['user.gender']
						           +'<br/>实名：'+data['user.realname']
						           +'<br/>用户名：'+data['user.username'];
					}
				});
				//me.tdAttr = 'data-qtip="' + tdAttrStr+ '"';
			}
	    }
	});

	
	Ext.define("detailColumnModel", {
		extend : "Ext.data.Model",
		fields:[
				{name:"id",mapping:"id"},
				{name:"orgName"},
				{name:"username"},
				{name:"password"},
				{name:"userId"},
				{name:"realname"}
			]
	});

	var detailColumnStore = Ext.create('Ext.data.Store', {
		model : 'detailColumnModel',
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
	    }],
		autoLoad:true
	});
	var detailColumnCm=[
		{xtype: "rownumberer"},
    	{
		 text: "人员所在部门",
		 dataIndex: "orgName",
		 valueField: "id",
		 width:90
    	},
		{
    	 dataIndex: "realname",
    	 xtype:'personColumn',
    	 valueField: "id"
		},
    	{
         header: "详情",
    	 width:70,
    	 renderer: function(val, metadata, record, rowIndex, columnIndex, store) {
    		 var id = record.get('id');
    		 return '<a onclick="DetailsDetailColumn(\''+id+'\')" class="color_blue">详情事件</a>';}
    	}
    ];
	/**
	 * 定义Grid
	 */
	var detailColumnGrid =  Ext.create("Ext.grid.Panel",{
			title:'示例1',
			renderTo: 'detailColumn-example',
		    selModel:Ext.create("Ext.selection.CheckboxModel"),
			store: detailColumnStore,
			columns:detailColumnCm,
			listeners: {
				'cellclick': function( table , td, cellIndex, record, tr, rowIndex, e, eOpts){
					
				}
		    },
			//底部工具条
		    bbar : Ext.create("Ext.PagingToolbar", {
				    store : detailColumnStore
			})
		});
	});
	var detailColumnDetailForm=Ext.create('Ext.form.Panel', {
		items: [{
				layout: 'form',
				columnWidth: 0.5,
				border: false,
				items: [{
					fieldLabel: '部门',
					xtype: 'displayfield',
					name: 'orgNames'
				},{
					fieldLabel: '登录名',
					xtype: 'displayfield',
					name: 'orgNames'
				}]
		},{
			layout: 'form',
			columnWidth: 0.5,
			border: false,
			items: [{
				fieldLabel: '姓名',
				xtype: 'displayfield',
				name: 'user.id',
				pathByUrl:basePath + '/user/getUserByIdForUpdate.action',
				valueField : 'id',
				displayField : 'user.realname',
			},{
				fieldLabel: '职务',
				xtype: 'displayfield',
				name: 'user.job',
				valueField : 'dictionaryCode',
				displayField : 'dictionaryName',
				pathByUrl :basePath+'/dict/getDictByCode.action'
			}]
	   }]
	});
	var detailColumnDetailsWin=Ext.create("Ext.window.Window", {
	    width : 500,
		items : [detailColumnDetailForm],
		buttons : [ {
			text : '关闭',
			handler : function() {
				var basicForm = detailColumnDetailsWin.down('form').getForm();
				alert('姓名字段的实际值为id=：'+basicForm.findField('user.id').value+'；职务字段的实际值为：'+basicForm.findField('user.job').value);
				this.findParentByType("window").close();
			}
		} ]
	});
	function DetailsDetailColumn(idd){
		detailColumnDetailsWin.setTitle('详情');
		var basicForm = detailColumnDetailsWin.down('form').getForm();
		basicForm.reset();	
		basicForm.load({
			url : basePath + '/user/getUserByIdForUpdate.action',
			params : {
				id : idd
			}
		});
		detailColumnDetailsWin.show();
	}