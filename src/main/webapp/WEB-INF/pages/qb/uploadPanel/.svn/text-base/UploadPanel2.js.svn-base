/**
 * 多文件上传组件 
 * for extjs4.0
 * @author cbai
 * @since 2013-03-01
 */


Ext.define('XX.view.ux.UploadPanel',{
	extend: 'Ext.grid.Panel',
	alias: 'widget.uploadpanel',
	width: 560,
	height: 350,
	upload_url: '',
	columns : [
        {xtype: 'rownumberer'},
		{text: '文件名', width: 180,dataIndex: 'name'},
		{text: '自定义文件名', width: 180,dataIndex: 'attachName',editor: {xtype: 'textfield'}},
        {text: '类型', width: 70,dataIndex: 'extendName'},
        {text: '大小', width: 70,dataIndex: 'fileSize',renderer:function(v){
        	return Ext.util.Format.fileSize(v);
        }},
        {text: '进度', width: 130,dataIndex: 'percent',renderer:function(v){      
        	if(isNaN(v)){
        		v=100;
        	}
			var stml =
				'<div>'+
					'<div style="border:1px solid #008000;height:10px;width:115px;margin:2px 0px 1px 0px;float:left;">'+		
						'<div style="float:left;background:green;width:'+v+'%;height:8px;"><div></div></div>'+
					'</div>'+
				//'<div style="text-align:center;float:right;width:40px;margin:3px 0px 1px 0px;height:10px;font-size:12px;">{3}%</div>'+			
			'</div>';
			return stml;
        }},
        {text: '状态', width: 120,dataIndex: 'status',renderer:function(v){
			var status;
			if(v==-1){
				status = "等待上传";
			}else if(v==-2){
				status =  "上传中...";
			}else if(v==-3){
				status =  '<div style="color:red;">上传失败</div>';
			}else if(v==-4){
				status =  '上传成功';
			}else if(v==-5){
				status =  "停止上传";
			}		
			return status;
		}},
        {
			text: '操作',
            xtype:'actioncolumn',
           // hidden:notOperation,//------------------------------------------这里要注意 定义的为全局
            width:50,
            items: [{
            	 icon: rootConText+'images/icons/delete_file.gif',
                tooltip: '删除',
                handler: function(grid, rowIndex, colIndex) {
                	var id = grid.store.getAt(rowIndex).get('id');
                	var attachId = grid.store.getAt(rowIndex).get('attachId');
                	if(attachId!=null&&attachId!=''){
                		Ext.Ajax.request({
        	 				url : rootConText+'uploadfile/deleteAttach.action',
        	 				async:false,
        	 				params : {attachIds:attachId},
        	 				success : function(res, options) {
        	 				}
        	 		});
                	}
                    grid.store.remove(grid.store.getAt(rowIndex));
                }
            }],
            listeners:{
        		afterrender:function(comm,eOpts){
        			comm.setVisible(!notOperation);
        		}}
        },
        {text: '查看', width: 80,dataIndex: 'view',renderer:function(url){
			var stml = url;
			return stml;
		}}
    ],
	listeners:{
		afterrender:function(comm,eOpts){
			
			/*if(this.parentStatus==-1||this.parentStatus=='-1'){
				
			}*/
			
			var proxy = this.getStore().getProxy();
    		proxy.setExtraParam("attachGroupId",attachGroupId);
			this.getStore().load();
		}
	},
    plugins: [
        Ext.create('Ext.grid.plugin.CellEditing', {
            clicksToEdit: 1
        })
    ],    
    /*store : Ext.create('Ext.data.JsonStore',{
    	autoLoad : false,
    	fields : ['id','name','extendName','attachGroupId','fileSize','percent','status','attachName','attachId']
    }),*/
    
    
    store:Ext.create('Ext.data.ArrayStore', {
        // store 的配置
    	autoLoad : false,
         /*proxy:{
        	 type:'ajax',
				url: rootConText+"uploadfile/getAttachListByGroupId.action",
				actionMethods: {
	                read: 'POST'
	            },reader: {
				     type: 'json',
			    	    root: 'attachList'
		    }
			},*/
    	
    	proxy:Ext.create("Ext.ux.data.proxy.Ajax",{
			async:false,
			url: rootConText+"uploadfile/getAttachListByGroupId.action",
			actionMethods: {
                read: 'POST'
            },reader: {
			     type: 'json',
		    	    root: 'attachList'
	    }
		}),
       // autoDestroy: true,
       // storeId: 'formulaDetailStore',
        idIndex: 0,
        fields: [
			{name: 'name',mapping:function(v){
	        	   return v.attachName;
	           }},
           {name: 'id',mapping:function(v){
        	   return v.pkAttachId;
           }},
           {name: 'extendName' },
           {name: 'attachGroupId',mapping:function(v){
        	   return v.attachGroup.pkAttachGroupId;
           } },
           {name: 'fileSize' },
           {name: 'percent',mapping:function(v){
        	   return 100;
           } },
           {name: 'status',mapping:function(v){
        	   return -4;
           } },
           {name: 'attachName' },
           {name: 'view' ,mapping:function(v){
        	   var filepath=rootConText+v.url;
        	   return "<div><a href='"+filepath+"' target='blank'>查看</a></div>";
           }},
           {name: 'attachId',mapping:function(v){
        	   return v.pkAttachId;
           } }
        ]
    }),
    
    fileurl_hostport : '',
	//addFileBtnText : 'Add File',
	//uploadBtnText : 'Upload',
	//removeBtnText : 'Remove All',
	//cancelBtnText : 'Cancel',
	addFileBtnText: '选择文件...',
	uploadBtnText: '上传',
	removeBtnText: '移除所有',
	cancelBtnText: '取消上传',
	completeBtnText: '完成',
	debug : false,
	parentStatus:'',
	file_size_limit : 100,//MB
	file_types : '*.*',
	file_types_description : 'All Files',
	file_upload_limit : 50,
	file_queue_limit : 0,
	post_params : {},
	upload_url : 'test.do',
	use_query_string:false,
	flash_url : "swfupload/swfupload.swf",
	flash9_url : "swfupload/swfupload_fp9.swf",
	notifyUploadRes_url : "",
	initComponent : function(){		
		this.dockedItems = [{
		    xtype: 'toolbar',
		    dock: 'top',
		    items: [
		        { 
			        xtype:'button',
			        itemId: 'addFileBtn',
			        iconCls : 'add_file',
			        id : '_btn_for_swf_',
			        hidden:notOperation,
			        text : this.addFileBtnText
		        },{ xtype: 'tbseparator' , hidden:notOperation },{
		        	xtype : 'button',
		        	itemId : 'uploadBtn',
		        	 hidden:notOperation,
		        	iconCls : 'up_file',
		        	text : this.uploadBtnText,
		        	scope : this,
		        	handler : this.onUpload
		        },{ xtype: 'tbseparator', hidden:notOperation },{
		        	xtype : 'button',
		        	itemId : 'removeBtn',
		        	iconCls : 'trash_file',
		        	hidden:notOperation,
		        	text : this.removeBtnText,
		        	scope : this,
		        	handler : this.onRemoveAll
		        },{ xtype: 'tbseparator', hidden:true },{
		        	xtype : 'button',
		        	hidden:true,
		        	itemId : 'cancelBtn',
		        	iconCls : 'cancel_file',
		        	disabled : true,
		        	text : this.cancelBtnText,
		        	scope : this,
		        	handler : this.onCancelUpload
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
			parentStatus:me.parentStatus,
			flash_url : me.flash_url,
			flash_url : me.flash_url,
			use_query_string:me.use_query_string,
			attachGroupId: me.attachGroupId,
			flash9_url : me.flash9_url,	
			upload_url: me.upload_url || '',
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
			file_queued_handler : me.file_queued_handler,/*,
			file_dialog_complete_handler : me.file_dialog_complete_handler*/
			file_post_name: 'upLoadFile'
		};
	},
	swfupload_preload_handler : function(){ 
		if (!this.support.loading) {
			Ext.Msg.show({
				title : '提示',
				msg : '浏览器Flash Player版本太低,不能使用该上传功能！点击yes下载最新版本的flash',
				width : 250,
				icon : Ext.Msg.ERROR,
				modal: true,
				buttons: Ext.Msg.YESNO,
				fn: function (b,t) {
                         if('yes' == b)
                         {
                           //下载flash
                           try{
                              window.open(me.post_params.codebase,"_blank");
                           }catch(e)
                           { 
                              //跳转到flash下载页面
                              window.open("http://get.adobe.com/cn/flashplayer/","_blank");
                           }
                           //提示用户下载完成后进行刷新操作
                           $('#refresh').showTopbarMessage();
                            
                         }
                }	
			});
			return false;
		}
	},
	file_queue_error_handler : function(file, errorCode, message){
		switch(errorCode){
			case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED : msg('上传文件列表数量超限,不能选择！');
			break;
			case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT : msg('文件大小超过限制, 不能选择!');
			break;
			case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE : msg('该文件大小为0,不能选择！');
			break;
			case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE : msg('该文件类型不允许上传！');
			break;
			case -140 : msg(message);
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
		this.setUseQueryString(true);
		//获取fileid
		var attachId = rec.get('attachId');
		var params = {'fileSize':rec.get('fileSize'),'attachGroupId':attachGroupId,'attachId':rec.get('attachId'),attachName:rec.get('attachName'),'extendName':rec.get('extendName')};
		 this.setPostParams(params);
		
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
	//每上传一个文件失败触发
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
	//每上传一个文件成功后触发
	upload_success_handler : function(file, serverData, responseReceived,v1,v2,v3){
		
		 var data = Ext.decode(serverData);
		//serverData = eval('(' + serverData + ')');
	    //失败
	    if(!data.success || data.success=='false')
	    {
	        //触发失败按钮
	        file.filestatus = -3;
		    this.queueEvent("upload_error_handler", [file, SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED, '上传文件失败']);
	        return;
	    }
		var me = this.settings.custom_settings.scope_handler;		
		var rec = me.store.getById(file.id); 
		//var attachId = rec.get('attachId');
		var me = this.settings.custom_settings.scope_handler;
		var res = null;
		var filepath = rootConText+data.attachFile.url;
		var viewhtml = "<div><a href='"+filepath+"' target='blank'>查看</a></div>";
		
		
		rec.set('attachId', data.attachId);
		
		rec.set('percent', 100);
		rec.set('status', file.filestatus);		
		rec.set('view',viewhtml);
		rec.commit();
		if (this.getStats().files_queued > 0 && this.uploadStopped == false) {
			this.startUpload();
		}else{
			me.showBtn(me,true);
		}
	},
	//上传完成之后触发
	upload_complete_handler : function(file){
		
	},
	//这个事件在选定文件后触发
	file_queued_handler : function(file){ 
	    //从后台获取objectid 
		/*
	    var getObjectIdurl = this.settings.post_params.getObjectIdUrl;
	    var objectId = null;
	    var exception = null;
	    $.ajax({
		        url: getObjectIdurl+"?t="+new Date().getTime(),
		        type: 'get', 
		        async: false,//同步执行
				success:function(result)
					{   
					      try{
					      	  var  data= eval('(' + result + ')');
						      if(null != data ) 
						      {
						        objectId = data[0].objectId; 
						      }
					      }catch(e)
					      {
					          exception="获取文件id失败,请检查连接是否正常"+getObjectIdurl;
					      }
					},
				error : function(e) 
				    {   
				          //alert(e);
					}  
		}) 
		if(null == objectId || objectId.length < 1)
		{ 
		  //抛出自定义异常 -140
		  this.queueEvent("file_queue_error_handler", [file, -140, '初始化上传文件失败']);
		  return;
		}
	    */
		var me = this.settings.custom_settings.scope_handler;
		me.store.add({
			id : file.id,
			name : file.name,
			attachName : file.name,
			fileSize : file.size,
			extendName : file.type,
			status : file.filestatus,
			percent : 0/*,
			attachId : objectId*/
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
		me.down('#removeBtn').setDisabled(!bl);
		me.down('#cancelBtn').setDisabled(bl);
		if(bl){
			me.down('actioncolumn').show();
		}else{
			me.down('actioncolumn').hide();
		}		
	},
	onRemoveAll : function(){
		var ds = this.store;
		var attachIds='';
		for(var i=0;i<ds.getCount();i++){
			var record =ds.getAt(i);
			var file_id = record.get('id');
			var attachId = record.get('attachId');
			if(attachId!=null&&attachId!=''){
				attachIds+=attachId+',';
			}
			
			this.swfupload.cancelUpload(file_id,false);			
		}
		
		if(attachIds.length>0){
			attachIds=attachIds.substring(0,attachIds.length-1);
			 Ext.Ajax.request({
	 				url : rootConText+'uploadfile/deleteAttach.action',
	 				async:false,
	 				params : {attachIds:attachIds},
	 				success : function(res, options) {
	 					 
	 				}
	 		});
			
		}
		
		ds.removeAll();
		this.swfupload.uploadStopped = false;
	},
	beforeDestroy: function() {
        var me = this;
        me.store.removeAll();
        Ext.destroy(
            me.placeholder,
            me.ghostPanel
        );
        me.callParent();
    },
	onCancelUpload : function(){
		if (this.swfupload) {
			this.swfupload.uploadStopped = true;
			this.swfupload.stopUpload();
			this.showBtn(this,true);
		}
	}
});
