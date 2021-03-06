//
//  CCActionFollow+CurrentOffset.m
//  TJumpGame
//
//  Created by Ting on 7/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCActionFollow+CurrentOffset.h"

@implementation CCActionFollow (CurrentOffset)

- (CGPoint)currentOffset {
    if(_boundarySet)
    {
        // whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
        if(_boundaryFullyCovered)
            return [(CCNode *)_target position];
        
        CGPoint tempPos = ccpSub( _halfScreenSize, _followedNode.position);
        return ccp(-1*clampf(tempPos.x, _leftBoundary, _rightBoundary), -1*clampf(tempPos.y, _bottomBoundary, _topBoundary));
    }
    else
        return ccpSub( _halfScreenSize, _followedNode.position );
}

@end
