/**
 * @date 2015-05-27
 * 设置EXTJS控制的默认值，为控制添加默认监听事件或行为等。
 */

/**
 * 初始化消息提示
 */
Ext.QuickTips.init();

/**
 * @author hedjaojun
 * @date 2015-05-28
 * 
 * 默认显示分页信息
 */
Ext.define('Ext.ux.pagingToolbarOverride', {
	override : 'Ext.PagingToolbar',
	displayInfo : true // 第 {0} - {1} 条，共 {2} 条
});

/**
 * @author hedjaojun
 * @date 2015-05-28
 * 
 * 设置表格单元格在鼠标移动上去后，默认出现提示信息
 */
Ext.define('Ext.grid.column.ColumnOverride', {
	override : 'Ext.grid.column.Column',
	menuDisabled: true,
	renderer : function(v , ctx , record){ 
	    ctx.tdAttr = 'data-qtip="' + v + '"';
	    return v; 
	}
});

/**
 * @author zengchao
 * @date 2016-01-21
 * 
 * 在列表的序号列
 */
Ext.define('Ext.grid.RowNumbererOverride', {
	override : 'Ext.grid.RowNumberer',
	text:"序号",
	width:30,
	align:"center",
	renderer: function(value, metaData, record, rowIdx, colIdx, store) {
		var me=this;
		var rowspan = this.rowspan,
			page = store.currentPage,
			result = record.index;
		if (rowspan) {
			metaData.tdAttr = 'rowspan="' + rowspan + '"';
		}
	
		if (result == null) {
			result = rowIdx;
			if (page > 1) {
				result += (page - 1) * store.pageSize; 
			}
		}
		var digit=result.toString().length-1;
		me.width=35+5*digit;
		return result + 1;
	}
});

/**
 * @author zenchao
 * @date 2015-05-29
 * 
 * 设置默认没有排序功能
 */
Ext.define('Ext.grid.header.ContainerOverride', {
	override : 'Ext.grid.header.Container',
	defaults: { // defaults 将会应用所有的子组件上,而不是父容器
		sortable : false
	}
});

/**
 * @author hedjaojun
 * @date 2015-05-29
 * 
 * 设置分页条数为 99
 */
Ext.define('Ext.data.StoreOverride', {
	override : 'Ext.data.Store',
	pageSize: 99
});

/**
 * @author hedjaojun
 * @date 2015-05-29 定义数据格式
 */
Ext.define('Ext.ux.data.proxy.Format', {
    extend: 'Ext.data.proxy.Ajax',
    alias: 'proxy.format',
    actionMethods: {
		read: 'POST'
    },
    reader: {
        type: 'json',
        root: "list",
        totalProperty: "totalSize",
        messageProperty: "msg"
    },
    listeners: {
        exception : function (proxy, response, options, epots) {
            sshframe.FailureProcess.Proxy.apply(this, arguments);
        }
    }
});

 /**
 * @author zengchao
 * @date 2015-05-29
 * 
 * @edit hedaojun
 * @data 2015-06-03 复选框,实现根据选择的记录条数，disable 删除，添加等按钮。 使用时，需要为CheckboxModel
 *       添加 使用时，在列表的button配置里添加 属性 disabledExpr 例：
 *       disabledExpr:"$selectedRows != 1 || $status =='1'" $selectedRows
 *       表示选中的记录数不等于1,或者选择行记录的状态为禁用 $status 为modal中定义的字段。
 * 
 */
Ext.define("Ext.selection.CheckboxModelOverride", {
	override : 'Ext.selection.CheckboxModel',
	injectCheckbox : 1,
	listeners :{
	    "selectionchange" : function (checkModel){
	    	// 定义计算表达式的函数。
	    	var evalExpr = function(expr){
				var result = false;
				try{ result = eval(expr);  }catch(e){
					 // alert('禁用按钮表达示错误: '+e.name+' '+e.message);
				 }
				 return result;
			};
			var ownerCt=checkModel.view.initialConfig.grid;
	        var selectRows = ownerCt.getSelectionModel().getSelection();
			var selLenth=selectRows.length;
			var buttons = Ext.ComponentQuery.query('button',ownerCt);
			var exps,disabled;
			for(var i=0;i<buttons.length;i++){
				 if(buttons[i].disabledExpr){
					 var exps = buttons[i].disabledExpr;
					 // selLenth为前面定义的选择的行数
					 exps = exps.replace(/\$selectedRows/g, 'selLenth');
					 if(selLenth==0){
						 disabled = evalExpr(exps);
					 }else{
						 for(var j = 0; j<selLenth ; j++) {
							 var data = selectRows[j].data;
							 exps = exps.replace(/\$/g, 'data.');
							 disabled = evalExpr(exps);
							 if(disabled === true){
							 	break;
							 }
						}
					 }
					 if(disabled === true){
						 	buttons[i].setDisabled(true);
					 }else{
						 buttons[i].setDisabled(false);
					 }
				}
			}
		}
    }
});


/**
 * @author hedjaojun
 * @date 2015-05-28
 * 设置表格列边框，强制适应页面等基本样式
 * 
 * @author zengchao
 * @date 2015-12-24
 * 列表的自动显示暂无数据和查询条件下午数据的图片展示方式
 */
var judgeArrIsAllthenull=function(arr){//判断store中是否没有参数，或者参数全部为空
	var result = true;
	if(arr.length===0){
		return true;
	}else{
		for(x in arr){
			if(arr[x]==''||arr[x]==undefined||arr[x]==null){
			}else{
				result=false;
				break;
			}
		}
	}
	return result;
};

Ext.define('Ext.grid.PanelOverride', {
	override : 'Ext.grid.Panel',
	columnLines : true, // 列边框线
	forceFit : true, // 列表自适应页面
	autoScroll: true,
	stripeRows: true,
	store:{},
	gridNoNumber:'',
	initComponent:function(){
		var me=this;
		me.store.on("load",function(dataStore) {  
			var count = dataStore.getCount();
			var paramsArr = Ext.Object.getValues(dataStore.getProxy().extraParams);	
			paramsResult=judgeArrIsAllthenull(paramsArr);
			if (count <= 0) {
				if (paramsResult==false) {
					var gridNoimg2_id='gridNoimg2_'+me.id;
					me.getView().update('<div id="'+gridNoimg2_id+'" class="gridNoimg_2"></div>');
				} else {
					var gridNoimg1_id='gridNoimg1_'+me.id;
					me.getView().update('<div id="'+gridNoimg1_id+'"class="gridNoimg_1"></div>');
				}
			} else {
				if (Ext.getDom('gridNoimg1_'+me.id)) {
					Ext.getDom('gridNoimg1_'+me.id).style.cssText = 'display:none;';
				}
				if (Ext.getDom('gridNoimg2_'+me.id)) {
					Ext.getDom('gridNoimg2_'+me.id).style.cssText = 'display:none;';
				}
			}
		},this);
		me.store.on("add",function(store) {  
				if (Ext.getDom('gridNoimg1_'+me.id)) {
					Ext.getDom('gridNoimg1_'+me.id).style.cssText = 'display:none;';
				}else if (Ext.getDom('gridNoimg2_'+me.id)) {
					Ext.getDom('gridNoimg2_'+me.id).style.cssText = 'display:none;';
				}
		},this);
		this.callParent(arguments); 
     }
});

Ext.define("Ext.form.action.ActionOverride",{
    override : 'Ext.form.action.Action',
    waitTitle : '请等待...',
    waitMsg : '正在提交...'
});

 /**
	 * @author zengchao
	 * @date 2015-06-01
	 * 
	 * 为弹出的form中的录入控件增加必填项标示*
	 * 
	 */
Ext.override(Ext.form.field.Base, { // 针对form中的基本组件
	initComponent : function () {
		if (this.allowBlank !== undefined && !this.allowBlank) {
			if (this.fieldLabel) {
				this.fieldLabel = "<span style='color:red;'>*</span>" + this.fieldLabel;
			}
		}
		this.callParent(arguments);
	}
});
Ext.override(Ext.container.Container, { // 针对form中的容器组件
	initComponent : function () {
		if (this.allowBlank !== undefined && !this.allowBlank) {
			if (this.fieldLabel) {
				this.fieldLabel = "<span style='color:red;'>*</span>" + this.fieldLabel;
			}
		}
		this.callParent(arguments);
	}
});


 /**
	 * @author zengchao
	 * @date 2015-06-01
	 * 
	 * 弹出框windows 在不同的展示中可能会对layout进行多种调整，默认为auto，这样的窗口会从上至下的去展示items中的组件；
	 * 
	 */
Ext.define("Ext.window.WindowOverride",{
	override : 'Ext.window.Window',
	closable: true,
	resizable: false,
	buttonAlign: "center",
	modal: true,
	layout : 'fit',
	closeAction : 'hide'
});

 /**
	 * @author zengchao
	 * @date 2015-06-02
	 * 
	 * xtype:'combo'在from表单中 默认显示为 请选择
	 * 
	 */
Ext.define("Ext.form.ComboBoxOverride",{
	override : 'Ext.form.ComboBox',
	typeAhead:false,
	editable:false,
	queryMode: 'local'
});

/**
 * @author hedaojun
 * @date 2015-06-30
 * 根据表达式判断返回一个布尔值的方法
 *
 */
var evalExpr = function(expr){
	var result = false;
	try{
		result = eval(expr);
	 }catch(e){
		 Ext.Msg.showError('计算表达式错误: '+e.name+' '+e.message);
	 }
	 return result;
};

/**
 * @author zengchao
 * @date 2015-06-30
 * 
 * @rewrite zengchao
 * @date 2015-06-30
 * grid.column中的操作列，图标按钮控制，需要配置showExpr表达式参数来确定根据什么条件显示此按钮
 * 例： showExpr:'$d=="同意"||$e==3'  /$d=="同意" 表示model中取得的行数据等于 "同意"的时候显示
 * 注意：将过去的$name$=='value'方式调整为$name=='value'
 */

Ext.define('Ext.grid.column.ActionOverride', {
	override : 'Ext.grid.column.Action',
	iconClsArray : new Array(),
	initComponent : function(){
    	var me = this;
    	me.iconClsArray.length = 0;
        me.callParent(arguments);
    },
	renderer : function (value, cellmeta, record, rowIndex, columnIndex, store) {
		// 定义计算表达式的函数。
		 var evalExpr = function(expr){
			var result = false;
			try{ result = eval(expr);  }catch(e){
				 // alert('禁用按钮表达示错误: '+e.name+' '+e.message);
			 }
			 return result;
		}
		var pd=true;
		for (var i = 0; i < this.items.length; i++) {
			if(this.items[i].iconCls=='null-button'){
				pd=false;
				break;
			}
			else{
			}
		}
		if(pd==true){
			this.iconClsArray.length = 0;
		}else{
			
		}
		for (var i = 0; i < this.items.length; i++) {
			var exps = this.items[i].showExpr;
			if(exps){
			this.iconClsArray.push(this.items[i].iconCls);
			exps = exps.replace(/\$/g, 'record.data.');
			disabled = evalExpr(exps);
			if (disabled == false) {
				this.items[i].iconCls = 'null-button';
			} else {
				this.items[i].iconCls = this.iconClsArray[i];
			}
		  }
		}
	}
});

/**
 * @author zengchao
 * @date 2015-09-23
 * 
 * 封装tree树形菜单，简化前端代码;
 */	
Ext.define('Ext.tree.PanelOverride', {
	override : 'Ext.tree.Panel',
	border : true,
	collapseMode : "mini",
	collapsible : false,
	split : true,
	rootVisible : false
});
/**
 * @author zengchao
 * @date 2015-09-15
 * 
 * 封装form.Panel普通面板，单纯对整体样式风格进行封装：内容整体边距为10px;items标题长度为80;
 */	
 
Ext.define("Ext.form.PanelOverride", {
	override : 'Ext.form.Panel',
	frame: false,
	bodyPadding: 0,
	border: 0,
	border: false,
	layout: 'column',
	bodyStyle: 'padding:0px 3px 0px 2px',
	fieldDefaults: {
		labelWidth: 80,
		labelAlign: 'right',
		anchor: '100%'
	},
	defaults: {
	border: 0,
	border: false,
	bodyStyle :'padding-right:3px;padding-left:3px'
	}
});

 /**
 * @author zengchao
 * @date 2015-07-01
 * 
 * 创建searchButton按钮类，按钮作用于gird中tbar下的查询按钮
 * 1，遍历查询按钮之前的
 * 2，遍历tbar下的查询条件，对存在dataIndex的控件提取值，用于对columns列隐藏；
 * 例：dataIndex=a&b，标示columns中dataIndex值为a和b的都隐藏
 * 注：在显示的时候如果前置条件存在a值并且隐藏掉了，那么当前条件如果dataIndex=a&b，并且值为全部的时候a不会被显示出来
 */
Ext.define("Ext.SearchBtn", {
	extend : 'Ext.Button',
	xtype : 'searchBtn',
	text : "查询",
	iconCls : "search-button",
	handler : function (button) {
		var myGrid = this.findParentByType("grid");
		var tbarItems = this.findParentByType("toolbar").items;
		var tbarItemsKeys = tbarItems.keys;
		var new_params = {};
		var arr = new Array();
		for (key in tbarItemsKeys) {
			var buttonItmes = button.prev('#' + tbarItemsKeys[key]);
			if (buttonItmes) {
				if (buttonItmes.itemId != undefined) {
					arr.push(buttonItmes.itemId);
					new_params[buttonItmes.itemId] = buttonItmes.getValue();
				}
			}
		}
		var dataStore = myGrid.getStore();
		Ext.apply(dataStore.getProxy().extraParams, new_params);
		dataStore.loadPage(1);
		
		var gridColumns = myGrid.columns;
		var dataIndexArray = new Array();
		for (var i = 0; i < tbarItems.length; i++) {
			var hideIndex = (tbarItems.items)[i].dataIndex
			var patt = new RegExp('&');
			var relation = patt.test(hideIndex);
			if (relation == false && hideIndex) {
				dataIndexArray.push(hideIndex);
			}
		}
		for (var i = 0; i < tbarItems.length; i++) {
			if ((tbarItems.items)[i].dataIndex && (tbarItems.items)[i].value != 'all') {
				var hideIndex = (tbarItems.items)[i].dataIndex
				var hideIndexArray = hideIndex.split("&"); //拆分表达式
				for (var y in hideIndexArray) { //遍历判断
					for (var x in gridColumns) {
						if (myGrid.columns[x].dataIndex == hideIndexArray[y]) {
							gridColumns[x].hide();
						}
					}
				}
			} else if ((tbarItems.items)[i].dataIndex && (tbarItems.items)[i].value == 'all') {
				
				var hideIndex = (tbarItems.items)[i].dataIndex
				var hideIndexArray = hideIndex.split("&");
				var patt = new RegExp('&');
				var relation = patt.test(hideIndex);
				if (relation == true) {
					for (var z in dataIndexArray) {
						Ext.Array.remove(hideIndexArray, dataIndexArray[z])
					}
					for (var y in hideIndexArray) {
						for (var x in gridColumns) {
							if (myGrid.columns[x].dataIndex == hideIndexArray[y]) {
								gridColumns[x].show();
							}
						}
					}
				} else if (relation == false) {
					for (var y in hideIndexArray) {
						for (var x in gridColumns) {
							if (myGrid.columns[x].dataIndex == hideIndexArray[y]) {
								gridColumns[x].show();
							}
						}
					}
				}
			}
		}
	}
});



/**
 * @author zengchao
 * @date 2015-09-18
 * 封装日期控件dateTimePicker；
 * 1，需要设置dateFmt属性，标示出时间格式；默认为值dateFmt:'yyyy-MM-dd'，既 年-月-日的显示方式；
 * 2，当控件实例中设置了allowBlank:false默认必填，那么控件会自动给出当前日期；
 * 3，需要设置参数maxDate或者minDate；其中maxDate为最大日期限制的日期控件id，minDate为最小日期限制的日期控件id；
 * 例：maxDate:'endDate'，那么此日期控件能选择的范围不得超过id为endDate的控件日期的范围；
 * 例：maxDate:'2016-01-05'，那么此日期控件能选择的范围不得超过2016年1月5日的控件日期的范围；
 * 注：控件的内核代码为my97DatePicker；
 * 注：此封装只是针对了这种联锁关系限制的简化控制，如果有特殊情况比如需要一个特点日期的限制，请不要使用此dateTimePicker控件，用my97日期控件原始去做控制；
 */
Ext.define("Ext.form.field.My97DateTimePicker", {
	extend : 'Ext.form.field.Text',
	xtype : "dateTimePicker",
	dateFmt:'yyyy-MM-dd',
	minTime : "1900-01-01 00:00:00",
	maxTime : "2099-12-31 23:59:59",
	readOnly:true,
	initComponent : function(){
		var me = this;
    	var changedFun=me.changedFun
		if(this.allowBlank==false){
			var curDate = new Date();
			var dateFmtRequired=this.dateFmt;
			dateFmtRequired=dateFmtRequired.replace(/yyyy/, "Y");
			dateFmtRequired=dateFmtRequired.replace(/MM/, "m");
			dateFmtRequired=dateFmtRequired.replace(/dd/, "d");
			dateFmtRequired=dateFmtRequired.replace(/HH/, "H");
			dateFmtRequired=dateFmtRequired.replace(/mm/, "m");
			dateFmtRequired=dateFmtRequired.replace(/ss/, "s");
			var time=Ext.Date.format(curDate, dateFmtRequired);
			this.setValue(time);
		}
        me.callParent(arguments);
    },
	listeners : {
		'render' : function (p) {
			var me=this;
			var thisinputEl=this.id+'-inputEl';
			var thisInput = Ext.getDom(thisinputEl);
			thisInput.className = 'dateTime-icon';
			var dateFmt=this.dateFmt;
			if(this.maxDate){
				var dateRequired=this.maxDate;
				dateRequired=dateRequired.replace(/\-/g, "");
				dateRequired=dateRequired.replace(/\:/g, "");
				dateRequired=dateRequired.replace(/[\u4E00-\u9FA5]/g, "");
				var re = /^[0-9]+.?[0-9]*$/;   //判断字符串是否为数字
			    if (!re.test(dateRequired))
			    {
			    	this.maxTime="#F{$dp.$D(\'"+this.maxDate+"-inputEl\')}"; 
			    }else{
			    	this.maxTime=this.maxDate; 
			    }
			}if(this.minDate){
				var dateRequired=this.minDate;
				dateRequired=dateRequired.replace(/\-/g, "");
				dateRequired=dateRequired.replace(/\:/g, "");
				dateRequired=dateRequired.replace(/[\u4E00-\u9FA5]/g, "");
				var re = /^[0-9]+.?[0-9]*$/;   //判断字符串是否为数字
			    if (!re.test(dateRequired))
			    {
			    	this.minTime="#F{$dp.$D(\'"+this.minDate+"-inputEl\')}"; 
			    }else{
			    	this.minTime=this.minDate; 
			    }
			}
			thisInput.onclick = function(){
				WdatePicker({
					readOnly : true,
					dateFmt : dateFmt,
					minDate : me.minTime,
					maxDate : me.maxTime,
					onpicked: dateTimePickerCallBack
				});
			};
			function dateTimePickerCallBack(){
				 if (me.changedCallback) {
						var changedCallback = me.changedCallback;
						changedCallback();
					}
			}
		}
	}
});
/**
 * @author zengchao
 * @date 2015-10-27
 * 封装combox下拉分页控件；
 * 1，需要配置pathByUrl通过id去查询数据的action地址；
 * 2，解决如果初始化或者更新数据不在第一页或者本页的情况下，不能赋值的漏洞
 * 3，解决翻页后，已选择数据会被置空的漏洞
 * 4，通过对Ext.locale.zh_CN.toolbar.Paging重构的改写，对数据combo的翻页样式进行了编辑，以适应在较短的输入框中也能显示完全
 */

Ext.define("Ext.form.field.ComboBox.QuerySelectCombo", {
	extend : 'Ext.form.field.ComboBox',
	xtype:'querySelectCombo',
	forceSelection : true,
	queryParam : 'keystring',
	valueField : 'id',
	minChars : 0,
	triggerAction : 'all',
	pageSize :5,
	editable : true,
	typeAhead : false,
	queryMode : 'remote',
	displayFieldValue:'',
	valueFieldValue:'',
	targetObject:'',
	validateOnChange:false,
	setDefaultValue : function(val) {
		var me = this;
		if (val != '') {
			me.setValue(val);
		}
	},
    setValue:function(idd){
       var me = this;
       var paramsId=idd;
     	if(paramsId==undefined|| paramsId == ''){
     		if(paramsId==undefined){
				me.setRawValue('');
				me.value='';
     		} else{
       	     // 设置空数据
        		var data ;
    			Ext.Array.forEach(me.store.data.items, function(element,i , list) {
    				if(element.data[me.valueField]==''){
    					data = element.data;
    					return ;
    				}
    			});
    			if(data!=undefined){
        			me.displayTplData =[data];
    				me.setRawValue(data[me.displayField]);
    				me.value=paramsId;
    			} else{
    				me.setRawValue('');
    				me.value='';
    			}
     		}
     	}else if(typeof(idd)=='object'){
    		// 设置行数据时的处理
    		var path=me.pathByUrl;
    		paramsId=idd[0].data[me.valueField];
    		if(paramsId==''){
    			// 选中值为''的时候
    			var data ;
    			Ext.Array.forEach(me.store.data.items, function(element,i , list) {
    				if(element.data[me.valueField]==paramsId){
    					data = element.data;
    					return ;
    				}
    			});
    			if(data!=undefined){
	    			me.displayTplData =[data];
					me.setRawValue(data[me.displayField]);
					me.value=paramsId;
    			}
    		} else if(me.store.find(me.valueField,paramsId) >=0){
    			// 绑定数据列表的时候
    			var data ;
    			Ext.Array.forEach(me.store.data.items, function(element,i , list) {
    				if(element.data[me.valueField]==paramsId){
    					data = element.data;
    					return ;
    				}
    			});
    			if(data!=undefined){
	    			me.displayTplData =[data];
					me.setRawValue(data[me.displayField]);
					me.value=paramsId;
    			}
    		} else{
    			// 其他时候
				me.setRawValue(idd[0].data[me.displayField]);
				me.value=paramsId;
    		}
    		if(me.propertyMap){
    		  setPropertyMap(me.propertyMap,idd[0].data)
    		}
    	} else  { //if (me.store.find(me.valueField,paramsId) == -1) {
    		// 数据不在Store列表中
    		var path=me.pathByUrl;
    		var queryCondition={};
    		queryCondition[me.valueField]=paramsId;		
     		Ext.Ajax.request({
			    url:path,
				params:queryCondition,
				success : function(res) {
					var ret = Ext.decode(res.responseText);
					if (ret.success) {
						var udata = ret.data;
						if(me.store.data.items.length>0 && udata!==undefined){
							var rdata = me.store.data.items[0].copy();
							if(targetObject!=''){
								rdata[me.displayField] = udata[targetObject+'.'+me.displayField];
								rdata[me.valueField] = paramsId;							
							}else{
								rdata[me.displayField] = udata[me.displayField];
								rdata[me.valueField] = paramsId;							
							}
							me.displayTplData = [  rdata ];
							me.setRawValue(rdata[me.displayField]);
							me.value=paramsId;
						} else{
							me.setRawValue(udata[me.displayField]);
							me.value=paramsId;
						}
			    		if(me.propertyMap){
			        		  setPropertyMap(me.propertyMap,udata)
			        	}
					}
				}
			});
		}
    },
    initComponent : function(){
    	var me = this;
    	displayFieldValue=me.displayField;
    	valueFieldValue=me.valueField;
    	targetObject=me.targetObject;
    	me.on('change', function(ctrl, newval, oldval) {
			 if(me.store.findRecord(me.valueField, newval)){
					me.setDefaultValue(newval);
			 }else if (newval != '' && oldval == '') {
					me.setDefaultValue(newval);
			 } 
		});
    	me.callParent(arguments);
    }
});

function setPropertyMap(propertyMap,record){
	for (name in propertyMap) {
		var key = propertyMap[name];
		if (typeof key == 'function') {
			key(record[name]); // 执行传入方法
			continue;
		}
		var relation = name.indexOf('.')
		var resultValue;
		if (name && relation > 0) {
			var showExprArray = name.split("."); // 拆分表达式
			resultValue = record[showExprArray[0]][showExprArray[1]];
		} else if (relation == -1) {
			resultValue = record[name];
		}
		Ext.getCmp(propertyMap[name]).setValue(resultValue);
	}
}

function emptyPropertyMap(propertyMap){
	for (name in propertyMap) {
		var key = propertyMap[name];
		if (typeof key == 'function') {
			continue;
		};
		Ext.getCmp(propertyMap[name]).setValue('');
	}
}

/**
 * 
 */
Ext.define("Ext.form.field.ComboBox.QuerySelectGrid", {
	extend : 'Ext.form.field.ComboBox',
	hideTrigger : true,
	queryMode : 'local',
	xtype : "querySelectGrid",
	fieldLabel:'',
	queryParam : 'keystring',
	targetObject:'',
	listeners : {
		'render' : function(p) {
			var thisinputEl = this.id + '-inputEl'
			var thisInput = Ext.getDom(thisinputEl);
			thisInput.className = 'selectGrid-icon';
		},'focus' : function() {
			var me = this;
			createGridWin(me.columnsMap,me.store,me);
		}
	},
    setValue:function(idd){
    	if(idd){
    	var me=this;
    	var path=me.pathByUrl;
		var queryCondition={};
		var paramsId=idd;
		var targetObject=me.targetObject
		queryCondition[me.valueField]=paramsId;		
 		Ext.Ajax.request({
		    url:path,
			params:queryCondition,
			success : function(res) {
				var ret = Ext.decode(res.responseText);
				if (ret.success) {
					var udata = ret.data;
					if(me.store.data.items.length>0 && udata!==undefined){
						var rdata = me.store.data.items[0].copy();
						if(targetObject!=''){
							rdata[me.displayField] = udata[targetObject+'.'+me.displayField];
							rdata[me.valueField] = paramsId;							
						}else{
							rdata[me.displayField] = udata[me.displayField];
							rdata[me.valueField] = paramsId;							
						}
						me.displayTplData = [  rdata ];
						me.setRawValue(rdata[me.displayField]);
						me.value=paramsId;
					} else{
						me.setRawValue(udata[me.displayField]);
						me.value=paramsId;
					}
		    		if(me.propertyMap){
		        		  setPropertyMap(me.propertyMap,udata)
		        	}
				}
			}
		});
       }
    },
	initComponent : function() {
		var me = this;
		me.callParent(arguments);
	}
});

function createGridWin(columnsMap,querySelectGridStore,target){
	var querySelectGridCm=[{
		xtype : "rownumberer",
		text : "序号",
		width : 40,
		align : "center"
	}];
	for (name in columnsMap) {
		var new_columns ={};
		if(typeof(columnsMap[name])=='object'){
		  new_columns=columnsMap[name];
		}else{
		  new_columns = {
				text : columnsMap[name],
				dataIndex : name,
				width : 120
			};
		}
		querySelectGridCm.push(new_columns);
	}
	var querySelectGridGrid = Ext.create("Ext.grid.Panel",{ 
		border:0,
		selModel : Ext.create("Ext.selection.CheckboxModel",{}),
		store : querySelectGridStore,
		columns : querySelectGridCm,
		//头部工具条
		tbar:['关键字',{
				xtype : 'textfield',
				itemId : target.queryParam,
				width:90
			},{
			    xtype:'searchBtn'
	        }
		 ],
	    bbar : Ext.create("Ext.PagingToolbar", {
			    store : querySelectGridStore
		})
	}); 
	querySelectGridWin= Ext.create("Ext.window.Window", {
	    title : target.fieldLabel+'选择', 
		width : 600,
		height:400,
		closeAction : 'destroy',
		items : [querySelectGridGrid],
		buttons : [ {
			text : SystemConstant.saveBtnText,
			handler : function() {
				var record = querySelectGridGrid.getSelectionModel().getSelection()[0];
				target.displayTplData =[record.data];//这是核心，extjs原生的属性
				target.setRawValue(record.get(target.displayField));
				target.value=record.get(target.valueField);
				if(target.propertyMap){	
                 setPropertyMap(target.propertyMap,record.data)
                }
				this.findParentByType("window").close();
			}
		}, {
			text : '清空',
			handler : function() {
				target.setValue('');
				target.setRawValue('');
				if(target.propertyMap){	
					emptyPropertyMap(target.propertyMap)
	            };
				this.findParentByType("window").close();
			}
		}, {
			text : SystemConstant.closeBtnText,
			handler : function() {
				querySelectGridGrid.destroy();
				this.findParentByType("window").close();
			}
		}]
	}).show();
}

/*外键显示字段*/
Ext.define("Ext.form.field.Display", {
	override  : 'Ext.form.field.Display',
	targetObject:'',
	valueField : 'id',
	setValue:function(idd){
		var me=this;
		if(idd&&!me.pathByUrl){
			me.setRawValue(idd);
			me.value=idd;
		} else if(idd&&me.pathByUrl){
    	var path=me.pathByUrl;
		var queryCondition={};
		var paramsId=idd;
		var targetObject=me.targetObject
		queryCondition[me.valueField]=paramsId;		
 		Ext.Ajax.request({
		    url:path,
			params:queryCondition,
			success : function(res) {
				var ret = Ext.decode(res.responseText);
				if (ret.success) {
					var udata = ret.data;
					if(udata!==undefined){
						var rdata = udata;
						if(targetObject!=''){
							rdata[me.displayField] = udata[targetObject+'.'+me.displayField];
							rdata[me.valueField] = paramsId;							
						}else{
							rdata[me.displayField] = udata[me.displayField];
							rdata[me.valueField] = paramsId;							
						}
						me.displayTplData = [  rdata ];
						me.setRawValue(rdata[me.displayField]);
						me.value=paramsId;
					} else{
						me.setRawValue(udata[me.displayField]);
						me.value=paramsId;
					}
				}
			}
		});
       }
    }
 });
/**/
Ext.define("Ext.window.BasicWindow", {
	extend:'Ext.window.Window',
	xtype:'basicWindow',
	title:'',
	actionUrl:'',
	targetStore:{},
	targetGrid:{},
	init:function(way,actionUrl,target,idd) {
		var me=this
		me.targetGrid=target;
		me.targetStore = target.store;
		me.actionUrl = actionUrl;
		if (way == 'add') {
			this.setTitle('添加');
		} else if (way == 'edit') {
			this.setTitle('修改');
			var basicForm = me.down('form').getForm();
			basicForm.reset();	
			basicForm.load({
				url : me.actionUrl,
				params : {
					id : idd
				}
			});
		} else if (way == 'detail') {
			this.setTitle('详情');
			var basicForm = me.down('form').getForm();
			basicForm.reset();	
			basicForm.load({
				url : me.actionUrl,
				params : {
					id : idd
				}
			});
		}
	},
	buttons : [ {
		text : '保存',
		//text : SystemConstant.saveBtnText,
		handler : function() {
			var basicWin=this.findParentByType("window");
			var basicForm =basicWin.down('form').getForm();
			basicForm.url = basicWin.actionUrl;
			if (basicForm.isValid()) {
				basicForm.submit({
					success : function(form, action) {
						if(action.result.success){
							Ext.Msg.showTip(action.result.msg);
							basicWin.targetStore.loadPage(1);
							basicWin.close();
						} else{
							Ext.Msg.showError(action.result.msg);
						}
					},
					failure : function(form, action) {
						Ext.Msg.showError(action.result.msg);
					}
				});
			}
		}
	},  {
		text : '关闭',
		//text : SystemConstant.closeBtnText,
		handler : function() {
			this.findParentByType("window").close();
		}
	}]
});

/**
 * @author zengchao
 * @date 2015-09-15
 * 
 * 创建添加按钮封装样式
 */
Ext.define("Ext.AddBtn", {
	extend : 'Ext.Button',
	xtype : 'addBtn',
	text : SystemConstant.addBtnText,
	iconCls: "add-button"
 });
/**
 * @author zengchao
 * @date 2015-09-15
 * 
 * 创建修改按钮封装样式
 */
Ext.define("Ext.EditBtn", {
	extend : 'Ext.Button',
	xtype : 'editBtn',
	text : SystemConstant.modifyBtnText,
	iconCls: "edit-button"
 });
/**
 * @author zengchao
 * @date 2015-09-15
 * 
 * 创建删除按钮封装样式
 */
Ext.define("Ext.DeleteBtn", {
	extend : 'Ext.Button',
	xtype : 'deleteBtn',
	text : SystemConstant.deleteBtnText,
	iconCls: "delete-button"
 });