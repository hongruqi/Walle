#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIViewController+Performance.h"
#import "XYPerformanceLabel.h"
#import "XYPerformanceMonitor.h"
#import "XYPerformanceUtility.h"
#import "XYPerformanceView.h"

FOUNDATION_EXPORT double WalleVersionNumber;
FOUNDATION_EXPORT const unsigned char WalleVersionString[];

