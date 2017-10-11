//
//  CoreDataManager.m
//  web6_(CoreDataManager 02)
//
//  Created by zhulei on 15/12/14.
//  Copyright (c) 2015年 zhulei. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager{
    
    AppDelegate *_delegate;
}

+(instancetype)zhulei{
    
    static CoreDataManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CoreDataManager alloc]init];
    });
    
    return manager;
}
-(instancetype)init{
    
    if (self = [super init]) {
        
        _delegate = [UIApplication sharedApplication].delegate;
    }
    
    return self;
}
-(void)insertDataWithImageData:(NSData *)imageData Name:(NSString *)name PhoneNum:(NSString *)number{
    
    Student *student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_delegate.managedObjectContext];
    
    student.headImageData = imageData;
    
    student.name = name;
    
    student.phoneNum = number;
    
    [_delegate.managedObjectContext save:nil];
}

-(NSArray *)fetch{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:_delegate.managedObjectContext];
    
    [request setEntity:entity];
    
    NSArray *array = [_delegate.managedObjectContext executeFetchRequest:request error:nil];
    
    return array;
}
-(void)deleteModelWithModel:(Student *)student{
    
    [_delegate.managedObjectContext deleteObject:student];
    
    [_delegate.managedObjectContext save:nil];
}
-(void)update:(Student *)student{
   
    
    [_delegate.managedObjectContext save:nil];
}
@end
