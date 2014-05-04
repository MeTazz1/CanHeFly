//
//  Bonus.m
//  CanHeFly
//
//  Created by Christophe Dellac on 10/28/13.
//
//

#import "Bonus.h"

@implementation Bonus

- (Bonus*)initWithBonusType:(BonusType)type andId:(NSString*)id andDirection:(BonusDirection)direction
{
    if (self = [super initWithContentsOfFile:[NSString stringWithFormat:@"%i_simple.png", type]])
    {
        _id = id;
        _direction = direction;
        _type = type;
    }
    return self;
}

- (void)rotateBonus:(NSMutableDictionary*)bonusImages andBonusDistances:(NSMutableDictionary*)bonusDistances
{
    if (self->_direction == DIRECTION_LEFT)
    {
        self.x -= 2;
        self.scaleX = 1;
        ((SPImage*)[bonusImages objectForKey:self->_id]).scaleX = 1;
        ((SPImage*)[bonusImages objectForKey:self->_id]).x = ((SPTextField*)[bonusDistances objectForKey:self->_id]).x = self.x;
        if (self.x < SIDE_SIZE)
            self->_direction = DIRECTION_RIGHT;
    }
    else
    {
        self.x += 2;
        ((SPImage*)[bonusImages objectForKey:self->_id]).x = self.x;
        ((SPImage*)[bonusImages objectForKey:self->_id]).scaleX = self.scaleX = -1;
        ((SPTextField*)[bonusDistances objectForKey:self->_id]).x = self.x - (self.width * 2);
        if (self.x > (GAME_WIDTH - SIDE_SIZE))
            self->_direction = DIRECTION_LEFT;
        
    }

}
@end
