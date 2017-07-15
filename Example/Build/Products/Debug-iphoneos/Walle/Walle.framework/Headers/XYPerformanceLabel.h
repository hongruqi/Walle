//
//  XYPerformanceLabel.h
//  Walle
//
//  Created by hongru qi on 07/07/2017.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYPerformanceLabelState){
    XYPerformanceStateGood,
    XYPerformanceStateWarning,
    XYPerformanceStateBad,
};

typedef NS_ENUM(NSInteger, XYPerformanceMonitorType){
    XYPerformanceMonitorMemory,
    XYPerformanceMonitorCPU,
    XYPerformanceMonitorFPS,
};

@interface XYPerformanceLabel : UILabel

@property (assign, nonatomic)XYPerformanceLabelState state;

- (void)setTextColor:(UIColor *)textColor forState:(XYPerformanceLabelState)state;

- (UIColor *)textColorForState:(XYPerformanceLabelState)state;
@end
