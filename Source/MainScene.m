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
    CCScene *levelMenuScene = [CCBReader loadAsScene:@"LevelMenu"];
    [[CCDirector sharedDirector] replaceScene:levelMenuScene];
}

- (void)howToPlay{
    CCScene *howtoplayScene = [CCBReader loadAsScene:@"HowToPlay"];
    [[CCDirector sharedDirector] replaceScene:howtoplayScene];
}
@end
