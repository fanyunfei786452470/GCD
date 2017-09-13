//
//  dispatch_semaphore_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_semaphore_t_VC.h"

@interface dispatch_semaphore_t_VC ()

@end

@implementation dispatch_semaphore_t_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.indexPath.row == 0)
    {
        [self Create_semaphore_t0];
    }
    if (self.indexPath.row == 1)
    {
        [self Create_semaphore_t1];
    }
    if (self.indexPath.row == 2)
    {
        [self Create_semaphore_t2];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark --------------------------- 数组添加数据------------------------------------
- (void)Create_semaphore_t0
{
    dispatch_queue_t  queue  = dispatch_queue_create("semaphore0.com", DISPATCH_QUEUE_CONCURRENT);
    /* semaphore 的计数置为1 保证每次访问NSMutableArray 对象的线程只有1个 */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    NSMutableArray * array = [[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < 1000 ; i++) {
        dispatch_async(queue, ^{
            /**
             处于等待状态，知道dispatch semaphore 的计数值>=1，才开始向下执行
             */
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            
            /**
             由于dispatch_semaphore 计数值>=1
             通过上面方法，dispatch semaphore 的计数值减去1
             dispatch_semaphore_wait函数返回
             执行到此时，dispatch_semaphore的计数值 为0
             所以此时可访问NSMutableArray类对象的线程只有一个，因此可安全地进行更新
             */
            NSLog(@"添加数据：%d",i);
            [array addObject:[NSNumber numberWithInt:i]];
            
            /**
             执行到此处，排他控制处理已经结束
             执行dispatch_semaphore_signal函数，dispatch_semaphore 的计数值加1
             此时就会通知最先开始等待的线程：告诉这个线程开始执行任务了
             */
            dispatch_semaphore_signal(semaphore);
        });
    }
    
    /**
     通过打印结果来完全按顺序来依次添加数据，没有出现紊乱
     */
    dispatch_barrier_async(queue, ^{
        NSLog(@"array:%@",array);
    });
}

#pragma mark ------------------------------- end --------------------------------------

#pragma mark --------------------------- 汽车的例子 ------------------------------------
- (void)Create_semaphore_t1
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 5ull * NSEC_PER_SEC);
    
    NSLog(@"begin==> 车库开始营业了");
    
    /**
     如果semaphore 的计数值为0，就阻塞5秒才会网下执行
     如果semaphore 的计数值>=1,semaphore 进行减1处理
     */
    long result = dispatch_semaphore_wait(semaphore, time);
    if (result == 0)
    {
        /**
         *由子Dispatch Semaphore的计数值达到大于等于1
         *或者在待机中的指定时间内
         *Dispatch Semaphore的计数值达到大于等于1
         所以Dispatch Semaphore的计数值减去1
         可执行需要进行排他控制的处理.
         可以理解为：没有阻塞的线程了。
         就好比：车库有一个或一个以上的车位，只来了一辆车，所以“无需等待”
         */
        NSLog(@"result = 0 ==> 有车位，无需等待！==> 在这里可安全地执行【需要排他控制的处理（比如只允许一条线程为mutableArray进行addObj操作）】");
        dispatch_semaphore_signal(semaphore);
    }
    else
    {
        /*
         *
         *由于Dispatch Semaphore的计数值为0
         .因此在达到指定时间为止待机
         这个else里发生的事情，就好比：车库没车位，来了一辆车，等待了半个小时后，做出的一些事情。
         比如：忍受不了，走了。。
         *
         */
        NSLog(@"result != 0 ==> timeout，deadline，忍受不了，走了。。");
    }
}
#pragma mark ------------------------------- end --------------------------------------

#pragma mark --------------------------- 控制并发数 ------------------------------------
- (void)Create_semaphore_t2
{
    dispatch_queue_t queue = dispatch_queue_create("com.ioschengxuyuan.gcd.ForBarrier", DISPATCH_QUEUE_CONCURRENT);
    /*
     *
     *生成Dispatch Semaphore
     Dispatch Semaphore 的计数初始值设定为“1”
     (该初始值的1与下文中两个函数dispatch_semaphore_wait与dispatch_semaphore_signal进行的减1、加1里的1没有必然联系。
     
     就算初始值是100，两个函数dispatch_semaphore_wait与dispatch_semaphore_signal还是会减“1”、加“1”)。
     保证可访问 NSMutableArray 类对象的线程
     同时只能有1个
     *
     */
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for(int i = 0; i< 100000; ++i) {
        dispatch_async_limit(queue, 1, ^{
            /*
             *
             *等待Dispatch Semaphore
             *一直等待，直到Dispatch Semaphore的计数值达到大于等于1
             */
            //            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER) ;
            /*
             *由于Dispatch Semaphore的计数值达到大于等于1
             *所以将Dispatch Semaphore的计数值减去1
             *dispatch_semaphore_wait 函数执行返回。
             *即执行到此时的
             *Dispatch Semaphore 的计数值恒为0
             *
             *由于可访问NSMutaleArray类对象的线程
             *只有一个
             *因此可安全地进行更新
             *
             */
            NSLog(@"%@",[NSThread currentThread]);
            [array addObject:[NSNumber numberWithInt:i]];
            /*
             *
             *排他控制处理结束，
             *所以通过dispatch_semaphore_signal函数
             *将Dispatch Semaphore的计数值加1
             *如果有通过dispatch_semaphore_wait函数
             *等待Dispatch Semaphore的计数值增加的线程，
             ★就由最先等待的线程执行。
             */
            //            dispatch_semaphore_signal(semaphore);
        });
    }
    /*
     *
     等为数组遍历添加元素后，检查下数组的成员个数是否正确
     *
     */
    dispatch_barrier_async(queue, ^{
        NSLog(@"类名与方法名：%s（在第%d行），描述：%@", __PRETTY_FUNCTION__, __LINE__, @([array count]));
    });
}

/*
 *
 实战版本：具有专门控制并发等待的线程，优点是不会阻塞主线程，可以跑一下 demo，你会发现主屏幕上的按钮是可点击的。但相应的，viewdidload 方法中的栅栏方法dispatch_barrier_async就失去了自己的作用：无法达到“等为数组遍历添加元素后，检查下数组的成员个数是否正确”的效果。
 
 *
 */
void dispatch_async_limit(dispatch_queue_t queue,NSUInteger limitSemaphoreCount, dispatch_block_t block) {
    //控制并发数的信号量
    static dispatch_semaphore_t limitSemaphore;
    //专门控制并发等待的线程
    static dispatch_queue_t receiverQueue;
    
    //使用 dispatch_once而非 lazy 模式，防止可能的多线程抢占问题
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        limitSemaphore = dispatch_semaphore_create(limitSemaphoreCount);
        receiverQueue = dispatch_queue_create("receiver", DISPATCH_QUEUE_SERIAL);
    });
    
    dispatch_async(receiverQueue, ^{
        //可用信号量后才能继续，否则等待
        dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);
        dispatch_async(queue, ^{
            !block ? : block();
            //在该工作线程执行完成后释放信号量
            dispatch_semaphore_signal(limitSemaphore);
        });
    });
}

///*
// *
// 简单版本：无专门控制并发等待的线程，缺点阻塞主线程，可以跑一下 demo，你会发现主屏幕上的按钮是不可点击的
// *
// */
//void dispatch_async_limit(dispatch_queue_t queue,NSUInteger limitSemaphoreCount, dispatch_block_t block) {
//    //控制并发数的信号量
//    static dispatch_semaphore_t limitSemaphore;
//    //专门控制并发等待的线程
//
//
//    //使用 dispatch_once而非 lazy 模式，防止可能的多线程抢占问题
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        limitSemaphore = dispatch_semaphore_create(limitSemaphoreCount);
//    });
//
//
//        //可用信号量后才能继续，否则等待
//        dispatch_semaphore_wait(limitSemaphore, DISPATCH_TIME_FOREVER);
//        dispatch_async(queue, ^{
//            !block ? : block();
//            //在该工作线程执行完成后释放信号量
//            dispatch_semaphore_signal(limitSemaphore);
//        });
//
//}
#pragma mark ------------------------------- end --------------------------------------


@end
