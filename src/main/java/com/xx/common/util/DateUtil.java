/**  
 * @文件名: DateUtil.java
 * @版权:Copyright 2009-2013 版权所有：大庆金桥信息工程有限公司成都分公司
 * @描述: 日期工具类
 * @修改人: 王路聪
 * @修改时间: 2013-11-25 上午10:43:22
 * @修改内容:新增
 * @修改人: liukang-wb
 * @修改时间: 2014-9-19 上午11:55:22
 * @修改内容:修改(注释)
 */
package com.xx.common.util;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * 日期工具类
 * 
 * @author wanglc
 * @version V1.20,2013-12-6 下午3:59:44
 * @see [相关类/方法]
 * @since V1.20
 * @depricated
 */
public class DateUtil {
    /** @Fields logger : logger */
    private final static Log logger = LogFactory.getLog(DateUtil.class);
    
    /** @Fields DATE_FORMAT : DATE_FORMAT */
    public static String DATE_FORMAT = "yyyy-MM-dd";
    
    /** @Fields DATE_TIME_FORMAT : DATE_TIME_FORMAT */
    public static String DATE_TIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
    
    /**
     * @Title getNowYearMonthDayWeek
     * @author wanglc
     * @Description: 取当前年月日 星期
     * @date 2013-12-6
     * @return
     */
    public static String getNowYearMonthDayWeek() {
        return DateUtil.getNowDate("yyyy年M月d日 H:m:s") + " 星期"
            + "日一二三四五六".charAt(getNowDayOfWeek() - 1);
    }
    
    /**
     * 取当前星期
     * 
     * @Title getNowDayOfWeek
     * @author wanglc
     * @date 2013-12-6
     * @return
     */
    public static int getNowDayOfWeek() {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(new Date());
        return calendar.get(Calendar.DAY_OF_WEEK);
    }
    
    /**
     * 取当前时间
     * 
     * @Title getNowDate
     * @author wanglc
     * @date 2013-12-6
     * @param format yyyy-MM-dd HH:mm:ss:S 年月日时分秒毫杪
     * @return
     */
    public static String getNowDate(String format) {
        String dateTime = "";
        try {
            Date now = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat(format);
            dateTime = sdf.format(now);
        }
        catch (Exception e) {
            logger.error(e);
        }
        return dateTime;
    }
    
    /**
     * 把日期转化为字符类型
     * 
     * @Title nowStringDate
     * @author wanglc
     * @date 2013-12-6
     * @param pattern
     * @return
     */
    public static String nowStringDate(String pattern) {
        return dateToString(new Date(), pattern);
    }
    
    /**
     * 获得昨天的日期
     * 
     * @Title getStringYesterday
     * @author wanglc
     * @date 2013-12-6
     * @param pattern
     * @return
     */
    public static String getStringYesterday(String pattern) {
        return dateToString(new Date(new Date().getTime() - 24 * 3600 * 1000),
            pattern);
    }
    
    /**
     * 得到当前日期
     * 
     * @Title nowDate
     * @author wanglc
     * @date 2013-12-6
     * @param pattern
     * @return
     */
    public static Date nowDate(String pattern) {
        String nowStringDate = nowStringDate(pattern);
        return stringToDate(nowStringDate, pattern);
    }
    
    /**
     * 日期转化字符
     * 
     * @Title dateToString
     * @author wanglc
     * @date 2013-12-6
     * @param date
     * @param pattern
     * @param locale
     * @return
     */
    public static String dateToString(Date date, String pattern, Locale locale) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat(pattern, locale);
            return sdf.format(date);
        }
        catch (Exception e) {
            return "";
        }
    }
    
    /**
     * 日期转化字符
     * 
     * @Title dateToString
     * @author wanglc
     * @date 2013-12-6
     * @param date
     * @param pattern
     * @return
     */
    public static String dateToString(Date date, String pattern) {
        Locale locale = Locale.getDefault();
        return dateToString(date, pattern, locale);
    }
    
    /**
     * 字符类型日期转化为长类型
     * 
     * @Title stringToLong
     * @author wanglc
     * @date 2013-12-6
     * @param strDate
     * @param pattern
     * @param locale
     * @return
     * @throws ParseException
     */
    public static long stringToLong(String strDate, String pattern,
        Locale locale)
        throws ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat(pattern, locale);
        Date date = sdf.parse(strDate);
        return date.getTime();
    }
    
    /**
     * 字符类型日期转化为长类型
     * 
     * @Title stringToLong
     * @author wanglc
     * @date 2013-12-6
     * @param strDate
     * @param pattern
     * @return
     * @throws ParseException
     */
    public static long stringToLong(String strDate, String pattern)
        throws ParseException {
        Locale locale = Locale.CHINESE;
        return stringToLong(strDate, pattern, locale);
    }
    
    /**
     * 字符转化为日期
     * 
     * @Title stringToDate
     * @author wanglc
     * @date 2013-12-6
     * @param strDate
     * @param pattern
     * @return
     */
    public static Date stringToDate(String strDate, String pattern) {
        try {
            long ltime = stringToLong(strDate, pattern);
            return new Date(ltime);
        }
        catch (Exception ex) {
            return null;
        }
    }
    
    /**
     * 字符转化为日期
     * 
     * @Title stringToDate
     * @author wanglc
     * @date 2013-12-6
     * @param strDate
     * @param pattern
     * @param otherPattern
     * @return
     */
    public static Date stringToDate(String strDate, String pattern,
        String otherPattern) {
        try {
            long ltime = stringToLong(strDate, pattern);
            return new Date(ltime);
        }
        catch (Exception ex) {
            try {
                long ltime = stringToLong(strDate, otherPattern);
                return new Date(ltime);
            }
            catch (Exception e) {
                return null;
            }
        }
    }
    
    /**
     * 格式化日期
     * 
     * @Title formatDate
     * @author wanglc
     * @date 2013-12-6
     * @param date
     * @param pattern
     * @return
     */
    public static Date formatDate(Date date, String pattern) {
        String s = dateToString(date, pattern);
        return stringToDate(s, pattern);
    }
    
    /**
     * 取得当前日期的天份
     * 
     * @Title getEmbodyDay
     * @author wanglc
     * @date 2013-12-6
     * @param date
     * @return
     */
    public static int getEmbodyDay(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int embodyDay = calendar.get(Calendar.DAY_OF_MONTH);
        return embodyDay;
        
    }
    
    /**
     * 取得当前日期的月份
     * 
     * @Title getEmbodyMonth
     * @author wanglc
     * @date 2013-12-6
     * @param date
     * @return
     */
    public static int getEmbodyMonth(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int embodyMonth = calendar.get(Calendar.MONTH) + 1;
        return embodyMonth;
        
    }
    
    /**
     * 取得当前日期的年份
     * 
     * @Title getEmbodyYear
     * @author wanglc
     * @date 2013-12-6
     * @param date
     * @return
     */
    public static int getEmbodyYear(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        int embodyYear = calendar.get(Calendar.YEAR);
        return embodyYear;
        
    }
    
    /**
     * 根据参数和格式取未来日期
     * 
     * @Title getFutureDay
     * @author wanglc
     * @date 2013-12-6
     * @param appDate
     * @param format
     * @param days
     * @return
     */
    public static String getFutureDay(String appDate, String format, int days) {
        String future = "";
        try {
            Calendar calendar = GregorianCalendar.getInstance();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
            Date date = simpleDateFormat.parse(appDate);
            calendar.setTime(date);
            calendar.add(Calendar.DATE, days);
            date = calendar.getTime();
            future = simpleDateFormat.format(date);
        }
        catch (Exception e) {
            
        }
        
        return future;
    }
    
    /**
     * 根据参数和格式取未来时间
     * 
     * @Title getFutureTime
     * @author wanglc
     * @date 2013-12-6
     * @param appDate
     * @param format
     * @param hours
     * @return
     */
    public static String getFutureTime(String appDate, String format, int hours) {
        String future = "";
        try {
            Calendar calendar = GregorianCalendar.getInstance();
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(format);
            Date date = simpleDateFormat.parse(appDate);
            calendar.setTime(date);
            calendar.add(Calendar.HOUR, hours);
            date = calendar.getTime();
            future = simpleDateFormat.format(date);
        }
        catch (Exception e) {
            
        }
        
        return future;
    }
    
    /**
     * 字符串转换成日期，如果需转换的字符串为null，则返回为null
     * 
     * @Title string2date
     * @author wanglc
     * @date 2013-12-6
     * @param value String 需转换的字符串 格式为yyyy-MM-dd
     * @return
     */
    public static Date string2date(String value) {
        if (value == null) {
            return null;
        }
        SimpleDateFormat sdf = new SimpleDateFormat(DATE_FORMAT);
        try {
            return sdf.parse(value);
        }
        catch (ParseException e) {
            logger.error(e);
            throw new RuntimeException(e);
        }
    }
    
}
