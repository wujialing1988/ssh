<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="../../../WEB-INF/pages/common/doc_type.jsp"%>
<html>
<head>
<%@include file="../../../WEB-INF/pages/common/meta.jsp"%>
<%@include file="../../../WEB-INF/pages/common/taglibs.jsp"%>
<%@include file="../../../WEB-INF/pages/common/css.jsp"%>
<%@include file="../../../WEB-INF/pages/common/ext.jsp"%>
<title>示例1</title>

<script type="text/javascript" >
//var menuId = '<s:property value="#parameters.id"/>';
</script>
</head>
<body>
	<script type="text/javascript">
	//@定义树形数据模型
	Ext.define('eam.examples.main.MainTreeModel', {
		extend : 'Ext.data.Model',
		fields : [{
				name : 'parentId',
				type : 'string'
			}, {
				name : 'id',
				type : 'string'
			}, {
				name : 'nodeId',
				mapping : 'id'
			}, {
				name : 'text',
				type : 'string'
			}, {
				name : 'href',
				type : 'string'
			}, {
				name : 'leaf',
				type : 'boolean'
			},{
				name:'hrefTarget',
				type : 'string'
			}
		]
	});
	//定义数据store
	eam.configuration={};
	/**
	 * 定义列表树表格data
	 */
	eam.configuration.DataDictionaryTreeData = [];

	/**
	 * 定义列表数表格
	 */
	eam.configuration.DataDictionaryTreeStore = Ext.create('Ext.data.TreeStore', {
		model: 'eam.examples.main.MainTreeModel',
	    clearOnLoad:true,
	    proxy: {
	        type: 'memory',
	        data: eam.configuration.DataDictionaryTreeData,
	        reader: {
	            type: 'json'
	        }
	    }
	});

	//定义树形panel
	eam.examples.main.MainTree = Ext.create('Ext.tree.Panel', {
		region : 'west',
		collapsible: true,
        split: true,
        collapseMode:"mini",
		width : 160,
		store : eam.configuration.DataDictionaryTreeStore,
        tbar:new Ext.Toolbar({
            style:"border-top:0px;border-left:0px",
            items:[
            {
                iconCls: "icon-expand-all",
                text:"展开",
                tooltip: "展开所有",
                handler: function(){ eam.examples.main.MainTree.expandAll(); },
                scope: this
            },{
                iconCls: "icon-collapse-all",
                text:"折叠",
                tooltip: "折叠所有",
                handler: function(){ eam.examples.main.MainTree.collapseAll(); },
                scope: this
            }]
        }),
		listeners : {
			load : function (treePanel) {
				var root = treePanel.getRootNode();
				if (!root.data.leaf && root.childNodes.length > 0) {
					var firstChild = null;
					root.cascadeBy(function(child){
						if(child.data.leaf && !firstChild){
                            window.frames['frame_Content'].location.href = child.data.href;
                            firstChild = child;
                            eam.examples.main.MainTree.getSelectionModel().select(child, true);
                        }
					});
				}
            }
        }
	});
	
	Ext.onReady(function() {
		/**
		 * 定义Store(生成列表的动态数据)
		 */
		eam.configuration.DataDictionaryStore = Ext.create('Ext.data.Store', {
			model : 'eam.examples.main.MainTreeModel',
			proxy : {
				type : "format",
				url: basePath+'/user/getSecondLevelMenu.action',
				extraParams:{id: '<s:property value="#parameters.id"/>'}
			},
			autoLoad:true,
			listeners:{
		    	load:function(obj,records, successful){
		    		//全部清除所有的子节点
		    		if(records && records.length){
		    			for(var i=0;i<records.length;i++){
		    				eam.configuration.DataDictionaryTreeData.push(records[i]);
		        		}
		    		}
		    		eam.configuration.DataDictionaryTreeStore.load();//treeStore加载数据
		    		eam.configuration.DataDictionaryTreeData.length = 0;
		    	}
		    }
		});

		Ext.create("Ext.container.Viewport", {
			layout : "border",
			items : [eam.examples.main.MainTree,{
                   region: "center",
				border: false,
                   html: "<iframe id='myGrid' src='' width='100%' height='100%' frameborder='0' scrolling='auto' name='frame_Content'></iframe>"
               }]
		});
	});
	</script>
</body>
</html>