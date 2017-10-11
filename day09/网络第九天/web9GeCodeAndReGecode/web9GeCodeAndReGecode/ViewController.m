//
//  ViewController.m
//  web9GeCodeAndReGecode
//
//  Created by zhulei on 15/12/17.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    //生成一个全局地图搜索器
    
    AMapSearchAPI *_API;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
   /*
    地理编码 <通过输入地理名称,来确定地理位置>
    
    地理反编码<输入地理位置,来获取地理名称以及周边信息>
    */
    
    //让当前页面具有搜索的权限<注册权限使用的key和appdelegate里面使用的key是一样的>
    
    _API = [[AMapSearchAPI alloc]initWithSearchKey:@"b2746bfc0d78ad25fa592de1a9db0d55" Delegate:self];
    
    
    //编码搜索
    [self GeCode];
    
    [self REGeoCode];
    
}
-(void)GeCode{
    
  //先创建一个编码请求
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
    
    //设置请求的属性
    request.address = @"北京大学";//具体地址
    
    request.city = @[@"北京"];
    
    //设置请求的搜索类型
    
    request.searchType = AMapSearchType_Geocode;
    
    //搜索器执行搜索请求  搜索结果会在代理方法里体现出来
    [_API AMapGeocodeSearch:request];
    
}
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    //返回地理编码请求的结果 结果储存在response里
    
    if (response) {
        
        NSArray *geocodes = response.geocodes;
        
        for (AMapGeocode *code in geocodes) {
            
            NSLog(@"%@",code.description);
        }
    }
    
    
}
-(void)REGeoCode{
  
    //地理反编码
    AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc]init];
    
    //反编码请求的属性
    
    //给request一个地理经纬度
    
    
    AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:39.991360 longitude:116.306038];
    
    request.location =  point;
    
    request.searchType = AMapSearchType_ReGeocode;
    
    //请求的搜索半径范围
    request.radius = 100;
    
    [_API AMapReGoecodeSearch:request];

}

-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    
    //反编码请求的结果 在该方法里,返回的信息在response里面
    
    if (response) {
        
        NSLog(@"%@",response.regeocode.formattedAddress);
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
