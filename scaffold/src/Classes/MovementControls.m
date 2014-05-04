//
//  MovementControls.m
//  PlatformerControls
//
//  Created by Shilo White on 9/10/13.
//
//

#import "MovementControls.h"

@interface SPTouch (Location)

- (SPPoint *)locationInSpace2:(SPDisplayObject *)space;

@end

@interface MovementControlsEvent ()

- (id)initWithType:(NSString *)type movementType:(ControlsMovementType)movementType;

@end

@implementation MovementControls {
    
    SPImage *_leftButton;
    SPImage *_rightButton;

    ControlsMovementType _movementType;
    SPQuad *_hitBounds;
}

- (id)init
{
    if ((self = [super init]))
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    [self setupImagesAndHitBounds];
    [self updateControls];
    [self setupEvents];
}

- (void)setupImagesAndHitBounds
{
    _leftButton = [SPImage imageWithContentsOfFile:@"left_up.png"];
    _leftButton.pivotX = _leftButton.width / 2;
    _leftButton.pivotY = _leftButton.height / 2;
    
    _rightButton = [SPImage imageWithContentsOfFile:@"right_down.png"];
    _rightButton.pivotX = _rightButton.width / 2;
    _rightButton.pivotY = _rightButton.height / 2;
    
    float padding = 20.0f;
    _hitBounds = [SPQuad quadWithWidth:_leftButton.width + _rightButton.width + padding * 2 height:_leftButton.height + padding * 2];
    _hitBounds.visible = NO;
    [self addChild:_hitBounds atIndex:0];
    
    _leftButton.x = (_hitBounds.width - _leftButton.width -_rightButton.width) / 2 +_leftButton.pivotX;
    _leftButton.y = (_hitBounds.height - _leftButton.height) / 2 + _leftButton.pivotY;
    _rightButton.x = _leftButton.x + _leftButton.width;
    _rightButton.y = _leftButton.y;
    
    [self addChild:_leftButton];
    [self addChild:_rightButton];
}


- (void)setupEvents
{
    [Sparrow.stage addEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)updateControls
{
    _leftButton.alpha = (_movementType == ControlsMovementTypeLeft) ? 1.0f : 0.5;
    _rightButton.alpha = (_movementType == ControlsMovementTypeRight) ? 1.0f : 0.5;
    _leftButton.scaleX = _leftButton.scaleY = (_movementType == ControlsMovementTypeLeft) ? 0.2f : 0.22f;
    _rightButton.scaleX = _rightButton.scaleY = (_movementType == ControlsMovementTypeRight) ? 0.2f : 0.22f;
}

- (void)onTouch:(SPTouchEvent *)event
{
    SPTouch *touch = [[event touches] anyObject];
    SPPoint *location = [touch locationInSpace2:self];
    
    SPDisplayObject *hit = [self hitTestPoint:location];
    if (hit && (touch.phase == SPTouchPhaseBegan || touch.phase == SPTouchPhaseMoved))
    {
        SPRectangle *leftBounds = [SPRectangle rectangleWithX:0 y:0 width:self.width/2.0f height:self.height];
        if ([leftBounds containsPoint:location])
        {
            if (_movementType != ControlsMovementTypeLeft)
            {
                _movementType = ControlsMovementTypeLeft;
                [self updateControls];
                [self dispatchMovementChangedEvent];
            }
        }
        else if (_movementType != ControlsMovementTypeRight)
        {
            _movementType = ControlsMovementTypeRight;
            [self updateControls];
            [self dispatchMovementChangedEvent];
        }
    }
    else if ((!hit || touch.phase == SPTouchPhaseEnded || touch.phase == SPTouchPhaseCancelled) && (_movementType != ControlsMovementTypeStop))
    {
        _movementType = ControlsMovementTypeStop;
        [self updateControls];
        [self dispatchMovementChangedEvent];
    }
}

- (void)dispatchMovementChangedEvent
{
    [self dispatchEvent:[[MovementControlsEvent alloc] initWithType:EVENT_TYPE_MOVEMENT_CHANGED movementType:_movementType]];
}

- (SPRectangle *)boundsInSpace:(SPDisplayObject *)targetSpace
{
    return [_hitBounds boundsInSpace:targetSpace];
}

- (SPDisplayObject *)hitTestPoint:(SPPoint *)localPoint
{
    if (!self.visible || !self.touchable) return nil;
    
    if ([[self boundsInSpace:self] containsPoint:localPoint]) return self;
    else return nil;
}


- (void)dealloc
{
    [Sparrow.stage removeEventListener:@selector(onTouch:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

@end

@interface SPTouch () {
    @protected
    float _globalX;
    float _globalY;
    SPDisplayObject *__weak _target;
}

@end

@implementation SPTouch (Location)

- (SPPoint *)locationInSpace2:(SPDisplayObject *)space
{
    SPDisplayObject *root = ([_target isKindOfClass:[SPStage class]])?_target:_target.root;
    SPMatrix *transformationMatrix = [root transformationMatrixToSpace:space];
    return [transformationMatrix transformPointWithX:_globalX y:_globalY];
}

@end

@implementation MovementControlsEvent

@synthesize movementType = _movementType;

- (id)initWithType:(NSString *)type movementType:(ControlsMovementType)movementType {
	if ((self = [super initWithType:type bubbles:YES]))
    {
		_movementType = movementType;
    }
    return self;
}

@end