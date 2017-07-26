//
//  XYPerformanceMonitor.h
//  Pods
//
//  Created by walter on 04/07/2017.
//
//

#import <Foundation/Foundation.h>

/**
 性能分析，输出每秒中，帧率，内存，CPU 使用情况。
 log以输入到文件内Library／Caches／Logs 目录下
 同时支持显示到，App status bar 上，测试过程中可以，直接看到性能数据。
 */
@interface XYPerformanceMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)startMonitorWithBar:(BOOL)isShownPerformanceBar;

- (void)stop;

- (void)setPageName:(NSString *)name;

@end
