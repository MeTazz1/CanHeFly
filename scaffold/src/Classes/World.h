//
//  World.h
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import <Foundation/Foundation.h>
#import "SXParticleSystem.h"

typedef enum BackgroundStep
{
    NONE,
    FIRST_STEP,
    SECOND_STEP,
    THIRD_STEP,
    FOURTH_STEP,
    FIFTH_STEP,
    SIXTH_STEP,
    SEVENTH_STEP,
    EIGHTH_STEP
} BackgroundStep;

@interface World : SPSprite
{
   	SPImage *wBackground;
    SPImage *wMainBackground;
    SXParticleSystem *wBgStars;
    BackgroundStep _step;
}

- (World*)initWorld;
- (void)moveWorldWithDistance:(float)distance;
- (void)initStars;
- (void)initRepeatedBackgroundForStep:(BackgroundStep)step;
@end
