//
//  WTMainMonitor.m
//  WeCycle
//
//  Created by Frenzy-Mac on 2017/5/19.
//  Copyright © 2017年 com.quvideo.wecycle. All rights reserved.
//

#import "WTMainLoopMonitor.h"
#import <libkern/OSAtomic.h>
#import <execinfo.h>
#import "BSBacktraceLogger.h"

@interface WTMainLoopMonitor(){
    CFRunLoopObserverRef _observer;
    dispatch_semaphore_t _semaphore;
    CFRunLoopActivity _activity;
    NSInteger _countTime;
}

@end

@implementation WTMainLoopMonitor

+ (instancetype) sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)startMonitor{
    [self registerObserver];
}

- (void)endMonitor
{
    if (_observer) {
        CFRunLoopRemoveObserver(CFRunLoopGetMain(), _observer, kCFRunLoopCommonModes);
        CFRelease(_observer);
        _observer = NULL;
    }
}

- (void)registerObserver
{
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
}


@end
