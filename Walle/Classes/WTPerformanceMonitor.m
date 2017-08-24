//
//  WTPerformanceMonitor.m
//  Pods
//
//  Created by walter on 04/07/2017.
//
//

#import "WTPerformanceMonitor.h"
#import "WTPerformanceUtility.h"
#import "WTPerformanceView.h"
#import "WTPerformanceLabel.h"
#include <mach/mach_time.h>
#import "WTMainLoopMonitor.h"

static uint64_t loadTime;
static uint64_t applicationRespondedTime = -1;
static mach_timebase_info_data_t timebaseInfo;

static inline NSTimeInterval MachTimeToSeconds(uint64_t machTime) {
    return ((machTime / 1e9) * timebaseInfo.numer) / timebaseInfo.denom;
}

@interface WTPerformanceMonitor()

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) WTPerformanceView *performanceView;
@property (nonatomic, assign) BOOL isShownPerformanceBar;
@property (nonatomic, copy) NSString *currentPageName;
@property (nonatomic, assign) CGFloat currentPageRenderTime;

@end

@implementation WTPerformanceMonitor

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
                                                                   NSLog(@"App_Start_Time: %.f s", MachTimeToSeconds(applicationRespondedTime - loadTime));
                                                                });
                                                                [[NSNotificationCenter defaultCenter] removeObserver:obs];
                                                            }];
    }
}

#pragma mark - Init
+ (instancetype)sharedInstance{
    static WTPerformanceMonitor * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[WTPerformanceMonitor alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(envokeDisplayLink:)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        _displayLink.paused = YES;
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationDidBecomeActiveNotification)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(applicationWillResignActiveNotification)
                                                     name: UIApplicationWillResignActiveNotification
                                                   object: nil];
        _performanceView = [[WTPerformanceView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    }
    
    return self;
}

- (void)dealloc
{
    _displayLink.paused = YES;
    [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)startMonitorWithBar:(BOOL)isShownPerformanceBar
{
    self.displayLink.paused = NO;
    [self.performanceView showPerformacneView:isShownPerformanceBar];
    [[WTMainLoopMonitor sharedInstance] startMonitor];
}

- (void)stop
{
    self.displayLink.paused = YES;
    [self.performanceView showPerformacneView:NO];
    [[WTMainLoopMonitor sharedInstance] endMonitor];
}

- (void)setPageName:(NSString *)name
{
    self.currentPageName = name;
}

- (void)setPageRenderTime:(CGFloat)time
{
    self.currentPageRenderTime = time;
}

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
    
    if ([self.delegate respondsToSelector:@selector(performanceMonitorResult:cpu:memory:FPS:render:)]) {
        [self.delegate performanceMonitorResult:self cpu:cpu memory:memory FPS:shownFPS render:self.currentPageRenderTime];
    }
    
    [self.performanceView setPerformanceViewData:cpu memory:memory FPS:shownFPS render:self.currentPageRenderTime];
}

- (void)applicationDidBecomeActiveNotification {
    _displayLink.paused = NO;
}

- (void)applicationWillResignActiveNotification {
    _displayLink.paused = YES;
}


@end
