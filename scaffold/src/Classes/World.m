//
//  World.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "World.h"

@implementation World

- (World*)initWorld
{
    if (self = [super init])
    {
        wBackground = [[SPImage alloc] initWithContentsOfFile:@"test.png"];
        [wBackground setWidth:GAME_WIDTH];
        [wBackground setHeight:GAME_HEIGHT * 2];
        wBackground.y = GAME_HEIGHT - wBackground.height;
        [self addChild:wBackground];
    
        [self initStars];
    }
    return self;
}

- (void)initStars
{
    wBgStars = [[SXParticleSystem alloc] initWithContentsOfFile:@"stars.pex"];
    wBgStars.y = GAME_HEIGHT / 2;
    [self addChild:wBgStars];
    [Sparrow.juggler addObject:wBgStars];
    [wBgStars start];
}

- (void)backgroundStepOne
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"square.png"];
    texture.repeat = YES;
    wMainBackground = [[SPImage alloc] initWithTexture:texture];
    wMainBackground.width = GAME_WIDTH;
    wMainBackground.height = GAME_HEIGHT * 40;
    wMainBackground.y = -GAME_HEIGHT * 40;

    [self addChild:wMainBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = -(GAME_HEIGHT * 40) / GAME_HEIGHT;
    [wMainBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wMainBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wMainBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}

- (void)backgroundStepTwo
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"gods.png"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    [self removeChild:wMainBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 2;
    wBackground.height = GAME_HEIGHT * 2;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;

    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}

- (void)backgroundStepThree
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"mars.jpg"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 1.8;
    wBackground.height = GAME_HEIGHT;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}

- (void)backgroundStepFour
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"jupiter.jpg"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 1.8;
    wBackground.height = GAME_HEIGHT;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}

- (void)backgroundStepFive
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"saturne.jpg"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 1.8;
    wBackground.height = GAME_HEIGHT;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}
- (void)backgroundStepSix
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"uranus.jpg"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 1.8;
    wBackground.height = GAME_HEIGHT;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}
- (void)backgroundStepSeven
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"neptune.jpg"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 1.8;
    wBackground.height = GAME_HEIGHT;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}
- (void)backgroundStepEight
{
    SPGLTexture *texture = (SPGLTexture *)[SPTexture textureWithContentsOfFile:@"pluton.jpg"];
    texture.repeat = NO;
    
    // create SPImage with that texture
    [self removeChild:wBackground];
    
    wBackground = [SPImage imageWithTexture:texture];
    wBackground.width = GAME_WIDTH * 1.8;
    wBackground.height = GAME_HEIGHT;
    wBackground.y = -GAME_HEIGHT;
    [self addChild:wBackground atIndex:0];
    
    // this is the important part: changing the texture coordinates
    // so that the texture is repeated.
    
    float xRepeat = 1.0f;
    float yRepeat = 1.0f;
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:0.0f] ofVertex:1];
    [wBackground setTexCoords:[SPPoint pointWithX:0.0f y:yRepeat] ofVertex:2];
    [wBackground setTexCoords:[SPPoint pointWithX:xRepeat y:yRepeat] ofVertex:3];
}


- (void)initRepeatedBackgroundForStep:(BackgroundStep)step
{
    _step = step;
    switch (step) {
        case FIRST_STEP:
            [self backgroundStepOne];
            break;
        case SECOND_STEP:
            [self backgroundStepTwo];
            break;
        case THIRD_STEP:
            [self backgroundStepThree];
            break;
        case FOURTH_STEP:
            [self backgroundStepFour];
            break;
        case FIFTH_STEP:
            [self backgroundStepFive];
            break;
        case SIXTH_STEP:
            [self backgroundStepSix];
            break;
        case SEVENTH_STEP:
            [self backgroundStepSeven];
            break;
        case EIGHTH_STEP:
            [self backgroundStepEight];
            break;
        default:
            break;
    }
}

- (void)moveWorldWithDistance:(float)distance
{
    if (_step == NONE || _step == FIRST_STEP)
    {
        wBackground.y += distance;
        if (wMainBackground != nil)
            wMainBackground.y += distance;
    }
    else
        wBackground.y += distance / 100;
}

- (void)dealloc
{
    [Sparrow.juggler removeObject:wBgStars];

    [self removeChild:wBackground];
    [self removeChild:wBgStars];
    
    [wBackground release];
    [wMainBackground release];
    [wBgStars release];
    [super dealloc];
}

@end
