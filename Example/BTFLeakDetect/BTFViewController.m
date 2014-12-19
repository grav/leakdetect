//
//  BTFViewController.m
//  BTFLeakDetect
//
//  Created by Mikkel Gravgaard on 12/19/2014.
//  Copyright (c) 2014 Mikkel Gravgaard. All rights reserved.
//

#import "BTFViewController.h"
#import "BTFLeakDetect.h"
#import "BTFLeakyViewController.h"

@interface BTFViewController ()

@property(nonatomic, strong) UISwitch *leakSwitch;
@end

@implementation BTFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"BTFLeakDetect Example";

    UIButton *presentButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [presentButton setTitle:@"Present" forState:UIControlStateNormal];
    [self.view addSubview:presentButton];
    [presentButton sizeToFit];

    CGPoint p = self.view.center;
    p.y-=100;
    presentButton.center = p;

    [presentButton addTarget:self action:@selector(present) forControlEvents:UIControlEventTouchUpInside];


    UIButton *pushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [pushButton setTitle:@"Push" forState:UIControlStateNormal];
    [self.view addSubview:pushButton];
    [pushButton sizeToFit];
    p.y+=100;
    pushButton.center = p;

    [pushButton addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];

    UILabel *label = [UILabel new];
    label.text = @"Create leaks";
    [label sizeToFit];
    [self.view addSubview:label];
    p.y+=100;
    label.center = p;

    self.leakSwitch = [UISwitch new];
    [self.view addSubview:self.leakSwitch];
    p.y+=50;
    self.leakSwitch.center = p;

    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)push
{
    BTFLeakyViewController *vc = [BTFLeakyViewController new];
    vc.view.backgroundColor = [UIColor yellowColor];

    if(self.leakSwitch.isOn) [vc leak];

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)present
{
    BTFLeakyViewController *vc = [BTFLeakyViewController new];
    vc.title = @"Presented view controller";
    vc.view.backgroundColor = [UIColor greenColor];

    if(self.leakSwitch.isOn) [vc leak];

    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton sizeToFit];
    [vc.view addSubview:dismissButton];
    dismissButton.center = dismissButton.superview.center;
    [self presentViewController:vc animated:YES completion:nil];
    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
