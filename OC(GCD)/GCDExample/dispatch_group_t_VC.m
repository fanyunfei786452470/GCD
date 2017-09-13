//
//  dispatch_group_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_group_t_VC.h"

@interface dispatch_group_t_VC ()

@end

@implementation dispatch_group_t_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self Create_group_t];
}

/* 多组网络并发请求 */
- (void)Create_group_t
{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("group.com", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    /* 模拟请求1 */
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        dispatch_group_leave(group);

        NSLog(@"请求1完成");
    });
    
    /* 模拟请求2 */
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:3];
        dispatch_group_leave(group);
        NSLog(@"请求2完成");
    });
    
    /* 模拟请求3 */
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        [NSThread sleepForTimeInterval:5];
        dispatch_group_leave(group);
        NSLog(@"请求3完成");
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务完成，刷新");
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
