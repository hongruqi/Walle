//
//  XYPerformanceView.m
//  Walle
//
//  Created by hongru qi on 07/07/2017.
//

#import "XYPerformanceView.h"
#import "XYPerformanceLabel.h"

@interface XYPerformanceView()

@property (nonatomic, strong) UIWindow *performanceBar;

@property (strong, nonatomic) XYPerformanceLabel * fpsLabel;

@property (strong, nonatomic) XYPerformanceLabel * memoryLabel;

@property (strong, nonatomic) XYPerformanceLabel * cpuLabel;

@end

@implementation XYPerformanceView

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

- (void)setPerformanceViewData:(CGFloat)cpu memory:(CGFloat)memory FPS:(CGFloat)FPS
{
    self.fpsLabel.text = [NSString stringWithFormat:@"FPS:%d",(int)round(FPS)];
    self.fpsLabel.state = [self labelStateWith:XYPerformanceMonitorFPS performanceValue:FPS];
    self.fpsLabel.backgroundColor = [UIColor whiteColor];
    self.memoryLabel.text = [NSString stringWithFormat:@"MEM:%.2f", memory];
    self.memoryLabel.state = [self labelStateWith:XYPerformanceMonitorMemory performanceValue:memory];
    self.memoryLabel.backgroundColor = [UIColor whiteColor];
    self.cpuLabel.text = [NSString stringWithFormat:@"CPU:%.2f", cpu];
    self.cpuLabel.state = [self labelStateWith:XYPerformanceMonitorCPU performanceValue:cpu];
    self.cpuLabel.backgroundColor = [UIColor whiteColor];
}

- (void)showPerformacneView:(BOOL)isShown
{
    self.performanceBar.hidden = !isShown;
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    _fpsLabel = [[XYPerformanceLabel alloc] initWithFrame:CGRectZero];
    _fpsLabel.font = [UIFont systemFontOfSize:10];
    _fpsLabel.textColor = [UIColor whiteColor];
    _fpsLabel.text = @"FPS: d-";
    _fpsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_fpsLabel];
    
    _memoryLabel = [[XYPerformanceLabel alloc] initWithFrame:CGRectZero];
    _memoryLabel.font = [UIFont systemFontOfSize:10];
    _memoryLabel.textColor = [UIColor whiteColor];
    _memoryLabel.text = @"Memory:-";
    _memoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_memoryLabel];
    
    _cpuLabel = [[XYPerformanceLabel alloc] initWithFrame:CGRectZero];
    _cpuLabel.font = [UIFont systemFontOfSize:10];
    _cpuLabel.textColor = [UIColor whiteColor];
    _cpuLabel.text = @"CPU:-";
    _cpuLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_cpuLabel];
    
    //Layout
    NSDictionary * subviews = NSDictionaryOfVariableBindings(_fpsLabel,_memoryLabel,_cpuLabel);
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
    //CenterX
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_memoryLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_fpsLabel]-8-[_memoryLabel]-8-[_cpuLabel]" options:0 metrics:nil views:subviews]];
}

- (XYPerformanceLabelState)labelStateWith:(XYPerformanceMonitorType)monitorType performanceValue:(CGFloat)performanceValue
{
    switch (monitorType) {
        case XYPerformanceMonitorFPS:
            if (performanceValue > 55) {
                return XYPerformanceStateGood;
            }else if (performanceValue > 40){
                return XYPerformanceStateWarning;
            }else{
                return XYPerformanceStateBad;
            }
            break;
        case XYPerformanceMonitorCPU:
            if (performanceValue < 70.0) {
                return XYPerformanceStateGood;
            }else if (performanceValue < 90){
                return XYPerformanceStateWarning;
            }else{
                return XYPerformanceStateBad;
            }
            break;
        case XYPerformanceMonitorMemory:
            if (performanceValue < 150) {
                return XYPerformanceStateGood;
            }else if (performanceValue < 200){
                return XYPerformanceStateWarning;
            }else{
                return XYPerformanceStateBad;
            }
            break;
            
        default:
            break;
    }
}

@end
