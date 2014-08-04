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
#import "LevelMenu.h"
#import "CCActionFollow+CurrentOffset.h"


static const CGFloat scrollSpeed = 80.f;
static const CGFloat scrollBackgroundSpeed = 20.f;
//static const CGFloat scrollSpeed = 0.f;
static const CGFloat leftSpeed = 40.f;
static const CGFloat rightSpeed = 40.f;

static NSString * const kFirstLevel = @"Level1";
NSString *selectedLevel = @"Level1";
//static int levelSpeed = 0;


@implementation GamePlay{
    CCPhysicsNode *_physicsNode;
    CCNode *_levelNode;
    CCSprite *_hero;
    CCNode *_block1;
    CCNode *_block2;
    CCNode *_star;
    CCNode *_enemy;
    NSArray *_blocks;
    BOOL _jumped;
    CGPoint touchLocation;
    
    Level *_loadedLevel;
    LevelMenu *_mode;
    CCLabelTTF *_scoreLabel;
    int _score;
    int count;
    CCAction *_followHero;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    CCLOG(@"selectedLevel x:%s", selectedLevel);
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    
    _physicsNode =_loadedLevel.physicsNode;
    _hero = _loadedLevel.hero;
    _block1 = _loadedLevel.block1;
    _block2 = _loadedLevel.block2;
    _score = _loadedLevel.score;
    count = 0;
    _star = _loadedLevel.star;
    _enemy = _loadedLevel.enemy;
    // tell this scene to accept touches
    //self.userInteractionEnabled = TRUE;
    // CCScene *level = [CCBReader loadAsScene:@"Levels/block1"];
    //[_levelNode addChild:level];
    
    //levelSpeed = _loadedLevel.levelSpeed;
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    _blocks = @[_block1, _block2];
    
}

- (void)launchEnemy {
    // loads the Penguin.ccb we have set up in Spritebuilder
    CCNode* enemy = [CCBReader load:@"Enemy"];
    // position the penguin at the bowl of the catapult
    enemy.position = ccp(150, 150);
    
    // add the penguin to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:enemy];
    
}

- (void)onEnter {
    [super onEnter];

    //[self launchEnemy];
    /*
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_hero worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
     
    */
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
            [_hero.physicsBody applyImpulse:ccp(0, 1000)];
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
    
    /*
    if(_hero.position.y > 600){
        _physicsNode.position = ccp(_physicsNode.position.x,  _physicsNode.contentSize.height - _hero.position.y + 200);
    }*/
   
    // ensure followed object is in visible are when starting
    //self.position = ccp(0, 0);
    
    // follow the flying penguin
    //_followHero = [CCActionFollow actionWithTarget:_hero worldBoundary:_hero.boundingBox];
    //[_physicsNode runAction:_followHero];
    
    //CCActionFollow *follow = [CCActionFollow actionWithTarget:_hero worldBoundary:self.boundingBox];
    //[self runAction:follow];
    /*
    CCActionFollow *follow = [CCActionFollow actionWithTarget:_hero worldBoundary:[_loadedLevel boundingBox]];
    _physicsNode.position = [follow currentOffset];
    [_physicsNode runAction:follow];
    */
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
    
    //CCLOG(@"the hero position is x:%0.2f, y:%0.2f", _hero.position.x, _hero.position.y);
    //CCLOG(@"the _physicsNode position is x:%0.2f, y:%0.2f", _physicsNode.position.x, _physicsNode.position.y);
    //CCLOG(@"the boundingBox Y position is y:%0.2f", CGRectGetMinY([_physicsNode boundingBox]));

    count++;
    if((count+1)%60 == 0){
        _score++;
    }
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];

}
/*
- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair enemy:(CCNode *)enemy wildcard:(CCNode *)nodeB {
    CCLOG(@"Something collided with a seal!");
    
    float energy = [pair totalKineticEnergy];
    
    // if energy is large enough, remove the seal
    if (energy > 5000.f) {
        [self sealRemoved:enemy];
    }
}*/


- (void)sealRemoved:(CCNode *)seal {
    // load particle effect
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"SealExplosion"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the seals position
    explosion.position = seal.position;
    // add the particle effect to the same node the seal is on
    [seal.parent addChild:explosion];
    
    // finally, remove the destroyed seal
    [seal removeFromParent];
}

//- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)_hero enemy:(CCNode *)_enemy {
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero wildcard:(CCNode *)nodeB {
    NSLog(@"Collision2");
    CCLOG(@"Something collided with a seal!");
    //NSLog(@"%@", hero.physicsBody.collisionType);
    //NSLog(@"%@", _enemy.physicsBody.collisionType);
    //[_enemy removeFromParent];
    _score++;
    
    //_scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    
    return YES;
}


#pragma mark - Game Over

- (void)gameOver {
    CCScene *restartScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:restartScene withTransition:transition];
}


@end
