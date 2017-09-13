//
//  dispatch_once_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/12.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_once_t_VC.h"

@interface dispatch_once_t_VC ()

@end

static dispatch_once_t_VC * once_t_VC = nil;

@implementation dispatch_once_t_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self Create_once_t];
}

static dispatch_once_t onceToken;

+(instancetype)shareOnce
{
    dispatch_once(&onceToken, ^{
        once_t_VC = [[dispatch_once_t_VC alloc]init];
    });
    return once_t_VC;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"创建");
    }
    return self;
}

/* 可以看出两次初始化的对象的地址是相同的 */
- (void)Create_once_t
{
    dispatch_once_t_VC * vc1 = [[dispatch_once_t_VC shareOnce]init];
    NSLog(@"vc1:%@",vc1);
    
    dispatch_once_t_VC * vc2 = [[dispatch_once_t_VC shareOnce]init];
    NSLog(@"vc@:%@",vc2);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
