/**
 * 附件组示例
 * @author hedjaojun
 * @date 2015-07-01
 */
Ext.onReady(function() {
	//定义表格grid
	var attachGrid = Ext.create("Ext.grid.AttachPanel",{
		renderTo: 'attach-grid-example',
		attachGroupId:'', //修改时，设置附件组ID的值。添加新附件组时，设置attachGroupId为0或不设置。默认值为0
		allowFileType:["gif","jpg","jpeg","bmp","png","rar","zip","txt","doc","docx","xls","xlsx","ppt","pdf"],
		maxFileCount:6, // 最多上传文件数。
		maxFileSize:10*1024*1024,//文件大小限制 此处为10M
		savePath:'',//文件存放目录 默认为 C:\\uploadFile\\$date{yyyy}\\$date{MM}   $date{yyyy-MM}表示当前日期的月份
		showAddButton:true, // 是否显示"添加"按钮，默认值为"false"
		showDelButton:true, // 是否显示"删除"按钮，默认值为"false"
		showDownloadButton:true, // 是否显示"批量下载"按钮，默认值为"true"
		
		//上传附件成功回调函数，用于设置业务表与附件组ID关联。此示例中将新附件组ID添加到页面中附件ID下拉选择框中。
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
		attachGrid.setAttachGroupId(groupId);
	});
})