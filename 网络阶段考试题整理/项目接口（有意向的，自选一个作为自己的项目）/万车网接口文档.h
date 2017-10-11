//
//  CONST.h
//  WebCars
//
//  Created by apple on 14-6-05.
//  Copyright (c) 2014年 Allenliu. All rights reserved.
//

#ifndef WebCars_CONST_h
#define WebCars_CONST_h

// 资讯模块接口
// 最新0 新车2 评测10 导购5 经销商资讯6
#define CONSULT_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetNews&currentPage=%d&typeid=%d"

// (资讯细节)
#define CONSULT_DETAIL_URL @"http://app.webcars.com.cn/News.aspx?newsid=%@&page=%d"

//车型模块的接口
//获取所有品牌的车列表
#define CARTYPE_ALL_BRAND_URL @"http://app.webcars.com.cn/default.aspx?MsgID=getAllBrandList"
//某一个品牌所有商家的报价
#define CARTYPE_BRAND_PRICE_URL @"http://app.webcars.com.cn/default.aspx?MsgID=getAllSeriesListbyCityName&brandid=%@&cityName=Province_00"

//按类型 微型车
#define CARTYPE_TYPE_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetSeriesList&vType=%@&cityName=Province_00&sortType=1"

//按价格
#define CARTYPE_PRICE_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetSeriesByPrice&MinPrice=%@&MaxPrice=%@&cityName=Province_00&sortType=1"

//某一个品牌车某一个型号系列车  顶部显示的信息
#define CARTYPE_SERIESINFO_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetSeriesDetailInfo&seriesId=%@&cityName=Province_00"

//系列信息里的车型信息
#define CARTYPE_CARTYPE_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetCarList&seriesId=%@&cityName=Province_00"

//车照片的地址  外观 空间  内饰
#define CARTYPE_CARPICTURE_URL @"http://tuanadmin.webcars.com.cn/Default.aspx?MsgID=getphotolist&seriesId=%@&phototype=%d&ispage=true&pagesize=%d&pagenumber=%d"

//汽车图片前部分url
#define CARTYPE_BEFORCAR_URL @"http://files.webcars.com.cn"

//促销优惠
#define CARTYPE_DISCOUNT_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetSeriesSaleInfomation&seriesId=%@&cityName=Province_00&currentPage=%d&pageSize=%d"

//促销优惠详情
#define CARTYPE_DISCOUNT_DETAILINFO_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetSeriesDetailInfo&seriesId=%@&cityName=Province_00"

//汽车型号参数
#define CARTYPE_PARAMETER_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetParameter&CarId=%@"

//汽车详细型号参数的信息
#define CARTYPE_DETAIL_PARAMETER_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=CarParametersStr&CarId=%@"

//某一系列车的经销商
#define CARTYPE_AGENCY_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetDealerListByCars&CarId=%@&cityName=%@&sortType=1&currentPage=%d&pageSize=%d"

//经销商的接口   sortType 1.推荐  2.价格
#define AGENCY_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetDealerList&seriesId=%@&cityName=%@&sortType=%d&currentPage=%d&pageSize=%d"

//团购的接口
// 团购汽车品牌
#define CARBRAND_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=tuanMakeList&area=%@&type=0"

// 团购车型
#define SERIES_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetSeriesAllList&area=%@&type=0"

// 查询团购
#define GBDETAIL_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=tuanInfo&area=%@&seriesId=%@"

#endif
