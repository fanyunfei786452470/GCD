//
//  dispatch_source_t_VC.m
//  OC(GCD)
//
//  Created by 范云飞 on 2017/9/11.
//  Copyright © 2017年 范云飞. All rights reserved.
//

#import "dispatch_source_t_VC.h"


@interface dispatch_source_t_VC ()
{
#pragma mark ---------- 创建定时器 -------------
    NSInteger timeoutCount;/* 用于超时计数 */
    NSInteger timeoutLength;/* 设定20为超时的长度 */
    float timeInterval;/* 时间间隔 */
    BOOL isFinish;/* 结束任务完成的标志 */
#pragma mark -----------end ------------------
    
#pragma mark --------- 文件监听-----------------
    NSString * path;
    dispatch_source_t vnodeSource;
    dispatch_queue_t vnodeQueue;
#pragma mark ---------- end-------------------
    
#pragma mark ---------- 读取文件 --------------
    dispatch_source_t readSource;
#pragma mark ---------- end ------------------
    
#pragma mark ---------- 写文件 ----------------
    dispatch_source_t writeSource;
#pragma mark ---------- end ------------------
    
#pragma mark ---------- 自定义事件 -------------
    dispatch_source_t customSource;
#pragma mark ---------- end ------------------
    
#pragma mark ---------- 分派源 ----------------
    
#pragma mark ---------- end ------------------
#pragma mark ---------- 监听进程 ----------------
#pragma mark ---------- end ------------------
#pragma mark ---------- 监听信号 ----------------
    dispatch_source_t signalSource;
#pragma mark ---------- end ------------------
}

@end

static dispatch_source_t_VC * source_t_VC = nil;

@implementation dispatch_source_t_VC


#pragma mark ----------------------------- 创建定时器-----------------------------
dispatch_queue_t timerQueue;
dispatch_source_t Timer;
dispatch_source_t CreateDispatchTimer(uint64_t interval,
                                      uint64_t leeway,
                                      dispatch_queue_t queue,
                                      dispatch_block_t block)
{
    if (!Timer) {
        Timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                       0,
                                       0,
                                       queue
                                       );
        if (Timer) {
            dispatch_source_set_timer(Timer,
                                      dispatch_walltime(NULL, 0),
                                      interval,
                                      leeway
                                      );
            dispatch_source_set_event_handler(Timer, block);
            dispatch_resume(Timer);
        }
        
    }
    return Timer;
}

+ (void) MyCreateTimerInterval:(float) timeInterval Block:(dispatch_block_t)block
{
    if (!timerQueue) {
        timerQueue = dispatch_queue_create("timeout queue", DISPATCH_QUEUE_SERIAL);
        dispatch_source_t timer = CreateDispatchTimer(timeInterval * NSEC_PER_SEC,
                                                      1ull * NSEC_PER_SEC,
                                                      timerQueue,
                                                      block
                                                      );
        if (timer) {
            NSLog(@"creating a timeout queue is ok");
        }
    }
}

+ (dispatch_source_t_VC *)shareSource{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        source_t_VC = [[dispatch_source_t_VC alloc]init];
    });
    return source_t_VC;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"dispatch_source_t_VC";
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.indexPath.row == 0)
    {
        timeInterval = 0.1;
        timeoutCount = 0;
        timeoutLength = 20;
        [self Create_Timer];
    }
    if (self.indexPath.row == 1) {
        [self Create_Read_File];
    }
    if (self.indexPath.row == 2) {
        [self Create_Write_File];
    }
    if (self.indexPath.row == 3)
    {
        [self Create_Monitor_File];
    }
    if (self.indexPath.row == 4) {
        [self Create_Custom_Event];
    }
    if (self.indexPath.row == 5) {
        
    }
    if (self.indexPath.row == 6) {
        [self Create_Monitor_Signal];
    }
    
    /* 初始化操作按钮 */
    [self Create_UI];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)Create_UI
{
    UIButton * button = [[UIButton alloc]init];
    button.center = self.view.center;
    button.frame = CGRectMake(100, 100, 100, 30);
    button.backgroundColor = [UIColor blackColor];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)click:(UIButton *)sender
{
    if (self.indexPath.row == 3)
    {
        [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    }
    if (self.indexPath.row == 4) {
        /* 取消监听 */
        dispatch_cancel(customSource);
    }
}


/* 创建一个定时器 timer */
- (void)Create_Timer
{
    dispatch_async(dispatch_queue_create("time_out_control", DISPATCH_QUEUE_SERIAL), ^{
        [dispatch_source_t_VC MyCreateTimerInterval: timeInterval Block:^{
            /* 每隔0.1秒 检测一次耗时操作是否超时 */
            [self checkTimeOut];
        }];
        /* 耗时操作 */
        [self TimeConsumingTasks];
    });
    
    while (!isFinish)
    {
        if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive)
        {
            break;
        }
        else
        {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"***********timeoutCount:%ld*********",timeoutCount);
        NSLog(@"***********timeoutCount * timeInterval:%f*********",timeoutCount * timeInterval);
        NSLog(@"***********%@*********",@"到此为止");
        timeoutCount = 0;
    });
    
}

/* 耗时方法 */
- (void)TimeConsumingTasks
{
    
    for (int i = 0; i < 10 ; i++)
    {
        NSLog(@"***********%@ %d*********",@"执行任务中",i);
        /* 此处判断是否超时，超时直接终止耗时操作 */
        if (timeoutCount * timeInterval >= timeoutLength) {
            [[dispatch_source_t_VC shareSource] stopTimer];
            [self performSelectorOnMainThread:@selector(endRunLoop) withObject:nil waitUntilDone:NO];
            break;
        }
    }
    
    /* 此处唤醒 run loop（没有超时） */
    if(isFinish == 0)
    {
        [[dispatch_source_t_VC shareSource] stopTimer];
        [self performSelectorOnMainThread:@selector(endRunLoop) withObject:nil waitUntilDone:NO];
    }
    
}

/* 检查超时的方法 */
- (void)checkTimeOut{
    timeoutCount ++;
    if (timeoutCount * timeInterval >= timeoutLength) {
        NSLog(@"***********%@*********",@"你大爷的已经超时了");
        //        [[dispatch_source_t_VC shareSource] stopTimer];
        return;
    }
}

/* 注销 Timer */

- (void)stopTimer
{
    NSCondition* Condition = [[NSCondition alloc] init];
    [Condition lock];
    {
        if (Timer) {
            dispatch_source_set_cancel_handler(Timer, ^{
            });
            dispatch_source_cancel(Timer);
            Timer = NULL;
            {
                if (timerQueue) {
                    Timer = NULL;
                    timerQueue = NULL;
                }
            }
        }
    }
    [Condition unlock];
}

/* 结束roonloop 的跑圈 */
- (void)endRunLoop
{
    isFinish = YES;
}

#pragma mark ------------------------------  end --------------------------------------

#pragma mark -------------------------- 文件监听 ---------------------------------------
- (NSString *)applicationDocumentsDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)Create_Monitor_File
{
    /* 监听文件事件 */
    NSFileManager * fm = [NSFileManager defaultManager];
    path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"text.txt"];
    NSLog(@"\n path:%@",path);
    
    ([fm createFileAtPath:path contents:nil attributes:nil]) ? NSLog(@"创建文件成功") : NSLog(@"创建文件失败");
    const int infd = open([path fileSystemRepresentation], O_EVTONLY);
    vnodeQueue = dispatch_queue_create("file.com", DISPATCH_QUEUE_CONCURRENT);
    
    /* 监听文件 */
    vnodeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE,
                                         infd,
                                         DISPATCH_VNODE_DELETE,
                                         vnodeQueue
                                         );
    dispatch_source_set_event_handler(vnodeSource, ^{
        unsigned long flag = dispatch_source_get_data(vnodeSource);
        if (flag & DISPATCH_VNODE_DELETE) {
            NSLog(@"监听到文件删除");
        }
    });
    
    /* 不在监听时关闭文件 */
    dispatch_source_set_cancel_handler(vnodeSource, ^{
        close(infd);
    });
    
    /* 启动 */
    dispatch_resume(vnodeSource);
    
}
#pragma mark ------------------------------  end --------------------------------------

#pragma mark ----------------------------- 读取文件-------------------------------------
- (void) Create_Read_File
{
    if (readSource) {
        dispatch_source_cancel(readSource);
    }

    NSString *fileName = [NSString stringWithFormat:@"/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/crc算法.txt"];
    
    int fd = open([fileName UTF8String], O_RDONLY);
    NSLog(@"read fd:%d",fd);
    if (fd == -1)
        return ;
    fcntl(fd, F_SETFL, O_NONBLOCK);  // Avoid blocking the read operation
    dispatch_queue_t queue = dispatch_queue_create("readfile.com", DISPATCH_QUEUE_SERIAL);
    dispatch_source_t reSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, queue);
    if (reSource == NULL) {
        close(fd);
        return ;
    }
    
    
    // Install the event handler
    /* 只要文件写入了新内容，就会自动读入新内容 */
    dispatch_source_set_event_handler(reSource, ^{
        long estimated = dispatch_source_get_data(reSource);
        NSLog(@"Read From File, estimated length: %ld",estimated);
        if (estimated < 0) {
            NSLog(@"Read Error:");
            dispatch_source_cancel(reSource);  //如果文件发生了截短，事件处理器会一直不停地重复
        }
        
        /* 把数据局读入buffer */
        char *buffer = (char *)malloc(estimated);
        if (buffer) {
            ssize_t actual = read(fd, buffer, (estimated));
            NSLog(@"Read From File, actual length: %ld",actual);
            NSLog(@"Readed Data: \n%s",buffer);
            //            Boolean done = MyProcessFileData(buffer, actual);  // Process the data.
            
            // Release the buffer when done.
            free(buffer);
            
            // If there is no more data, cancel the source.
            //            if (done)
            //                dispatch_source_cancel(readSource);
        }
    });
    
    // Install the cancellation handler
    dispatch_source_set_cancel_handler(reSource, ^{
        NSLog(@"Read from file Canceled");
        close(fd);
    });
    
    // Start reading the file.
    dispatch_resume(reSource);
    
    readSource = reSource; //can be omitted
}


#pragma mark ------------------------------ end ---------------------------------------

#pragma mark ----------------------------- 写文件-------------------------------------
- (void)Create_Write_File
{
    if (writeSource) {
        return;
    }
    NSString *fileName = [NSString stringWithFormat:@"/Users/fanyunfei/Desktop/iOS学习/swift学习/swift(UI阶段)/OC(GCD)/OC(GCD)/write.txt"];
    int fd = open([fileName UTF8String], O_WRONLY | O_CREAT | O_TRUNC,
                  (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    NSLog(@"Write fd:%d",fd);
    if (fd == -1)
        return ;
    fcntl(fd, F_SETFL); // Block during the write.
    
    dispatch_source_t wSource = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    wSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE,fd, 0, queue);
    
    dispatch_source_set_event_handler(wSource, ^{
        size_t bufferSize = 100;
        void *buffer = malloc(bufferSize);
        
        static NSString *content = @"Write Data Action: ";
        content = [content stringByAppendingString:@"=New info="];
        
        NSString *writeContent = [content stringByAppendingString:@" 你大爷的快点\n"];
        const char * string = [writeContent UTF8String];
        size_t actual = strlen(string);
        memcpy(buffer, string, actual);
        
        write(fd, buffer, actual);
        NSLog(@"Write to file Finished");
        
        free(buffer);
        // Cancel and release the dispatch source when done.
        //        dispatch_source_cancel(writeSource);
        dispatch_suspend(wSource);  //不能省,否则只要文件可写，写操作会一直进行，直到磁盘满，本例中，只要超过buffer容量就会崩溃
        //        close(fd);   //会崩溃
    });
    dispatch_source_set_cancel_handler(wSource, ^{
        NSLog(@"Write to file Canceled");
        close(fd);
    });
    
    if (!wSource) {
        close(fd);
        return;
    }
    
    dispatch_resume(wSource);
    
    writeSource = wSource;

}
#pragma mark ------------------------------ end ---------------------------------------

#pragma mark ----------------------------- 自定义事件 ---------------------------------
- (void)Create_Custom_Event
{
    if (customSource) {
        customSource = NULL;
    }
    dispatch_queue_t queue = dispatch_queue_create("custom.event.com", DISPATCH_QUEUE_CONCURRENT);
    customSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, queue);
    
    /* 监听后的任务设置 */
    dispatch_source_set_event_handler(customSource, ^{
        unsigned long vlue = dispatch_source_get_data(customSource);
        NSLog(@"监听到数据:%ld  当前线程：%@",vlue,[NSThread currentThread]);
    });
    
    dispatch_source_set_cancel_handler(customSource, ^{
        NSLog(@"取消监听");
    });
    
    /* 恢复任务，必须调用 */
    dispatch_resume(customSource);
    
    /* 发送一个数据1000进行测试 */
    dispatch_source_merge_data(customSource, 1000);
    
}



#pragma mark ------------------------------ end ---------------------------------------

#pragma mark ----------------------------- 监听进程 -------------------------------------

#pragma mark ------------------------------ end ---------------------------------------
#pragma mark ----------------------------- 监听信号 -------------------------------------
- (void)Create_Monitor_Signal
{
    signal(SIGCHLD, SIG_IGN);
    dispatch_queue_t queue = dispatch_queue_create("signal.com", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_source_t sSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGCHLD, 0, queue);
    
    if (sSource)
    {
        dispatch_source_set_event_handler(sSource, ^{
            static NSInteger i = 0;
            i++;
            NSLog(@"signal Detected:%ld",i);
        });
        
        dispatch_source_set_cancel_handler(sSource, ^{
            NSLog(@"singal canceled");
        });
        
        dispatch_resume(sSource);
    }
    
    signalSource = sSource;
}
#pragma mark ------------------------------ end ---------------------------------------


@end



