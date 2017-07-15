//
//  XYPerformanceLabel.m
//  Walle
//
//  Created by hongru qi on 07/07/2017.
//

#import "XYPerformanceLabel.h"

@interface XYPerformanceLabel()

@property (strong,nonatomic)NSMutableDictionary * configCache;

@end

@implementation XYPerformanceLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setTextColor:[UIColor colorWithRed:244.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] forState:XYPerformanceStateBad];
    [self setTextColor:[UIColor orangeColor] forState:XYPerformanceStateWarning];
    [self setTextColor:[UIColor colorWithRed:66.0/255.0 green:244.0/255.0 blue:89.0/255.0 alpha:1.0] forState:XYPerformanceStateGood];
    self.state = XYPerformanceStateGood;
}

- (void)setTextColor:(UIColor *)textColor forState:(XYPerformanceLabelState)state{
    if (textColor) {
        [self.configCache setObject:textColor forKey:@(state)];
    }else{
        [self.configCache removeObjectForKey:@(state)];
    }
}

- (UIColor *)textColorForState:(XYPerformanceLabelState)state
{
    return [self.configCache objectForKey:@(state)];
}

- (void)setState:(XYPerformanceLabelState)state
{
    _state = state;
    UIColor * color = [self textColorForState:state];
    self.textColor = color;
}

- (NSMutableDictionary *)configCache
{
    if (!_configCache) {
        _configCache = [[NSMutableDictionary alloc] init];
    }
    return _configCache;
}

@end
