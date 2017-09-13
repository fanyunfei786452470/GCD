//
//  dispatch_block_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/12.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_block_t_VC.h"

@interface dispatch_block_t_VC ()

@end

@implementation dispatch_block_t_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self Create_block_t];
}

- (void)Create_block_t
{
    dispatch_queue_t queue = dispatch_queue_create("blcok.com", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        dispatch_queue_t taskQueue = dispatch_queue_create("taskQueue.com", DISPATCH_QUEUE_CONCURRENT);
        dispatch_block_t block = dispatch_block_create(0, ^{
            NSLog(@"开始执行");
            for (int i = 0 ; i < 10000 ; i++) {
                NSLog(@"任务执行中%d",i);
                
            }
            NSLog(@"结束执行");
        });
        dispatch_async(taskQueue, block);
        
        /* 等待时长，10s之后超时 */
        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, (int64_t) (10 * NSEC_PER_SEC));
        
        long resutl = dispatch_block_wait(block, timeout);
        
        if (resutl == 0)
        {
            NSLog(@"执行成功");
        }
        else
        {
            NSLog(@"执行超时");
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
