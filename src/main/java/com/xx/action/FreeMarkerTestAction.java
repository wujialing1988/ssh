package com.xx.action;

import java.util.Map;
import java.util.Random;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

/**
 * FreeMarker结合Struts2测试
 * 
 * @author wujialing
 */
public class FreeMarkerTestAction extends ActionSupport {

	/**
	 * 序列号
	 */
	private static final long serialVersionUID = 1L;
	
	/**
	 * 测试页面 hello world！
	 * 
	 * @return
	 */
	public String test(){
		Map<String, Object> map = ActionContext.getContext().getSession();
		map.put("user", "何东");
		map.put("random", new Random().nextInt(100));
		return "success";
	}

}
