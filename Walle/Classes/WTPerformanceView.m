//
//  WTPerformanceView.m
//  Walle
//
//  Created by walter on 07/07/2017.
//

#import "WTPerformanceView.h"
#import "WTPerformanceLabel.h"

@interface WTPerformanceView()

@property (nonatomic, strong) UIWindow *performanceBar;

@property (nonatomic, strong) WTPerformanceLabel *fpsLabel;

@property (nonatomic, strong) WTPerformanceLabel *memoryLabel;

@property (nonatomic, strong) WTPerformanceLabel *cpuLabel;

@property (nonatomic, strong) WTPerformanceLabel *pageRenderLabel;

@end

@implementation WTPerformanceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _performanceBar = [[UIWindow alloc] initWithFrame:self.frame];
        _performanceBar.hidden = YES;
        _performanceBar.windowLevel = UIWindowLevelAlert + 1;
        _performanceBar.backgroundColor = [UIColor clearColor];
        [_performanceBar addSubview:self];
        [self setup];
    }
    return self;
}

- (void)setPerformanceViewData:(CGFloat)cpu memory:(CGFloat)memory FPS:(CGFloat)FPS render:(CGFloat)render
{
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS:%d",(int)round(FPS)];
    self.fpsLabel.state = [self labelStateWith:WTPerformanceMonitorFPS performanceValue:FPS];
    self.fpsLabel.backgroundColor = [UIColor whiteColor];
    self.memoryLabel.text = [NSString stringWithFormat:@"MEM:%.2f", memory];
    self.memoryLabel.state = [self labelStateWith:WTPerformanceMonitorMemory performanceValue:memory];
    self.memoryLabel.backgroundColor = [UIColor whiteColor];
    self.cpuLabel.text = [NSString stringWithFormat:@"CPU:%.2f", cpu];
    self.cpuLabel.state = [self labelStateWith:WTPerformanceMonitorCPU performanceValue:cpu];
    self.cpuLabel.backgroundColor = [UIColor whiteColor];
    self.pageRenderLabel.text = [NSString stringWithFormat:@"RENDER:%.2f", render];
    self.pageRenderLabel.state = [self labelStateWith:WTPerformanceMonitorRender performanceValue:render];
    self.pageRenderLabel.backgroundColor = [UIColor whiteColor];
}

- (void)showPerformacneView:(BOOL)isShown
{
    self.performanceBar.hidden = !isShown;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    _fpsLabel = [[WTPerformanceLabel alloc] initWithFrame:CGRectZero];
    _fpsLabel.font = [UIFont systemFontOfSize:10];
    _fpsLabel.textColor = [UIColor whiteColor];
    _fpsLabel.text = @"FPS: d-";
    _fpsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_fpsLabel];
    
    _memoryLabel = [[WTPerformanceLabel alloc] initWithFrame:CGRectZero];
    _memoryLabel.font = [UIFont systemFontOfSize:10];
    _memoryLabel.textColor = [UIColor whiteColor];
    _memoryLabel.text = @"Memory:-";
    _memoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_memoryLabel];
    
    _cpuLabel = [[WTPerformanceLabel alloc] initWithFrame:CGRectZero];
    _cpuLabel.font = [UIFont systemFontOfSize:10];
    _cpuLabel.textColor = [UIColor whiteColor];
    _cpuLabel.text = @"CPU:-";
    _cpuLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_cpuLabel];
    
    _pageRenderLabel = [[WTPerformanceLabel alloc] initWithFrame:CGRectZero];
    _pageRenderLabel.font = [UIFont systemFontOfSize:10];
    _pageRenderLabel.textColor = [UIColor whiteColor];
    _pageRenderLabel.text = @"RENDER:-";
    _pageRenderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_pageRenderLabel];
    //Layout
    NSDictionary * subviews = NSDictionaryOfVariableBindings(_fpsLabel,_memoryLabel,_cpuLabel,_pageRenderLabel);
    //CenterY
    for (UIView * label in subviews.allValues) {
        [self addConstraint:[NSLayoutConstraint constraintWithItem:label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
    }
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_fpsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:50]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_fpsLabel]-8-[_memoryLabel]-8-[_cpuLabel]-8-[_pageRenderLabel]" options:0 metrics:nil views:subviews]];
}

- (WTPerformanceLabelState)labelStateWith:(WTPerformanceMonitorType)monitorType performanceValue:(CGFloat)performanceValue
{
    switch (monitorType) {
        case WTPerformanceMonitorFPS:
            if (performanceValue > 55) {
                return WTPerformanceStateGood;
            }else if (performanceValue > 40){
                return WTPerformanceStateWarning;
            }else{
                return WTPerformanceStateBad;
            }
            break;
        case WTPerformanceMonitorCPU:
            if (performanceValue < 70.0) {
                return WTPerformanceStateGood;
            }else if (performanceValue < 90){
                return WTPerformanceStateWarning;
            }else{
                return WTPerformanceStateBad;
            }
            break;
        case WTPerformanceMonitorMemory:
            if (performanceValue < 150) {
                return WTPerformanceStateGood;
            }else if (performanceValue < 200){
                return WTPerformanceStateWarning;
            }else{
                return WTPerformanceStateBad;
            }
            break;
        case WTPerformanceMonitorRender:
            if (performanceValue < 1.0) {
                return WTPerformanceStateGood;
            }else if (performanceValue < 1.5){
                return WTPerformanceStateWarning;
            }else{
                return WTPerformanceStateBad;
            }
            break;
        default:
            break;
    }
}

@end
