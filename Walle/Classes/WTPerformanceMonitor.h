//
//  WTPerformanceMonitor.h
//  Pods
//
//  Created by walter on 04/07/2017.
//
//

#import <Foundation/Foundation.h>

@class WTPerformanceMonitor;
@protocol WTPerformanceMonitorDelegate<NSObject>

- (void)performanceMonitorResult:(WTPerformanceMonitor *)monitor cpu:(CGFloat)cpu memory:(CGFloat)memory FPS:(CGFloat)FPS render:(CGFloat)render;

@end
/**
 性能分析，输出每秒中，帧率，内存，CPU 使用情况。
 log以输入到文件内Library／Caches／Logs 目录下
 同时支持显示到，App status bar 上，测试过程中可以，直接看到性能数据。
 */
@interface WTPerformanceMonitor : NSObject

@property (nonatomic, weak) id<WTPerformanceMonitorDelegate>delegate;

+ (instancetype)sharedInstance;

- (void)startMonitorWithBar:(BOOL)isShownPerformanceBar;

- (void)stop;

- (void)setPageName:(NSString *)name;

- (void)setPageRenderTime:(CGFloat)time;

@end
