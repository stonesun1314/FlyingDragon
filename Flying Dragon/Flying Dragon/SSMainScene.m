

//
//  SSMainScene.m
//  Flying Dragon
//
//  Created by SunStone on 14-6-15.
//  Copyright (c) 2014年 SunStone. All rights reserved.
//

#import "SSMainScene.h"

#import "SSFoeCloud.h"

#define kSSFirstLevelDuringTime       10
#define kSSSecondLevelDuringTime      12
#define kSSThirdLevelDuringTime       15




// 角色类别
typedef NS_ENUM(uint32_t, SSRoleCategory){
    SSRoleCategoryDragon = 1,
    SSRoleCategoryCloud = 4,
};

@interface SSMainScene ()<SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;

    int _adjustmentBackgroundPosition;
    
    int _foecloudTime;
}

@property (nonatomic, retain) SKSpriteNode *backgroundSprite;

@property (nonatomic, retain) SKSpriteNode *flyingDragonSprite;

@end

@implementation SSMainScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [UIColor clearColor];
        
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0,0);
        
        screenHeight = kSSScreenHeight;
        screenWidth = kSSScreenWidth;
        
        _adjustmentBackgroundPosition = kSSScreenHeight;
        

        
        [self initBackground];
        [self initFlyingDragon];

    }
    return self;
}

- (void)initBackground{
    self.backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"game_bg.jpg"];
    //self.backgroundSprite.yScale=768/3072;   //缩放比例
    self.backgroundSprite.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    [self addChild:self.backgroundSprite];
}

- (void)initGame{
    
    [self removeAllActions];
    [self removeAllChildren];
    _foecloudTime = 120;
    
    self.gameState = SSGamePlaying;
    [self initBackground];
    [self initFlyingDragon];
    
}

- (void)initFlyingDragon{
    self.flyingDragonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"dragon0001.png"];
    self.flyingDragonSprite.xScale = 0.4;
    self.flyingDragonSprite.yScale = 0.4;
    self.flyingDragonSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-200);
    self.flyingDragonSprite.zPosition = 1;
    //self.flyingDragonSprite.physicsBody.dynamic = YES; // 2
    self.flyingDragonSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.flyingDragonSprite.size];
    self.flyingDragonSprite.physicsBody.categoryBitMask = SSRoleCategoryDragon;
    self.flyingDragonSprite.physicsBody.collisionBitMask = SSRoleCategoryCloud;
    self.flyingDragonSprite.physicsBody.contactTestBitMask = SSRoleCategoryCloud;
    SKTexture *dragon1=[SKTexture textureWithImageNamed:@"dragon0001.png"];
    SKTexture *dragon2=[SKTexture textureWithImageNamed:@"dragon0002.png"];
    SKTexture *dragon3=[SKTexture textureWithImageNamed:@"dragon0003.png"];
    SKTexture *dragon4=[SKTexture textureWithImageNamed:@"dragon0004.png"];
    
    SKAction *dragonAction=[SKAction animateWithTextures:@[dragon1,dragon2,dragon3,dragon4] timePerFrame:0.1];
    SKAction *spinForever=[SKAction repeatActionForever:dragonAction];
    [self.flyingDragonSprite runAction:spinForever];
    [self addChild:self.flyingDragonSprite];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    if (self.gameState == SSGamePlaying) {
       [self createFoeCloud]; 
    }
    
    [self scrollBackground];
}

#pragma mark
- (void)createFoeCloud{
    
    _foecloudTime++;
    
    SSFoeCloud * (^create)() = ^(){
        
        int x = (arc4random() % 720) + 35;
        int type = (arc4random() % 7)+1;
        
        SSFoeCloud *foeCloud = [SSFoeCloud spriteNodeWithImageNamed:[NSString stringWithFormat:@"game00%d.png",type]];
        
        [foeCloud setScale:0.5];
        
        foeCloud.zPosition = 1;
        foeCloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:foeCloud.size];
        foeCloud.physicsBody.categoryBitMask = SSRoleCategoryCloud;
        foeCloud.physicsBody.collisionBitMask = SSRoleCategoryDragon;
        foeCloud.physicsBody.contactTestBitMask = SSRoleCategoryDragon;
        foeCloud.position = CGPointMake(x, self.size.height);
        
        return foeCloud;
    };
    
    if (_foecloudTime > 150) {
        float speed = (arc4random() % 5) + 15;
        
        SSFoeCloud *foeCloud = create();
        [self addChild:foeCloud];
        [foeCloud runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        _foecloudTime = 0;
    }
}


- (void)didBeginContact:(SKPhysicsContact *)contact{
    NSLog(@"碰撞检测");
    if (contact.bodyA.categoryBitMask & SSRoleCategoryCloud || contact.bodyB.categoryBitMask & SSRoleCategoryCloud) {
        
        
        if (contact.bodyA.categoryBitMask & SSRoleCategoryDragon || contact.bodyB.categoryBitMask & SSRoleCategoryDragon) {
            
            SKSpriteNode *dragon = (contact.bodyA.categoryBitMask & SSRoleCategoryDragon) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self dragonCollisionAnimation:dragon];
        }
    }
}
- (void)didEndContact:(SKPhysicsContact *)contact{

}

- (void)startGame:(SSGameLevel)gamelevel{
    if (gamelevel == SSGameFirstLevel) {       //第一关
        [self initGame];
    }else if(gamelevel == SSGameSecondLevel){   //第二关
        [self initGame];
    }else if (gamelevel == SSGameThirdLevel){  //第三关
        [self initGame];
    }
}

#pragma mark 
- (void)scrollBackground{
    
    _adjustmentBackgroundPosition--;
    
    if (_adjustmentBackgroundPosition <= 0)
    {
        _adjustmentBackgroundPosition = 768;
    }
    
    [self.backgroundSprite setPosition:CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition )];
}

- (void)dragonCollisionAnimation:(SKSpriteNode *)sprite{
    
    
    if (sprite == self.flyingDragonSprite) {
        
        self.gameState = SSGameOver;
        if ([self.delegate respondsToSelector:@selector(gameOver)]) {
            [self.delegate gameOver];
        }
        [self.flyingDragonSprite runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:0.8],[SKAction removeFromParent]]]];
    }

}

- (void)moveLeft{
    if (self.gameState == SSGamePlaying && (self.flyingDragonSprite.position.x > (self.flyingDragonSprite.size.width/2 +50))) {
        CGFloat moveToX = self.flyingDragonSprite.position.x - 50;
        SKAction *action = [SKAction moveToX:moveToX duration:0.2];
        [self.flyingDragonSprite runAction:action];
    }
}

- (void)moveRight{
    if (self.gameState == SSGamePlaying && (self.flyingDragonSprite.position.x < (self.frame.size.width - self.flyingDragonSprite.size.width/2)-50)) {
        CGFloat moveToX = self.flyingDragonSprite.position.x + 50;
        SKAction *action = [SKAction moveToX:moveToX duration:0.2];
        [self.flyingDragonSprite runAction:action];
    }

}


@end
