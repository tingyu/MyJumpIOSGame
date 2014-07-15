//
//  Level.h
//  TJumpGame
//
//  Created by Ting on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Level : CCNode

@property (nonatomic, copy) NSString *nextLevelName;
@property (nonatomic, assign) int levelSpeed;
@property (nonatomic, copy) CCPhysicsNode *physicsNode;
@property (nonatomic, copy) CCSprite *hero;
@property (nonatomic, copy) CCNode *block1;
@property (nonatomic, copy) CCNode *block2;
@property (nonatomic, assign) int score;

-(BOOL) returnsTrueAndHasNoParameters;
@end
