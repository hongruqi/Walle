//
//  WTViewController.m
//  Walle
//
//  Created by lbrsilva-allin on 07/04/2017.
//  Copyright (c) 2017 lbrsilva-allin. All rights reserved.
//

#import "XYViewController.h"
#import "WTPerformanceMonitor.h"
#import "XYOneViewController.h"

@interface XYViewController ()

@property (nonatomic, strong) UIButton *pushButton;

@end

@implementation XYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
     [[WTPerformanceMonitor sharedInstance] startMonitorWithBar: YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.pushButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.pushButton addTarget:self action:@selector(pushOneViewController) forControlEvents:UIControlEventTouchUpInside];
    [self.pushButton setTitle:@"push" forState:UIControlStateNormal];
    [self.pushButton setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:self.pushButton];
}

- (void)pushOneViewController
{
    XYOneViewController *oneVC = [[XYOneViewController alloc] init];
    [self.navigationController pushViewController:oneVC animated:YES];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
