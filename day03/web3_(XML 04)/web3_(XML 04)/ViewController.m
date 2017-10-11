//
//  ViewController.m
//  web3_(XML 04)
//
//  Created by MS on 15-12-9.
//  Copyright (c) 2015年 郭永峰. All rights reserved.
//

#import "ViewController.h"
#import "GDataXMLNode.h"

@interface ViewController ()
{
    //生成一个XML解析器
    GDataXMLDocument * _document;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     1.使用GData 要添加一个系统的依赖库  xibxml2
     2.要手动添加一条依赖库的路径，能够被X-Code找到这个依赖库 /usr/include/libxml2
     3.手动把非ARC 改成 ARC  -fno-objc-arc
     */
    //先把本地的XML数据文本路径找到
    NSString * path = [[NSBundle mainBundle]pathForResource:@"xml" ofType:@"txt"];
    NSData * data = [NSData dataWithContentsOfFile:path];
    
    //获取所有数据存入_document
    _document = [[GDataXMLDocument alloc]initWithData:data options:0 error:nil];
    //1、获取根节点
    GDataXMLElement * rootElement = [_document rootElement];
    //2、从根节点获取子节点，要用数组来接收<获取books节点>
    NSArray * booksElementArray = [rootElement elementsForName:@"books"];
    //3、从数组里面 获取到books节点
    GDataXMLElement * booksElement = booksElementArray[0];
    //4、获取booksElement节点下的子节点<获取book节点>
    NSArray * bookElementArray = [booksElement elementsForName:@"book"];
    //5、获取到bookElementArray下的每个book节点
    for (GDataXMLElement * bookElement in bookElementArray) {
        NSArray * summaryElementArray = [bookElement elementsForName:@"summary"];
        GDataXMLElement * summaryElement = summaryElementArray[0];
        NSLog(@"%@",[summaryElement stringValue]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
