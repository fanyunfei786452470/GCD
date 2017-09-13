//
//  dispatch_queue_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_queue_t_VC.h"

@interface dispatch_queue_t_VC ()

@end

@implementation dispatch_queue_t_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.indexPath.row == 0)
    {
        [self Create_async_concurrent];
    }
    if (self.indexPath.row == 1)
    {
        [self Create_async_serial];
    }
    if (self.indexPath.row == 2)
    {
        [self Create_sync_concurrent];
    }
    if (self.indexPath.row == 3)
    {
        [self Create_sync_serial];
    }
    if (self.indexPath.row == 4)
    {
        [self Create_global];
    }
    if (self.indexPath.row == 5)
    {
        [self Create_main];
    }
    if (self.indexPath.row == 6)
    {
        [self Create_after];
    }
    if (self.indexPath.row == 7) {
        [self Create_apply];
    }
}
#pragma mark ------------------------------------ 异步+并行-------------------------------
- (void)Create_async_concurrent
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* 模拟请求1 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    /* 模拟请求3 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });
    
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });
}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 异步+串行-------------------------------
- (void)Create_async_serial
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue.com", DISPATCH_QUEUE_SERIAL);
    
    /* 模拟请求1 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    /* 模拟请求3 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });
    
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });
}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 同步+并行-------------------------------
- (void)Create_sync_concurrent
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* 模拟请求1 */
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    /* 模拟请求3 */
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });
}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 同步+串行-------------------------------
- (void)Create_sync_serial
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue.com", DISPATCH_QUEUE_SERIAL);
    
    /* 模拟请求1 */
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    /* 模拟请求3 */
    dispatch_sync(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });
}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 全局队列--------------------------------
- (void)Create_global
{
    /* 模拟请求1 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    /* 模拟请求3 */
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });

    
//    /* 模拟请求1 */
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"请求1完成");
//    });
//    /* 模拟请求2 */
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"请求2完成");
//    });
//    /* 模拟请求3 */
//    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [NSThread sleepForTimeInterval:6];
//        NSLog(@"请求3完成");
//    });
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"所有任务完成");
//    });
//
}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 主队列----------------------------------
- (void)Create_main
{
    /* 模拟请求1 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    /* 模拟请求3 */
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"所有任务完成");
    });

    
//    /* 模拟请求1 */
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [NSThread sleepForTimeInterval:2];
//        NSLog(@"请求1完成");
//    });
//    /* 模拟请求2 */
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [NSThread sleepForTimeInterval:3];
//        NSLog(@"请求2完成");
//    });
//    /* 模拟请求3 */
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        [NSThread sleepForTimeInterval:6];
//        NSLog(@"请求3完成");
//    });
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSLog(@"所有任务完成");
//    });

}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 延时提交 -------------------------------
- (void)Create_after
{
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* 模拟请求1 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"请求1完成");
    });
    /* 模拟请求2 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:3];
        NSLog(@"请求2完成");
    });
    
    dispatch_barrier_async(concurrentQueue, ^{
        NSLog(@"等待3秒");
        [NSThread sleepForTimeInterval:3];
    });
    /* 模拟请求3 */
    dispatch_async(concurrentQueue, ^{
        [NSThread sleepForTimeInterval:6];
        NSLog(@"请求3完成");
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (uint64_t)(5ull * NSEC_PER_SEC) ), concurrentQueue, ^{
        NSLog(@"继续执行");
    });
}
#pragma mark ------------------------------------- end-----------------------------------

#pragma mark ------------------------------------ 快速迭代 -------------------------------
- (void)Create_apply
{
    NSMutableArray * array = [[NSMutableArray alloc]init];
    for (int i = 0 ; i < 100 ; i++) {
        [array addObject:[NSNumber numberWithInt:i]];
    }
    dispatch_queue_t queue = dispatch_queue_create("com", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_apply([array count], queue, ^(size_t i) {
        NSLog(@"%@",[array objectAtIndex:i]);
    });
}
#pragma mark ------------------------------------- end-----------------------------------

@end
