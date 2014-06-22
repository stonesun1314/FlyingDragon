//
//  SSFlyingDragonViewController.m
//  Flying Dragon
//
//  Created by SunStone on 14-6-15.
//  Copyright (c) 2014年 SunStone. All rights reserved.
//

#import "SSFlyingDragonViewController.h"
#import "SSMainScene.h"


@interface SSFlyingDragonViewController ()<SSMainSceneDelegate>

@property (nonatomic, strong) SKView *skView;

@property (nonatomic, strong) UIView *gameOverView;

@property (nonatomic, strong) UIView *gameReadyView;

@property (nonatomic, retain) UIButton *btnMoveLeft;

@property (nonatomic, retain) UIButton *btnMoveRight;

@property (nonatomic, retain) UIButton *btnFirstLevel;

@property (nonatomic, retain) UIButton *btnSecondLevel;

@property (nonatomic, retain) UIButton *btnThirdLevel;

@property (nonatomic, retain) SSMainScene *mainScene;

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
    self.view = self.skView;

    
    // Create and configure the scene.
    self.mainScene = [SSMainScene sceneWithSize:self.skView.bounds.size];
    self.mainScene.scaleMode = SKSceneScaleModeAspectFill;
    self.mainScene.delegate = self;
    // Present the scene.
    [self.skView presentScene:self.mainScene];
    
    [self.view addSubview:self.gameOverView];
    
    [self initHandles];
    
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


#pragma mark ---lifeStyle

- (void)initHandles{
    _btnMoveLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMoveLeft.frame = CGRectMake(20, 650, 120, 80);
    _btnMoveLeft.backgroundColor = [UIColor redColor];
    [_btnMoveLeft setTitle:@"Left" forState:UIControlStateNormal];
    [_btnMoveLeft addTarget:self action:@selector(moveLeft:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnMoveLeft];
    
    _btnMoveRight = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnMoveRight.frame = CGRectMake(884, 650, 120, 80);
    _btnMoveRight.backgroundColor = [UIColor redColor];
    [_btnMoveRight setTitle:@"Right" forState:UIControlStateNormal];
    [_btnMoveRight addTarget:self action:@selector(moveRight:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_btnMoveRight];
}

- (void) shakeFrame
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:4];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.view  center].x - 4.0f, [self.view  center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.view  center].x + 4.0f, [self.view  center].y)]];
    [[self.skView layer] addAnimation:animation forKey:@"position"];
}


- (UIView *)gameOverView{
    
    if (_gameOverView == nil) {
        _gameOverView = [[UIView alloc] initWithFrame:self.view.bounds];
        _gameOverView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:.0 alpha:0.5];
        _gameOverView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        _btnFirstLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFirstLevel.frame = CGRectMake(kSSScreenWidth/3, kSSScreenHeight/2-30, 80, 60);
        [_btnFirstLevel setTitle:@"第一关" forState:UIControlStateNormal];
        [_btnFirstLevel setBackgroundColor:[UIColor redColor]];
        [_btnFirstLevel addTarget:self action:@selector(startFirstLevel:) forControlEvents:UIControlEventTouchUpInside];
        [_gameOverView addSubview:_btnFirstLevel];
        
        _btnSecondLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSecondLevel setTitle:@"第二关" forState:UIControlStateNormal];
        _btnSecondLevel.frame = CGRectMake(kSSScreenWidth/3+130, kSSScreenHeight/2-30, 80, 60);
        [_btnSecondLevel addTarget:self action:@selector(startSecondLevel:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSecondLevel setBackgroundColor:[UIColor redColor]];
        [_gameOverView addSubview:_btnSecondLevel];
        
        _btnThirdLevel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnThirdLevel setTitle:@"第三关" forState:UIControlStateNormal];
        _btnThirdLevel.frame = CGRectMake(kSSScreenWidth/3+260, kSSScreenHeight/2-30, 80, 60);
        [_btnThirdLevel addTarget:self action:@selector(startThirdLevel:) forControlEvents:UIControlEventTouchUpInside];
        [_btnThirdLevel setBackgroundColor:[UIColor redColor]];
        [_gameOverView addSubview:_btnThirdLevel];
    }
    
    return _gameOverView;
}


#pragma mark ---SSM

- (void) gameStart{
    
    

}
- (void) gamePlay:(SSGameLevel)level{
    [UIView animateWithDuration:0.1
                          delay:.0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.gameOverView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self.mainScene startGame:level];
                     }];
    
}
- (void) gameOver{
    
    [self shakeFrame];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.gameOverView.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
                         }
                     }];
    
}


#pragma mark ---Action
- (void)startFirstLevel:(UIButton *)sender{
    [self gamePlay:SSGameFirstLevel];
}

- (void)startSecondLevel:(UIButton *)sender{
    [self gamePlay:SSGameSecondLevel];
}

- (void)startThirdLevel:(UIButton *)sender{
    [self gamePlay:SSGameThirdLevel];
}

- (void)moveLeft:(UIButton *)sender{
    [self.mainScene moveLeft];
}

- (void)moveRight:(UIButton *)sender{
    [self.mainScene moveRight];
}

@end
