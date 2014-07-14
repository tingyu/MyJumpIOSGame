//
//  Level.m
//  TJumpGame
//
//  Created by Ting on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Level.h"

static const CGFloat scrollSpeed = 80.f;
static const CGFloat leftSpeed = 40.f;
static const CGFloat rightSpeed = 40.f;

@implementation Level{
    CCPhysicsNode *_physicsNode;
    CCNode *_levelNode;
    CCSprite *_hero;
    CCNode *_block1;
    CCNode *_block2;
    NSArray *_blocks;
    BOOL _jumped;
    CGPoint touchLocation;
}
/*
// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [_hero.physicsBody applyImpulse:ccp(0, 400.f)];
    /*
     [_hero.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
     if (!_jumped) {
     [_hero.physicsBody applyImpulse:ccp(0, 2000)];
     _jumped = TRUE;
     [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
     }
     }];*/
    
    // we want to know the location of our touch in this scene
 //   touchLocation = [touch locationInNode:<#(CCNode *)#>];
//}
/*
- (void)update:(CCTime)delta {
    if (touchLocation.x < _hero.position.x) {
        _hero.position = ccp(_hero.position.x - delta * leftSpeed, _hero.position.y + delta * scrollSpeed);
    }else if (touchLocation.x > _hero.position.x){
        _hero.position = ccp(_hero.position.x + delta * rightSpeed, _hero.position.y + delta * scrollSpeed);
    }else{
        _hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
    }
    _hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
   // _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (rightSpeed *delta));
    
    // loop the blocks
    /*
     for (CCNode *block in _blocks) {
     // get the world position of the ground
     CGPoint blockWorldPosition = [_physicsNode convertToWorldSpace:block.position];
     // get the screen position of the ground
     CGPoint blockScreenPosition = [self convertToNodeSpace:blockWorldPosition];
     // if the left corner is one complete width off the screen, move it to the right
     if (blockScreenPosition.y <= (-1 * block.contentSize.height)) {
     block.position = ccp(block.position.x, block.position.y  + 2 * block.contentSize.height);
     }
     }*/
    
    
    // clamp velocity
/*
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);
}*/



@end
