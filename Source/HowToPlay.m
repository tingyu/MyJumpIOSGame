//
//  HowToPlay.m
//  TJumpGame
//
//  Created by Ting on 8/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HowToPlay.h"

@implementation HowToPlay
- (void)back {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
@end
