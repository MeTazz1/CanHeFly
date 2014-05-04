//
//  Bonus.h
//  CanHeFly
//
//  Created by Christophe Dellac on 10/28/13.
//
//

#import "SPSprite.h"

typedef enum BonusDirection {
    DIRECTION_NONE,
    DIRECTION_LEFT,
    DIRECTION_RIGHT,
} BonusDirection;

typedef enum BonusType {
    BONUS_SPEEDUP,
    BONUS_GRAVITY,
    BONUS_ROCK,
    BONUS_BIRD,
    BONUS_THUNDER,
    BONUS_GRAVITY_INVERSE,
    BONUS_WEAPON,
} BonusType;

@interface Bonus : SPImage
{
    float _distance;

@public
    BonusType _type;
    BonusDirection _direction;
    NSString *_id;
}

- (Bonus*)initWithBonusType:(BonusType)type andId:(NSString*)id andDirection:(BonusDirection)direction;
- (void)rotateBonus:(NSMutableDictionary*)bonusImages andBonusDistances:(NSMutableDictionary*)bonusDistances;

@end
