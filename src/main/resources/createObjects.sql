create sequence HIBERNATE_SEQUENCE
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
 cache 100
noorder;

create sequence SEQ_ACTIVITI_CATEGORY
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_ACTIVITI_FORM
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_ACTIVITI_TASK_ROLE
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_DICTIONARY
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_GROUP
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_GROUP_MEMBER
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_LOG
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_ORGANIZATION
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_ORG_USER
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_RESOURCE
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_ROLE
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_ROLE_MEMBER_SCOPE
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_ROLE_RESOURCE
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence SEQ_SCOPE_MEMBER
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence SEQ_USER
increment by 1
start with 1
 nomaxvalue
 nominvalue
nocycle
noorder;

create sequence S_ACTIVITI_DEFINE_TEMPLATE
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence S_ACTIVITI_DELEGATE
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence S_ACTIVITI_PROCESS_APPROVAL
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;

create sequence S_ACTIVITI_PROCESS_INST
increment by 1
start with 1
 maxvalue 9999999999999999999999999999
 nominvalue
nocycle
noorder;


/*==============================================================*/
/* Table: SYS_ACTIVITI_CATEGORY                                 */
/*==============================================================*/
create table SYS_ACTIVITI_CATEGORY 
(
   PK_ACTIVITI_CATEGORY_ID NUMBER(10)           not null,
   CATEGORY_CODE        VARCHAR2(50)         not null,
   DESCRIPTION          VARCHAR2(1000),
   ISDELETE             NUMBER(10),
   LEAF                 NUMBER(10),
   NAME                 VARCHAR2(100)        not null,
   PARENTID             NUMBER(10),
   SORT                 NUMBER(10),
   constraint SYS_C0053661 primary key (PK_ACTIVITI_CATEGORY_ID)
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_DEFINE_TEMPLATE                          */
/*==============================================================*/
create table SYS_ACTIVITI_DEFINE_TEMPLATE 
(
   PK_ACTIVITI_DEFINE_TEMPLATE_ID NUMBER(10)           not null,
   ISDELETE             NUMBER(10),
   NAME                 VARCHAR2(255)        not null,
   PROCESS_DEFINE_KEY   VARCHAR2(255)        not null,
   REAL_NAME            VARCHAR2(255),
   URL                  VARCHAR2(255)        not null,
   FK_CATEGORY_ID       NUMBER(10)           not null,
   constraint SYS_C0053667 primary key (PK_ACTIVITI_DEFINE_TEMPLATE_ID)
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_DELEGATE                                 */
/*==============================================================*/
create table SYS_ACTIVITI_DELEGATE 
(
   PK_ACTIVITI_DELEGATE_ID NUMBER(10)           not null,
   DELEGATE_END_TIME    DATE,
   DELEGATE_START_TIME  DATE,
   DELEGATE_STATUS      NUMBER(10),
   ISDELETE             NUMBER(10),
   DELEGATE_ID          NUMBER(10),
   OWNER_ID             NUMBER(10),
   constraint SYS_C0053678 primary key (PK_ACTIVITI_DELEGATE_ID)
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_FORM                                     */
/*==============================================================*/
create table SYS_ACTIVITI_FORM 
(
   PK_ACTIVITI_FORM_ID  NUMBER(10)           not null,
   ADAPTATION_NODE      VARCHAR2(500),
   DESCRIPTION          VARCHAR2(500),
   FORM_NAME            VARCHAR2(200),
   FORM_URL             VARCHAR2(200),
   ISDELETE             NUMBER(10),
   constraint SYS_C0053680 primary key (PK_ACTIVITI_FORM_ID)
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_FORM_CATEGORY                            */
/*==============================================================*/
create table SYS_ACTIVITI_FORM_CATEGORY 
(
   PK_ACTIVITI_FORM_ID  NUMBER(10)           not null,
   PK_CATEGORY_ID       NUMBER(10)           not null
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_PROCESS_APPROVAL                         */
/*==============================================================*/
create table SYS_ACTIVITI_PROCESS_APPROVAL 
(
   PK_ACTIVITI_PRO_APPROVAL_ID NUMBER(10)           not null,
   APPROVAL             NUMBER(10),
   ELECTRONIC_SIGNATURE BLOB,
   ELECTRONIC_SOURCE    NUMBER(10),
   ELECTRONIC_URL       VARCHAR2(300),
   ISDELETE             NUMBER(10),
   OPINION              VARCHAR2(2000),
   PROCESS_INSTANCE_ID  VARCHAR2(255),
   TASKID               VARCHAR2(255),
   FK_USER_ID           NUMBER(10),
   constraint SYS_C0053671 primary key (PK_ACTIVITI_PRO_APPROVAL_ID)
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_PROCESS_INST                             */
/*==============================================================*/
create table SYS_ACTIVITI_PROCESS_INST 
(
   PK_ACTIVITI_PROCESS_INST_ID NUMBER(10)           not null,
   BUSINESS_ID          VARCHAR2(1000),
   BUSINESS_ORG         VARCHAR2(300),
   BUSINESS_TITLE         VARCHAR2(1000),
   ISDELETE             NUMBER(10),
   PROCESS_CODE         VARCHAR2(255),
   PROCESS_CREATE_DATE  DATE,
   PROCESS_DEFINEKEY    VARCHAR2(255),
   PROCESS_INSTANCE_ID  VARCHAR2(255),
   PROCESS_NAME         VARCHAR2(255),
   PROCESS_TYPE         VARCHAR2(255),
   FK_ACTIVITI_CATEGORY_ID NUMBER(10),
   FK_PROCESS_CREATER   NUMBER(10),
   constraint SYS_C0053673 primary key (PK_ACTIVITI_PROCESS_INST_ID)
);

/*==============================================================*/
/* Table: SYS_ACTIVITI_ROLE                                     */
/*==============================================================*/
create table SYS_ACTIVITI_ROLE 
(
   PK_ACTIVITI_TASK_ROLE_ID NUMBER(10)           not null,
   TASKID               VARCHAR2(300)        not null,
   FK_ROLE_ID           NUMBER(10),
   constraint SYS_C0053676 primary key (PK_ACTIVITI_TASK_ROLE_ID)
);

/*==============================================================*/
/* Table: T_ATTACH                                              */
/*==============================================================*/
create table T_ATTACH 
(
   ATTACH_ID            NUMBER(10)           not null,
   ATTACH_NAME          VARCHAR2(100)        not null,
   ATTACH_TYPE          VARCHAR2(100),
   ATTACH_URL           VARCHAR2(200)        not null,
   DESCRIPTION          VARCHAR2(1000),
   DOWNLOAD_TIME        NUMBER(10),
   FILE_SIZE            VARCHAR2(50),
   REMARKS              VARCHAR2(2000),
   STATUS               NUMBER(10)           not null,
   SUBMIT_DATE          DATE                 not null,
   ATTACH_GROUP_ID      NUMBER(10)           not null,
   constraint SYS_C0045410 primary key (ATTACH_ID)
);

/*==============================================================*/
/* Table: T_ATTACH_GROUP                                        */
/*==============================================================*/
create table T_ATTACH_GROUP 
(
   ATTACH_ID            NUMBER(10)           not null,
   REMARKS              VARCHAR2(2000),
   STATUS               NUMBER(10)           not null,
   SUBMIT_DATE          DATE                 not null,
   constraint SYS_C0045414 primary key (ATTACH_ID)
);

/*==============================================================*/
/* Table: T_DICTIONARY                                          */
/*==============================================================*/
create table T_DICTIONARY 
(
   PK_ID                NUMBER(10)           not null,
   DICT_CODE            VARCHAR2(255),
   DICT_UUID            VARCHAR2(255),
   DICTIONARY_NAME      VARCHAR2(48),
   DICTIONARY_VALUE     VARCHAR2(480),
   FK_DICT_TYPE_UUID    VARCHAR2(255),
   LEVEL_ORDER          NUMBER(10),
   STATUS               VARCHAR2(1),
   PARENT_ID            NUMBER(10),
   constraint SYS_C0053979 primary key (PK_ID)
);

/*==============================================================*/
/* Table: T_GROUP                                               */
/*==============================================================*/
create table T_GROUP 
(
   ID                   NUMBER(10)           not null,
   CREATE_DATE          DATE                 not null,
   GROUP_NAME           VARCHAR2(100)        not null,
   REMARK               VARCHAR2(2000),
   constraint SYS_C0053983 primary key (ID)
);

/*==============================================================*/
/* Table: T_GROUP_MEMBER                                        */
/*==============================================================*/
create table T_GROUP_MEMBER 
(
   ID                   NUMBER(10)           not null,
   GROUP_ID             NUMBER(10)           not null,
   ORG_ID               NUMBER(10),
   USER_ID              NUMBER(10),
   constraint SYS_C0053986 primary key (ID)
);

/*==============================================================*/
/* Table: T_LOG                                                 */
/*==============================================================*/
create table T_LOG 
(
   PK_LOG_ID            NUMBER(19)           not null,
   IP_URL               VARCHAR2(50),
   FK_LOG_TYPE_UUID     VARCHAR2(255),
   OP_CONTENT           VARCHAR2(4000),
   OP_DATE              DATE                 not null,
   LOG_TYPE             NUMBER(10),
   USER_ID              NUMBER(10),
   constraint SYS_C0053989 primary key (PK_LOG_ID)
);

/*==============================================================*/
/* Table: T_ORGANIZATION                                        */
/*==============================================================*/
create table T_ORGANIZATION 
(
   ORG_ID               NUMBER(10)           not null,
   DIS_ORDER            NUMBER(10),
   ENABLE               NUMBER(10)           not null,
   ISDELETEABLE         NUMBER(10)           not null,
   ORG_CODE             VARCHAR2(50),
   ORG_FROM             NUMBER(10),
   ORG_NAME             VARCHAR2(100)        not null,
   FK_ORGTYPE_UUID      VARCHAR2(255),
   STATUS               NUMBER(10)           not null,
   FK_ORGTYPE           NUMBER(10),
   PARENT_ID            NUMBER(10),
   constraint SYS_C0053995 primary key (ORG_ID)
);

/*==============================================================*/
/* Table: T_ORG_USER                                            */
/*==============================================================*/
create table T_ORG_USER 
(
   PK_ORG_USER_ID       NUMBER(10)           not null,
   ISDELETE             NUMBER(10)           not null,
   FK_ORG_ID            NUMBER(10)           not null,
   FK_USER_ID           NUMBER(10)           not null,
   constraint SYS_C0054000 primary key (PK_ORG_USER_ID)
);

/*==============================================================*/
/* Table: T_RESOURCE                                            */
/*==============================================================*/
create table T_RESOURCE 
(
   RESOURCE_ID          NUMBER(10)           not null,
   CODE                 VARCHAR2(100),
   CREATE_DATE          DATE                 not null,
   DIS_ORDER            NUMBER(10),
   ISDELETEABLE         NUMBER(10)           not null,
   REMARKS              VARCHAR2(200),
   RESOURCE_FROM        NUMBER(10),
   RESOURCE_NAME        VARCHAR2(100)        not null,
   RESOURCE_TYPE_UUID   VARCHAR2(255),
   STATUS               NUMBER(10)           not null,
   URLPATH              VARCHAR2(200),
   PARENT_ID            NUMBER(10),
   RESOURCE_TYPE        NUMBER(10),
   constraint SYS_C0054006 primary key (RESOURCE_ID)
);

/*==============================================================*/
/* Table: T_ROLE                                                */
/*==============================================================*/
create table T_ROLE 
(
   ROLE_ID              NUMBER(10)           not null,
   DESCRIPTION          VARCHAR2(200),
   ISDELETE             NUMBER(10)           not null,
   ISDELETEABLE         NUMBER(10)           not null,
   ROLE_CODE            VARCHAR2(50),
   ROLE_NAME            VARCHAR2(50)         not null,
   FK_ROLE_TYPE_UUID    VARCHAR2(255),
   FK_ROLE_TYPE         NUMBER(10),
   constraint SYS_C0054011 primary key (ROLE_ID)
);

/*==============================================================*/
/* Table: T_ROLE_MEMBER                                   */
/*==============================================================*/
create table T_ROLE_MEMBER 
(
   ID                   NUMBER(10)           not null,
   GROUP_ID             NUMBER(10),
   ROLE_ID              NUMBER(10)           not null,
   USER_ID              NUMBER(10),
   constraint SYS_C0054014 primary key (ID)
);

/*==============================================================*/
/* Table: T_ROLE_RESOURCE                                       */
/*==============================================================*/
create table T_ROLE_RESOURCE 
(
   ROLE_RESOURCE_ID     NUMBER(10)           not null,
   RESOURCE_ID          NUMBER(10)           not null,
   ROLE_ID              NUMBER(10)           not null,
   constraint SYS_C0054018 primary key (ROLE_RESOURCE_ID)
);

/*==============================================================*/
/* Table: T_DATA_SCOPE                                        */
/*==============================================================*/
create table T_DATA_SCOPE 
(
   ID                   NUMBER(10)           not null,
   GROUP_ID             NUMBER(10),
   ORG_ID               NUMBER(10),
   ROLE_MEMBER_ID       NUMBER(10),
   USER_ID              NUMBER(10),
   constraint SYS_C0054026 primary key (ID)
);

/*==============================================================*/
/* Table: T_TEMP_TEAM                                           */
/*==============================================================*/
create table T_TEMP_TEAM 
(
   ID                   NUMBER               not null,
   NAME                 VARCHAR2(100),
   CREATE_DATE          DATE,
   REMARKS              VARCHAR2(1000),
   constraint PK_TEMP_TEAM_ID primary key (ID)
);

/*==============================================================*/
/* Table: T_TEMP_TEAM_MENBER                                    */
/*==============================================================*/
create table T_TEMP_TEAM_MENBER 
(
   ID                   NUMBER               not null,
   USER_ID              NUMBER               not null,
   TEMP_TEAM_ID         NUMBER,
   constraint PK_RULE_ROUND_USER primary key (ID)
);

/*==============================================================*/
/* Table: T_USER                                                */
/*==============================================================*/
create table T_USER 
(
   USER_ID              NUMBER(10)           not null,
   BIRTHDAY             VARCHAR2(50),
   BIRTH_PLACE          VARCHAR2(255),
   CARD_CODE            VARCHAR2(255),
   DIS_ORDER            NUMBER(10),
   ELECTRONIC_SIGNATURE VARCHAR2(255),
   EMAIL                VARCHAR2(255),
   ISENABLE             NUMBER(10),
   ERP_ID               VARCHAR2(255),
   GENDER               VARCHAR2(3),
   ID_CARD              VARCHAR2(255),
   ISDELETABLE          NUMBER(10),
   FK_JOB1_UUID         VARCHAR2(255),
   FK_JOB2_UUID         VARCHAR2(255),
   FK_JOBLEVEL_UUID     VARCHAR2(255),
   MOBILE_PHONE1        VARCHAR2(20),
   MOBILE_PHONE2        VARCHAR2(20),
   PASSWORD             VARCHAR2(50),
   PERSONAL_IMAGE       VARCHAR2(255),
   PHONE_NO             VARCHAR2(20),
   FK_POSTTITLE_UUID    VARCHAR2(255),
   FK_POST_UUID         VARCHAR2(255),
   REALNAME             VARCHAR2(50),
   SHORT_NO1            VARCHAR2(20),
   SHORT_NO2            VARCHAR2(20),
   STATUS               NUMBER(10),
   FK_TEAM_UUID         VARCHAR2(255),
   USER_ONLINE          NUMBER(19),
   FK_USERTYPE_UUID     VARCHAR2(255),
   USERNAME             VARCHAR2(50),
   FK_JOB1              NUMBER(10),
   FK_JOB2              NUMBER(10),
   FK_JOBLEVEL          NUMBER(10),
   FK_POST              NUMBER(10),
   FK_POSTTITLE         NUMBER(10),
   FK_TEAM              NUMBER(10),
   FK_TYPE              NUMBER(10),
   constraint SYS_C0054028 primary key (USER_ID)
);

/*===================注释======================*/
comment on column SYS_ACTIVITI_PROCESS_INST.BUSINESS_ORG is
'业务数据的归属组织ID';
comment on column SYS_ACTIVITI_PROCESS_INST.BUSINESS_ORG is
'业务数据的归属组织ID';
comment on table T_DICTIONARY is
'字典表';

comment on column T_DICTIONARY.PK_ID is
'字典表主键';

comment on column T_DICTIONARY.DICTIONARY_NAME is
'字典名称';

comment on column T_DICTIONARY.DICTIONARY_VALUE is
'字典值';

comment on column T_DICTIONARY.LEVEL_ORDER is
'等级或排序号';

comment on column T_DICTIONARY.STATUS is
'删除标志 0未删除 1 已删除';

comment on column T_DICTIONARY.FK_DICT_TYPE_UUID is
'字典类型随机数';

comment on column T_DICTIONARY.DICT_UUID is
'字典数据随机数';

comment on column T_DICTIONARY.DICT_CODE is
'字典编码';

comment on column T_DICTIONARY.PARENT_ID is
'字典类型ID';
comment on table T_GROUP is
'群组';

comment on column T_GROUP.GROUP_NAME is
'群组名称';

comment on column T_GROUP.CREATE_DATE is
'创建时间';

comment on column T_GROUP.REMARK is
'备注';
comment on table T_GROUP_MEMBER is
'群组成员';

comment on column T_GROUP_MEMBER.USER_ID is
'用户ID';

comment on column T_GROUP_MEMBER.ORG_ID is
'部门ID';

comment on column T_GROUP_MEMBER.GROUP_ID is
'群组ID';
comment on table T_LOG is
'日志表';

comment on column T_LOG.PK_LOG_ID is
'日志表主键';

comment on column T_LOG.USER_ID is
'操作人ID';

comment on column T_LOG.OP_DATE is
'操作时间';

comment on column T_LOG.OP_CONTENT is
'日志内容';

comment on column T_LOG.IP_URL is
'操作IP地址';

comment on column T_LOG.LOG_TYPE is
'日志类型 1系统日志，2，用户日志 3，系统错误日志';

comment on column T_LOG.FK_LOG_TYPE_UUID is
'日志类型字典数据UUID';
comment on table T_ORGANIZATION is
'组织表';

comment on column T_ORGANIZATION.ORG_CODE is
'为了给用户使用方便，这里增加组织代码，例如：生产管理部的代码：SCGL';

comment on column T_ORGANIZATION.FK_ORGTYPE is
'字典数据';

comment on column T_ORGANIZATION.DIS_ORDER is
'同级排序';

comment on column T_ORGANIZATION.ENABLE is
'0：可用；1：禁用';

comment on column T_ORGANIZATION.STATUS is
'0：未删除
1：删除   2架构删除';

comment on column T_ORGANIZATION.ORG_FROM is
'组织来源  0：架构自行添加     1：继承平台同步';

comment on column T_ORGANIZATION.FK_ORGTYPE_UUID is
'组织类型字典数据UUID';

comment on column T_ORGANIZATION.ISDELETEABLE is
'1不允许删除；0可以删除';
comment on table T_ORG_USER is
'用户-组织表';

comment on column T_ORG_USER.PK_ORG_USER_ID is
'主键';

comment on column T_ORG_USER.FK_ORG_ID is
'组织ID';

comment on column T_ORG_USER.FK_USER_ID is
'用户ID';

comment on column T_ORG_USER.ISDELETE is
'0：未删除  1：已删除';
comment on table T_RESOURCE is
'资源表';

comment on column T_RESOURCE.RESOURCE_ID is
'主键';

comment on column T_RESOURCE.RESOURCE_NAME is
'资源名称';

comment on column T_RESOURCE.CODE is
'资源编码';

comment on column T_RESOURCE.RESOURCE_TYPE is
'字典数据';

comment on column T_RESOURCE.URLPATH is
'该字段可以存储菜单或页面的URL';

comment on column T_RESOURCE.REMARKS is
'备注';

comment on column T_RESOURCE.PARENT_ID is
'父菜单ID';

comment on column T_RESOURCE.DIS_ORDER is
'从1开始排序';

comment on column T_RESOURCE.STATUS is
'0：未删除
1：已删除 2：同步时删除';

comment on column T_RESOURCE.CREATE_DATE is
'录入时间';

comment on column T_RESOURCE.RESOURCE_FROM is
'资源来源 0：架构自行添加 1：集成平台同步';

comment on column T_RESOURCE.RESOURCE_TYPE_UUID is
'资源类型字典数据UUID';

comment on column T_RESOURCE.ISDELETEABLE is
'1不允许删除；0可以删除';
comment on table T_ROLE is
'角色表';

comment on column T_ROLE.ROLE_ID is
'主键';

comment on column T_ROLE.ROLE_NAME is
'角色名';

comment on column T_ROLE.ROLE_CODE is
'角色编码';

comment on column T_ROLE.DESCRIPTION is
'描述';

comment on column T_ROLE.ISDELETE is
'删除标志：0未删除 1已删除';

comment on column T_ROLE.FK_ROLE_TYPE is
'角色种类：0：自有角色 1：授权角色';

comment on column T_ROLE.FK_ROLE_TYPE_UUID is
'角色种类字典数据UUID';

comment on column T_ROLE.ISDELETEABLE is
'1不允许删除；0可以删除';
comment on table T_ROLE_MEMBER is
'角色、角色成员、有效范围的关联表';

comment on column T_ROLE_MEMBER.ROLE_ID is
'角色ID';

comment on column T_ROLE_MEMBER.USER_ID is
'用户ID';

comment on column T_ROLE_MEMBER.GROUP_ID is
'群组的ID';
comment on table T_ROLE_RESOURCE is
'角色资源表';

comment on column T_ROLE_RESOURCE.ROLE_RESOURCE_ID is
'主键';

comment on column T_ROLE_RESOURCE.RESOURCE_ID is
'资源ID';

comment on column T_ROLE_RESOURCE.ROLE_ID is
'角色ID';

comment on table T_DATA_SCOPE is
'权限范围';

comment on column T_DATA_SCOPE.ROLE_MEMBER_ID is
'角色成员ID';

comment on column T_DATA_SCOPE.ORG_ID is
'组织ID';
comment on table T_USER is
'用户表';

comment on column T_USER.USER_ID is
'主键';

comment on column T_USER.USERNAME is
'登录名';

comment on column T_USER.ERP_ID is
'ERP编号';

comment on column T_USER.PASSWORD is
'密码';

comment on column T_USER.MOBILE_PHONE1 is
'手机号码1';

comment on column T_USER.ELECTRONIC_SIGNATURE is
'电子签名';

comment on column T_USER.PERSONAL_IMAGE is
'个人头像';

comment on column T_USER.REALNAME is
'真实姓名';

comment on column T_USER.GENDER is
'性别';

comment on column T_USER.STATUS is
'0：未删除
1：已删除';

comment on column T_USER.DIS_ORDER is
'排序';

comment on column T_USER.ISENABLE is
'0:未禁用；1：禁用';

comment on column T_USER.FK_TYPE is
'用户类型-字典表';

comment on column T_USER.USER_ONLINE is
'最后在线时刻(用毫秒表示)';

comment on column T_USER.FK_TEAM is
'班组';

comment on column T_USER.SHORT_NO1 is
'集团短号1';

comment on column T_USER.PHONE_NO is
'座机号码';

comment on column T_USER.BIRTH_PLACE is
'出生地';

comment on column T_USER.EMAIL is
'邮箱';

comment on column T_USER.CARD_CODE is
'卡号';

comment on column T_USER.ID_CARD is
'身份证号';

comment on column T_USER.FK_POSTTITLE is
'职称-字典表';

comment on column T_USER.FK_POST is
'职位-字典表';

comment on column T_USER.FK_JOB1 is
'职务1-字典表';

comment on column T_USER.FK_JOBLEVEL is
'职级-字典表';

comment on column T_USER.BIRTHDAY is
'出生日期';

comment on column T_USER.ISDELETABLE is
'是否允许删除： 0 允许  1 不允许';

comment on column T_USER.MOBILE_PHONE2 is
'手机号码2';

comment on column T_USER.SHORT_NO2 is
'集团短号2';

comment on column T_USER.FK_JOB2 is
'职务2-字典表';

comment on column T_USER.FK_USERTYPE_UUID is
'用户类型字典数据UUID';

comment on column T_USER.FK_TEAM_UUID is
'班组字典数据UUID';

comment on column T_USER.FK_POSTTITLE_UUID is
'职称字典数据UUID';

comment on column T_USER.FK_POST_UUID is
'职位字典数据UUID';

comment on column T_USER.FK_JOB1_UUID is
'职务1字典数据UUID';

comment on column T_USER.FK_JOB2_UUID is
'职务2字典数据UUID';

comment on column T_USER.FK_JOBLEVEL_UUID is
'职级字典数据UUID';

/*======================约束=====================*/

alter table SYS_ACTIVITI_DEFINE_TEMPLATE
   add constraint FKB9E57A9010AF362B foreign key (FK_CATEGORY_ID)
      references SYS_ACTIVITI_CATEGORY (PK_ACTIVITI_CATEGORY_ID)
      not deferrable;

alter table SYS_ACTIVITI_FORM_CATEGORY
   add constraint FK5E10EAABBAF7CEE9 foreign key (PK_ACTIVITI_FORM_ID)
      references SYS_ACTIVITI_FORM (PK_ACTIVITI_FORM_ID)
      not deferrable;

alter table SYS_ACTIVITI_FORM_CATEGORY
   add constraint FK5E10EAABE3591661 foreign key (PK_CATEGORY_ID)
      references SYS_ACTIVITI_CATEGORY (PK_ACTIVITI_CATEGORY_ID)
      not deferrable;

alter table SYS_ACTIVITI_PROCESS_INST
   add constraint FKA2CEB7644D6CC09F foreign key (FK_ACTIVITI_CATEGORY_ID)
      references SYS_ACTIVITI_CATEGORY (PK_ACTIVITI_CATEGORY_ID)
      not deferrable;

alter table T_ATTACH
   add constraint FK2B049890EE20AD3D foreign key (ATTACH_GROUP_ID)
      references T_ATTACH_GROUP (ATTACH_ID)
      not deferrable;

alter table T_DICTIONARY
   add constraint FKFEB7F561FA82F069 foreign key (PARENT_ID)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_GROUP_MEMBER
   add constraint FKAF71F68558DC4FB2 foreign key (USER_ID)
      references T_USER (USER_ID)
      not deferrable;

alter table T_GROUP_MEMBER
   add constraint FKAF71F685EFF3B282 foreign key (GROUP_ID)
      references T_GROUP (ID)
      not deferrable;

alter table T_GROUP_MEMBER
   add constraint FKAF71F685F0C9319A foreign key (ORG_ID)
      references T_ORGANIZATION (ORG_ID)
      not deferrable;

alter table T_LOG
   add constraint FK4CC0CB958DC4FB2 foreign key (USER_ID)
      references T_USER (USER_ID)
      not deferrable;

alter table T_LOG
   add constraint FK4CC0CB9F7234EEE foreign key (LOG_TYPE)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_ORGANIZATION
   add constraint FK6FC9673E11C78A3D foreign key (FK_ORGTYPE)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_ORGANIZATION
   add constraint FK6FC9673EA84F3A14 foreign key (PARENT_ID)
      references T_ORGANIZATION (ORG_ID)
      not deferrable;

alter table T_ORG_USER
   add constraint FKAC44D3F1109B2A54 foreign key (FK_ORG_ID)
      references T_ORGANIZATION (ORG_ID)
      not deferrable;

alter table T_ORG_USER
   add constraint FKAC44D3F133496E38 foreign key (FK_USER_ID)
      references T_USER (USER_ID)
      not deferrable;

alter table T_RESOURCE
   add constraint FK47D00399B9801C64 foreign key (RESOURCE_TYPE)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_RESOURCE
   add constraint FK47D00399CC7298F9 foreign key (PARENT_ID)
      references T_RESOURCE (RESOURCE_ID)
      not deferrable;

alter table T_ROLE
   add constraint FK94B8458186C37602 foreign key (FK_ROLE_TYPE)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_ROLE_MEMBER
   add constraint FKAF0E2A4D58DC4FB2 foreign key (USER_ID)
      references T_USER (USER_ID)
      not deferrable;

alter table T_ROLE_MEMBER
   add constraint FKAF0E2A4DB7F777FD foreign key (ROLE_ID)
      references T_ROLE (ROLE_ID)
      not deferrable;

alter table T_ROLE_MEMBER
   add constraint FKAF0E2A4DEFF3B282 foreign key (GROUP_ID)
      references T_GROUP (ID)
      not deferrable;

alter table T_ROLE_RESOURCE
   add constraint FK3E7E410C9AA17315 foreign key (RESOURCE_ID)
      references T_RESOURCE (RESOURCE_ID)
      not deferrable;

alter table T_ROLE_RESOURCE
   add constraint FK3E7E410CB7F777FD foreign key (ROLE_ID)
      references T_ROLE (ROLE_ID)
      not deferrable;

alter table T_DATA_SCOPE
   add constraint FKF65C251058DC4FB2 foreign key (USER_ID)
      references T_USER (USER_ID)
      not deferrable;

alter table T_DATA_SCOPE
   add constraint FKF65C251089298BF8 foreign key (ROLE_MEMBER_ID)
      references T_ROLE_MEMBER (ID)
      not deferrable;

alter table T_DATA_SCOPE
   add constraint FKF65C2510EFF3B282 foreign key (GROUP_ID)
      references T_GROUP (ID)
      not deferrable;

alter table T_DATA_SCOPE
   add constraint FKF65C2510F0C9319A foreign key (ORG_ID)
      references T_ORGANIZATION (ORG_ID)
      not deferrable;

alter table T_TEMP_TEAM_MENBER
   add constraint FK_TEMP_USER_TEMP_TEM foreign key (TEMP_TEAM_ID)
      references T_TEMP_TEAM (ID)
      on delete cascade
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D64EDAFAE7 foreign key (FK_JOB1)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D64EDAFAE8 foreign key (FK_JOB2)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D64EDDB773 foreign key (FK_POST)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D64EDF6130 foreign key (FK_TEAM)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D64EDFAE0D foreign key (FK_TYPE)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D692BFBFBA foreign key (FK_JOBLEVEL)
      references T_DICTIONARY (PK_ID)
      not deferrable;

alter table T_USER
   add constraint FK94B9B0D6EB41C257 foreign key (FK_POSTTITLE)
      references T_DICTIONARY (PK_ID)
      not deferrable;