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
static CGFloat scrollBackgroundSpeed = 0.f;
//static const CGFloat scrollSpeed = 0.f;
static const CGFloat leftSpeed = 40.f;
static const CGFloat rightSpeed = 40.f;

static NSString * const kFirstLevel = @"Level1";
NSString *selectedLevel = @"Level1";
//static int levelSpeed = 0;
#define ARC4RANDOM_MAX      0x100000000



@implementation GamePlay{
    CCPhysicsNode *_physicsNode;
    CCNode *_levelNode;
    CCSprite *_hero;
    CCNode *_block1;
    CCNode *_block2;
    CCNode *_star;
    //CCNode *_enemy;

    NSArray *_blocks;
    BOOL _jumped;
    CGPoint touchLocation;
    
    Level *_loadedLevel;
    LevelMenu *_mode;
    CCLabelTTF *_scoreLabel;
    int _score;
    int count;
    CCAction *_followHero;
    
    CCNode *enemy;
    CCNode *bonus;
}


// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    //_physicsNode.collisionDelegate = self;
    _loadedLevel = (Level *) [CCBReader load:selectedLevel owner:self];
    [_levelNode addChild:_loadedLevel];
    
    _physicsNode =_loadedLevel.physicsNode;
    _hero = _loadedLevel.hero;
    _block1 = _loadedLevel.block1;
    _block2 = _loadedLevel.block2;
    _score = _loadedLevel.score;
    count = 0;
    _star = _loadedLevel.star;
    //_enemy = _loadedLevel.enemy;
    
    _physicsNode.collisionDelegate = self;
    _hero.physicsBody.collisionType = @"hero";
    //_enemy.physicsBody.collisionType = @"enemy";

    // CCScene *level = [CCBReader loadAsScene:@"Levels/block1"];
    //[_levelNode addChild:level];
    
    //levelSpeed = _loadedLevel.levelSpeed;
    
    // visualize physics bodies & joints
    //_physicsNode.debugDraw = TRUE;
    
    _blocks = @[_block1, _block2];
    [self launchEnemy];
    
}

- (void)launchEnemy {
    // loads the Enemy.ccb we have set up in Spritebuilder
    enemy = [CCBReader load:@"Enemy"];
    // position the enemy
    [self setupRandomPosition:enemy];
    enemy.physicsBody.collisionType = @"enemy";
    // add the enemy to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:enemy];
}

- (void)launchBonus {
    // loads the Bonus we have set up in Spritebuilder
    bonus = [CCBReader load:@"Bonus"];
    // position the bonus
    //enemy.position = ccp(150, 150);
    [self setupRandomPosition:bonus];
    bonus.physicsBody.collisionType = @"bonus";
    // add the bonus to the physicsNode of this scene (because it has physics enabled)
    [_physicsNode addChild:bonus];
}

- (void)setupRandomPosition:(CCNode*)character{
    // value between 0.f and 1.f
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat rangeY = [[CCDirector sharedDirector] viewSize].height;
    CGFloat rangeX = [[CCDirector sharedDirector] viewSize].width;
    character.position = ccp(-_physicsNode.position.x + _hero.position.x + rangeX*random, -_physicsNode.position.y + _hero.position.y + rangeY*random);
}

- (void)onEnter {
    [super onEnter];
    srandom((unsigned int)time(NULL));
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


// called on every touch in this scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [_hero.physicsBody applyImpulse:ccp(0, 400.f)];
    /*
    [_hero.physicsBody.chipmunkObjects[0] eachArbiter:^(cpArbiter *arbiter) {
        if (!_jumped) {
            [_hero.physicsBody applyImpulse:ccp(0, 2000)];
            //[_hero.physicsBody applyImpulse:CGVectorMake(0, 120)];
            _jumped = TRUE;
            [self performSelector:@selector(resetJump) withObject:nil afterDelay:0.f];
        }
    }];
    */
    // we want to know the location of our touch in this scene
    touchLocation = [touch locationInNode:self];
}

#pragma mark - Player Movement

- (void)resetJump {
    _jumped = FALSE;
}

- (void)update:(CCTime)delta {
    //_hero.position = ccp(touchLocation.x, touchLocation.y);
    
    if (touchLocation.x < _hero.position.x) {
    _hero.position = ccp(_hero.position.x - delta * leftSpeed, _hero.position.y + delta * scrollSpeed);
    }else if (touchLocation.x > _hero.position.x){
        _hero.position = ccp(_hero.position.x + delta * rightSpeed, _hero.position.y + delta * scrollSpeed);
    }else{
        _hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
    }
    //_hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
    if((int)(_hero.position.y+1)%20 == 0) scrollBackgroundSpeed++;
    _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollBackgroundSpeed *delta));
    
    /*
    if(_hero.position.y > 400){
        _physicsNode.position = ccp(_physicsNode.position.x,  _physicsNode.contentSize.height - _hero.position.y + 200);
    }*/
   
    
    for (CCNode *block in _blocks) {
        // get the world position of the block
        CGPoint blockWorldPosition = [_physicsNode convertToWorldSpace:block.position];
        // get the screen position of the block
        CGPoint blockScreenPosition = [self convertToNodeSpace:blockWorldPosition];

        if (blockScreenPosition.y <= (-1 * block.contentSize.height)) {
            block.position = ccp(block.position.x, block.position.y  + 2 * block.contentSize.height);
        }
    }
    

    // clamp velocity
    /*
    float yVelocity = clampf(_hero.physicsBody.velocity.y, -1 * MAXFLOAT, 200.f);
    _hero.physicsBody.velocity = ccp(0, yVelocity);*/
    
    if (_hero.position.y < -1*CGRectGetMinY([_physicsNode boundingBox])) {
        [self gameOver];
    }

    count++;

    if((count+1)%60 == 0){
        _score++;
    }
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];

}


-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)nodeA enemy:(CCNode *)nodeB
{
    CCLOG(@"Something collided with a Enemy!");
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"EnemyExplosion"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the enemy position
    explosion.position = enemy.position;
    // add the particle effect to the same node the enemy is on
    [enemy.parent addChild:explosion];
    [enemy removeFromParent];
    [self gameOver];
    return YES;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)nodeA bonus:(CCNode *)nodeB
{
    CCLOG(@"Something collided with a Bonus!");
    CCParticleSystem *explosion = (CCParticleSystem *)[CCBReader load:@"BonusExplosion"];
    // make the particle effect clean itself up, once it is completed
    explosion.autoRemoveOnFinish = TRUE;
    // place the particle effect on the bonus position
    explosion.position = nodeB.position;
    // add the particle effect to the same node the bonus is on
    [nodeB.parent addChild:explosion];
    // finally, remove the destroyed bonus
    [nodeB removeFromParent];
    _score+=3;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", _score];
    return YES;
}



- (void)retry {
    scrollBackgroundSpeed = 0.f;
    CCScene *restartScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:restartScene];
}

#pragma mark - Game Over

- (void)gameOver {
    scrollBackgroundSpeed = 0.f;
    CCScene *restartScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:restartScene withTransition:transition];
}


@end
