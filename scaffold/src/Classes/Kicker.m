//
//  Kicker.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "Kicker.h"

@implementation Kicker

@synthesize kickerPlaying = _kickerPlaying;

- (Kicker*)init
{
    SPTextureAtlas *ryuTexture = [SPTextureAtlas atlasWithContentsOfFile:@"ryu.xml"];
    NSArray *frames = [ryuTexture texturesStartingWith:@"walk_"];
    if (self = [super initWithFrames:frames fps:12])
    {
        self.x = CENTER_X / 5;
        self.y = GAME_HEIGHT - self.height;
    }
    return self;
}

@end
