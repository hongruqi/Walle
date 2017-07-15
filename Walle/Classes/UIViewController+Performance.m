//
//  UIViewController+Performance.m
//  Pods
//
//  Created by hongru qi on 14/07/2017.
//
//

#import "UIViewController+Performance.h"
#import <objc/runtime.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DDLegacyMacros.h"

static const DDLogLevel ddLogLevel = DDLogLevelInfo;

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

@end
