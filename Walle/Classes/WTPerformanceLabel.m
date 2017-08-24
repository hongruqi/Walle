//
//  WTPerformanceLabel.m
//  Walle
//
//  Created by walter on 07/07/2017.
//

#import "WTPerformanceLabel.h"

@interface WTPerformanceLabel()

@property (strong,nonatomic)NSMutableDictionary * configCache;

@end

@implementation WTPerformanceLabel

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
    [self setTextColor:[UIColor colorWithRed:244.0/255.0 green:66.0/255.0 blue:66.0/255.0 alpha:1.0] forState:WTPerformanceStateBad];
    [self setTextColor:[UIColor orangeColor] forState:WTPerformanceStateWarning];
    [self setTextColor:[UIColor colorWithRed:66.0/255.0 green:244.0/255.0 blue:89.0/255.0 alpha:1.0] forState:WTPerformanceStateGood];
    self.state = WTPerformanceStateGood;
}

- (void)setTextColor:(UIColor *)textColor forState:(WTPerformanceLabelState)state{
    if (textColor) {
        [self.configCache setObject:textColor forKey:@(state)];
    }else{
        [self.configCache removeObjectForKey:@(state)];
    }
}

- (UIColor *)textColorForState:(WTPerformanceLabelState)state
{
    return [self.configCache objectForKey:@(state)];
}

- (void)setState:(WTPerformanceLabelState)state
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
