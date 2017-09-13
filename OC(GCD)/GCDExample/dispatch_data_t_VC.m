//
//  dispatch_data_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_data_t_VC.h"

@interface dispatch_data_t_VC ()

@end

@implementation dispatch_data_t_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self Create_data_t];
}

- (void)Create_data_t
{
    dispatch_queue_t queue = dispatch_queue_create("data>com", DISPATCH_QUEUE_CONCURRENT);
    char buffer1[10] = "124567890";
    /* 转换成dispatch_data_t */
    dispatch_data_t data1 = dispatch_data_create(buffer1, sizeof(buffer1), queue, ^{
        
    });
    NSLog(@"data1:%@",data1);
    
    char buffer2[7] = "abcdefg";
    dispatch_data_t data2 = dispatch_data_create(buffer2, sizeof(buffer2), queue, ^{
        
    });
    NSLog(@"data2:%@",data2);
    
    /* 将两个dispatch_data_t 拼接 */
    dispatch_data_t data3 = dispatch_data_create_concat(data1, data2);
    NSLog(@"data3:%@",data3);
    
    /* 遍历置顶的dispatch_data_t */
    dispatch_data_apply(data3, ^bool(dispatch_data_t  _Nonnull region, size_t offset, const void * _Nonnull buffer, size_t size) {
        NSLog(@"\n region:%@ \n offset:%ld \n buffer:%s \n size:%ld",region,offset,buffer,size);
        return YES;
    });
    
    dispatch_data_t mapData = dispatch_data_create_map(data3, NULL, NULL);
    NSLog(@"mapData:%@",mapData);
    
    dispatch_data_t subData = dispatch_data_create_subrange(mapData, 2, 8);
    NSLog(@"subData:%@",subData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
