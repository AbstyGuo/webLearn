//
//  QFPKNetInterface.h
//  PocketKitchen
//
//  Created by DancewithPeng on 15/3/9.
//  Copyright (c) 2015年 dancewithpeng@gmail.com. All rights reserved.
//


/**
 应用的网络接口
 */

#ifndef PocketKitchen_QFPKNetInterface_h
#define PocketKitchen_QFPKNetInterface_h


// 获取应用连接的IP
#define URL_HOSTIP @"http://client.izhangchu.com/get-videoIP.html"


/*
 菜谱首页数据
 
 user_id    用户ID，未登录写0
 
 
 固定参数：
 is_traditional=0
 page=1
 pageRecord=3
 phonetype=1
 */
#define URL_COOKBOOK @"/HandheldKitchen/api/home/tblHomepageVegetable!getHomeVegetableList.do?"


/*
 菜谱首页广告
 
 
 固定参数：
 is_traditional=0
 phonetype=1
 */
#define URL_COOKBOOK_AD @"/HandheldKitchen/api/home/tblHomepageVegetable!getSpecialList.do?"


/*
 广场
 
 page               第几页
 pageRecord         每页有几个记录
 
 
 固定参数：
 is_traditional=0
 */
#define URL_PLAZA @"/HandHeldKitchenCommunity/api/theme/themeProduct!getProductList.do?"


/*
 分类搜索
 
 name               搜索关键字
 child_catalog_name 中华菜系
 taste              口味分类
 fitting_crowd      人群分类
 cooking_method     烹饪分类
 effect             功效分类
 user_id            用户ID   没有登录可为空串
 
 
 固定参数：
 page               第几页
 pageRecord         每个有几个记录
 phonetype          手机类型
 is_traditional     繁简体
 */
#define URL_VEGETABLE_INFO @"/HandheldKitchen/api/vegetable/tblvegetable!getVegetableInfo.do?"


/*
 选择的菜谱的对应信息
 
 vegetable_id       菜谱ID
 type               1，所需原料。2.制作步骤。3.相宜。4.相关常识
 
 
 固定参数：
 phonetype=0
 is_traditional=0
 */
#define URL_VEGETABLE_DETAIL @"/HandheldKitchen/api/vegetable/tblvegetable!getIntelligentChoice.do?"


/*
 材料信息
 
 vegetable_id       菜谱ID
 user_id            用户ID
 
 
 固定参数：
 phonetype=2
 is_traditional=0
 */
#define URL_VEGETABLE_DETAIL_INFO @"/HandheldKitchen/api/vegetable/tblvegetable!getTblVegetables.do?"


/*
 评论
 
 vegetableId        // 菜谱ID
 
 
 固定参数：
 page=1
 is_traditional=0
 */
#define URL_VEGETABLE_COMMENTS @"/HandheldKitchen/api/vegetable/vegetableComment!getList.do?"


/*
 登录 POST
 
 loginName  用户ID
 password   密码的MD5的值
 
 
 固定参数：
 md5=3336
 is_traditional=0
 */
#define URL_Login @"http://admin.izhangchu.com:80/HandHeldKitchenCommunity/api/user/users!login.do"

/*
 第三方登录  POST
 
 tencenToken   腾讯Token
 userName      QQ昵称
 
 
 固定参数：
 is_traditional=0
 channel=App Store
 */
#define URL_QQLogin @"http://admin.izhangchu.com:80/HandHeldKitchenCommunity/api/user/users!singleLogin.do"


#endif
