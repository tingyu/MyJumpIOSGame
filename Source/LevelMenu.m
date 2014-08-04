//
//  LevelMenu.m
//  TJumpGame
//
//  Created by Ting on 7/22/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelMenu.h"

@implementation LevelMenu
- (void)back {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)seaMode {
    selectedLevel = @"Level1";
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    //_loadedLevel = (Level *) [[CCBReader load:_selectedMode owner:self]];
    //[_levelNode addChild:_loadedLevel];

}

- (void)mushroomMode {
    selectedLevel = @"Level2";
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)candyMode {
    selectedLevel = @"Level3";
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
@end
