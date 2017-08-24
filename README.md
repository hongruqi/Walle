Walle can monitor the core data of iOS application performance.

# Features

Real-time monitoring of the following data

- Memory
- FPS
- CPU
- launch time
- UIViewController appear time
- monitor main thread whether blocked
#Environment
IOS 8 or later , XCode 7 or later

#How To Use
```Objc
#import "WTPerformanceMonitor.h"

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    [[WTPerformanceMonitor sharedInstance] startMonitorWithBar:YES];
}
```

#Installation
pod 'Walle'

---
# iOS 应用，性能监控
> 背景，目前正在优化项目，首先要对项目内的性能指标进行分析，这个可以通过Instrument 进行debug 分析。这样做只适用于开发人员。性能指标作为一项衡量App的重要指标无法量化。为了每次发布前能有一个性能报告，需要开发一个组件，对性能数据进行记录，之后通过脚本生成报表。

##报表中重点关注的指标有以下几点：
- 启动时间
- 内存
- FPS（页面刷新帧率）
- CPU 
- 页面渲染时间

## debug模式
- 主线程阻塞时，输出MainThread 栈信息。

##分别介绍如何实现这些数据的采集。

###  内存
```Objc
vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}
```
### FPS
- 使用CADisplayLink 进行获取

```Objc
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(envokeDisplayLink:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        

- (void)envokeDisplayLink:(CADisplayLink *)displayLink
{
    if (_lastTime == 0) {
        _lastTime = displayLink.timestamp;
        return;
    }
    
    _count ++;
    
    NSTimeInterval interval = displayLink.timestamp - _lastTime;
    
    if (interval < 1) {
        return;
    }
    
    _lastTime = displayLink.timestamp;
    CGFloat fps = _count / interval;
    _count = 0;
    
    NSInteger shownFPS = round(fps);
    CGFloat memory = [WTPerformanceUtility usedMemoryInMB];
    CGFloat cpu = [WTPerformanceUtility cpuUsage];
    DDLogInfo(@"FPS:%ld,MEM:%.2f,CPU:%.2f", (long)shownFPS, memory, cpu);
    
    [self.performanceView setPerformanceViewData:cpu memory:memory FPS:shownFPS];
    
}   
```

###  CPU
```Objc
float cpu_usage()
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}
```
### 启动时间
```Objc
+ (void)load
{
    loadTime = mach_absolute_time();
    mach_timebase_info(&timebaseInfo);
    @autoreleasepool {
        __block id obs;
        obs = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                                object:nil queue:nil
                                                            usingBlock:^(NSNotification *note) {
                                                                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                                    applicationRespondedTime = mach_absolute_time();
                                                                   DDLogInfo(@"VivaVedio_IOS_Start_Time: %.f", MachTimeToSeconds(applicationRespondedTime - loadTime));
                                                                });
                                                                [[NSNotificationCenter defaultCenter] removeObserver:obs];
                                                            }];
    }
}
```

### 页面渲染耗时
利用runtime， 将UIViewController 的viewWillAppear， viewDidAppear 进行hook。输出调用的时间间隔。

```Objc
@interface UIViewController()

@property (nonatomic, assign) CFTimeInterval viewControllerAppearDuration;

@end

@implementation UIViewController (Performance)
+ (void)load{
    [self walle_swizzlingViewWillAppear];
    [self walle_swizzlingViewDidAppear];
}

+ (void)walle_swizzlingViewWillAppear
{
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(walle_viewWillAppear:);
    [self swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (void)walle_swizzlingViewDidAppear
{
    SEL originalSelector = @selector(viewDidAppear:);
    SEL swizzledSelector = @selector(walle_viewDidAppear:);
    [self swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

- (void)walle_viewWillAppear:(BOOL)animated
{
    self.viewControllerAppearDuration = CACurrentMediaTime();
    [self walle_viewWillAppear:animated];
}

- (void)walle_viewDidAppear:(BOOL)animated
{
    [self walle_viewDidAppear:animated];
    self.viewControllerAppearDuration = CACurrentMediaTime() - self.viewControllerAppearDuration;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *name = NSStringFromClass(self.class);
        DDLogInfo(@"View Controller :%@ show time : %g s", name, self.viewControllerAppearDuration);
    });
}


+ (void)swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class clz = cls;
    Method originalMethod = class_getInstanceMethod(clz, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(clz, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(clz, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(clz, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)setViewControllerAppearDuration:(CFTimeInterval)viewControllerAppearDuration
{
    objc_setAssociatedObject(self, @selector(viewControllerAppearDuration), @(viewControllerAppearDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFTimeInterval )viewControllerAppearDuration
{
    return [objc_getAssociatedObject(self, @selector(viewControllerAppearDuration)) doubleValue];
}

```
## debug 主线程阻塞
- 通过监控Runloop的回调进行监控

```Objc
    _observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, true, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        self->_activity = activity;
        dispatch_semaphore_t semaphore = self->_semaphore;
        dispatch_semaphore_signal(semaphore);
    });
    
    CFRunLoopAddObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
    // 创建信号
    _semaphore = dispatch_semaphore_create(0);
    // 在子线程监控时长
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (YES)
        {
            // 超时250ms 认为卡顿
            long st = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, 50*NSEC_PER_MSEC));
            if (st != 0)
            {
                if (_activity == kCFRunLoopBeforeSources || _activity == kCFRunLoopAfterWaiting)
                {
                    if (++_countTime < 5)
                        continue;
                    NSString *track = [BSBacktraceLogger bs_backtraceOfMainThread];
                    NSLog(@"############### Main thread is blocked ###############");
                    NSLog(@"%@", track);
                    NSLog(@"############### Main thread is blocked ###############");
                }
            }
            _countTime = 0;
        }
    });
```






