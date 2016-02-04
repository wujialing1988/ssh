Ext.define('orgTypeModel', {
	extend : 'Ext.data.Model',
	fields : [ 
	          {name: 'id'},
	          {name: 'dictionaryName'},
	          {name: 'dictionaryCode'}
	           ]
});	
var orgTypeStore = Ext.create('Ext.data.Store', {
	model: 'orgTypeModel',
	proxy: {
	type: 'ajax',
	url: basePath+'/dict/getDictListByTypeCode.action',
	extraParams:{dictTypeCode:"ORGTYPE"},
	reader: {
  		type: 'json'
	}
	},
	autoLoad: true
});