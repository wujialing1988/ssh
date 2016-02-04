/**
 * 资源类型 model
 * */
Ext.define('resourceTypeModel', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'id'},
        {name: 'dictionaryName'},
        {name: 'dictionaryCode'}
    ]
});	
/**
 * 资源类型 store
 * */
var parentResourceTypeStore = Ext.create('Ext.data.Store', {
 	model: 'resourceTypeModel',
 	proxy: {
  	   type: 'ajax',
  	   url: basePath + '/dict/getDictListByTypeCode.action',
  	   extraParams:{dictTypeCode:"RESOURCETYPE"},
   	   reader: {
   	      type: 'json'
  	   }
 	},
 	autoLoad: false,
	listeners:{
		load:function(storeObj,records){
            if(records.length>0){
            	Ext.getCmp("parentResourceId").setValue(records[0].get("dictionaryCode"));
            }
		}
	}
});