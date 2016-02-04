<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../common/doc_type.jsp"%>
<html>
<head>
<%@include file="../common/meta.jsp"%>
<%@include file="../common/taglibs.jsp"%>
<%@include file="../common/css.jsp"%>
<%@include file="../common/ext.jsp"%>
<title>角色管理</title>
<script type="text/javascript" src="${ctx}/scripts/role/userAndGroupSelect.js"></script>
<script type="text/javascript" src="${ctx}/scripts/role/RoleGrid.js"></script>
<script type="text/javascript" src="${ctx}/scripts/role/RoleWin.js"></script>
</head>
<body>
	<script type="text/javascript">
		Ext.onReady(function() {
			Ext.define('treeModel', {
				extend : 'Ext.data.Model',
				fields : [ {
					name : 'nodeId',
					type : 'int'
				}, {
					name : 'parentId',
					type : 'int'
				}, {
					name : 'id',
					type : 'int',
					mapping : 'nodeId'
				}, {
					name : 'text',
					type : 'string'
				}, {
					name : 'code',
					type : 'string'
				} ]
			});
			var treeStore = Ext.create("Ext.data.TreeStore", {
				proxy : {
					type : "ajax",
					extraParams : {
						dictTypeCode : "ROLETYPE"
					},
					url : "${ctx}/dict/getDictListForTree.action"
				},
				root : {
					text : "角色类型",
					nodeId : "0"
				}
			});

			treeStore.on("load", function(store, node, records) {
				treePanel.getSelectionModel().select(node.firstChild, true);
				treePanel.fireEvent("itemclick", treePanel.getView(), node.firstChild);
			});

			resourceTreeStore = Ext.create('Ext.data.TreeStore', {
				model : 'treeModel',
				nodeParam : 'parentId',
				autoLoad : false,
				clearOnLoad : true,
				proxy : {
					type : 'ajax',
					reader : {
						type : 'json'
					},
					folderSort : true,
					sorters : [ {
						property : 'nodeId',
						direction : 'DESC'
					} ],
					url : '${ctx}/role/getRoleResourceForTree.action'
				},
				root : {
					expanded : true,
					id : "0"
				}
			});

			var treePanel = Ext.create("Ext.tree.Panel", {
				title : '角色类型',
				layout : 'fit',
				width : 200,
				region : "west",
				border : false,
				collapsible : true,
				split : true,
				collapseMode : "mini",
				store : treeStore,
				id : "typeTree",
				useArrows : true,
				rootVisible : true,
				dockedItems : [ {
					xtype : 'toolbar',
					style : "border-top:0px;border-left:0px",
					items : [ {
						iconCls : "icon-expand-all",
						text : '展开',
						tooltip : "展开所有",
						handler : function() {
							treePanel.expandAll();
						},
						scope : this
					}, {
						iconCls : "icon-collapse-all",
						text : '折叠',
						tooltip : "折叠所有",
						handler : function() {
							treePanel.collapseAll();
						},
						scope : this
					} ]
				} ],
				listeners : {
					"afterrender" : function(treePanel, eOpts) {
						var path = treePanel.getRootNode().getPath();
						treePanel.expandPath(path)
					}
				}
			});
			treePanel.on("itemclick", function(view, record, item, index, e, opts) {
				//获取当前点击的节点  
				var treeNode = record.raw;
				var text = treeNode.text;
				var id = treeNode.nodeId;
				var code=treeNode.code;
				sshframe.role.RoleStore.on('beforeload', function(store, options) {
					var new_params = {
						//"roleType" : id
						  "roleType" : code
					};
					Ext.apply(store.proxy.extraParams, new_params);
				});
				var proxy = sshframe.role.RoleStore.getProxy();
				proxy.setExtraParam("roleName", Ext.getCmp('inputRoleName').getValue());
				sshframe.role.RoleStore.loadPage(1);
			});

			Ext.create("Ext.container.Viewport", {
				layout : "border",
				renderTo : Ext.getBody(),
				items : [ treePanel, sshframe.role.RoleGrid ]
			});
		});

		function toAddResource(roleId) {
			resourceTreePanel = Ext.create(Ext.tree.Panel, {
				id : 'resourceTreePanel',
				autoScroll : true,
				border : false,
				rootVisible : false,
				modal : true,
				store : resourceTreeStore,
				viewConfig : {
					onCheckboxChange : function(e, t) {
						var resourceIds = [];
						var item = e.getTarget(this.getItemSelector(), this.getTargetEl()), record;
						if (item) {
							Ext.MessageBox.wait("", "角色资源修改", {
								text : "请稍后..."
							});

							record = this.getRecord(item);
							var check = !record.get('checked');
							record.set('checked', check);
							if (check) {
								record.bubble(function(parentNode) {
									parentNode.set('checked', true);
									resourceIds.push(parentNode.raw.nodeId);
								});
								record.cascadeBy(function(node) {
									node.set('checked', true);
									resourceIds.push(node.raw.nodeId);
								});
								record.expand();
								record.expandChildren();
							} else {
								record.collapse();
								record.collapseChildren();
								record.cascadeBy(function(node) {
									node.set('checked', false);
									resourceIds.push(node.raw.nodeId);
								});
								record.bubble(function(parentNode) {
									var childHasChecked = false;
									var childNodes = parentNode.childNodes;
									if (childNodes || childNodes.length > 0) {
										for (var i = 0; i < childNodes.length; i++) {
											if (childNodes[i].data.checked) {
												childHasChecked = true;
												break;
											}
										}
									}
									if (!childHasChecked) {
										parentNode.set('checked', false);
										resourceIds.push(parentNode.raw.nodeId);
									}
								});

							}
							resourceIds = Ext.Array.unique(Ext.Array.remove(resourceIds, "0"));
							resourceIds = Ext.Array.unique(Ext.Array.remove(resourceIds, ""));
							$.post("${ctx}/role/addRoleResource.action", {
								roleId : roleId,
								resourceIds : resourceIds.join(),
								checked : check
							}, function(data) {
								Ext.MessageBox.hide();

								var responseData = Ext.decode(data);
								if (responseData.success) {
									new Ext.ux.TipsWindow({
										title : SystemConstant.alertTitle,
										html : responseData.msg
									}).show();
								} else {
									Ext.MessageBox.show({
										title : SystemConstant.alertTitle,
										msg : responseData.msg,
										buttons : Ext.MessageBox.OK,
										icon : Ext.MessageBox.INFO
									});
								}
							});
						}
					}
				}
			});

			roleResourceWin = Ext.create(Ext.window.Window, {
				title : SystemConstant.allocationOperaText + SystemConstant.resource_res,
				width : 800,
				height : 445,
				modal : true,
				layout : 'fit',
				items : [ resourceTreePanel ],
				resizable : true,
				buttonAlign : 'center',
				buttons : [ {
					text : '关闭',
					handler : function() {
						roleResourceWin.close();
					}
				} ]
			}).show();

			var proxy = resourceTreeStore.getProxy();
			proxy.setExtraParam("roleId", roleId);
			resourceTreeStore.load(proxy);
		};

		var roleMemberIds;
		function togetUserListByCurrenRole(roleId) {
			//右侧组织树store
			var orgTreeStore = Ext.create('Ext.data.TreeStore', {
				model : 'treeModel',
				nodeParam : 'parentId',
				autoLoad : false,
				border : false,
				clearOnLoad : true,
				proxy : {
					type : 'ajax',
					extraParams : {
						roleMemberIds : roleMemberIds
					},
					reader : {
						type : 'json'
					},
					folderSort : true,
					sorters : [ {
						property : 'nodeId',
						direction : 'DESC'
					} ],
					url : '${ctx}/role/getRoleOrgForTree.action'
				},
				root : {
					expanded : true,
					id : "0"
				}
			});
		}
	</script>
</body>
</html>