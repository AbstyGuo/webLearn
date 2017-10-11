//
//  ViewController.m
//  web9ZLMap
//
//  Created by zhulei on 15/12/17.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    
    //地图要设置成全局变量
    
    MAMapView *_mapView;
    
    //生成一个全局地图搜索器
    
    AMapSearchAPI *_API;

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _API = [[AMapSearchAPI alloc]initWithSearchKey:@"f8f64658085e763a11eae045dcc81bac" Delegate:self];
    
    
    //编码搜索
    [self GeCode];
    
    [self creatMapView];
    
    [self creatAnnotation];
}

-(void)GeCode{
    
    //先创建一个编码请求
    
    AMapGeocodeSearchRequest *request = [[AMapGeocodeSearchRequest alloc]init];
    
    //设置请求的属性
    request.address = @"北京大学主校区";//具体地址
    
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

-(void)creatMapView{
    
    //初始化地图
    _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
   
    //设置地图属性
    
    //地图层级
    
    _mapView.zoomLevel = 17;
    
    //设置地图刚出来的时候的中心点经纬度
   
    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(40.116000, 116.251700)];
    
    //去掉比例尺和指北针
    
    _mapView.showsCompass = NO;
    
    _mapView.showsScale = NO;
    
    //是否显示用户位置
    _mapView.showsUserLocation = YES;
    
    //要想显示用户位置,就得实现代理方法
    _mapView.delegate = self;
    
    //把地图加到视图上
    [self.view addSubview:_mapView];
}
-(void)creatAnnotation{
   //创建大头针 相当于model
    //假如请求下来一组地理坐标
//    NSArray *locationArray = [NSArray array];
//    
//    for (int i = 0; i<locationArray.count; i++) {
//        
//        
//    }
    MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
    
    //设置大头针的属性
    
    point.title = @"北京千锋互联科技";
    
    point.subtitle = @"沙河分校区";
    
    //设置一下大头针的经纬度<在实际工作当中,这个经纬度是从服务器获取到的>
    
    [point setCoordinate:CLLocationCoordinate2DMake(40.116000, 116.251000)];
    
    
    //把大头针加到地图上
    
    [_mapView addAnnotation:point];
    
}
//参照tableviewcell复用去写
-(MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    MAPinAnnotationView *view = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    
    if (!view) {
        
        view = [[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ID"];
        
    }
    
    //设置是否弹出大头针的气泡<气泡里显示的大头针的title和subtitle>
    view.canShowCallout = YES;
    
    //设置大头针加到地图上的动画效果是从天而降
    view.animatesDrop = YES;
    return view;
    
    
}
//大头针点击代理方法
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    
   //点击哪个大头, 就把该大头针移向地图中心
    //首先获取到点击的大头针的经纬度
    
   //view.annotation.coordinate
    
    //然后把这个获取到的经纬度 赋给地图的中心点
    
    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
}
//大头针反选代理方法
-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    
    
}
//前提是使用真机测试,获取到当前用户的地理位置,要想把用户显示到地图上,需要把地理位置 赋给 大头针,并把大头针扎到地图上
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    
    if (updatingLocation) {
        
        NSLog(@"Latitude=%f Longitude=%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
