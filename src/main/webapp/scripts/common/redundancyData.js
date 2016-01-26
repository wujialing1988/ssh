Ext.define('Ext.grid.column.Element', {
	extend : 'Ext.grid.column.Column',
	text: '组织',
	xtype:'elementColumn',
	menuDisabled: true,
	renderer : function(v , ctx , record){ 
		var me=this
		var tdAttrStr='';
		Ext.Ajax.request({
			url : basePath + '/user/getUserByIdForUpdate.action',
			async:false,
			params : {
				id:'4028b881522eb08001522f2c62e20005'
			},
			success : function(response, action) {
				var response = Ext.decode(response.responseText);
				var data=response.data;
				tdAttrStr='部门名称：'+data['orgNames']+'<br/>ERPID：'+data['user.erpId']+'<br/>性别：'+data['user.gender']+'<br/>实名：'+data['user.realname']+'<br/>用户名：'+data['user.username'];
			}
		});
	    ctx.tdAttr = 'data-qtip="' + tdAttrStr+ '"';
	    return v; 
	}
});