//
//  SSMainScene.m
//  Flying Dragon
//
//  Created by SunStone on 14-6-15.
//  Copyright (c) 2014年 SunStone. All rights reserved.
//

#import "SSMainScene.h"

// 角色类别
typedef NS_ENUM(uint32_t, SSRoleCategory){
    SSRoleCategoryDragon = 1,
    SKRoleCategoryCloud = 4,
};

@interface SSMainScene ()<SKPhysicsContactDelegate>{
    CGRect screenRect;
    CGFloat screenHeight;
    CGFloat screenWidth;
    double currentMaxAccelX;
    double currentMaxAccelY;
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
        
        screenRect=[[UIScreen mainScreen] bounds];
        screenHeight=screenRect.size.height;
        screenWidth=screenRect.size.width;
        
        self.backgroundSprite = [SKSpriteNode spriteNodeWithImageNamed:@"game_bg.jpg"];
        //self.backgroundSprite.yScale=768/3072;   //缩放比例
        self.backgroundSprite.position=CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.backgroundSprite];
        
        self.flyingDragonSprite = [SKSpriteNode spriteNodeWithImageNamed:@"dragon0001.png"];
        self.flyingDragonSprite.xScale = 0.3;
        self.flyingDragonSprite.yScale = 0.3;
        self.flyingDragonSprite.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100);
        self.flyingDragonSprite.zPosition = 1;
        self.flyingDragonSprite.physicsBody.dynamic = YES; // 2
        self.flyingDragonSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.flyingDragonSprite.size];
        self.flyingDragonSprite.physicsBody.categoryBitMask = SKRoleCategoryCloud;
        self.flyingDragonSprite.physicsBody.collisionBitMask = 0;
        self.flyingDragonSprite.physicsBody.contactTestBitMask = SKRoleCategoryCloud;
        
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
}

#pragma mark
- (void)createCloud{
    
}


- (void)didBeginContact:(SKPhysicsContact *)contact{

}
- (void)didEndContact:(SKPhysicsContact *)contact{

}


@end
