//
//  MovementControls.h
//  PlatformerControls
//
//  Created by Shilo White on 9/10/13.
//
//

#import "SPSprite.h"

#define EVENT_TYPE_MOVEMENT_CHANGED @"movement"

typedef enum
{
    ControlsMovementTypeStop = 0,
    ControlsMovementTypeLeft = -1,
    ControlsMovementTypeRight = 1
} ControlsMovementType;

@interface MovementControls : SPSprite

@end

@interface MovementControlsEvent : SPEvent

@property (nonatomic, readonly) ControlsMovementType movementType;

@end
