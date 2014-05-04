//
//  Target.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "Target.h"

@implementation Target

@synthesize hasBeenKicked = _hasBeenKicked;
@synthesize speed = _speed;
@synthesize gravity = _gravity;
@synthesize fire;
@synthesize gravityStyle = _gravityStyle;
@synthesize hasWeapon = _hasWeapon;
@synthesize bullets = _bullets;
@synthesize remainingBullets = _remainingBullets;
@synthesize xFactor = _xFactor;

- (Target*)initWithContentsOfFile:(NSString*)file
{
    if (self = [super initWithContentsOfFile:file])
    {
        _hasBeenKicked = NO;
        _hasWeapon = NO;
        _speed = 0.0f;
        _remainingBullets = 0;
        _gravity = GRAVITY;
        _gravityStyle = NORMAL;
        _bullets = [NSMutableArray new];
        [self addEventListener:@selector(update:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    }
    return self;
}

- (void)update:(SPEnterFrameEvent *)event
{
    int factor = _xFactor / 100;
    float move = _movementType * (_gravity / 4) + factor;
    if (_gravityStyle == NORMAL) {
        if ((_movementType == PlayerMovementTypeLeft && self.x - ((_gravity / 2)) > 0.0f) ||
            (_movementType == PlayerMovementTypeRight && self.x + ((_gravity / 2)) < GAME_WIDTH - self.width))
        {
            self.x += move;
            self.fire.x += move;
            _movementType == PlayerMovementTypeLeft ? (self.fire.rotation = -1 + (self.gravity / 100)) : (self.fire.rotation = 1 + (self.gravity / 100));
        }
    }
    else if (_gravityStyle == INVERSE)
    {
        if ((_movementType == PlayerMovementTypeRight && self.x - ((_gravity / 2)) > 0.0f) ||
            (_movementType == PlayerMovementTypeLeft && self.x + ((_gravity / 2)) < GAME_WIDTH - self.width))
        {
            self.x -= move;
            self.fire.x -= move;
            _movementType == PlayerMovementTypeLeft ? (self.fire.rotation = 1 + (self.gravity / 100)) : (self.fire.rotation = -1 + (self.gravity / 100));
        }
    }
    
    if (_movementType == PlayerMovementTypeStop)
        self.fire.rotation = 2 * PI;
}

- (void)stopWeapon
{
    _hasWeapon = NO;
    _remainingBullets = 0;
}

- (void)initWeapon
{
    _hasWeapon = YES;
    _remainingBullets = NB_BULLETS_BY_BONUS;
}


@end
