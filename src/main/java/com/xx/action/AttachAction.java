package com.xx.action;

import java.io.File;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.struts2.ServletActionContext;

import com.opensymphony.xwork2.ActionSupport;
import com.xx.common.util.JsonUtil;

/**
 * 附件上传
 * 
 * @author wujialing
 */
public class AttachAction extends ActionSupport {

	/**
	 * 序列号
	 */
	private static final long serialVersionUID = 1L;
	
	private File Filedata;   //上传的附件
	
	public InputStream fileStream;
	
	/**
	 * 跳转附件上传
	 * 
	 * @return
	 */
	public String toAttach(){
		return "success";
	}
	
	/**
	 * 上传附件
	 * 
	 * @return
	 */
	public String addAttach(){
		HttpServletRequest request  = ServletActionContext.getRequest();
		FileItemFactory factory = new DiskFileItemFactory();  
		ServletFileUpload upload = new ServletFileUpload(factory);  
		Map<String,Object> attachMap = new HashMap<String, Object>();
		try {
			List<FileItem> items = upload.parseRequest(request);
			System.err.println(items.size());
		} catch (FileUploadException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
		if (Filedata == null ) {
			attachMap.put("success",false);
			attachMap.put("result","添加失败。");
			JsonUtil.outJson(attachMap);
			return null;
		}else{
			attachMap.put("success",true);
			attachMap.put("result","添加成功。");
			JsonUtil.outJson(attachMap);
			return null;
		}
	}



	public File getFiledata() {
		return Filedata;
	}

	public void setFiledata(File filedata) {
		Filedata = filedata;
	}

	public InputStream getFileStream() {
		return fileStream;
	}

	public void setFileStream(InputStream fileStream) {
		this.fileStream = fileStream;
	}
}
