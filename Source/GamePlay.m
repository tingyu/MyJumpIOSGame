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
#import "Level.h"

static const CGFloat scrollSpeed = 80.f;
static const CGFloat leftSpeed = 40.f;
static const CGFloat rightSpeed = 40.f;

static NSString * const kFirstLevel = @"Level1";
static NSString *selectedLevel = @"Level1";
//static int levelSpeed = 0;


@implementation GamePlay{
    CCPhysicsNode *_physicsNode;
    CCNode *_levelNode;
    CCSprite *_hero;
    CCNode *_block1;
    CCNode *_block2;
    NSArray *_blocks;
    BOOL _jumped;
    CGPoint touchLocation;
    
    Level *_loadedLevel;
    CCLabelTTF *_scoreLabel;
    int _score;

}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    
    _physicsNode =_loadedLevel.physicsNode;
    _hero = _loadedLevel.hero;
    _block1 = _loadedLevel.block1;
    _block2 = _loadedLevel.block2;
    _score = _loadedLevel.score;
    // tell this scene to accept touches
    //self.userInteractionEnabled = TRUE;
    // CCScene *level = [CCBReader loadAsScene:@"Levels/block1"];
    //[_levelNode addChild:level];
    
    //levelSpeed = _loadedLevel.levelSpeed;
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    _blocks = @[_block1, _block2];
    
}

- (void)onEnter {
    [super onEnter];
    
    //CCActionFollow *follow = [CCActionFollow actionWithTarget:_hero worldBoundary:[_loadedLevel boundingBox]];
   // _physicsNode.position = [follow currentOffset];
    //[_physicsNode runAction:follow];
}

- (void)onEnterTransitionDidFinish {
    [super onEnterTransitionDidFinish];
    
    self.userInteractionEnabled = YES;
}

#pragma mark - Level completion

- (void)loadNextLevel {
    selectedLevel = _loadedLevel.nextLevelName;
    
    CCScene *nextScene = nil;
    
    if (selectedLevel) {
        nextScene = [CCBReader loadAsScene:@"Gameplay"];
    } else {
        selectedLevel = kFirstLevel;
        nextScene = [CCBReader loadAsScene:@"StartScene"];
    }
    
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:nextScene withTransition:transition];
}

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
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //[_hero.physicsBody applyImpulse:ccp(0, 400.f)];
    
    [_hero.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
        if (!_jumped) {
            [_hero.physicsBody applyImpulse:ccp(0, 2000)];
            _jumped = TRUE;
            [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.3f];
        }
    }];
    
    // we want to know the location of our touch in this scene
    touchLocation = [touch locationInNode:self];
}


#pragma mark - Player Movement

- (void)resetJump {
    _jumped = FALSE;
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
    
    // loop the blocks
    
    for (CCNode *block in _blocks) {
        // get the world position of the ground
        CGPoint blockWorldPosition = [_physicsNode convertToWorldSpace:block.position];
        // get the screen position of the ground
        CGPoint blockScreenPosition = [self convertToNodeSpace:blockWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (blockScreenPosition.y <= (-1 * block.contentSize.height)) {
            block.position = ccp(block.position.x, block.position.y  + 2 * block.contentSize.height);
        }
    }

    // clamp velocity
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
   _hero.physicsBody.velocity = ccp(0, yVelocity);
    
    //if (CGRectGetMaxY([_hero boundingBox]) <   CGRectGetMinY([_physicsNode boundingBox])) {
    if (_hero.position.y < -1*CGRectGetMinY([_physicsNode boundingBox])) {
        [self gameOver];
    }
    
    CCLOG(@"the hero position is x:%0.2f, y:%0.2f", _hero.position.x, _hero.position.y);
    CCLOG(@"the _physicsNode position is x:%0.2f, y:%0.2f", _physicsNode.position.x, _physicsNode.position.y);
    CCLOG(@"the boundingBox Y position is y:%0.2f", CGRectGetMinY([_physicsNode boundingBox]));


}


- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero star:(CCNode *)star {
 //   [star removeFromParent];
 //   _score++;

    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    
    return YES;
}

#pragma mark - Game Over

- (void)gameOver {
    CCScene *restartScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:restartScene withTransition:transition];
}


@end
