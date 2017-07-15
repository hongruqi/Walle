//
//  XYPerformanceView.h
//  Walle
//
//  Created by hongru qi on 07/07/2017.
//

#import <UIKit/UIKit.h>

@class XYPerformanceLabel;

@interface XYPerformanceView : UIView

//@property (strong, nonatomic) XYPerformanceLabel * fpsLabel;
//
//@property (strong, nonatomic) XYPerformanceLabel * memoryLabel;
//
//@property (strong, nonatomic) XYPerformanceLabel * cpuLabel;
//
//- (NSArray<XYPerformanceLabel *> *)subLabels;


- (void)showPerformacneView:(BOOL)isShown;

- (void)setPerformanceViewData:(CGFloat)cpu memory:(CGFloat)memory FPS:(CGFloat) FPS;

@end
