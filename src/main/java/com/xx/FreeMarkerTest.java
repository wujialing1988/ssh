package com.xx;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

/**
 * FreeMarker结合Struts2测试
 * 
 * @author wujialing
 */
public class FreeMarkerTest extends ActionSupport {

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
		ActionContext.getContext().getSession().put("user", "何东");
		return "success";
	}

}
