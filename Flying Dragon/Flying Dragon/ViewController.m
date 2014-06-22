//
//  ViewController.m
//  Flying Dragon
//
//  Created by SunStone on 14-6-14.
//  Copyright (c) 2014年 SunStone. All rights reserved.
//

#import "ViewController.h"
#import "SSFlyingDragonViewController.h"


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200,1024, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Zapfino" size:28];
    label.textColor = [UIColor redColor];
    label.text = @"Welcome to Flying Dragon";
    [self.view addSubview:label];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 350, 1024, 60);
    button.titleLabel.font = [UIFont fontWithName:@"MarkerFelt-Thin" size:28];
    [button setTitle:@"Enter game" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(enterGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    

}

- (void)enterGame:(UIButton *)sender{
    SSFlyingDragonViewController *gameViewController = [[SSFlyingDragonViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:gameViewController animated:YES completion:nil];
}


- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskLandscape;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
