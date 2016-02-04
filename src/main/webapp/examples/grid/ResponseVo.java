package com.dqgb.sshframe.common.vo;

import java.util.List;

import com.dqgb.sshframe.common.util.StringUtil;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class ResponseVo {

	/**
	 * 是否成功
	 */
	private boolean success = true;

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
	 * 返回全部非空的属性JSON对象。
	 * @return JSONObject 
	 */
	public JSONObject getJsonObject() {
		JSONObject jo = new JSONObject();
		jo.put("success", success);
		if (totalSize != null) {
			jo.put("totalSize", totalSize);
		}
		if (StringUtil.isNotBlank(msg)) {
			jo.put("msg", msg);
		}
		if (list != null) {
			jo.put("list", JSONArray.fromObject(list));
		}
		if (data != null) {
			jo.put("data", JSONObject.fromObject(data));
		}
		return jo;
	}

	public boolean isSuccess() {
		return success;
	}

	public void setSuccess(boolean success) {
		this.success = success;
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

}
