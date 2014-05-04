//
//  Game.h
//  AppScaffold
//

#import <Foundation/Foundation.h>
#import <UIKit/UIDevice.h>
#import "Target.h"
#import "World.h"
#import "Kicker.h"
#import "MovementControls.h"
#import <iAd/iAd.h>
#import "F3BarGauge.h"
#import <CoreMotion/CoreMotion.h>

#define ACCEL_FACTOR 1000
#define NUM_FILTER_POINT 3

#define EVENT_TYPE_MOVEMENT_CHANGED @"movement"
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

@interface Game : World <ADBannerViewDelegate>
{
@private
    Kicker *_ryu;
    float _currentKickTime;
    SPTextField *currentTimeText;
    // Total time handler
	float _totalTime;
    float _distance;
    SPTextField *_distanceField;
    
    MovementControls *_movementControls;
    
    SPImage *_tutoImage;
    int _clicCount;
    
    // Bonus
    NSMutableArray *_bonusSoundList;
    int _totalBonusGenerated;
    NSMutableDictionary *_bonus;
    NSMutableDictionary *_bonusImages;
    NSMutableDictionary *_bonusDistances;
    NSTimer *_bulletTimer;
    
    F3BarGauge *_speedGauge;
    SPImage *_speedGaugeImg;
    
    F3BarGauge *_bulletsGauge;
    SPImage *_targetGaugeImg;
    
    Target *_target;
    F3BarGauge *_gravityGauge;
    
    BOOL _userControls;
    CMMotionManager *_motionManager;
    NSMutableArray *_rawAccelX;
}

// iAd

@property (nonatomic, retain) ADBannerView *adBannerView;


- (void)accellorateByX:(int)x;
@end
