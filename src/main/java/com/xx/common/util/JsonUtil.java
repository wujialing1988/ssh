/**  
 * @文件名: JsonUtil.java
 * @版权:Copyright 2009-2013 版权所有：大庆金桥信息工程有限公司成都分公司
 * @描述: Json工具类
 * @修改人: 王路聪
 * @修改时间: 2013-11-25 上午10:43:22
 * @修改内容:新增
 * @修改人: liukang-wb
 * @修改时间: 2014-9-19 上午11:55:22
 * @修改内容:修改(注释)
 */
package com.xx.common.util;

import java.io.PrintWriter;
import java.util.Date;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import com.xx.common.vo.ResponseVo;

/**
 * json数据转化类
 * 
 * @author wanglc
 * @version V1.20,2013-12-6 下午4:37:35
 * @see [相关类/方法]
 * @since V1.20
 * @depricated
 */
public class JsonUtil {
    
    private static final Logger log = Logger.getLogger(JsonUtil.class);
    
    /**
     * getResponse
     * 
     * @Title getResponse
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @return
     */
    public static HttpServletResponse getResponse() {
        return ServletActionContext.getResponse();
    }
    
    /**
     * 将对象等转换为json格式并输出
     * 
     * @Title outJson
     * @author hedj
     * @Description:
     * @date 2013-12-6
     * @param obj 要转换的对象
     * @param objs 可变参数 第一个参数日期格式，默认为"yyyy-MM-dd"
     * @return
     */
    public static String outJson(Object obj, Object ... objs) {
    	try {
    		String dateFormat = DateUtil.DATE_FORMAT;
    		if(objs!=null && objs.length>0){
    			dateFormat = (String) objs[0];
    		}
    		JsonConfig config = new JsonConfig();
    		config.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor(dateFormat));
    		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
    		String json = JSONObject.fromObject(obj,config).toString();
    		getResponse().setContentType("text/html;charset=UTF-8");
    		PrintWriter out = getResponse().getWriter();
    		out.write(json);
    		return json;
    	}
    	catch (Exception e) {
    		log.error(" 转换JSON错误：" ,e);
    		return "";
    	}
    }
    
    /**
     * 将对象等转换为json格式并输出
     * 
     * @Title outJson
     * @author hedj
     * @Description:
     * @date 2013-12-6
     * @param obj 要转换的对象
     * @param objs 可变参数 第一个参数日期格式，默认为"yyyy-MM-dd"
     * @return
     */
    public static String toJsonString(Object obj, Object ... objs) {
    	try {
    		String dateFormat = DateUtil.DATE_FORMAT;
    		if(objs!=null && objs.length>0){
    			dateFormat = (String) objs[0];
    		}
    		JsonConfig config = new JsonConfig();
    		config.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor(dateFormat));
    		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
    		return JSONObject.fromObject(obj,config).toString();
    	}
    	catch (Exception e) {
    		log.error(" 转换JSON错误：" ,e);
    		return "";
    	}
    }
    
    /**
     * 将ResponseVo转换为json格式并输出
     * 
     * @Title outJson
     * @author hedj
     * @Description:
     * @date 2013-12-6
     * @param rv ResponseVo对象
     * @param objs 可变参数 第一个参数日期格式，默认为"yyyy-MM-dd"
     * @return
     */
    public static String outJson(ResponseVo rv, Object ... objs) {
    	return JsonUtil.outJson(rv.getJsonObject(objs), objs);
    }
    
    /**
     * 将list.数组格式数据转换为json
     * 
     * @Title outJsonArray
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param obj 要转换的集合对象
     * @param objs 可变参数 第一个参数日期格式，默认为"yyyy-MM-dd"
     * @return
     */
    public static String outJsonArray(Object obj, Object... objs) {
        try {
            String json = "";
            String dateFormat = DateUtil.DATE_FORMAT;
    		if(objs!=null && objs.length>0){
    			dateFormat = (String) objs[0];
    		}
    		JsonConfig config = new JsonConfig();
    		config.registerJsonValueProcessor(Date.class, new JsonDateValueProcessor(dateFormat));
    		config.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
            json += JSONArray.fromObject(obj, config).toString();
            getResponse().setContentType("text/html;charset=UTF-8");
            PrintWriter out = getResponse().getWriter();
            out.write(json);
            return json;
        }
        catch (Exception e) {
        	log.error(" 转换JSON错误：" ,e);
            return "";
        }
    }
   
}
