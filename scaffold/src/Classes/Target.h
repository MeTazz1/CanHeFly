//
//  Target.h
//  CanHeFly
//
//  Created by Christophe Dellac on 10/26/13.
//
//

#import "SPImage.h"
#import "SXParticleSystem.h"

typedef enum
{
    NORMAL,
    INVERSE,
} GravityStyle;

typedef enum
{
    PlayerMovementTypeStop = 0,
    PlayerMovementTypeLeft = -1,
    PlayerMovementTypeRight = 1
} PlayerMovementType;

@interface Target : SPImage
{
}

@property (nonatomic, assign) PlayerMovementType movementType;
@property (nonatomic, assign) SXParticleSystem *fire;

@property (nonatomic) BOOL hasBeenKicked;
@property (nonatomic) float speed;
@property (nonatomic) int gravity;
@property (nonatomic) int xFactor;
@property (nonatomic) GravityStyle gravityStyle;
@property (nonatomic) BOOL hasWeapon;

/* Weapon's stuff */
@property (nonatomic, retain) NSMutableArray *bullets;
@property (nonatomic) int remainingBullets;

- (Target*)initWithContentsOfFile:(NSString*)file;
- (void)initWeapon;
- (void)stopWeapon;

@end
