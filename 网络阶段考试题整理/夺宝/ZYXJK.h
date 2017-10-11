//
//  ZYXJK.h
/
//
//  Created by qianfeng on 15/6/27.
//  Copyright (c) 2015年 qianfeng. All rights reserved.
//

#define  myColor [UIColor colorWithRed:184/255. green:40/255. blue:65/255. alpha:1]

// 抢购
#define URL_QG @"http://api.1.9117zhuan.com/index"

// 奖品详情
//#define URL_JPXQ @"http://api.1.9117zhuan.com/product_detail?productid=%@"
#define URL_JPXQ @"&os=iPhone%208.1.2&time=1431487684&ver=1.7.0&platform=1&device=5DE6721E-C32E-4941-A76F-A22A7E20D69B&iphonename=B.T.%F0%9F%93%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8"

// 所有参与记录
#define URL_CYJL @"http://api.1.9117zhuan.com/product_bills?productid=%@&pageNo=%d"
#define URL_CYJL2 @"&os=iPhone%207.1.2&time=1435579100&ver=1.7.0&platform=1&device=FF8DC745-B529-44E9-A6D3-A0F2A122BAEA&iphonename=%E6%AA%80%E5%B0%8F%E5%BA%B7%20%E6%9D%8E%E5%B0%8F%E8%B4%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8"

//http://api.1.9117zhuan.com/product_bills?productid=559a40f71954313790bf564f&os=iPhone%207.1.2&time=1435579100&ver=1.7.0&platform=1&device=FF8DC745-B529-44E9-A6D3-A0F2A122BAEA&iphonename=%E6%AA%80%E5%B0%8F%E5%BA%B7%20%E6%9D%8E%E5%B0%8F%E8%B4%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8

// 往期揭晓
#define URL_WQJX @"http://api.1.9117zhuan.com/history_win_bills?productid=%@&pageNo=%d"
#define URL_WQJX2 @"&os=iPhone%207.1.2&time=1435626538&ver=1.7.0&platform=1&device=FF8DC745-B529-44E9-A6D3-A0F2A122BAEA&iphonename=%E6%AA%80%E5%B0%8F%E5%BA%B7%20%E6%9D%8E%E5%B0%8F%E8%B4%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8"

//http://api.1.9117zhuan.com/history_win_bills?productid=559a40f71954313790bf564f&os=iPhone%207.1.2&time=1435626538&ver=1.7.0&platform=1&device=FF8DC745-B529-44E9-A6D3-A0F2A122BAEA&iphonename=%E6%AA%80%E5%B0%8F%E5%BA%B7%20%E6%9D%8E%E5%B0%8F%E8%B4%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8

// 晒单
#define URL_SD @"http://api.1.9117zhuan.com/show_showbill?brand_id=%@&pageNo=%d"
#define URL_SD2 @"&os=iPhone%207.1.2&time=1435633649&ver=1.7.0&platform=1&device=FF8DC745-B529-44E9-A6D3-A0F2A122BAEA&iphonename=%E6%AA%80%E5%B0%8F%E5%BA%B7%20%E6%9D%8E%E5%B0%8F%E8%B4%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8"

//http://api.1.9117zhuan.com/show_showbill?brand_id=54a23ca2e13823308956da26&os=iPhone%207.1.2&time=1435633649&ver=1.7.0&platform=1&device=FF8DC745-B529-44E9-A6D3-A0F2A122BAEA&iphonename=%E6%AA%80%E5%B0%8F%E5%BA%B7%20%E6%9D%8E%E5%B0%8F%E8%B4%B1&is_jailbreak=0&isp=%E4%B8%AD%E5%9B%BD%E7%A7%BB%E5%8A%A8

// 计算结果
#define URL_JSJQ @"http://api.1.9117zhuan.com/show_compute_panel?productid=%@"

// 查看ta的号码
#define URL_HM @"http://api.1.9117zhuan.com/search_luck_nums?user_id=%@&productid=%@"

// 最新揭晓 详情
#define URL_ZXJX @"http://api.1.9117zhuan.com/product_newest_open?productid=%@"



// 全部商品
#define URL_SP @"http://api.1.9117zhuan.com/products?pageNo=%ld"


// 最新揭晓
#define URL_JX @"http://api.1.9117zhuan.com/new_publish?pageNo=%ld"




//判断屏幕尺寸
#define IPHONE4 ([UIScreen mainScreen].bounds.size.width==320 && [UIScreen mainScreen].bounds.size.height==480)

#define IPHONE5 ([UIScreen mainScreen].bounds.size.width==320 && [UIScreen mainScreen].bounds.size.height==568)

#define IPHONE6 ([UIScreen mainScreen].bounds.size.width==375 && [UIScreen mainScreen].bounds.size.height==667)

#define IPHONE6P ([UIScreen mainScreen].bounds.size.width==414 && [UIScreen mainScreen].bounds.size.height==736)
