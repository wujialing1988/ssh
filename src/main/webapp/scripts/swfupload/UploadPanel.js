/**
 * 多文件上传组件 
 * for extjs4.0
 * @author caizhiping
 * @since 2012-11-15
 */

Ext.define("sshFrame.multi.AttachModel",{
	extend:"Ext.data.Model",
	fields:[
			{name: "id"}, 
			{name: "attachId",mapping:function(v){
	        	   return v.id;
	        }},
			{name: "attachName"},
			{name: "attachType"}, 
			{name: "fileSize"},
	        {name: 'percent',mapping:function(v){
	        	   return 100;
	        }},
	        {name: 'status',mapping:function(v){
	        	   return -4;
	        }}
	        
		]
});
sshFrame.multi.attachStore=Ext.create("Ext.data.Store", {
    model:"sshFrame.multi.AttachModel",
	proxy: {
        type:"format",
	    url: basePath+"/attach/getAttachsByGroupId.action"
    }
});

Ext.define('Ext.grid.UploadPanel',{
	extend : 'Ext.grid.Panel',
	alias : 'uploadpanel',
	width : 700,
	height : 300,
	columns : [
        {xtype: 'rownumberer'},
		{text: '文件名', width: 100,dataIndex: 'attachName',renderer:function(vaule, metadata, record, rowIndex, columnIndex, store){
            var attachId = record.get('attachId');
            if (attachId) {
    			return '<a target="_blank" href="'+basePath+'/attach/downloadAttach.action?attachId='+attachId+'" title="下载" >'+vaule+'</a>';
			}else{
				return vaule;
			}
		}},
		/*{text: '自定义文件名', width: 130,dataIndex: 'fileName',editor: {xtype: 'textfield'}},*/
        {text: '类型', width: 70,dataIndex: 'attachType'},
        {text: '大小', width: 70,dataIndex: 'fileSize',renderer:function(vaule, metadata, record, rowIndex, columnIndex, store){
        	return vaule;
        }},
        {text: '进度', width: 130,dataIndex: 'percent',renderer:function(v){        	
           	if(isNaN(v)){
        		v=100;
        	}
        	var stml =
				'<div>'+
						'<div style="float:left;background:#FFCC66;width:'+v+'%;height:8px;"><div></div></div>'+
					'</div>'+
			'</div>';
			return stml;
        }},
        {text: '状态', width: 80,dataIndex: 'status',renderer:function(v){
			var status;
			if(v==-1){
				status = "等待上传";
			}else if(v==-2){
				status =  "上传中...";
			}else if(v==-3){
				status =  "<div style='color:red;'>上传失败</div>";
			}else if(v==-4){
				status =  "上传成功";
			}else if(v==-5){
				status =  "停止上传";
			}		
			return status;
		}}
    ],
	listeners:{
		afterrender:function(comm,eOpts){
			var proxy = this.getStore().getProxy();
    		proxy.setExtraParam("attachGroupId",comm.attachGroupId);
			this.getStore().load();
		}
	},
    plugins: [
        Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1
        })
    ],    
    selModel : Ext.create("Ext.selection.CheckboxModel"),
    store : sshFrame.multi.attachStore,
    onUploadSuccess:function(){},//附件回调，如果没有groupId，传groupid给业务进行处理
	addFileBtnText : '选择文件',
	uploadBtnText : '上传',
	removeBtnText : '删除附件',
	cancelBtnText : '取消上传',
	downloadBtnText : '批量下载',
	debug : false,
	file_size_limit : 100,//MB
	file_types : '*.*',
	file_types_description : 'All Files',
	file_upload_limit : 50,
	file_queue_limit : 0,
	post_params : {},
	attachGroupId:'',
	upload_url : basePath+'test.do',
	flash_url : basePath+"/scripts/swfupload/swfupload.swf",
	flash9_url : basePath+"/scripts/swfupload/swfupload_fp9.swf",
	initComponent : function(){		
		this.dockedItems = [{
		    xtype: 'toolbar',
		    dock: 'top',
		    items: [
		        { 
			        xtype:'button',
			        itemId: 'addFileBtn',
			        iconCls : 'add',
			        id : '_btn_for_swf_',
			        text : this.addFileBtnText
		        },{ xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'uploadBtn',
		        	iconCls : 'up',
		        	text : this.uploadBtnText,
		        	scope : this,
		        	handler : this.onUpload
		        },{ xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'removeBtn',
		        	iconCls : 'trash',
		        	text : this.removeBtnText,
		        	disabled:true, 
		        	disabledExpr : "$selectedRows == 0",
		        	scope : this,
		        	handler : this.onRemove
		        },{ xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'cancelBtn',
		        	iconCls : 'cancel',
		        	disabled : true,
		        	text : this.cancelBtnText,
		        	scope : this,
		        	handler : this.onCancelUpload
		        },
		        { xtype: 'tbseparator' },{
		        	xtype : 'button',
		        	itemId : 'downloadBtn',
		        	iconCls : 'download-button',
		        	text : this.downloadBtnText,
		        	disabled:true, 
		        	disabledExpr : "$selectedRows == 0 || $attachId == ''",
		        	scope : this,
		        	handler : this.downLoadZip
		        }
		    ]
		}];
		
		this.callParent();
		this.down('button[itemId=addFileBtn]').on({			
			afterrender : function(btn){
				var config = this.getSWFConfig(btn);		
				this.swfupload = new SWFUpload(config);
				Ext.get(this.swfupload.movieName).setStyle({
					position : 'absolute',
					top : 0,
					left : -2
				});	
			},
			scope : this,
			buffer:300
		});
	},
	getSWFConfig : function(btn){
		var me = this;
		var placeHolderId = Ext.id();
		var em = btn.getEl().child('em');
		if(em==null){
			em = Ext.get(btn.getId()+'-btnWrap');
		}		
		em.setStyle({
			position : 'relative',
			display : 'block'
		});
		em.createChild({
			tag : 'div',
			id : placeHolderId
		});
		return {
			debug: me.debug,
			flash_url : me.flash_url,
			flash9_url : me.flash9_url,	
			upload_url: me.upload_url,
			post_params: me.post_params||{savePath:'upload\\'},
			file_size_limit : (me.file_size_limit*1024),
			file_types : me.file_types,
			file_types_description : me.file_types_description,
			file_upload_limit : me.file_upload_limit,
			file_queue_limit : me.file_queue_limit,
			button_width: em.getWidth(),
			button_height: em.getHeight(),
			button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
			button_cursor: SWFUpload.CURSOR.HAND,
			button_placeholder_id: placeHolderId,
			custom_settings : {
				scope_handler : me
			},
			swfupload_preload_handler : me.swfupload_preload_handler,
			file_queue_error_handler : me.file_queue_error_handler,
			swfupload_load_failed_handler : me.swfupload_load_failed_handler,
			upload_start_handler : me.upload_start_handler,
			upload_progress_handler : me.upload_progress_handler,
			upload_error_handler : me.upload_error_handler,
			upload_success_handler : me.upload_success_handler,
			upload_complete_handler : me.upload_complete_handler,
			file_queued_handler : me.file_queued_handler/*,
			file_dialog_complete_handler : me.file_dialog_complete_handler*/,
			file_post_name: me.file_post_name,
			attachGroupId: me.attachGroupId
		};
	},
	swfupload_preload_handler : function(){
		if (!this.support.loading) {
			Ext.Msg.show({
				title : '提示',
				msg : '浏览器Flash Player版本太低,不能使用该上传功能！',
				width : 250,
				icon : Ext.Msg.ERROR,
				buttons :Ext.Msg.OK
			});
			return false;
		}
	},
	file_queue_error_handler : function(file, errorCode, message){
		switch(errorCode){
			case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED : msg('上传文件列表数量超限,不能选择！');
			break;
			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT : msg('文件大小超过限制, 不能选择！');
			break;
			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE : msg('该文件大小为0,不能选择！');
			break;
			case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE : msg('该文件类型不允许上传！');
			break;
		}
		function msg(info){
			Ext.Msg.show({
				title : '提示',
				msg : info,
				width : 250,
				icon : Ext.Msg.WARNING,
				buttons :Ext.Msg.OK
			});
		}
	},
	swfupload_load_failed_handler : function(){
		Ext.Msg.show({
			title : '提示',
			msg : 'SWFUpload加载失败！',
			width : 180,
			icon : Ext.Msg.ERROR,
			buttons :Ext.Msg.OK
		});
	},
	upload_start_handler : function(file){
		var me = this.settings.custom_settings.scope_handler;
		me.down('#cancelBtn').setDisabled(false);	
		var rec = me.store.getById(file.id);
		var params = {'attachGroupId':me.attachGroupId,'attachType':file.type};
		this.setPostParams(params);
		//this.setFilePostName(encodeURIComponent(rec.get('fileName')));
	},
	upload_progress_handler : function(file, bytesLoaded, bytesTotal){
		var me = this.settings.custom_settings.scope_handler;		
		var percent = Math.ceil((bytesLoaded / bytesTotal) * 100);
		percent = percent == 100? 99 : percent;
       	var rec = me.store.getById(file.id);
       	rec.set('percent', percent);
		rec.set('status', file.filestatus);
		rec.commit();
	},
	upload_error_handler : function(file, errorCode, message){
		var me = this.settings.custom_settings.scope_handler;		
		var rec = me.store.getById(file.id);
       	rec.set('percent', 0);
		rec.set('status', file.filestatus);
		rec.commit();
		if (this.getStats().files_queued > 0 && this.uploadStopped == false) {
			this.startUpload();
		}else{
			me.showBtn(me,true);
		}
	},
	upload_success_handler : function(file, serverData, responseReceived){
		var me = this.settings.custom_settings.scope_handler;		
		var rec = me.store.getById(file.id);
		var data = Ext.decode(serverData);
		if(!data.success || data.success=='false')
	    {
//	        file.filestatus = -3;
//		    this.queueEvent("upload_error_handler", [file, SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED, '上传文件失败']);
//	        return;
			rec.set('percent', 0);
			rec.set('status', SWFUpload.FILE_STATUS.ERROR);
	    }else{
	    	rec.set('attachId', data.attachId);
			rec.set('percent', 100);
			rec.set('status', file.filestatus);		
	    }
		rec.commit();
		if (this.getStats().files_queued > 0 && this.uploadStopped == false) {
			this.startUpload();
		}else{
			me.showBtn(me,true);
		}
		//设置回调
		if(!me.attachGroupId && data.attachGroupId){
			me.onUploadSuccess(data.attachGroupId);
			me.attachGroupId = data.attachGroupId ;
		}
	},
	upload_complete_handler : function(file){
		
	},
	file_queued_handler : function(file){
		var me = this.settings.custom_settings.scope_handler;
		me.store.add({
			id : file.id,
			attachName : file.name,
			fileSize : Ext.util.Format.fileSize(file.size),
			attachType : file.type,
			status : file.filestatus,
			percent : 0
		});
	},
	onUpload : function(){
		if (this.swfupload&&this.store.getCount()>0) {
			if (this.swfupload.getStats().files_queued > 0) {
				this.showBtn(this,false);
				this.swfupload.uploadStopped = false;		
				this.swfupload.startUpload();
			}
		}
	},
	showBtn : function(me,bl){
		me.down('#addFileBtn').setDisabled(!bl);
		me.down('#uploadBtn').setDisabled(!bl);
		me.down('#cancelBtn').setDisabled(bl);
	},
	onRemove : function(){
		var ds = this.getStore();
		var rows = this.getSelectionModel().getSelection();
		var attachIds='';
		for(var i=0;i<rows.length;i++){
			var file_id = rows[i].get('id');
			var attachId = rows[i].get('attachId');
			if(attachId!=null&&attachId!=''){
				attachIds+=attachId+',';
			}
			ds.remove(rows[i]);
			this.swfupload.cancelUpload(file_id,false);
		}
		if(attachIds.length>0){
			attachIds=attachIds.substring(0,attachIds.length-1);
			 Ext.Ajax.request({
	 				url : basePath+'/attach/deleteAttachs.action',
	 				async:false,
	 				params : {attachIds:attachIds},
	 				success : function(res, options) {
	 					 
	 				}
	 		});
		}
		this.swfupload.uploadStopped = false;
	},
	onCancelUpload : function(){
		if (this.swfupload) {
			this.swfupload.uploadStopped = true;
			this.swfupload.stopUpload();
			this.showBtn(this,true);
		}
	},
	downLoadZip : function(){
       	var rows = this.getSelectionModel().getSelection();
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
});