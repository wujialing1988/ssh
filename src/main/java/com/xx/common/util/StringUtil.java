/**  
 * @文件名: StringUtils.java
 * @版权:Copyright 2009-2013 版权所有：大庆金桥信息工程有限公司成都分公司
 * @描述: 字符串工具类
 * @修改人: 王路聪
 * @修改时间: 2013-11-25 上午10:43:22
 * @修改内容:新增
 * @修改人: liukang-wb
 * @修改时间: 2014-9-19 上午11:55:22
 * @修改内容:修改(注释)
 */
package com.xx.common.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.sql.Blob;
import java.sql.Clob;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Hibernate;

/**
 * 定义了一些针对String的基本操作
 * 
 * @author wanglc
 * @version V1.20,2013-12-6 下午3:39:37
 * @see [相关类/方法]
 * @since V1.20
 * @depricated
 */
@SuppressWarnings({"rawtypes", "unchecked"})
public abstract class StringUtil extends StringUtils {
    
    /**
     * 对传入的字符串进行修正(null,>>>化为>>>null)
     * 
     * @Title fixup
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param in
     * @return
     */
    public static String fixup(String in) {
        return in == null ? "" : in;
    }
    
    /**
     * 对传入的对象进行修正(null||o.toString()为"null"==>>>null) AND ISO2GBK
     * 
     * @Title fixup
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param o
     * @return
     */
    public static String fixup(Object o) {
        if (o instanceof java.sql.Timestamp) {
            String time = o.toString();
            return time.lastIndexOf("00:00:00.0") != -1 ? time.substring(0, 10)
                : time.substring(0, 19);
            
        }
        return o == null ? "" : o.toString();
    }
    
    /**
     * 大于比较(greater than)
     * 
     * @Title gt
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str1
     * @param rule_value
     * @return 如果str1>rule_value返回true
     */
    public static boolean gt(String str1, String rule_value) {
        if (isBlank(str1) || isBlank(rule_value)) {
            return false;
        }
        try {
            double d1 = Double.valueOf(str1).doubleValue();
            double d2 = Double.valueOf(rule_value).doubleValue();
            return d1 > d2 && d2 != 0;
        }
        catch (Exception e) {
        }
        return false;
    }
    
    /**
     * 大于比较(greater than)
     * 
     * @Title gt
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str1
     * @param rule_value
     * @return 如果str1>rule_value返回true
     */
    public static boolean gt(String str1, BigDecimal rule_value) {
        if (isBlank(str1)) {
            return false;
        }
        try {
            double d1 = Double.valueOf(str1).doubleValue();
            double d2 = rule_value.doubleValue();
            return d1 > d2 && d2 != 0;
        }
        catch (Exception e) {
        }
        return false;
    }
    
    /**
     * 小于比较(less than)
     * 
     * @Title lt
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str1
     * @param rule_value
     * @return 如果str1<rule_value返回true
     */
    public static boolean lt(String str1, String rule_value) {
        if (isBlank(str1) || isBlank(rule_value)) {
            return false;
        }
        try {
            double d1 = Double.valueOf(str1).doubleValue();
            double d2 = Double.valueOf(rule_value).doubleValue();
            return d1 < d2 && d2 != 0;
        }
        catch (Exception e) {
        }
        return false;
    }
    
    /**
     * 小于比较(less than)
     * 
     * @Title lt
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str1
     * @param rule_value
     * @return 如果str1<rule_value返回true
     */
    public static boolean lt(String str1, BigDecimal rule_value) {
        if (isBlank(str1)) {
            return false;
        }
        try {
            double d1 = Double.valueOf(str1).doubleValue();
            double d2 = rule_value.doubleValue();
            return d1 < d2 && d2 != 0;
        }
        catch (Exception e) {
        }
        return false;
    }
    
    /**
     * 转换为Double类型
     * 
     * @Title toDouble
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static double toDouble(String str) {
        if (isBlank(str)) {
            return 0;
        }
        try {
            double d = Double.valueOf(str).doubleValue();
            return d;
        }
        catch (Exception e) {
        }
        return 0;
    }
    
    /**
     * 转换为Long类型
     * 
     * @Title toLong
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static Long toLong(String str) {
        if (isBlank(str)) {
            return null;
        }
        Long l = Long.valueOf(str);
        return l;
    }
    
    /**
     * 转换为Double类型
     * 
     * @Title toDouble
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static double toDouble(Object str) {
        if (str != null) {
            return toDouble(str.toString());
        }
        return 0;
    }
    
    /**
     * 以逗号截取为Login类型数组
     * 
     * @Title splitToLongArray
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static Long[] splitToLongArray(String str) {
        if (str == null) {
            return null;
        }
        String[] strArr = str.split(",");
        Long[] longArr = new Long[strArr.length];
        for (int i = 0; i < strArr.length; i++) {
            longArr[i] = toLong(strArr[i]);
        }
        return longArr;
    }
    
    /**
     * 字符数组转换为Long类型数组
     * 
     * @Title stringArrayToLongArray
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param strArr
     * @return
     */
    public static Long[] stringArrayToLongArray(String[] strArr) {
        if (strArr == null) {
            return null;
        }
        Long[] longArr = new Long[strArr.length];
        for (int i = 0; i < strArr.length; i++) {
            longArr[i] = toLong(strArr[i]);
        }
        return longArr;
    }
    
    /**
     * iso 转 gbk
     * 
     * @Title iso2gbk
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static String iso2gbk(String str) {
        if (str == null) {
            return null;
        }
        try {
            return new String(str.getBytes("ISO-8859-1"), "GBK");
        }
        catch (UnsupportedEncodingException e) {
            
        }
        return null;
    }
    
    /**
     * iso 转 utf8
     * 
     * @Title iso2utf
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static String iso2utf(String str) {
        if (str == null) {
            return null;
        }
        try {
            return new String(str.getBytes("ISO-8859-1"), "UTF-8");
        }
        catch (UnsupportedEncodingException e) {
            
        }
        return null;
    }
    
    /**
     * 自定义符号截取字符串为Long类型数组
     * 
     * @Title splitToLongArray
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @param separator 截取符
     * @return
     */
    public static Long[] splitToLongArray(String str, String separator) {
        if (str == null) {
            return null;
        }
        String[] strArr = str.split(separator);
        Long[] longArr = new Long[strArr.length];
        for (int i = 0; i < strArr.length; i++) {
            longArr[i] = toLong(strArr[i]);
        }
        return longArr;
    }
    
    /**
     * ORACLE列转为Java域
     * 
     * @Title oracleColumn2JavaField
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static String oracleColumn2JavaField(String str) {
        if (str != null) {
            String[] strs = str.split("_");
            String toStr = strs[0].toLowerCase();
            for (int i = 1; i < strs.length; i++) {
                toStr +=
                    strs[i].substring(0, 1).toUpperCase()
                        + strs[i].substring(1).toLowerCase();
            }
            return toStr;
        }
        return null;
    }
    
    /**
     * 判断字符串是否为空
     * 
     * @Title isEmpty
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static boolean isEmpty(String str) {
        return str == null || str.length() == 0;
    }
    
    /**
     * 获取字符串, null转换为空字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src 源对象
     * @return 字符串
     */
    public static String getStr(Object src) {
        return getStr(src, -1);
    }
    
    /**
     * @Title getTrimedStr
     * @author wanglc
     * @Description: 去空白符
     * @date 2013-12-6
     * @param src
     * @return
     */
    public static String getTrimedStr(Object src) {
        return getTrimedStr(src, -1);
    }
    
    /**
     * 截取字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param defaultValue
     * @return
     */
    public static String getStr(Object src, String defaultValue) {
        return getStr(src, -1, defaultValue);
    }
    
    /**
     * 去空白符
     * 
     * @Title getTrimedStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param defaultValue
     * @return
     */
    public static String getTrimedStr(Object src, String defaultValue) {
        return getTrimedStr(src, -1, defaultValue);
    }
    
    /**
     * 获取定长的字符串, null转换为空字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src 源对象
     * @param length 字符串长度
     * @return 字符串
     */
    public static String getStr(Object src, int length) {
        return getStr(src, 0, length);
    }
    
    /**
     * 获取定长的字符串, 并去空白符
     * 
     * @Title getTrimedStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param length
     * @return
     */
    public static String getTrimedStr(Object src, int length) {
        return getTrimedStr(src, 0, length);
    }
    
    /**
     * 截取字符
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param length
     * @param defaultValue
     * @return
     */
    public static String getStr(Object src, int length, String defaultValue) {
        return getStr(src, 0, length, defaultValue);
    }
    
    /**
     * 截取非空白字符
     * 
     * @Title getTrimedStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param length
     * @param defaultValue
     * @return
     */
    public static String getTrimedStr(Object src, int length,
        String defaultValue) {
        return getTrimedStr(src, 0, length, defaultValue);
    }
    
    /**
     * 从start位置开始获取定长字符串, null转换为空字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src 源对象
     * @param start 起始位置
     * @param length 长度
     * @return
     */
    public static String getStr(Object src, int start, int length) {
        return getStr(src, start, length, "", false);
    }
    
    /**
     * 取字符串
     * 
     * @Title getTrimedStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param start
     * @param length
     * @return
     */
    public static String getTrimedStr(Object src, int start, int length) {
        return getStr(src, start, length, "", true);
    }
    
    /**
     * 取字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param start
     * @param length
     * @param defaultValue
     * @return
     */
    public static String getStr(Object src, int start, int length,
        String defaultValue) {
        return getStr(src, start, length, defaultValue, false);
    }
    
    /**
     * 取字符串
     * 
     * @Title getTrimedStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param start
     * @param length
     * @param defaultValue
     * @return
     */
    public static String getTrimedStr(Object src, int start, int length,
        String defaultValue) {
        return getStr(src, start, length, defaultValue, true);
    }
    
    /**
     * 取字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @param start
     * @param length
     * @param defaultValue
     * @param trim
     * @return
     */
    public static String getStr(Object src, int start, int length,
        String defaultValue, boolean trim) {
        if (src == null) {
            return defaultValue;
        }
        
        String value = src.toString();
        
        if (value.length() > start) {
            if (length < 0 || value.length() < start + length) {
                value = value.substring(start);
            }
            else {
                value = value.substring(start, start + length);
            }
        }
        else {
            value = "";
        }
        
        return trim ? value.trim() : value;
    }
    
    /**
     * 从Blob中获取字符串
     * 
     * @Title fromBlob
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param blob
     * @return
     */
    public static String fromBlob(Blob blob) {
        if (blob == null) {
            return "";
        }
        try {
            
            byte[] array = new byte[1000];
            InputStream in = blob.getBinaryStream();
            
            // hjs 为了修改乱码的问题 保存每次读取的字节列表
            Vector v = new Vector();
            
            // 保存每次读取的字节长度
            Vector v1 = new Vector();
            int len = in.read(array, 0, 1000);
            
            // 保存所有字节的长度
            int alllen = 0;
            while (len > 0) {
                // sb.append(new String(array, 0, len));
                alllen = alllen + len;
                v.add(array);
                v1.add(new Integer(len));
                array = new byte[1000];
                len = in.read(array, 0, 1000);
            }
            if (alllen > 0 && v.size() > 0) {
                byte[] arraytemp = new byte[alllen];
                int index = 0;
                for (int i = 0; i < v.size(); i++) {
                    int lentemp = ((Integer)v1.get(i)).intValue();
                    byte[] arraytt = (byte[])v.get(i);
                    System.arraycopy(arraytt, 0, arraytemp, index, lentemp);
                    index = index + lentemp;
                }
                return new String(arraytemp);
                
            }
            
        }
        catch (Exception e) {
            
        }
        return "";
    }
    
    /**
     * 从Blob中获取字符串
     * 
     * @Title fromClob
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param clob
     * @return
     */
    public static String fromClob(Clob clob) {
        if (clob == null) {
            return "";
        }
        String resultString = "";
        try {
            Reader reader = clob.getCharacterStream();
            BufferedReader br = new BufferedReader(reader);
            String s = br.readLine();
            StringBuffer sb = new StringBuffer();
            while (s != null) {
                // 执行循环将字符串全部取出付值给StringBuffer由StringBuffer转成STRING
                sb.append(s);
                s = br.readLine();
            }
            resultString = sb.toString();
        }
        catch (SQLException e) {
            
        }
        catch (IOException e) {
            
        }
        return resultString;
    }
    
    /**
     * 将字符串根据spilter(非正则表达式)拆分开
     * 
     * @Title split
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @param spilter
     * @return
     */
    public static String[] split(String str, String spilter) {
        if (str == null) {
            return null;
        }
        if ((spilter == null) || (spilter.equals(""))
            || (str.length() < spilter.length())) {
            String[] t = {str};
            return t;
        }
        ArrayList al = new ArrayList();
        char[] cs = str.toCharArray();
        char[] ss = spilter.toCharArray();
        int length = spilter.length();
        int lastIndex = 0;
        for (int i = 0; i <= str.length() - length;) {
            boolean notSuit = false;
            for (int j = 0; j < length; ++j) {
                if (cs[(i + j)] != ss[j]) {
                    notSuit = true;
                    break;
                }
            }
            if (!(notSuit)) {
                al.add(str.substring(lastIndex, i));
                i += length;
                lastIndex = i;
            }
            else {
                ++i;
            }
        }
        if (lastIndex <= str.length()) {
            al.add(str.substring(lastIndex, str.length()));
        }
        String[] t = new String[al.size()];
        for (int i = 0; i < al.size(); ++i) {
            t[i] = ((String)al.get(i));
        }
        return t;
    }
    
    /**
     * 取字符串
     * 
     * @Title getStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param src
     * @return
     */
    public static String getStr(long src) {
        
        return String.valueOf(src);
        
    }
    
    /**
     * getBlobfromString
     * 
     * @Title getBlobfromString
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static Blob getBlobfromString(String str) {
        Blob blob = null;
        if (str != null && !"".equals(str)) {
            byte[] b = str.getBytes();
            blob = Hibernate.createBlob(b);
        }
        return blob;
    }
    
    /**
     * getBlobfromByte
     * 
     * @Title getBlobfromByte
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param b
     * @return
     */
    public static Blob getBlobfromByte(byte[] b) {
        return Hibernate.createBlob(b);
    }
    
    /**
     * getClobfromString
     * 
     * @Title getClobfromString
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static Clob getClobfromString(String str) {
        Clob clob = null;
        if (str != null && !"".equals(str)) {
            clob = Hibernate.createClob(str);
        }
        return clob;
    }
    
    /**
     * 将List[5765,5688]通过默认的分隔符号pCode=","转化为："5765,5688"
     * 
     * @Title getStrFromList
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param list
     * @return
     */
    public static String getStrFromList(List list) {
        String str = "";
        if (list == null || list.size() == 0) {
            return str;
        }
        String pCode = ",";
        str = getStrFromList(list, pCode);
        return str;
    }
    
    /**
     * 将List[5765,5688]通过使用分隔符号pCode=","转化为："5765,5688"
     * 
     * @Title getStrFromList
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param list
     * @param pCode
     * @return
     */
    public static String getStrFromList(List list, String pCode) {
        String str = "";
        for (int i = 0; i < list.size(); i++) {
            String s = StringUtil.getStr(list.get(i));
            if (i > 0) {
                str += pCode;
            }
            str += s;
        }
        return str;
    }
    
    /**
     * 字符串转化小写
     * 
     * @Title getLowerStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static String getLowerStr(String str) {
        if (!StringUtil.isEmpty(str)) {
            return str.toLowerCase();
        }
        return "";
    }
    
    /**
     * 字符串转化大写
     * 
     * @Title getUpperStr
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static String getUpperStr(String str) {
        if (!StringUtil.isEmpty(str)) {
            return str.toUpperCase();
        }
        return "";
    }
    
    /**
     * 去除字符串中的空格、回车、换行符、制表符
     * 
     * @Title replaceBlank
     * @author wanglc
     * @Description:
     * @date 2013-12-6
     * @param str
     * @return
     */
    public static String replaceBlank(String str) {
        String dest = "";
        if (str != null) {
            Pattern p = Pattern.compile("\\s*|\t|\r|\n");
            Matcher m = p.matcher(str);
            dest = m.replaceAll("").replaceAll("　", "");
        }
        return dest;
    }
    
    /**
     * 将逗号隔开的多个uuid前后添加单引号
     * 
     * @Title fixUuids
     * @author dong.he
     * @date 2015年12月23日
     * @param ids
     * @return
     */
    public static String fixUuids(String ids) {
        String fixed = "";
        if (StringUtils.isNotBlank(ids)) {
            String[] idArr = ids.trim().split(",|，");
            for (String id : idArr) {
                fixed += ",'" + id + "'";
            }
            fixed = fixed.substring(1);
        }
        return fixed;
    }
    
    public static void main(String[] args) {
        for (int i = 0; i < 190; i++) {
            UUID uuid = UUID.randomUUID();
            System.out.println("Dictionary-" + uuid);
        }
    }
}
