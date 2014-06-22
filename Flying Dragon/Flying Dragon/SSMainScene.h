//
//  SSMainScene.h
//  Flying Dragon
//
//  Created by SunStone on 14-6-15.
//  Copyright (c) 2014年 SunStone. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define kSSScreenWidth                  1024
#define kSSScreenHeight                 768

typedef NS_ENUM(NSInteger, SSGameState) {
    SSGameStart,
    SSGamePlaying,
    SSGamePause,
    SSGameOver,
};

typedef NS_ENUM(NSInteger, SSGameLevel) {
    SSGameFirstLevel,
    SSGameSecondLevel,
    SSGameThirdLevel,
};

@protocol SSMainSceneDelegate <NSObject>
- (void) gameStart;
- (void) gamePlay;
- (void) gameOver;
@end

@interface SSMainScene : SKScene

@property (nonatomic, assign) id<SSMainSceneDelegate> delegate;

@property (nonatomic, assign) SSGameState gameState;

@property (nonatomic, assign, readonly) SSGameLevel gameLevel;

- (void)startGame:(SSGameLevel)gamelevel;

- (void)moveLeft;

- (void)moveRight;

@end
