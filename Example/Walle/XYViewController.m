//
//  XYViewController.m
//  Walle
//
//  Created by lbrsilva-allin on 07/04/2017.
//  Copyright (c) 2017 lbrsilva-allin. All rights reserved.
//

#import "XYViewController.h"
#import "XYPerformanceMonitor.h"

@interface XYViewController ()

@end

@implementation XYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[XYPerformanceMonitor sharedInstance] startMonitor: YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
