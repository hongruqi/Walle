//
//  UIViewController+Performance.m
//  Pods
//
//  Created by walter on 14/07/2017.
//
//

#import "UIViewController+Performance.h"
#import <objc/runtime.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DDLegacyMacros.h"
#import "JRSwizzle.h"
#import "XYPerformanceMonitor.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;

@interface UIViewController()

@property (nonatomic, assign) CFTimeInterval viewControllerAppearDuration;

@end

@implementation UIViewController (Performance)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self walle_swizzlingViewWillAppear];
        [self walle_swizzlingViewDidAppear];
        [self walle_swizzlingViewDidLoad];
    });
}

+ (void)walle_swizzlingViewDidLoad
{    NSError *error = nil;
    [UIViewController jr_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(walle_viewDidLoad) error:&error];
}

+ (void)walle_swizzlingViewWillAppear
{
    [UIViewController jr_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(walle_viewWillAppear:) error:nil];
}

+ (void)walle_swizzlingViewDidAppear
{
    [UIViewController jr_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(walle_viewDidAppear:) error:nil];
}

- (void)walle_viewDidLoad
{
    self.viewControllerAppearDuration = CACurrentMediaTime();
    [self walle_viewDidLoad];
}

- (void)walle_viewWillAppear:(BOOL)animated
{
    if (self.viewControllerAppearDuration == 0) {
        self.viewControllerAppearDuration = CACurrentMediaTime();
    }
    
    [self walle_viewWillAppear:animated];
}

- (void)walle_viewDidAppear:(BOOL)animated
{
    [self walle_viewDidAppear:animated];
    self.viewControllerAppearDuration = CACurrentMediaTime() - self.viewControllerAppearDuration;
    NSString *name = NSStringFromClass(self.class);
    DDLogInfo(@"%@ view_finish_shown_time : %g s", name, self.viewControllerAppearDuration);
    self.viewControllerAppearDuration = 0;
    [[XYPerformanceMonitor sharedInstance] setPageName:NSStringFromClass(self.class)];
}

- (void)setViewControllerAppearDuration:(CFTimeInterval)viewControllerAppearDuration
{
    objc_setAssociatedObject(self, @selector(viewControllerAppearDuration), @(viewControllerAppearDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFTimeInterval )viewControllerAppearDuration
{
    return [objc_getAssociatedObject(self, @selector(viewControllerAppearDuration)) doubleValue];
}


@end
