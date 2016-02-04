Ext.onReady(function(){
    var fp=new Ext.form.FormPanel({ //注意：Ext.form.FormPanel=Ext.FormPanel
        title:'示例窗口',
        width:400,
        //height:250,
        renderTo:'welcome',
        frame:true,
        frame:true,
        defaults:{ //在这里同一定义item中属性，否则需要各个指明
            xtype:'textfield',
            labelAlign:'right',
            labelWidth:85,
            width:300
        },
        items:[
            {
			fieldLabel : 'IP地址',
			name : 'roleName',
			allowBlank : false
		},{
			fieldLabel : '邮箱地址',
			name : 'roleName',
			allowBlank : false
		},{
			fieldLabel : 'URL地址',
			name : 'roleName',
			allowBlank : false
		},{
			fieldLabel : '手机号码',
			name : 'roleName',
			allowBlank : false
		},{
			fieldLabel : '邮政编码',
			name : 'roleName',
			allowBlank : false
		},{
			fieldLabel : '账号',
			name : 'roleName',
			vtype:'account',
			allowBlank : false
		},{
			fieldLabel : '身份证号码',
			name : 'roleName',
			allowBlank : false
		} ,{
			fieldLabel : '特殊字符',
			name : 'roleName',
			allowBlank : false
		}
        ],
        buttonAlign:'center',//按钮对其方式
        buttons:[
            {
                text:'确定'
            },
            {
                text:'关闭'
            }
        ]
    });
}); 