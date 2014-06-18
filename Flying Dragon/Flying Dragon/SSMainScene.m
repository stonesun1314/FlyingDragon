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


#define kSSScreenWidth                  1024
#define kSSScreenHeight                 768

// 角色类别
typedef NS_ENUM(uint32_t, SSRoleCategory){
    SSRoleCategoryDragon = 1,
    SSRoleCategoryCloud = 4,
};

@interface SSMainScene ()<SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;
    
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
        _foecloudTime = 0;
        
        self.backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"game_bg.jpg"];
        //self.backgroundSprite.yScale=768/3072;   //缩放比例
        self.backgroundSprite.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:self.backgroundSprite];
        
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
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self createFoeCloud];
    //[self scrollBackground];
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
    
    if (_foecloudTime > 100) {
        float speed = (arc4random() % 5) + 20;
        
        SSFoeCloud *foeCloud = create();
        [self addChild:foeCloud];
        [foeCloud runAction:[SKAction sequence:@[[SKAction moveToY:0 duration:speed],[SKAction removeFromParent]]]];
        
        _foecloudTime = 0;
    }
}


- (void)didBeginContact:(SKPhysicsContact *)contact{
    NSLog(@"碰撞检测");
    if (contact.bodyA.categoryBitMask & SSRoleCategoryCloud || contact.bodyB.categoryBitMask & SSRoleCategoryCloud) {
        
        SSFoeCloud *sprite = (contact.bodyA.categoryBitMask & SSRoleCategoryCloud) ? (SSFoeCloud *)contact.bodyA.node : (SSFoeCloud *)contact.bodyB.node;
        
        if (contact.bodyA.categoryBitMask & SSRoleCategoryDragon || contact.bodyB.categoryBitMask & SSRoleCategoryDragon) {
            
            SKSpriteNode *playerPlane = (contact.bodyA.categoryBitMask & SSRoleCategoryDragon) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self playerPlaneCollisionAnimation:playerPlane];
        }else{
            SKSpriteNode *bullet = (contact.bodyA.categoryBitMask & SSRoleCategoryCloud) ? (SSFoeCloud *)contact.bodyB.node : (SSFoeCloud *)contact.bodyA.node;
            [bullet removeFromParent];
            [self foeCloudCollisionAnimation:sprite];
        }
    }
}
- (void)didEndContact:(SKPhysicsContact *)contact{

}

- (void)startGame:(NSInteger)level{
    if (level == 1) {       //第一关
        
    }else if(level == 2){   //第二关
        
    }else if (level == 3){  //第三关
    
    }
}

#pragma mark 
- (void)scrollBackground{
    
    _adjustmentBackgroundPosition--;
    
    if (_adjustmentBackgroundPosition <= 0)
    {
        _adjustmentBackgroundPosition = 3072;
    }
    
    [self.backgroundSprite setPosition:CGPointMake(self.size.width / 2, _adjustmentBackgroundPosition - kSSScreenHeight)];
}

- (void)playerPlaneCollisionAnimation:(SKSpriteNode *)sprite{
    
    [self removeAllActions];

}

- (void)foeCloudCollisionAnimation:(SSFoeCloud *)sprite{
    
}

@end
