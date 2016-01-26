/**
 * 附件组控件扩展EXTJS表格控件，实现附件列表显示、添加、删除和批量下载附件的功能。
 * 同时实现过虑文件大小、文件类型、最多上文件数和设置保存目录功能
 * @author hedjaojun
 * @date 2015-05-28
 */

/**
 * 建立model对象
 */
Ext.define("sshframe.attach.attachModel",{
	extend:"Ext.data.Model",
	fields:[
		{name:'attachId',mapping:'attachId'},
		{name:'attachName',mapping:'attachName'},
		{name:'attachUrl',mapping:'attachUrl'},
		{name:'downloadTime',mapping:'downloadTime'}
	]
});

//建立数据Store
sshframe.attach.attachStore=Ext.create("Ext.data.Store", {
    model:"sshframe.attach.attachModel",
	proxy: {
        type:"format",
	    url: basePath+"/attach/getAttachsByGroupId.action"
    }
});

Ext.define("Ext.grid.AttachPanel",{
	extend:"Ext.grid.Panel",
	title:'附件',
	attachGroupId:'', // 修改时，设置附件组ID的值。添加新附件组时，设置attachGroupId为0或不设置。默认值为0
	showAddButton:false, // 是否显示"添加"按钮，默认值为"false"
	showDelButton:false, // 是否显示"删除"按钮，默认值为"false"
	showDownloadButton:true, // 是否显示"批量下载"按钮，默认值为"true"
	allowFileType:["gif","jpg","jpeg","bmp","png","rar","zip","txt","doc","docx","xls","xlsx","ppt","pdf"],
	maxFileCount:0, // 最多上传文件数。为0时不限制，默认为0
	maxFileSize:0,//文件大小限制,
	savePath:'',//文件存放目录 默认为 C:\\uploadFile\\$date{yyyy}\\$date{MM}   根据当前日期生成目录，如：C:\\uploadFile\\2015\\07
	existFileCount:0, //已成功上传的文件数
	onUploadSuccess:function(){},
	selModel : Ext.create("Ext.selection.CheckboxModel"),
	store : sshframe.attach.attachStore,
	initComponent: function () {
        var me = this;
        var topBar = ['->'];
        if(me.showAddButton){
        	topBar.push({
	            buttonOnly: true,hideLabel: true,name: 'uploadAttach',
	            text: '添加',  iconCls: 'add-button',
	            handler: function(fb, v){
	            	me.addAttachWin.show();
	            }
        	});
        }
		if(me.showDelButton){
			topBar.push({
	 			iconCls : 'delete-button', text : '删除',
	 			disabled : true, disabledExpr : "$selectedRows == 0",
	 			handler : function(){
	 				me.deleteAttachs();
	 			}
	 		});
		}
		if(me.showDownloadButton){
			topBar.push({
	 			iconCls : 'download-button', text : '批量下载',
	 			disabled:true, disabledExpr : "$selectedRows == 0",
	 			handler : function(){
	 				me.downLoadZip();
	 			}
	 		});
		}
		if(topBar.length > 1){
			me.tbar = topBar;
		}
		
        me.columns = [{
			xtype : "rownumberer",text : "序号",width : 60,align : "center"
		},{
			text : '文件名称',dataIndex : 'attachName',
			renderer : function (data, metadata, record, rowIndex, columnIndex, store){
	            return '<a target="_blank" href="'+basePath+'/attach/downloadAttach.action?attachId='+record.get('attachId')+'" title="下载" >'
	            		+record.get('attachName')+'</a>';
	        }
		}];
        
        me.callParent(arguments);
        
        me.attachFormPanel = Ext.create('Ext.form.Panel', {
            width: 500,
            border:false,
            bodyPadding: '10 10 0',
            defaults: {
            	xtype: 'textfield',
                anchor: '100%',
                labelWidth: 50
            },
            items: [{
                name:'attachGroupId',
                value:'',
                hidden:true
            },{
                name:'maximumSize',
                value:me.maxFileSize,
                hidden:true
            },{
                name:'savePath',
                value:me.savePath,
                hidden:true
            },{
                xtype: 'filefield',
                emptyText: '选择文件',
                fieldLabel: '文件',
                allowBlank : false,
                name: 'uploadAttach',
                buttonText: '',
                buttonConfig: {
                	iconCls: 'add-button'
                },
                listeners: {
                    'change': function(fb, v){
                    	if(v){
                    		me.addAttach(fb, v);
                    	}
                    }
                }
            }]
        });
        
      //上传附件窗口
        me.addAttachWin = new Ext.Window({
        	title:'添加',
        	closable:true,
        	width:400,
        	closeAction:'hide',
        	height:100,
        	modal:true,
        	resizable:false,
        	layout :"fit",
        	items : [
        		me.attachFormPanel
        	]
        });
        
        /**
         * 设置grid 和 form 的 attachGroupId参数
         */
        me.setAttachGroupId = function(attachGroupId){
        	var form = me.attachFormPanel.getForm();
            form.findField('attachGroupId').setValue(attachGroupId);
            sshframe.attach.attachStore.getProxy().setExtraParam("attachGroupId", attachGroupId);
            sshframe.attach.attachStore.load(function(records, operation, success) {
            	me.existFileCount = records.length;
            });
        }
        
        me.setAttachGroupId(me.attachGroupId);
        
        /**
         * 调用后台上传附件
         */
        me.addAttach = function(fb, v){
        	var form = me.attachFormPanel.getForm();
        	if(me.allowFileType&& me.allowFileType.length && !RegExp("\.(" + this.allowFileType.join("|") + ")$", "i").test(v)){
        		 Ext.Msg.showError("支持的文件格式为："+this.allowFileType.join(",")+"。");
        		 return;
        	}
        	if(this.maxFileCount && this.existFileCount >= this.maxFileCount){
        		bCheck = false;
        		Ext.Msg.showError('最多只能上传'+this.maxFileCount+'个文件！当前已有'+this.existFileCount+'个！');
        		return;
        	}
            if(form.isValid() && v){
                form.submit({
                    url: basePath+"/attach/addAttach.action",
                    success: function(fp, o) {
                    	me.setAttachGroupId(o.result.attachGroupId)
                    	Ext.Msg.showTip('添加成功。');
                    	me.addAttachWin.close();
                    	me.onUploadSuccess(o.result.attachGroupId);
                    },
                    failure: function (form, action) {
                    	Ext.Msg.showError(action.result.result);
                    }
                });
            }
        }
        
        /**
         * 调用后台批量下载附件
         */
        me.downLoadZip = function(){
        	var rows = me.getSelectionModel().getSelection();
        	var attachIds="";
        	if(rows.length==1){
        		attachIds = rows[0].get('attachId');
        	}else{
        		for(var i=0;i<rows.length-1;i++){
        			attachIds += rows[i].get('attachId')+',';
        		}
        		attachIds += rows[rows.length-1].get('attachId');
        	}
        	window.open(basePath+"/attach/downLoadZip.action?attachIds="+attachIds,"下载文件")
        }
        
        /**
         * 调用后台批量删除附件
         */
        me.deleteAttachs = function(){
        	var rows = me.getSelectionModel().getSelection();
         	Ext.Msg.confirm(SystemConstant.alertTitle,"确认删除这" + rows.length + "条记录吗?",function(btn){
         		if(btn=='yes'){
         			var attachIds = "";
        			if(rows.length==1){
        				attachIds = rows[0].get('attachId');
        			}else{
        				for(var i=0;i<rows.length-1;i++){
        					attachIds += rows[i].get('attachId')+',';
        				}
        				attachIds += rows[rows.length-1].get('attachId');
        			}
        			
        			Ext.Ajax.request({
        				url: basePath+'/attach/deleteAttachs.action',
        			 		params: {
        			 	   		attachIds: attachIds
        			 	   	},
        					success: function(response, opts) {
        				      	var result = Ext.decode(response.responseText);
        				      	var flag = result.success;
        				      	if(flag){
        				      		sshframe.attach.attachStore.load(function(records, operation, success) {
        				            	me.existFileCount = records.length;
        				            });
        				      		Ext.Msg.showTip('删除成功。')
        				      	}else{
        				      		Ext.Msg.showError(result.msg)
        						}
        				   	}
        			});
         		}
         	});
        }
        
	}
});