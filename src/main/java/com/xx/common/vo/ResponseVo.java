package com.xx.common.vo;

import java.util.Date;
import java.util.List;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import com.xx.common.util.DateUtil;
import com.xx.common.util.JsonDateValueProcessor;
import com.xx.common.util.StringUtil;

public class ResponseVo {

	/**
	 * 消息提示类型
	 */
	public static final String MSG_TYPE_INFO = "INFO";//提示
	public static final String MSG_TYPE_WARNING = "WARNING";//警告
	public static final String MSG_TYPE_ERROR = "ERROR";//错误
	
	/**
	 * 是否成功
	 */
	private boolean success = true;

	/**
	 * 提示消息类型
	 */
	private String msgType=MSG_TYPE_INFO;
	
	/**
	 * 提示消息
	 */
	private String msg;
	
	/**
	 * 分页大小
	 */
	private Integer totalSize;

	/**
	 * 分页 list 对象，封装一页的数据
	 */
	private List<?> list;

	/**
	 * 单个对象，用于封装记录详细
	 */
	private Object data;

	/**
	 * 返回全部非空属性JSON对象。
	 * @return JSONObject JSON对象
	 */
	public JSONObject getJsonObject(Object[] objs) {
		JSONObject jo = new JSONObject();
		JsonConfig config = new JsonConfig();
		String dateFormat = DateUtil.DATE_FORMAT;
		if(objs!=null && objs.length>0){
			dateFormat = (String) objs[0];
		}
		config.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor(dateFormat));
		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
		jo.put("success", success);
		if (totalSize != null) {
			jo.put("totalSize", totalSize);
		}
		if (StringUtil.isNotBlank(msg)) {
			jo.put("msg", msg);
		}
		if (StringUtil.isNotBlank(msgType)) {
			jo.put("msgType", msgType);
		}
		if (list != null) {
			jo.put("list", JSONArray.fromObject(list,config));
		}
		if (data != null) {
			jo.put("data", JSONObject.fromObject(data,config));
		}
		return jo;
	}

	/**
	 * 默认构造函数
	 */
	public ResponseVo() {
		super();
	}
	
	/**
	 * 提示消息构造函数，success默认为true
	* @param msg 提示消息
	 */
	public ResponseVo(String msg) {
		super();
		this.msg = msg;
		this.success = true;
		this.msgType=MSG_TYPE_INFO;
	}
	
	/**
	 * 提示消息构造函数
	* @param msg 提示消息
	* @param success 是否成功
	 */
	public ResponseVo(String msg,boolean success) {
		super();
		this.success = success;
		//如果操作失败，将消息类型默认设置为警告
		if(!success && MSG_TYPE_INFO.equals(msgType)){
			this.msgType=MSG_TYPE_WARNING;
		}
		this.msg = msg;
	}
	
	/**
	 * 分页构造函数
	* @param list 分页LIST
	* @param totalSize 总记录数
	 */
	public ResponseVo(List<?> list, Integer totalSize) {
		super();
		this.totalSize = totalSize;
		this.list = list;
	}
	
	/**
	 * 详情构造函数
	* @param data 详情对象
	 */
	public ResponseVo(Object data) {
		super();
		this.data = data;
	}
	
	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
		//如果操作失败，将消息类型默认设置为警告
		if(!success && MSG_TYPE_INFO.equals(msgType)){
			this.msgType=MSG_TYPE_WARNING;
		}
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public Integer getTotalSize() {
		return totalSize;
	}

	public void setTotalSize(Integer totalSize) {
		this.totalSize = totalSize;
	}

	public List<?> getList() {
		return list;
	}

	public void setList(List<?> list) {
		this.list = list;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public String getMsgType() {
		return msgType;
	}

	public void setMsgType(String msgType) {
		this.msgType = msgType;
	}

	

}
