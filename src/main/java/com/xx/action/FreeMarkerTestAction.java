package com.xx.action;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Random;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;
import com.xx.vo.AddressVo;

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
		//字符串显示到页面
		map.put("user", "何东");
		//用户页面if判断
		map.put("random", new Random().nextInt(100));
		//列表在页面进行遍历
		List<AddressVo> list = new ArrayList<AddressVo>();
		list.add(new AddressVo("中国","北京"));
		list.add(new AddressVo("中国","上海"));
		list.add(new AddressVo("美国","纽约"));
		map.put("lst", list);
		return "success";
	}

}
