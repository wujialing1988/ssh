/**
 * 附件组示例
 * @author wujialing
 * @date 2016-01-28
 */
Ext.onReady(function() {
	
	var attachPanel = Ext.create('Ext.grid.UploadPanel',{
		renderTo: 'attach-grid-example-multi',
		addFileBtnText : '选择文件',
		uploadBtnText : '上传',
		removeBtnText : '删除附件',
		cancelBtnText : '取消上传',
		file_post_name:'uploadAttach',
		file_size_limit : 100,//MB
		file_types:'*.*',//限制格式 如“txt;doc,docx”，用英文分号隔开
		upload_url : basePath+'/attach/addAttach.action',
		attachGroupId:'',
		onUploadSuccess:function(newAttachGroupId){
			var groupIdDom = Ext.get('attachGroupId');
			//如果下拉选择框中无返回的 附件组ID: newAttachGroupId,则添加到下拉框。
			if(!groupIdDom.child('option[value="'+newAttachGroupId+'"]')){
				groupIdDom.createChild({
					tag : 'option',
					value : newAttachGroupId,
					selected:"selected",
					html:newAttachGroupId
				});
				Ext.Msg.showInfo("新附件组 ID为： "+newAttachGroupId);
			}
		}
	});
	
	/**
	 * 设置"加载"按钮点击事件。重新选择附件组ID下的全部附件。
	 */
	Ext.get('loadButton').on('click',function(event,target){
		var groupId = Ext.get('attachGroupId').getValue();
		//为附件组表格设置新的附件组ID,并刷新列表。
		attachPanel.getStore().getProxy().setExtraParam("attachGroupId", groupId)
		attachPanel.getStore().load();
	});
})