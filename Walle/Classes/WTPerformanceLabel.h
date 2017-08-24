//
//  WTPerformanceLabel.h
//  Walle
//
//  Created by walter on 07/07/2017.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WTPerformanceLabelState){
    WTPerformanceStateGood,
    WTPerformanceStateWarning,
    WTPerformanceStateBad,
};

typedef NS_ENUM(NSInteger, WTPerformanceMonitorType){
    WTPerformanceMonitorMemory,
    WTPerformanceMonitorCPU,
    WTPerformanceMonitorFPS,
    WTPerformanceMonitorRender
};

@interface WTPerformanceLabel : UILabel

@property (assign, nonatomic)WTPerformanceLabelState state;

- (void)setTextColor:(UIColor *)textColor forState:(WTPerformanceLabelState)state;

- (UIColor *)textColorForState:(WTPerformanceLabelState)state;
@end
