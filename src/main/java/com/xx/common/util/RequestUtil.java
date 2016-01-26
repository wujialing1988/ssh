/**  
 * @文件名: RequestUtil.java
 * @版权:Copyright 2009-2013 版权所有：大庆金桥信息工程有限公司成都分公司
 * @描述: RequestUtil
 * @修改人: 王路聪
 * @修改时间: 2013-11-25 上午10:43:22
 * @修改内容:新增
 * @修改人: liukang-wb
 * @修改时间: 2014-9-19 上午11:55:22
 * @修改内容:修改(注释)
 */
package com.xx.common.util;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.core.CollectionFactory;

/**
 * RequestUtil
 * 
 * @author wanglc
 * @version V1.20,2013-12-6 下午4:08:42
 * @see [相关类/方法]
 * @since V1.20
 * @depricated
 */
@SuppressWarnings({"unchecked", "rawtypes", "deprecation"})
public abstract class RequestUtil {
    
    /**
     * ip校验
     * 
     * @param s
     * @return
     */
    public static Boolean isIpAddress(String s) {
        String regex =
            "(((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))[.](((2[0-4]\\d)|(25[0-5]))|(1\\d{2})|([1-9]\\d)|(\\d))";
        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(s);
        return m.matches();
    }
    
    /**
     * 获取客户端ip
     * 
     * @param request
     * @return
     */
    public static String getClientAddress(HttpServletRequest request) {
        String address = request.getHeader("X-Forwarded-For");
        if (address != null && isIpAddress(address)) {
            return address;
        }
        return request.getRemoteAddr();
    }
    
    /**
     * 
     * @param request
     * @param name
     * @return 返回值为null时转换为空串""
     */
    public static String getString(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value;
    }
    
    /**
     * 根据请求返回对应的String值
     * 
     * @Title getString
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param request
     * @param name
     * @param defaultValue
     * @return
     */
    public static String getString(HttpServletRequest request, String name,
        String defaultValue) {
        String value = request.getParameter(name);
        return value == null || "".equals(value) ? defaultValue : value;
    }
    
    /**
     * 字符编码转换
     * 
     * @Title getIso2GbkString
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param request
     * @param name
     * @param defaultValue
     * @return
     */
    public static String getIso2GbkString(HttpServletRequest request,
        String name, String defaultValue) {
        String value = request.getParameter(name);
        return value == null || "".equals(value) ? defaultValue
            : StringUtil.iso2gbk(value);
    }
    
    /**
     * @Title getParameterMap
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param request
     * @return
     */
    public static Map<String, String> getParameterMap(HttpServletRequest request) {
        Enumeration enumeration = request.getParameterNames();
        Map<String, String> map =
            CollectionFactory.createLinkedCaseInsensitiveMapIfPossible(1);
        while (enumeration.hasMoreElements()) {
            String element = (String)enumeration.nextElement();
            // request.getParameterValues(element);
            map.put(element, request.getParameter(element));
        }
        return map;
    }
    
    /**
     * Iso2Utf
     * 
     * @Title getParameterIso2UtfMap
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param request
     * @return 参数Map
     */
    public static Map<String, String> getParameterIso2UtfMap(
        HttpServletRequest request) {
        Enumeration enumeration = request.getParameterNames();
        Map<String, String> map =
            CollectionFactory.createLinkedCaseInsensitiveMapIfPossible(1);
        while (enumeration.hasMoreElements()) {
            String element = (String)enumeration.nextElement();
            // request.getParameterValues(element);
            map.put(element, StringUtil.iso2utf(request.getParameter(element)));
        }
        return map;
    }
    
    /**
     * 将{key1:[v11,v12,...],key2:[v21,v22,...],...}组装到Bean[{key1:v11,
     * key2:v12,...},{key1:v12,key2:v22,...},...]
     * 
     * @param <T>
     * @param request
     * @param beanClass
     * @return
     */
    public static <T> List<T> populateBeans(HttpServletRequest request,
        Class<T> beanClass, String[] excludeFields) {
        List<T> list = null;
        List<Map<String, String>> valuesList = null;
        if (beanClass != null) {
            Field beanField[] = beanClass.getDeclaredFields();
            int fieldSize = beanField.length;
            for (Field field : beanField) {
                String fieldName = field.getName();
                String[] values = request.getParameterValues(fieldName);
                if (values == null) {
                    continue;
                }
                if (excludeFields != null) {
                    boolean isContinue = false;
                    for (String excludeField : excludeFields) {
                        if (fieldName.equals(excludeField)) {
                            isContinue = true;
                            break;
                        }
                    }
                    if (isContinue) {
                        continue;
                    }
                }
                int size = values.length;
                if (valuesList == null) {
                    valuesList = new ArrayList<Map<String, String>>(size);
                    for (int i = 0; i < size; i++) {
                        Map<String, String> map =
                            CollectionFactory.createLinkedCaseInsensitiveMapIfPossible(fieldSize);
                        valuesList.add(map);
                    }
                }
                if (list == null) {
                    list = new ArrayList<T>(size);
                }
                for (int i = 0; i < size; i++) {
                    Map<String, String> map = valuesList.get(i);
                    map.put(fieldName, values[i]);
                }
            }
            for (Map<String, String> map : valuesList) {
                try {
                    Collection<String> values = map.values();
                    boolean hasValues = false;
                    for (String value : values) {
                        if (value != null && value.length() > 0) {
                            hasValues = true;
                        }
                    }
                    if (!hasValues) {
                        continue;
                    }
                    T bean = beanClass.newInstance();
                    BeanUtils.populate(bean, map);
                    list.add(bean);
                }
                catch (Exception e) {
                    
                }
            }
        }
        return list == null ? new ArrayList(0) : list;
    }
    
    /**
     * 将request.getParameter("$")的值转换为Long型
     * 
     * @param request HttpServletRequest
     * @param name String 待转换参数
     * @return Long 如果request.getParameter("$")为空则返回空
     */
    public static Long getLong(HttpServletRequest request, String name) {
        Long param = null;
        if (request.getParameter(name) != null
            && !(request.getParameter(name).equals(""))
            && !"null".equals(request.getParameter(name))) {
            param = Long.valueOf(request.getParameter(name));
        }
        return param;
    }
    
    /**
     * 
     * 
     * @param request
     * @param name
     * @return
     * 
     *         备注：对request.getParameterValues()的处理
     * 
     */
    public static String[] getStringValues(HttpServletRequest request,
        String name) {
        String[] temp = request.getParameterValues(name);
        
        if (name == null || temp == null || temp.length == 0) {
            return null;
        }
        
        return temp;
    }
    
    /**
     * 将request.getParameter("$")的值转换为Integer型
     * 
     * @param request HttpServletRequest
     * @param name String 待转换参数
     * @return Integer 如果request.getParameter("$")为空则返回空
     */
    public static Integer getInteger(HttpServletRequest request, String name) {
        Integer param = null;
        if (request.getParameter(name) != null
            && !(request.getParameter(name).equals(""))
            && !"null".equals(request.getParameter(name))) {
            param = Integer.valueOf(request.getParameter(name));
        }
        return param;
    }
    
    /**
     * 将request.getParameter("$")的值转换为Integer型
     * 
     * @param request HttpServletRequest
     * @param name String 待转换参数
     * @return Integer 如果request.getParameter("$")为空则返回空
     */
    public static int getInt(HttpServletRequest request, String name) {
        Integer param = null;
        if (request.getParameter(name) != null
            && !(request.getParameter(name).equals(""))
            && !"null".equals(request.getParameter(name))) {
            param = Integer.valueOf(request.getParameter(name));
        }
        else {
            try {
                param =
                    Integer.valueOf(String.valueOf(request.getAttribute(name)));
            }
            catch (Exception e) {
                
            }
        }
        int temp = param == null ? 0 : param.intValue();
        return temp;
    }
    
    /**
     * 获取项目访问路径
     * 
     * @param request
     * @return
     */
    public static String getProjectURL(HttpServletRequest request) {
        return request.getScheme() + "://" + request.getServerName() + ":"
            + request.getServerPort() + request.getContextPath();
    }
}
