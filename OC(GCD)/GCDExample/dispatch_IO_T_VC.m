//
//  dispatch_IO_T_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_IO_T_VC.h"

@interface dispatch_IO_T_VC ()

@end

@implementation dispatch_IO_T_VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.indexPath.row == 0)
    {
        [self Create_io_t_read];
    }
    if (self.indexPath.row == 1)
    {
        [self Create_io_t_write];
    }
    if (self.indexPath.row == 2) {
        [self Create_periodic_callback];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -------------------------- I/O 中的read----------------------------
- (void)Create_io_t_read
{
    /* 获取文件路径 */
    NSString * path = @"/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/write.txt";
    
    /* 转化成c字符串 */
    const char * cPath = [path UTF8String];
    
    /* dispatch_fd_t 的本质就是一个int型的文件描述符 */
    dispatch_fd_t fd = open(cPath, O_RDONLY);
    
    /* 创建队列 */
    dispatch_queue_t queue = dispatch_queue_create("io.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* dispatch_io_t 可以看成一个异步I/O的处理对象 */
    dispatch_io_t io = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue, ^(int error) {
        if (error) {
            NSLog(@"io创建失败");
        }
    });
    
    /**
     读取数据

     @param io 传一个iO处理对象
     @param 0 这个值只对 DISPATCH_IO_RANDOM有限,DISPATCH_IO_STREAM下为0即可
     @param SIZE_MAX 表示文件全部读取出来
     @param queue 读取文件的队列
     @param done 读取是否完成
     @param data 数据，用dispatch_data_t 包装过，需要转换成可以读取的对象
     @param error 错误码
     */
    dispatch_io_read(io, 0, SIZE_MAX, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
        if (dispatch_data_get_size(data)) {
            NSLog(@"done:%d data:%@",done,data);
            const void * buffer = NULL;
            size_t size = 0;
            dispatch_data_t file = dispatch_data_create_map(data, &buffer, &size);
            if (file) {
                NSData * ocData = [[NSData alloc]initWithBytes:buffer length:size];
                NSString * str = [[NSString alloc]initWithData:ocData encoding:NSUTF8StringEncoding];
                NSLog(@"str :%@",str);
            }
        }
        
        if (done || error) {
            close(fd);
            dispatch_io_close(io, DISPATCH_IO_STOP);
        }
    });
}
#pragma mark ------------------------------ end -------------------------------

#pragma mark -------------------------- I/O 中的write---------------------------
- (void)Create_io_t_write
{
    dispatch_io_t io;
    
    /* 获取文件路径 */
    NSString * path = @"/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/write.txt";
    
    /* 转化成C字符串 */
    const char * cPath = [path UTF8String];
    
    /* dispatch_fd_t 的本质上就是一个int型的文件描述符 */
    dispatch_fd_t fd = open(cPath, O_RDWR);
    
    /* 创建队列 */
    dispatch_queue_t queue = dispatch_queue_create("io.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* dispatch_io_t可以看成一个异步I/O的处理对象 */
    io = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue, ^(int error) {
        if (error) {
            NSLog(@"io创建失败");
        }
    });
    
    /* 需要写入的数据 */
    const char buffer[] = "*******************你大爷的快点********************";
    dispatch_data_t writeData = dispatch_data_create(buffer, sizeof(buffer), queue, ^{
        
    });
    
    dispatch_io_write(io, 0, writeData, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
        if (done) {
            NSLog(@"数据写入完成，关闭文件");
            close(fd);
        }
        if (done || error) {
            close(fd);
            dispatch_io_close(io, DISPATCH_IO_STOP);
        }
    });

}
#pragma mark ------------------------------ end -------------------------------

#pragma mark ---------------- I/O操作中的高低水位与周期性回调----------------------
- (void)Create_periodic_callback
{
    dispatch_io_t io;
    /* 获取文件路径 */
    NSString * path = @"/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/crc.txt";
    
    /* 转成c字符串*/
    const char * cPath = [path UTF8String];
    
    /* dispatch_fd_t的本质就是一个int型的文件描述符 */
    dispatch_fd_t fd = open(cPath, O_RDWR);
    
    /* 创建队列 */
    dispatch_queue_t queue = dispatch_queue_create("io.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* dispatch_io_t 可以看成一个异步I/O 的处理对象 */
    io = dispatch_io_create(DISPATCH_IO_STREAM, fd, queue, ^(int error) {
        if (error)
        {
            NSLog(@"io创建失败");
        }
    });
    
    /* 需要写入的数据 */
    const char buffer[] = "《彼岸花》";
    
    dispatch_io_set_low_water(io, 1);
    dispatch_io_set_high_water(io, SIZE_MAX);
    
    dispatch_data_t writeData = dispatch_data_create(buffer, sizeof(buffer), queue, ^{
    });
    
    dispatch_io_write(io, sizeof(buffer), writeData, queue, ^(bool done, dispatch_data_t  _Nullable data, int error) {
        if (data) {
            NSLog(@"data:%lu",dispatch_data_get_size(data));
        }
        
        if (error) {
            NSLog(@"错误");
            close(fd);
            dispatch_io_close(io, DISPATCH_IO_STOP);
        }
        
        if (done) {
            NSLog(@"完成");
            close(fd);
            dispatch_io_close(io, DISPATCH_IO_STOP);
        }
        
    });
}
#pragma mark ------------------------------ end -------------------------------

@end
