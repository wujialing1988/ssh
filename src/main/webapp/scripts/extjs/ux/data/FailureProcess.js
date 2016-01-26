Ext.define('sshframe.ux.data.FailureProcess', {
    singleton: true,
    alternateClassName: 'sshframe.FailureProcess',
    requires: [
        'Ext.Msg'
    ],

    Ajax: function (response, options) {
        if (response.status == 404) {
            Ext.Msg.alert("错误信息", "错误的请求地址。");
        } else if (response.status == 500) {
            Ext.Msg.alert("错误信息", "服务器内部错误。");
        } else {
            Ext.Msg.alert("错误信息", Ext.String.format('错误代码：{0}<br\>响应：{1}', response.status, response.responseText));
        }
    },

    Proxy: function (proxy, response, options, epots) {
        var status = response.status;
        if ((status >= 200 && status < 300) || status == 304) {
            Ext.Msg.alert("信息", options.error);
        } else {
            SimpleCMS.FailureProcess.Ajax(response, options);
        }
    },

    Form: function (form, action) {
        var status = action.response.status;
        if ((status >= 200 && status < 300) || status == 304) {
            if (action.result.errors === undefined) {
                Ext.Msg.alert("信息", action.result.msg);
            }
        } else {
            SimpleCMS.FailureProcess.Ajax(action.response);
        }
    }

});
