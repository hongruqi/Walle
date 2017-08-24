//
//  WTPerformanceView.h
//  Walle
//
//  Created by walter on 07/07/2017.
//

#import <UIKit/UIKit.h>

@class WTPerformanceLabel;

@interface WTPerformanceView : UIView

- (void)showPerformacneView:(BOOL)isShown;

- (void)setPerformanceViewData:(CGFloat)cpu memory:(CGFloat)memory FPS:(CGFloat)FPS render:(CGFloat)render;

@end
