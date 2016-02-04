FlowDesigner = {};

FlowDesigner.addInitCallback = function(bname,callback){
	if(callback != null && callback != undefined){
		FABridge.addInitializationCallback(bname, callback);
	}
};

/**
 * 添加模板
 * bname bridgeName 的值
 */
FlowDesigner.add = function(bname) {
	try{
		FABridge[bname].root().add();
	}catch(e){}
};

/**
 * 修改模板
 * bname bridgeName 的值
 * key 流程模板编码
 */
FlowDesigner.edit = function(bname,key) {
	try{
		
		FABridge[bname].root().edit(key);
	}catch(e){}
};

/**
 * 修改实例
 * bname bridgeName 的值
 * key 流程模板编码
 */
FlowDesigner.editInst = function(bname,isntId) {
	try{
		FABridge[bname].root().editInst(isntId);
	}catch(e){}
};

/**
 * 查询模板
 * bname bridgeName 的值
 * key 流程模板编码
 */
FlowDesigner.see = function(bname,key) {
	try{
		FABridge[bname].root().see(key);
	}catch(e){}
};

/**
 * 监控实例
 * bname bridgeName 的值
 * instId 流程实例id
 */
FlowDesigner.monitor = function(bname,instId) {
	try{
		FABridge[bname].root().monitor(instId);
	}catch(e){}
};
