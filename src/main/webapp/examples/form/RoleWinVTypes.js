Ext.onReady(function(){
    var fp=new Ext.form.FormPanel({ //注意：Ext.form.FormPanel=Ext.FormPanel
        title:'示例窗口',
        width:400,
        //height:250,
       
        renderTo:'vtypesDiv',
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
			vtype:'IPAddress',
			emptyText:"vtype:'IPAddress'",
			allowBlank : false
		},{
			fieldLabel : '邮箱地址',
			name : 'roleName',
			vtype:'emailAddress',
			emptyText:"vtype:'emailAddress'",
			allowBlank : false
		},{
			fieldLabel : 'URL地址',
			name : 'roleName',
			vtype:'URLAddress',
			emptyText:"vtype:'URLAddress'",
			allowBlank : false
		},{
			fieldLabel : '手机号码',
			name : 'roleName',
			vtype:'phoneNumber',
			emptyText:"vtype:'phoneNumber'",
			allowBlank : false
		},{
			fieldLabel : '邮政编码',
			name : 'roleName',
			vtype:'zipCodeAddress',
			emptyText:"vtype:'zipCodeAddress'",
			allowBlank : false
		},{
			fieldLabel : '账号',
			name : 'roleName',
			vtype:'account',
			emptyText:"vtype:'account'",
			allowBlank : false
		},{
			fieldLabel : '身份证号码',
			name : 'roleName',
			vtype:'IDCard',
			emptyText:"vtype:IDCard",
			allowBlank : false
		} ,{
			fieldLabel : '特殊字符',
			name : 'roleName',
			vtype:'filterHtml',
			emptyText:"vtype:'filterHtml'",
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