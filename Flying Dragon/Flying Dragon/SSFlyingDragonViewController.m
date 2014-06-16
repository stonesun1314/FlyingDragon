//
//  SSFlyingDragonViewController.m
//  Flying Dragon
//
//  Created by SunStone on 14-6-15.
//  Copyright (c) 2014年 SunStone. All rights reserved.
//

#import "SSFlyingDragonViewController.h"
#import "SSMainScene.h"



@interface SSFlyingDragonViewController ()

@property (nonatomic, retain) SKView *skView;

@end

@implementation SSFlyingDragonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Configure the view.
    self.skView = [[SKView alloc] initWithFrame:self.view.bounds];
    self.skView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
    [self.view addSubview:self.skView];

    
    // Create and configure the scene.
    SKScene * scene = [SSMainScene sceneWithSize:self.skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [self.skView presentScene:scene];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
