//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene
- (void)startGame {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GamePlay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

- (void)chooseMode {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelMenu"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}
@end
