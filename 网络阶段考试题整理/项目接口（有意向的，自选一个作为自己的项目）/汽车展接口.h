//
//  CONST.h
//  WebCars
//
//  Created by apple on 14-3-10.
//  Copyright (c) 2014年 apple. All rights reserved.
//
// 资讯模块接口
// 最新0 新车2 评测10 导购5 经销商资讯6
#define CONSULT_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetNews&currentPage=%d&typeid=%d"

// (资讯细节)
#define CONSULT_DETAIL_URL @"http://app.webcars.com.cn/News.aspx?newsid=%@&page=%d"


//车型模块的接口
//获取所有品牌的车列表 界面1
#define CARTYPE_ALL_BRAND_URL @"http://app.webcars.com.cn/default.aspx?MsgID=getAllBrandList"

BrandID  MainBrandName imgURL
//某一个品牌所有商家的报价 界面2
#define CARTYPE_BRAND_PRICE_URL @"http://app.webcars.com.cn/default.aspx?MsgID=getAllSeriesListbyCityName&brandid=%@&cityName=Province_00"

SeriesId SeriesName carcount dealerQuote imgURL

//系列信息里的车型信息 界面3
#define CARTYPE_CARTYPE_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetCarList&seriesId=%@&cityName=Province_00"

CarId TrimCategory TrimName YearModel dealerQuote

//汽车型号参数 界面3(2)
#define CARTYPE_PARAMETER_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetParameter&CarId=%@"

Grade MSRP SeriesName TrimCategory TrimName VType YearModel carcount imgURL
//汽车详细型号参数的信息 界面4
#define CARTYPE_DETAIL_PARAMETER_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=CarParametersStr&CarId=%@"

//论坛 http://hezuo.xcar.com.cn/iphone/json5/bbsGetPostsByForumId.php?limit=20&offset=0&type=7&ver=5.2.1

详情html http://wap.xcar.com.cn/bbs/bbs_iphone_5.php?tid=20512992&p=1&type=0&network=wifi&deviceType=iphone&themeType=white&version=5.2.1

//按类型 微型车
#define CARTYPE_TYPE_URL @"http://app.webcars.com.cn:8080/default.aspx?MsgID=GetSeriesList&vType=%@&cityName=Province_00&sortType=1"


//某一个品牌车某一个型号系列车  顶部显示的信息
#define CARTYPE_SERIESINFO_URL @"http://app.webcars.com.cn/default.aspx?MsgID=GetSeriesDetailInfo&seriesId=%@&cityName=Province_00"


//车照片的地址  外观 空间  内饰
#define CARTYPE_CARPICTURE_URL @"http://tuanadmin.webcars.com.cn/Default.aspx?MsgID=getphotolist&seriesId=%@&phototype=%d&ispage=true&pagesize=%d&pagenumber=%d"






