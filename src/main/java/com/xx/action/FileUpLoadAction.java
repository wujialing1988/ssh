/**
 * 文件上传
 */
package com.dqgb.jxgl.assess.action;

import java.io.File;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;

import com.dqgb.jxgl.assess.entity.AppealScoreDetail;
import com.dqgb.jxgl.assess.entity.Attach;
import com.dqgb.jxgl.assess.entity.AttachGroup;
import com.dqgb.jxgl.assess.service.IAppealScoreService;
import com.dqgb.jxgl.assess.service.IAttachGroupService;
import com.dqgb.jxgl.assess.service.IAttachService;
import com.dqgb.jxgl.assess.service.IPublicityService;
import com.dqgb.sshframe.common.action.BaseAction;
import com.dqgb.sshframe.common.constant.Constant;
import com.dqgb.sshframe.common.util.FileUtil;
import com.dqgb.sshframe.common.util.JsonUtil;
import com.dqgb.sshframe.common.util.RequestUtil;
import com.dqgb.sshframe.common.util.StringUtil;
import com.dqgb.sshframe.dict.service.IDictService;
import com.dqgb.sshframe.log.entity.Log;
import com.dqgb.sshframe.log.service.ILogService;
import com.dqgb.sshframe.user.service.IUserService;

/**
 * 考核公示Action
 * 
 * @author qiubo
 * @version V1.20,2013-11-25 下午3:23:42
 * @see [相关类/方法]
 * @since V1.20
 * @depricated
 */
public class FileUpLoadAction extends BaseAction
{
    
    // 考核公示序列号
    private static final long serialVersionUID = -1661933388897792411L;
    
    // 日志
    static Logger logger = Logger.getLogger(FileUpLoadAction.class.getName());
    
    // 文件名称
    private String upLoadFileFileName;
    
    private File upLoadFile;
    
    private String upLoadFileContentType;  
    
    
    // 附件服务
    private IAttachService attachService;
    
    // 附件组服务
    private IAttachGroupService attachGroupService;
    
    // 考核公示服务
    @Resource
    public IPublicityService publicityService;
    
    // 用户服务
    @Resource
    public IUserService userService;
    
    // 日至服务
    @Autowired(required = true)
    @Qualifier("logService")
    private ILogService logService;
    
    // 字典服务
    @Resource
    private IDictService dictService;
    
    private List<Attach> attachList;
    
    
    @Resource
    public IAppealScoreService appealScoreService;
    
    
    /**
     * 删除附件
     * @return
     */
    public String deleteAttach(){
    	String attachIds=getRequest().getParameter("attachIds");
    	attachGroupService.deleteAttach(attachIds);
    	return null;
    }
    
    public String getAttachListByGroupId(){
    	try{
    		String attachGroupId=getRequest().getParameter("attachGroupId");
        	attachList=attachGroupService.getAttachListByGroupId(attachGroupId);
    	}catch (Exception e) {
			e.printStackTrace();
		}
    	
    	return SUCCESS;
    }
    
    
    public String getAttachGroupId(){
    	String type=getRequest().getParameter("type");
    	String pkId=getRequest().getParameter("pkId");
    	String attachGroupId=null;
    	//申诉附件组
    	if("1".equals(type)){
    		if(!StringUtil.isEmpty(pkId)){
    			AppealScoreDetail appealScoreDetail=appealScoreService.getAppealScoreDetailById(pkId);
    			if(appealScoreDetail.getAttachGroup()!=null){
    				attachGroupId=appealScoreDetail.getAttachGroup().toString();
    			}
    		}
    	}
    	if(null==attachGroupId){
        	AttachGroup attachGroup = null;
        	attachGroup = new AttachGroup();
            attachGroup.setStatus("0");
            attachGroup.setSubmitDate(new Date());
            attachGroupService.saveAttachGroup(attachGroup);
            attachGroupId=attachGroup.getPkAttachGroupId().toString();
        	
    	}
    	JsonUtil.outJson("{attachGroupId:"+attachGroupId+"}");
    	return null;
    }
    
    public String upLoadFile()
    {
    	 Map<String, String> map = RequestUtil.getParameterMap(getRequest());
        Map<String, Object> attachMap = new HashMap<String, Object>();
        AttachGroup attachGroup = null;
        String attachGroupId = this.getRequest().getParameter("attachGroupId");
        String extendName = this.getRequest().getParameter("extendName");
        String fileSize = this.getRequest().getParameter("fileSize");
        String attachName = this.getRequest().getParameter("attachName");
        try
        {
            if (attachGroupId != null && !"".equals(attachGroupId))
            {
                attachGroup =
                    attachGroupService.getAttachGroup(Long.parseLong(attachGroupId));
            }
            if (attachGroup == null)
            {
                attachGroup = new AttachGroup();
                attachGroup.setStatus("0");
                attachGroup.setSubmitDate(new Date());
                attachGroupService.saveAttachGroup(attachGroup);
            }
            Attach attach = new Attach();
            attach.setStatus("0");
            
            if (fileSize != null && !"".equals(fileSize))
            {
                attach.setFileSize(fileSize);
            }
            if (attachName != null && !"".equals(attachName))
            {
                attach.setAttachName(attachName);
            }
            
            if (extendName != null && !"".equals(extendName))
            {
                attach.setExtendName(extendName);
            }
            
            String attachURL =
                FileUtil.upload(upLoadFile, upLoadFileFileName, "upload");
            attach.setUrl(attachURL);
            attach.setAttachGroup(attachGroup);
            attachService.saveAttach(attach);
            
            attach.setAttachGroup(null);
            attachMap.put("attachGroupId", attachGroup.getPkAttachGroupId());
            attachMap.put("attachName", attach.getAttachName());
            attachMap.put("attachId", attach.getPkAttachId());
            attachMap.put("attachFile", attach);
            attachMap.put("success", true);
            attachMap.put("result", "Y");
        }
        catch (Exception e)
        {
        	e.printStackTrace();
            attachMap.put("result", "添加失败：" + e.getMessage());
            attachMap.put("success", false);
            Log log = new Log();
            log.setOpDate(new Date());
            log.setIpUrl(ServletActionContext.getRequest().getRemoteAddr());
            log.setOpContent("添加附件失败!错误信息:" + e.getMessage());
            log.setUser(RequestUtil.getLoginUser());
            log.setType(dictService.getDictByTypeCode(Constant.LOGTYPE).get(1));
            logService.addLog(log);
        }
        JsonUtil.outJson(attachMap);
        return null;
    }
    
    
    public void setPublicityService(IPublicityService publicityService)
    {
        this.publicityService = publicityService;
    }
    
    public void setUserService(IUserService userService)
    {
        this.userService = userService;
    }
    
	
    public void setAttachService(IAttachService attachService)
    {
        this.attachService = attachService;
    }
    
    public void setAttachGroupService(IAttachGroupService attachGroupService)
    {
        this.attachGroupService = attachGroupService;
    }

	
	public String getUpLoadFileContentType() {
		return upLoadFileContentType;
	}

	public void setUpLoadFileContentType(String upLoadFileContentType) {
		this.upLoadFileContentType = upLoadFileContentType;
	}

	public void setAppealScoreService(IAppealScoreService appealScoreService) {
		this.appealScoreService = appealScoreService;
	}

	public File getUpLoadFile() {
		return upLoadFile;
	}

	public void setUpLoadFile(File upLoadFile) {
		this.upLoadFile = upLoadFile;
	}

	public String getUpLoadFileFileName() {
		return upLoadFileFileName;
	}

	public void setUpLoadFileFileName(String upLoadFileFileName) {
		this.upLoadFileFileName = upLoadFileFileName;
	}

	public List<Attach> getAttachList() {
		return attachList;
	}

	public void setAttachList(List<Attach> attachList) {
		this.attachList = attachList;
	}
    
    
    
}
