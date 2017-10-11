//
//  Header.h
//  FreeDemo
//
//  Created by DuHaiFeng on 14-1-17.
//  Copyright (c) 2014年 dhf. All rights reserved.
//

#ifndef FreeDemo_Header_h
#define FreeDemo_Header_h

//限免
#define LIMIT_URL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d"
#define LIMIT_TYPE 100
//降价
#define SALES_URL @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%d"


#define SALES_TYPE 101
//免费
#define FREE_URL @"http://iappfree.candou.com:8080/free/applications/free?currency=rmb&page=%d"
#define FREE_TYPE 102



//热榜接口无法用
#define HOSTLIST_URL @"http://open.candou.com/mobile/hot/page/%d"
#define HOSTLIST_TYPE 103


//详情
#define APP_DETAIL_TYPE 2
#define DETAIL_URL @"http://iappfree.candou.com:8080/free/applications/%@?currency=rmb"



//周边
#define RECOMMEND_TYPE 3
#define RECOMMEND_URL @"http://iappfree.candou.com:8080/free/applications/recommend?longitude=%f&latitude=%f"

#define DOWNLOAD_IMAGE 4




//专题接口坏掉
#define SUBJECT_TYPE 5
#define SUBJECT_URL @"http://iappfree.candou.com:8080/free/special?page=%d&limit=5"




//搜索
#define SEARCH_TYPE 6
#define SEARCH_URL @"http://open.candou.com/search/app/word/%@/app/iphone/rank/0/start/1/limit/40"

#define TABLEVIEW_COLOR [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]

#define SORTLIST_TYPE 7
#define SORTLIST_URL @"http://open.candou.com/app/count"






//分类
#define SORTLIST_ID_TYPE 8
#define SORTLIST_LIMITED_URL @"http://iappfree.candou.com:8080/free/categories/limited"



#define SORTLIST_SALES_URL @"http://iappfree.candou.com:8080/free/categories/sales"



#define SORTLIST_FREE_URL @"http://iappfree.candou.com:8080/free/categories/free"



//分类的内容
//限免全部
#define LIST_LIMITED_ALL_URL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d&timestamp=20130810035056&sign=XXXXXXXXXXXXXXXX"
//限免分类
#define LIST_LIMITED_URL @"http://iappfree.candou.com:8080/free/applications/limited?currency=rmb&page=%d&category_id=#&timestamp=20130810035308&sign=XXXXXXXXXXXXXXXX"

//降价全部
#define LIST_SALES_ALL_URL @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%d&timestamp=20130810040657&sign=XXXXXXXXXXXXXXXX"
//降价分类
#define LIST_SALES_URL @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%d&category_id=#&timestamp=20130810040821&sign=XXXXXXXXXXXXXXXX"

//免费全部
#define LIST_FREE_ALL_URL @"http://iappfree.candou.com:8080/free/applications/free?currency=rmb&page=%d&timestamp=20130810041333&sign=XXXXXXXXXXXXXXXX"
//免费分类
#define LIST_FREE_URL @"http://iappfree.candou.com:8080/free/applications/sales?currency=rmb&page=%d&category_id=#&timestamp=20130810040821&sign=XXXXXXXXXXXXXXXX"

//热榜全部
#define LIST_HOST_ALL_URL @"http://open.candou.com/mobile/hot/page/%d&timestamp=20130810042504&sign=XXXXXXXXXXXXXXXX"
//热榜分类
#define LIST_HOST_URL @"http://open.candou.com/mobile/hot/page/%d&category_id=#&timestamp=20130810042629&sign=XXXXXXXXXXXXXXXX"

#define CANDOU_TYPE 9
#define CANDOU_URL @"http://open.candou.com/mobile/candou"



//所有tabbaritem项（视图控制器初始化时传的参数字典中的key）
//导航标题key
#define NAV_TITLE @"NAV_TITLE"
//tabbaritem项标题key
#define TABBAR_TITLE @"TABBAR_TITLE"
//tabbaritem项图片名key
#define TABBAR_IMAGE @"TABBAR_IMAGE"



#endif





