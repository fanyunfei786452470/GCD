//
//  ViewController.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "ViewController.h"

/* VC */
#import "dispatch_queue_t_VC.h"
#import "dispatch_group_t_VC.h"
#import "dispatch_semaphore_t_VC.h"
#import "dispatch_source_t_VC.h"
#import "dispatch_time_t_VC.h"
#import "dispatch_block_t_VC.h"
#import "dispatch_once_t_VC.h"
#import "dispatch_data_t_VC.h"
#import "dispatch_IO_T_VC.h"
#import "dispatch_object_t_VC.h"

@interface ViewController ()
<UITableViewDelegate,
UITableViewDataSource
>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray <NSString *>* titleArr;
@property (strong, nonatomic) NSArray <NSArray<NSString *> *>* dataArr;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self Create_UI];
    [self Create_DATA];
}

- (void)Create_UI
{
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)Create_DATA
{
    self.titleArr = @[@"dispatch_queue_t",
                      @"dispatch_group_t",
                      @"dispatch_semaphore_t",
                      @"dispatch_source_t",
                      @"dispatch_time_t",
                      @"dispatch_block_t",
                      @"dispatch_once_t",
                      @"dispatch_data_t",
                      @"dispatch_IO_t",
                      @"dispatch_object_t"
                      ];
    self.dataArr = @[@[@"异步+并行",
                       @"异步+串行",
                       @"同步+并行",
                       @"同步+串行",
                       @"全局队列",
                       @"主队列",
                       @"延时提交",
                       @"快速迭代"
                       ],
                     @[@"多组网络并发请求"
                       ],
                     @[@"解决资源竞争的例子(可变数组添加数据)",
                       @"车子占位的问题",
                       @"控制并发数"
                        ],
                     @[@"定时器(和runloop结合)",
                       @"文件读取",
                       @"文件写数据",
                       @"文件监听",
                       @"自定义事件",
                       @"监听进程",
                       @"监听信号"
                       ],
                     @[@"创建定时器"
                       ],
                     @[@"简单应用"
                       ],
                     @[@"简单应用"
                       ],
                     @[@"data操作的简单例子"
                       ],
                     @[@"I/O读数据",
                       @"I/O写数据",
                       @"I/O操作中的高低水位与周期性回调"
                       ],
                     @[@"object操作"]
                     ];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame
                                                 style:UITableViewStylePlain
                      ];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.titleArr[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        dispatch_queue_t_VC * queue_t_VC = [[dispatch_queue_t_VC alloc]init];
        queue_t_VC.indexPath = indexPath;
        [self.navigationController pushViewController:queue_t_VC animated:YES];
    }
    if (indexPath.section == 1) {
        dispatch_group_t_VC * group_t_VC = [[dispatch_group_t_VC alloc]init];
        [self.navigationController pushViewController:group_t_VC animated:YES];
    }
    if (indexPath.section == 2) {
        dispatch_semaphore_t_VC * semaphore_t_VC = [[dispatch_semaphore_t_VC alloc]init];
        semaphore_t_VC.indexPath = indexPath;
        [self.navigationController pushViewController:semaphore_t_VC animated:YES];
    }
    if (indexPath.section == 3) {
        dispatch_source_t_VC * source_t_VC = [[dispatch_source_t_VC alloc]init];
        source_t_VC.indexPath = indexPath;
        [self.navigationController pushViewController:source_t_VC animated:YES];
    }
    if (indexPath.section == 4) {
        dispatch_time_t_VC * time_t_VC = [[dispatch_time_t_VC alloc]init];
        [self.navigationController pushViewController:time_t_VC animated:YES];
    }
    if (indexPath.section == 5) {
        dispatch_block_t_VC * block_t_VC = [[dispatch_block_t_VC alloc]init];
        [self.navigationController pushViewController:block_t_VC animated:YES];
    }
    if (indexPath.section == 6) {
        dispatch_once_t_VC * once_t_VC = [[dispatch_once_t_VC alloc]init];
        [self.navigationController pushViewController:once_t_VC animated:YES];
    }
    if (indexPath.section == 7) {
        dispatch_data_t_VC * data_t_VC = [[dispatch_data_t_VC alloc]init];
        data_t_VC.indexPath = indexPath;
        [self.navigationController pushViewController:data_t_VC animated:YES];
    }
    if (indexPath.section == 8) {
        dispatch_IO_T_VC * io_t_VC = [[dispatch_IO_T_VC alloc]init];
        io_t_VC.indexPath = indexPath;
        [self.navigationController pushViewController:io_t_VC animated:YES];
    }
    if (indexPath.section == 9) {
        dispatch_object_t_VC * object_t_VC = [[dispatch_object_t_VC alloc]init];
        [self.navigationController pushViewController:object_t_VC animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
