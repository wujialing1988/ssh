/**
 * 哥特死亡工业 2015年6月3日 封装常用的VTYPE
 */

// 验证IP地址是否合法 IPAddress
Ext.apply(Ext.form.field.VTypes, {
	IPAddress : function(v) {
		return /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/.test(v);
	},
	IPAddressText : '该输入项必须是IP地址，格式如："61.139.6.69"',
	IPAddressMask : /[\d\.]/i
});

//验证邮箱地址是否合法 emailAddress
Ext.apply(Ext.form.field.VTypes, {
	emailAddress : function(v) {
		return /^(\w+)([\-+.][\w]+)*@(\w[\-\w]*\.){1,5}([A-Za-z]){2,6}$/.test(v);
	},
	emailAddressText : '该输入项必须是邮箱地址，格式如："user@example.com"',
	emailAddressMask : /[a-z0-9_\.\-@\+]/i
});

//验证URL地址是否合法 URLAddress
Ext.apply(Ext.form.field.VTypes, {
	URLAddress : function(v) {
		return /^(\w+)([\-+.][\w]+)*@(\w[\-\w]*\.){1,5}([A-Za-z]){2,6}$/.test(v);
	},
	URLAddressText : '该输入项必须是URL地址，格式如："http://www.example.com"',
	URLAddressMask : /[a-z0-9_\.\-@\+]/i
});

//验证手机号码是否合法 phoneNumber
Ext.apply(Ext.form.field.VTypes, {
	phoneNumber : function(v) {
		return /^[1][0-9]{10}$/.test(v);
	},
	phoneNumberText : '该输入项必须是手机号码，格式如："13987654321"'
});

//验证邮政编码是否合法 zipCodeAddress
Ext.apply(Ext.form.field.VTypes, {
	zipCodeAddress : function(v) {
		return /^[1-9]\d{5}(?!\d)$/.test(v);
	},
	zipCodeAddressText : '该输入项必须是邮政编码，格式如："100000"'
});

//验证登录账号是否合法 account
Ext.apply(Ext.form.field.VTypes, {
	account : function(v) {
		return /^[\w.\-\u4e00-\u9fa5]*$/.test(v);
	},
	accountText : '该输入项禁止输入空格、特殊字符。'
});

//验证身份证号码是否合法 IDCard
Ext.apply(Ext.form.field.VTypes, {
	IDCard : function(v) {
		return /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/.test(v);
	},
	IDCardText : '该输入项只能输入15位或18位正确的身份证号码。'
});

//过滤空格，<>的验证方法  filterHtml
Ext.apply(Ext.form.field.VTypes, {
	filterHtml : function(v) {
		return /^([^ ^<^>])*$/.test(v);
	},
	filterHtmlText : '该输入项禁止输入空格、"<" 和">"。'
});


Ext.apply(Ext.form.VTypes, {
	inputCharFilter : function(val, field) {
		this.inputCharFilterText ='含有特殊字符<,&amp;nbsp等';
        var regExp=new RegExp('<.*',"igm");
        var error=false;
        error=regExp.test(val);
        if(error){
        	return false;
        }
        regExp=new RegExp('&nbsp',"igm");
        error=regExp.test(val);
        if(error){
        	return false;
        }
        if(val!=null&&typeof(val)!=undefined&&Ext.String.trim(val)==""){
        	this.inputCharFilterText='不能只添加空格';
        	return false;
        }
        return !error;
    },

    inputCharFilterText : '含有特殊字符<,&amp;nbsp等'
});