//
//  UIViewController+Performance.m
//  Pods
//
//  Created by walter on 14/07/2017.
//
//

#import "UIViewController+Performance.h"
#import <objc/runtime.h>
#import "WTPerformanceMonitor.h"

@interface UIViewController()

@property (nonatomic, assign) CFTimeInterval viewControllerAppearDuration;

@end

@implementation UIViewController (Performance)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self walle_swizzlingViewWillAppear];
        [self walle_swizzlingViewDidAppear];
        [self walle_swizzlingLoadView];
    });
}

+ (void)walle_swizzlingLoadView
{
    SEL originalSelector = @selector(loadView);
    SEL swizzledSelector = @selector(walle_loadView);
    [self wt_swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (void)walle_swizzlingViewWillAppear
{
    SEL originalSelector = @selector(viewWillAppear:);
    SEL swizzledSelector = @selector(walle_viewWillAppear:);
    [self wt_swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

+ (void)walle_swizzlingViewDidAppear
{
    SEL originalSelector = @selector(viewDidAppear:);
    SEL swizzledSelector = @selector(walle_viewDidAppear:);
    [self wt_swizzlingInClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
}

- (void)walle_loadView
{
    self.viewControllerAppearDuration = CACurrentMediaTime();
    [self walle_loadView];
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
    [[WTPerformanceMonitor sharedInstance] setPageName:NSStringFromClass(self.class)];
    [[WTPerformanceMonitor sharedInstance] setPageRenderTime:self.viewControllerAppearDuration];
    self.viewControllerAppearDuration = 0;
}

- (void)setViewControllerAppearDuration:(CFTimeInterval)viewControllerAppearDuration
{
    objc_setAssociatedObject(self, @selector(viewControllerAppearDuration), @(viewControllerAppearDuration), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CFTimeInterval )viewControllerAppearDuration
{
    return [objc_getAssociatedObject(self, @selector(viewControllerAppearDuration)) doubleValue];
}


+ (void)wt_swizzlingInClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
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

@end
