--�ֵ��
--�Ƚ�Լ�����ã��������������
ALTER TABLE T_DICTIONARY disable constraint FK_DICT_PARENT_ID; 
ALTER TABLE T_ORGANIZATION disable constraint FK_ORG_PARENT_ID; 
ALTER TABLE T_ORG_USER disable constraint FK_OUSER_ORG_ID;
ALTER TABLE T_ORG_USER disable constraint FK_OUSER_USER_ID;
ALTER TABLE T_RESOURCE disable constraint FK_PARENT_ID;
ALTER TABLE T_ROLE_MEMBER disable constraint FK_RMEMBER_GROUP_ID;
ALTER TABLE T_ROLE_MEMBER disable constraint FK_RMEMBER_ROLE_ID;
ALTER TABLE T_ROLE_MEMBER disable constraint FK_RMEMBER_USER_ID;
ALTER TABLE T_ROLE_RESOURCE disable constraint FK_RRESOURCE_RESOURCE_ID;
ALTER TABLE T_ROLE_RESOURCE disable constraint FK_RRESOURCE_ROLE_ID;
--���û����ֶ�����
alter table T_USER modify username NVARCHAR2(64);
commit;


insert into SYS_ACTIVITI_CATEGORY (PK_ACTIVITI_CATEGORY_ID, CATEGORY_CODE, DESCRIPTION, ISDELETE, LEAF, NAME, PARENTID, SORT)values (1, 'Code', '����', 0, 0, '����', 0, 0);

truncate table T_DICTIONARY;
commit;
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EH7C8B49EE84021810B99F201E1BE4F', null, null, 'ZHIWEIYI', 'ְλһ', '21', 0, 114, null, null, '78023B33E8C2405F8DF36CA92660698B');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('97F202FF99354128B378C3C2E8FEA670', null, null, 'BUTTON', '��ť', '3', 0, 102, null, null, 'F7322EF9961E4015B108B111079D504B');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('F2D988D46CF84E21AD9A02F2C689DA55', null, null, 'PAGE', '�˵�', '2', 0, 101, null, null, 'F7322EF9961E4015B108B111079D504B');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA7C8B49EE84021810B99F201E1BE4F', null, null, 'ZYUSER', '�����û�', '1', 0, 112, null, null, 'F1AA077197E14D91A7C3D6A9E1B00191');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA6C8B49EE84021810B99F201E1BE4F', null, null, 'LOCALUSER', '�����û�', '0', 0, 113, null, null, 'F1AA077197E14D91A7C3D6A9E1B00191');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA5C8B49EE84021810B99F201E1BE4F', null, null, 'ORGTYPE', '��֯����', '7', 1, 1, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA4C8B49EE84021810B99F201E1BE4F', null, null, 'ROLETYPE', '��ɫ����', '6', 0, 2, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA3C8B49EE84021810B99F201E1BE4F', null, null, 'JOBLEVEL', 'ְ��', '5', 0, 3, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA2C8B49EE84021810B99F201E1BE4F', null, null, 'POSTTITLE', 'ְ��', '4', 0, 4, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('8EA1C8B49EE84021810B99F201E1BE4F', null, null, 'JOB', 'ְ��', '3', 0, 5, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('78023B33E8C2405F8DF36CA92660698B', null, null, 'POST', 'ְλ', '2', 0, 6, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('F1AA077197E14D91A7C3D6A9E1B00191', null, null, 'USERTYPE', '�û�����', '1', 0, 7, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('1EA7C8B49EE84021810B99F201E1BE4F', null, null, 'ZHICHENYI', 'ְ��һ', '41', 0, 111, null, null, '8EA2C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('2EA7C8B49EE84021810B99F201E1BE4F', null, null, 'ZHIJIER', 'ְ����', '52', 0, 110, null, null, '8EA3C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('3EA7C8B49EE84021810B99F201E1BE4F', null, null, 'LOGTYPE', '��־����', '1', 0, 8, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EA7C8B49EE84021810B99F201E1BE4F', null, null, 'SYS_LOG', 'ϵͳ��־', '2', 0, 108, null, null, '3EA7C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EB7C8B49EE84021810B99F201E1BE4F', null, null, 'ERR_LOG', '������־', '3', 0, 109, null, null, '3EA7C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EC7C8B49EE84021810B99F201E1BE4F', null, null, 'PROCESS_ROLE', '���̽�ɫ', '61', 0, 107, null, null, '8EA4C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4ED7C8B49EE84021810B99F201E1BE4F', null, null, 'SYS_CODE', 'ϵͳ��ɫ', '62', 0, 106, null, null, '8EA4C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EE7C8B49EE84021810B99F201E1BE4F', null, null, 'COMPANY', '��˾', '71', 0, 103, null, null, '8EA5C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EF7C8B49EE84021810B99F201E1BE4F', null, null, 'ORG', '����', '72', 0, 104, null, null, '8EA5C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('4EG7C8B49EE84021810B99F201E1BE4F', null, null, 'EQUIPMENT', 'װ��', '72', 0, 105, null, null, '8EA5C8B49EE84021810B99F201E1BE4F');
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('F7322EF9961E4015B108B111079D504B', null, null, 'RESOURCETYPE', '��Դ����', '1', 0, 0, null, null, null);
insert into T_DICTIONARY (id, create_date, create_user, dict_code, dictionary_name, dictionary_value, is_deleted, level_order, modify_date, modify_user, fk_parent_id)values ('297e0224528713a6015287376bbf0001', sysdate, '����Ա', 'ZW1', 'ְ��1', 'ZW1', 0, 133, sysdate, null, '8EA1C8B49EE84021810B99F201E1BE4F');
commit;

--��֯��
delete   T_ORGANIZATION;

commit;
insert into T_ORGANIZATION (id, create_date, create_user, dis_order, is_deleted, modify_date, modify_user, org_code, org_from, org_name, orgtype_dict_code, fk_parent_id)values ('85B47CE6D6B94DF08C50F3F78F7D7CA7', null, null, 0, 0, null, null, 'DQGB', 0, '�������', '0', null);

commit;
--�û���
delete T_LOG;
delete T_USER;
commit;
insert into T_USER (id, birthday, birth_place, card_code, create_date, create_user, dis_order, electronic_signature, email, erp_id, gender, id_card, is_deleted, is_disabled, job_dict_code, joblevel_dict_code, mobile_phone1, mobile_phone2, modify_date, modify_user, password, personal_image, phone_no, post_dict_code, posttitle_dict_code, realname, short_no1, short_no2, team_dict_code, type, user_online, username)values ('26C66729A0B245C38875F0B62028E55C', null, null, null, null, null, null, null, null, '1', '��', '1', 0, 0, null, null, null, null, null, null, 'e10adc3949ba59abbe56e057f20f883e', null, null, null, null, '����Ա', null, null, null, 0, 0, 'jg_admin');
commit;


--�û���֯��ϵ��
delete T_ORG_USER;
commit;
insert into T_ORG_USER (id, create_date, create_user, is_deleted, modify_date, modify_user, fk_org_id, fk_user_id)values ('3D7D7866F9AD4F52BFAEB47CAB993F8E', null, null, 0, null, null, '85B47CE6D6B94DF08C50F3F78F7D7CA7', '26C66729A0B245C38875F0B62028E55C');
commit;


--��Դ��
delete T_RESOURCE;
commit;

insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286b8c0ad0005', 'PERSONAL_MENU', sysdate, null, 100, 'bpm/toPersonManage.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��������', 'PAGE', null);
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b0ada210004', 'BPM_PERSONTASK_MENU', sysdate, '����Ա', 110, 'bpm/toPersonTaskManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, '��������', 'PAGE', '297e02245286a7f3015286b8c0ad0005');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b0bd8da0006', 'BPM_DONETASK_MENU', sysdate, '����Ա', 120, 'bpm/toPersonDoneTaskManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, '�Ѱ�����', 'PAGE', '297e02245286a7f3015286b8c0ad0005');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b0cdfcf0008', 'BPM_PERSONAPPLY_MENU', sysdate, '����Ա', 130, 'bpm/toPersonApplyManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, '�ѷ�����', 'PAGE', '297e02245286a7f3015286b8c0ad0005');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286b696770001', 'SYSTEM_MENU', sysdate, null, 200, 'SYSTEM_MENU', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, 'ϵͳ����', 'PAGE', null);
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286bc7f960016', 'USER_MENU', sysdate, null, 210, 'user/toUserIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '�û�����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca0152875b4ee1000d', 'USER_VIEW', sysdate, null, 211, 'USER_VIEW', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '�û�����鿴', 'BUTTON', '297e02245286a7f3015286bc7f960016');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca0152875bc35d000f', 'USER_MANAGE', sysdate, null, 213, 'USER_MANAGE', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '�û�����ά��', 'BUTTON', '297e02245286a7f3015286bc7f960016');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286be5266001f', 'ORG_MENU', sysdate, null, 220, 'org/toOrgIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��֯����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca01528758d40d0009', 'ORG_VIEW', sysdate, null, 221, 'ORG_VIEW', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��֯����鿴', 'BUTTON', '297e02245286a7f3015286be5266001f');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca01528759b907000b', 'ORG_MANAGE', sysdate, null, 223, 'ORG_MANAGE', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��֯����ά��', 'BUTTON', '297e02245286a7f3015286be5266001f');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286bd8f35001a', 'ROLE_MENU', sysdate, null, 230, 'role/toRoleIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��ɫ����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca01528751de7e0005', 'ROLE_VIEW', sysdate, null, 231, 'ROLE_VIEW', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��ɫ����鿴', 'BUTTON', '297e02245286a7f3015286bd8f35001a');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca01528752516b0007', 'ROLE_MANAGE', sysdate, null, 233, 'ROLE_MANAGE', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��ɫ����ά��', 'BUTTON', '297e02245286a7f3015286bd8f35001a');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528c41c2c00077', 'ROLEMEMBER_MENU', sysdate, null, 240, 'role/toRoleMember.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��ɫ��Ȩ', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528c42c1b90079', 'ROLEMEMBER_VIEW', sysdate, '����Ա', 241, 'ROLEMEMBER_VIEW', 'frame_Content', null, 0, sysdate, null, null, 0, '��ɫ��Ȩ�鿴', 'BUTTON', '297e0224528adfb201528c41c2c00077');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528c435efe007b', 'ROLEMEMBER_MANAGE', sysdate, '����Ա', 243, 'ROLEMEMBER_MANAGE', 'frame_Content', null, 0, sysdate, null, null, 0, '��ɫ��Ȩά��', 'BUTTON', '297e0224528adfb201528c41c2c00077');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224529a5ffa01529aba0bf1002e', 'GROUP_MENU', sysdate, null, 250, 'group/toGroupManagementIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, 'Ⱥ�����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224529a5ffa01529abc1f700030', 'GROUP_VIEW', sysdate, '����Ա', 251, 'GROUP_VIEW', null, null, 0, sysdate, null, null, 0, 'Ⱥ�����鿴', 'BUTTON', '297e0224529a5ffa01529aba0bf1002e');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224529a5ffa01529abcc8440032', 'GROUP_MANAGE', sysdate, '����Ա', 253, 'GROUP_MANAGE', null, null, 0, sysdate, null, null, 0, 'Ⱥ�����ά��', 'BUTTON', '297e0224529a5ffa01529aba0bf1002e');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286c04cfc0027', 'DIC_MENU', sysdate, null, 260, 'dict/toDictIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '�ֵ����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca0152875c72040011', 'DIC_VIEW', sysdate, null, 261, 'DIC_VIEW', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '�ֵ����鿴', 'BUTTON', '297e02245286a7f3015286c04cfc0027');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca0152875daa2a0013', 'DIC_MANAGE', sysdate, null, 263, 'DIC_MANAGE', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '�ֵ����ά��', 'BUTTON', '297e02245286a7f3015286c04cfc0027');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286bd0abb0018', 'RESOURCE_MENU', sysdate, null, 270, 'resource/toResourceIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��Դ����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca0152874fe3d10001', 'RESOURCE_VIEW', sysdate, null, 271, 'RESOURCE_VIEW', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��Դ����鿴', 'BUTTON', '297e02245286a7f3015286bd0abb0018');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca01528750a1b40003', 'RESOURCE_MANAGE', sysdate, null, 273, 'RESOURCE_MANAGE', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��Դ����ά��', 'BUTTON', '297e02245286a7f3015286bd0abb0018');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286c0c0920029', 'LOG_MENU', sysdate, null, 280, 'log/toLogIndex.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��־����', 'PAGE', '297e02245286a7f3015286b696770001');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e022452874dca0152875f2e7c0015', 'LOG_VIEW', sysdate, null, 281, 'LOG_VIEW', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '��־����鿴', 'BUTTON', '297e02245286a7f3015286c0c0920029');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286b7e3350003', 'PROCESS_MENU', sysdate, null, 300, 'bpm/toProcessManage.action', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, '���̹���', 'PAGE', null);
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b17e9d5000c', 'BPM_PROCESSLISTENER_MENU', sysdate, '����Ա', 310, 'bpm/toProcessListenerManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, '���̼��', 'PAGE', '297e02245286a7f3015286b7e3350003');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b16e960000a', 'BPM_PROCESSTEMPLATE_MENU', sysdate, '����Ա', 320, 'bpm/toProcessTemplateManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, '����ģ�����', 'PAGE', '297e02245286a7f3015286b7e3350003');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b2840ff0012', 'BPM_PROCESSFORM_MENU', sysdate, '����Ա', 330, 'bpm/toProcessFormManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, '����ַ����', 'PAGE', '297e02245286a7f3015286b7e3350003');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e0224528adfb201528b26e4e90010', 'BPM_PROCESSCATEGORY_MENU', sysdate, '����Ա', 340, 'bpm/toProcessCategoryManage.do', 'frame_Content', null, 0, sysdate, null, null, 0, 'ģ��������', 'PAGE', '297e02245286a7f3015286b7e3350003');
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('297e02245286a7f3015286b9793b0007', 'MYSITE_MENU', sysdate, null, 400, 'site/index.html', 'frame_Content', null, 0, sysdate, '����Ա', null, 0, 'վ����Ϣ', 'PAGE', null);
insert into T_RESOURCE (ID, CODE, CREATE_DATE, CREATE_USER, DIS_ORDER, HREF, HREF_TARGET, ICON_URL, IS_DELETED, MODIFY_DATE, MODIFY_USER, REMARKS, RESOURCE_FROM, RESOURCE_NAME, RESOURCETYPE_DICT_CODE, FK_PARENT_ID)values ('8af2c99e528c03bb01528c07259d0007', 'ZY_TYKJ', sysdate, null, 500, 'examples/index.jsp', null, null, 0, sysdate, '����Ա', 'ͨ�ÿؼ�', 0, 'ͨ�ÿؼ�', 'PAGE', null);
commit;



--��ɫ��
delete T_ROLE;
commit;
insert into T_ROLE (id, create_date, create_user, description, is_deleted, modify_date, modify_user, role_code, role_name, roletype_dict_code)values ('41F945F56C6F47EF92DFB8CC382E2D85', sysdate, null, null, 0, null, null, 'admin', '����Ա', 'SYS_CODE');
commit;


--��ɫ��Ա��
delete  T_ROLE_MEMBER;
commit;
insert into T_ROLE_MEMBER (id, create_date, create_user, modify_date, modify_user, fk_group_id, fk_role_id, fk_user_id)values ('51D8FDC95F7D4E4E92E1553044BC6CA7', sysdate, null, null, null, null, '41F945F56C6F47EF92DFB8CC382E2D85', '26C66729A0B245C38875F0B62028E55C');
commit;
--��ɫ��Դ��

delete T_ROLE_RESOURCE;
commit;
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('8af2c99e52a133fc0152a135948a0001', sysdate, '����Ա', sysdate, null, '8af2c99e528c03bb01528c07259d0007', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('8af2c99e52a133fc0152a135a66e0005', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286b696770001', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286babcdd000c', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286b7e3350003', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286babf64000f', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286b8c0ad0005', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286bac1480012', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286b9793b0007', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286c24308002e', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286bc7f960016', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286c247050032', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286bd0abb0018', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286c24ad60036', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286bd8f35001a', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286c24db6003a', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286be5266001f', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286c25035003e', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286c04cfc0027', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e02245286a7f3015286c252e90042', sysdate, '����Ա', sysdate, null, '297e02245286a7f3015286c0c0920029', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b62316e0021', sysdate, '����Ա', sysdate, null, '297e022452874dca0152875b4ee1000d', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b6234840026', sysdate, '����Ա', sysdate, null, '297e022452874dca0152875bc35d000f', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b623d41002b', sysdate, '����Ա', sysdate, null, '297e022452874dca0152874fe3d10001', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b623f860030', sysdate, '����Ա', sysdate, null, '297e022452874dca01528750a1b40003', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b624f0d0035', sysdate, '����Ա', sysdate, null, '297e022452874dca01528751de7e0005', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b62523e003a', sysdate, '����Ա', sysdate, null, '297e022452874dca01528752516b0007', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b625ac5003f', sysdate, '����Ա', sysdate, null, '297e022452874dca01528758d40d0009', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b625d0e0044', sysdate, '����Ա', sysdate, null, '297e022452874dca01528759b907000b', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b6263c40049', sysdate, '����Ա', sysdate, null, '297e022452874dca0152875c72040011', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b626671004e', sysdate, '����Ա', sysdate, null, '297e022452874dca0152875daa2a0013', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b626e4f0053', sysdate, '����Ա', sysdate, null, '297e022452874dca0152875f2e7c0015', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b627e87005a', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b26e4e90010', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b627e88005b', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b2840ff0012', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b628542005e', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b16e960000a', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b6288020062', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b17e9d5000c', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b6345f40066', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b0ada210004', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b6347fc006a', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b0bd8da0006', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528b634a67006e', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528b0cdfcf0008', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528c43c472007d', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528c41c2c00077', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528c43c475007f', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528c435efe007b', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('297e0224528adfb201528c43c4770080', sysdate, '����Ա', sysdate, null, '297e0224528adfb201528c42c1b90079', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('8af2c99e52a133fc0152a13a8bfd000b', sysdate, '����Ա', sysdate, null, '297e0224529a5ffa01529abc1f700030', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('8af2c99e52a133fc0152a13a8bfe000c', sysdate, '����Ա', sysdate, null, '297e0224529a5ffa01529aba0bf1002e', '41F945F56C6F47EF92DFB8CC382E2D85');
insert into t_role_resource (ID, CREATE_DATE, CREATE_USER, MODIFY_DATE, MODIFY_USER, FK_RESOURCE_ID, FK_ROLE_ID)values ('8af2c99e52a133fc0152a13c1f550010', sysdate, '����Ա', sysdate, null, '297e0224529a5ffa01529abcc8440032', '41F945F56C6F47EF92DFB8CC382E2D85');

commit;

ALTER TABLE T_DICTIONARY enable constraint FK_DICT_PARENT_ID; 
ALTER TABLE T_ORGANIZATION enable constraint FK_ORG_PARENT_ID; 
ALTER TABLE T_ORG_USER enable constraint FK_OUSER_ORG_ID;
ALTER TABLE T_ORG_USER enable constraint FK_OUSER_USER_ID;
ALTER TABLE T_RESOURCE enable constraint FK_PARENT_ID;
ALTER TABLE T_ROLE_MEMBER enable constraint FK_RMEMBER_GROUP_ID;
ALTER TABLE T_ROLE_MEMBER enable constraint FK_RMEMBER_ROLE_ID;
ALTER TABLE T_ROLE_MEMBER enable constraint FK_RMEMBER_USER_ID;
ALTER TABLE T_ROLE_RESOURCE enable constraint FK_RRESOURCE_RESOURCE_ID;
ALTER TABLE T_ROLE_RESOURCE enable constraint FK_RRESOURCE_ROLE_ID;
commit;