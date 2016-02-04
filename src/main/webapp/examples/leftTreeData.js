/**
 * 定义通用控件示例左侧树的数据
 * @author HEDJ
 */
var lefttreedata = {
	root : {
		text : "通用控件",
		expanded : true,
		children : [{
				text : 'ExtJs通用控件',
				children : [{
						text : '表格(grid)',
						children : [{
								text : '表格面板(Ext.grid.Panel)',
								leaf : true,
								url : 'grid/panel.html'
							}, {
								text : '单元格提示(Ext.grid.column.Column)',
								leaf : true,
								url : 'grid/column.html'
							}, {
								text : '无数据样式(Ext.grid.Panel)',
								leaf : true,
								url : 'grid/gridPanel.html'
							},  {
								text : '禁用排序(Ext.grid.header.Container)',
								leaf : true,
								url : 'grid/container.html'
							}, {
								text : '序号列(Ext.grid.RowNumberer)',
								leaf : true,
								url : 'grid/rowNumberer.html'
							}, {
								text : '分页大小(Ext.data.Store)',
								leaf : true,
								url : 'grid/store.html'
							}, {
								text : '分页信息(Ext.PagingToolbar)',
								leaf : true,
								url : 'grid/pagingToolbar.html'
							}, {
								text : '数据格式(Ext.data.proxy.Ajax)',
								leaf : true,
								url : 'grid/ajax.html'
							},{
								text : '按钮禁用(Ext.selection.CheckboxModel)',
								leaf : true,
								url : 'grid/checkboxModel.html'
							}, {
								text : '操作列按钮(Ext.grid.column.Action)',
								leaf : true,
								url : 'grid/columnAction.html'
							}, {
								text : '查询数据及隐藏列(Ext.SearchBtn)',
								leaf : true,
								url : 'grid/searchBtn.html'
							}
						]
					}, {
						text : '表单(form)',
						children : [{
								text : '必填项红色星号(Ext.form.field.Base)',
								leaf : true,
								url : 'form/base.html'
							}, {
								text : '表单验证(Ext.form.field.VTypes)',
								leaf : true,
								url : 'form/vtype.html'
							}, {
								text : '提交进度条(Ext.form.action.Action)',
								leaf : true,
								url : 'form/actionOverride.html'
							}
						]
					}, {
						text : '消息提示(msg)',
						children : [{
								text : '消息提示(Ext.Msg)',
								leaf : true,
								url : 'msg/msg.html'
							}
						]
					}, {
						text : '控件(widget)',
						children : [{
							text : 'My97日期控件(Ext.form.field.My97DateTimePicker)',
							leaf : true,
							url : 'my97DateTimePicker/my97DateTimePicker.html'
						},{
							text : '模糊查询翻页下拉(Ext.form.field.ComboBox.QuerySelectCombo)',
							leaf : true,
							url : 'querySelectCombo/querySelectCombo.html'
						},{
							text : '模糊查询弹出列表(Ext.form.field.ComboBox.QuerySelectGrid)',
							leaf : true,
							url : 'querySelectGrid/querySelectGrid.html'
					    },{
							text : '附件组(Ext.Attach)',
							leaf : true,
							url : 'attach/attach.html'
						 },
						 {
								text : '多附件上传(Ext.Attach)',
								leaf : true,
								url : 'attachMulti/attachMulti.html'
						 }
						]
					}, {
						text : '业务优化(optimize)',
						children : [{
							text : '列表明细列(Ext.grid.column.DetailColumn)',
							leaf : true,
							url : 'detailColumn/detailColumn.html'
					    }]
					}
				]
			}, {
				text : '异常处理及兼容',
				children : [{
						text : '右侧嵌入式iframe空白加载',
						leaf : true,
						url : 'abnormal/a1.html'
					}, {
						text : 'IE下飘浮提示数字符号断行',
						leaf : true,
						url : 'abnormal/a2.html'
					}, {
						text : '多层弹出窗口异常',
						leaf : true,
						url : 'abnormal/a3.html'
					}
				]
			}, {
				text : 'jQuery通用控件',
				leaf : false
			}, {
				text : '自定义JS通用控件',
				leaf : false
			}
		]
	}
};
