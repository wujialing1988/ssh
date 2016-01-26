Ext.ns('Ext.ux');
/**
 * 右下角的小贴士窗口
 * 
 * @author tipx.javaeye.com
 * @params conf 参考Ext.Window conf中添加autoHide配置项, 默认3秒自动隐藏, 设置自动隐藏的时间(单位:秒),
 *         不需要自动隐藏时设置为false
 * @注: 使用独立的window管理组(manager:new Ext.WindowGroup()), 达到总是显示在最前的效果
 */
(function($) {
	// 新建window组，避免被其它window影响显示在最前的效果
	var tipsGroupMgr = new Ext.WindowGroup();
	tipsGroupMgr.zseed = 999999999; // 将小贴士窗口前置

	$.TipsWindow = Ext.extend(Ext.Window, {
		title : '系统提示',
		width : 200,
		bodyStyle : 'padding:5px',
		height : 150,
		layout : 'fit',
		modal : false,
		plain : true,
		shadow : false,// 去除阴影
		draggable : false,// 默认不可拖拽
		resizable : false,
		closable : true,
		constrain:false,
		closeAction : 'hide',// 默认关闭为隐藏
		autoHide : 3,// n秒后自动隐藏，为false时,不自动隐藏
		count : 1,// 设置显示的是第几个tipwindow
		manager : tipsGroupMgr,// 设置window所属的组
		constructor : function(conf) {
			$.TipsWindow.superclass.constructor.call(this, conf);
			this.initPosition(true);
		},
		initEvents : function() {
			$.TipsWindow.superclass.initEvents.call(this);
			// 自动隐藏
			if (false != this.autoHide) {
				var task = new Ext.util.DelayedTask(this.hide, this), second = (parseInt(this.autoHide) || 3) * 1000;
				this.on('show', function(self) {
					task.delay(second);
				});
			}
			this.on('beforeshow', this.showTips);
			this.on('beforehide', this.hideTips);

			Ext.EventManager.onWindowResize(this.initPosition, this); // window大小改变时，重新设置坐标
			Ext.EventManager.on(window, 'scroll', this.initPosition, this); // window移动滚动条时，重新设置坐标
		},
		// 参数: flag - true时强制更新位置
		initPosition : function(flag) {
			if (true != flag && this.hidden) { // 不可见时，不调整坐标
				return false;
			}
			var doc = document, bd = (doc.body || doc.documentElement);
			// ext取可视范围宽高(与上面方法取的值相同), 加上滚动坐标
			var left = bd.scrollLeft + doc.body.clientWidth - 4 - this.width;
			var top = bd.scrollTop + doc.body.clientHeight - 4 - this.height * this.count;
			this.setPosition(left, top);
		},
		showTips : function() {
			var self = this;
			if (!self.hidden) {
				return false;
			}

			self.initPosition(true); // 初始化坐标
			self.el.slideIn('b', {
				callback : function() {
					// 显示完成后,手动触发show事件,并将hidden属性设置false,否则将不能触发hide事件
					self.fireEvent('show', self);
					self.hidden = false;
				}
			});
			return false; // 不执行默认的show
		},
		hideTips : function() {
			var self = this;
			if (self.hidden) {
				return false;
			}

			self.el.slideOut('b', {
				callback : function() {
					// 渐隐动作执行完成时,手动触发hide事件,并将hidden属性设置true
					self.fireEvent('hide', self);
					self.hidden = true;
				}
			});
			return false; // 不执行默认的hide
		}
	});
})(Ext.ux);
Ext.Msg.showTip = function(msg){
	new Ext.ux.TipsWindow({
		html : msg
	}).show();
}
Ext.Msg.showInfo = function(msg){
    Ext.Msg.show({
	title : '系统提示',
	msg : msg,
	buttons : Ext.MessageBox.OK,
	icon : Ext.MessageBox.INFO
    });
}
Ext.Msg.showError = function(msg){
    Ext.Msg.show({
	title : '系统提示',
	msg : msg,
	buttons : Ext.MessageBox.OK,
	icon : Ext.MessageBox.ERROR
    });
}
Ext.Msg.showWarning = function(msg){
    Ext.Msg.show({
	title : '系统提示',
	msg : msg,
	buttons : Ext.MessageBox.OK,
	icon : Ext.MessageBox.WARNING
    });
}