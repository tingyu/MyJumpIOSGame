//
//  GamePlay.m
//  TJumpGame
//
//  Created by Ting on 7/1/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GamePlay.h"
#import "Character.h"
#import "CCPhysics+ObjectiveChipmunk.h"
static const CGFloat scrollSpeed = 80.f;
static const CGFloat leftSpeed = 40.f;
static const CGFloat rightSpeed = 40.f;


@implementation GamePlay{
    CCPhysicsNode *_physicsNode;
    CCNode *_levelNode;
    CCSprite *_hero;
    BOOL _jumped;
    CGPoint touchLocation;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
   // CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    //[_levelNode addChild:level];
    _physicsNode.collisionDelegate = self;
    
    // visualize physics bodies & joints
    _physicsNode.debugDraw = TRUE;
    
     //_hero = (Character*)[CCBReader load:@"Hero"];
    
    //_hero.position = ccp(100, 100);
    //[self addChild:_hero];
    //_hero.xVel = 0;
    //_hero.yVel = 0;
    /*
    xVel = 0;
    yVel = 0;
    [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(check) userInfo:nil repeats:YES];*/
    
}

// on "init" you need to initialize your instance
/*
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		//self.isTouchEnabled = YES;
		_hero.xVel = 0;
		_hero.yVel = 0;
		[NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(check) userInfo:nil repeats:YES];
	}
	return self;
}*/
/*
-(id) init{
    if( (self = [super init])){
       // self.isTouchEnabled = YES;
        _hero.position = ccp(40, 40);
        [self addChild:_hero];
        _hero.xVel = 0;
        _hero.yVel = 0;
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(check) userInfo:nil repeats:YES];
    }
}*/
/*
-(void) check{
    if(_hero.position.y > 39){
        _hero.yVel -= 0.1;
        //yVel -= 0.1;
    }else{/*
        if(yVel != 6){
            yVel = 0;
            xVel = 0;
        }*/
/*
        if(_hero.yVel != 6){
            _hero.yVel = 0;
            _hero.xVel = 0;
        }
    }
    _hero.position = ccp(_hero.position.x + _hero.xVel, _hero.position.y + _hero.yVel);
    //_hero.position = ccp(_hero.position.x + xVel, _hero.position.y + yVel);
    //CCLOG(@"Move!!");
}
*/
// called on every touch in this scene
//- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    CCLOG(@"Touch!!");
    /*
    yVel = 20;
    xVel = 0.5;
    if(yVel !=0){
        CCLOG(@"should Move!!");*/
 /*
    _hero.yVel = 40;
    _hero.xVel = 0.5;
    if(_hero.yVel !=0){
        CCLOG(@"should Move!!");
    }
    _hero.position = ccp(_hero.position.x + _hero.xVel, _hero.position.y + _hero.yVel);
*/
    /*
    [_hero.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
        if (!_jumped) {
            [_hero.physicsBody applyImpulse:ccp(0, 2000)];
            _jumped = TRUE;
            [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
        }
    }];*/
//}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [_hero.physicsBody applyImpulse:ccp(0, 400.f)];
    
    // we want to know the location of our touch in this scene
    touchLocation = [touch locationInNode:self];
}
- (void)update:(CCTime)delta {
    if (touchLocation.x < _hero.position.x) {
    _hero.position = ccp(_hero.position.x - delta * leftSpeed, _hero.position.y + delta * scrollSpeed);
    }else if (touchLocation.x > _hero.position.x){
        _hero.position = ccp(_hero.position.x + delta * rightSpeed, _hero.position.y + delta * scrollSpeed);
    }else{
        _hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
    }
    _hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
    _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (rightSpeed *delta));
    // loop the ground

    
    // clamp velocity
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);
}


@end
