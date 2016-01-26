/**  
 * @文件名: PropertyUtil.java
 * @版权:Copyright 2009-2013 版权所有：大庆金桥信息工程有限公司成都分公司
 * @描述: 属性文件工具类
 * @修改人: 王路聪
 * @修改时间: 2013-11-25 上午10:43:22
 * @修改内容:新增
 * @修改人: liukang-wb
 * @修改时间: 2014-9-19 上午11:55:22
 * @修改内容:修改(注释)
 */
package com.xx.common.util;
import java.io.IOException;
import java.util.Properties;

import org.apache.log4j.Logger;

/**
 * 属性文件工具类
 * 
 * @author wanglc
 * @version V1.20,2013-12-6 下午4:55:26
 * @see [相关类/方法]
 * @since V1.20
 * @depricated
 */
public class PropertyUtil {
    private static Logger logger = Logger.getLogger(PropertyUtil.class);
    
    private static Properties props = new Properties();
    
    static {
        try {
            /*
             * InputStream in = new BufferedInputStream (new FileInputStream(
             * "D:/sunbridgeworkspace/sshFrame/web/src/main/resources/application.properties"));
             * props.load(in);
             */
            props.load(PropertyUtil.class.getResourceAsStream("/application.properties"));
        }
        catch (IOException e) {
            logger.error("获取资源文件错误。" + e.getMessage());
        }
    }
    
    /**
     * 根据属性名去属性值
     * 
     * @Title get
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param propertyName
     * @return
     */
    public static String get(String propertyName) {
        return props.getProperty(propertyName);
    }
    
    /*
     * public static void main(String[] args) { System.out.println(PropertyUtil.get("jdbc.url")); }
     */
}
