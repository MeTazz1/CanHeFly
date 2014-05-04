    //
//  Game.m
//  AppScaffold
//

#import "Game.h"
#import "Bonus.h"

#pragma mark - Private 

@interface Game ()

- (void)setup;
- (void)setupTarget;
- (void)setupControls;
- (void)setupKicker;

@end

// --- class implementation ------------------------------------------------------------------------

@implementation Game

@synthesize adBannerView = _adBannerView;

- (id)init
{
    if ((self = [super init]))
    {
        [self showFirstTuto];
        _userControls = NO;
    }
    return self;
}

- (void)initGame
{
    _rawAccelX = [[NSMutableArray alloc] initWithCapacity:NUM_FILTER_POINT];
    
    for (int i = 0; i < NUM_FILTER_POINT; ++i)
    {
        [_rawAccelX addObject:[NSNumber numberWithFloat:0.0f]];
    }
    
    _target.rotation = 0;
    _target.fire.y = GAME_HEIGHT / 1.5 + 20;
    _target.fire.x = _target.x + 18;
    _target.fire.maxNumParticles = 100;
    [_target.fire start];
    
    _speedGauge = [[F3BarGauge alloc] initWithFrame:CGRectMake(10, GAME_HEIGHT / 2 - 105, 20, 150)];
    [Sparrow.currentController.view addSubview:_speedGauge];
    _speedGauge.numBars = 30;
    _speedGauge.dangerThreshold = 0.25f;
    _speedGauge.warnThreshold = 0.15f;
    _speedGauge.normalBarColor = [UIColor redColor];
    _speedGauge.warningBarColor = [UIColor orangeColor];
    _speedGauge.dangerBarColor = [UIColor greenColor];
    _speedGaugeImg = [[SPImage alloc] initWithContentsOfFile:@"speedGauge.png"];
    _speedGaugeImg.x = 5;
    _speedGaugeImg.y = (GAME_HEIGHT / 2) - 140;
    _speedGaugeImg.width = 30;
    _speedGaugeImg.height = 30;
    [self addChild:_speedGaugeImg];
    
    _bulletsGauge = [[F3BarGauge alloc] initWithFrame:CGRectMake(GAME_WIDTH - 30, GAME_HEIGHT / 2 - 105, 20, 150)];
    [Sparrow.currentController.view addSubview:_bulletsGauge];
    _bulletsGauge.numBars = 5;
    _bulletsGauge.warnThreshold = 1.0f;
    _bulletsGauge.dangerThreshold = 1.0f;
    
    _gravityGauge = [[F3BarGauge alloc] initWithFrame:CGRectMake(GAME_WIDTH - 60, GAME_HEIGHT / 2 - 105, 20, 150)];
    [Sparrow.currentController.view addSubview:_gravityGauge];
    _gravityGauge.dangerThreshold = 0.55f;
    _gravityGauge.warnThreshold = 0.25f;
    _gravityGauge.normalBarColor = [UIColor redColor];
    _gravityGauge.warningBarColor = [UIColor orangeColor];
    _gravityGauge.dangerBarColor = [UIColor greenColor];
    _gravityGauge.numBars = 30;
    
    _targetGaugeImg = [[SPImage alloc] initWithContentsOfFile:@"targetGauge.png"];
    _targetGaugeImg.x = GAME_WIDTH - 35;
    _targetGaugeImg.y = (GAME_HEIGHT / 2) - 140;
    _targetGaugeImg.width = 30;
    _targetGaugeImg.height = 30;
    [self addChild:_targetGaugeImg];
    [self createAdBannerView];
    
    if (_userControls == NO)
    {
        _motionManager = [CMMotionManager new];
        [_motionManager startAccelerometerUpdates];
    }
}

- (void)cleanBeforeReplay
{
    // release any resources here
    
    if ([_adBannerView respondsToSelector:@selector(removeFromSuperview)])
        [UIView animateWithDuration:2.0 animations:^{
            [_adBannerView removeFromSuperview];
        }];
    _adBannerView.alpha = 0.0f;
    [_adBannerView release];
    _adBannerView = nil;

    [_speedGauge removeFromSuperview];
    [_bulletsGauge removeFromSuperview];
    [_gravityGauge removeFromSuperview];
    
    [self removeChild:_speedGaugeImg];
    [self removeChild:_targetGaugeImg];
//    [self removeChild:_gravityGaugeImg];
    
    [Media releaseAtlas];
    [Media releaseSound];
    
    [self removeChild:_target.fire];
    [self removeChild:_target];
    [Sparrow.juggler removeObject:_target.fire];
    
    //event listeners must be removed in the dealloc phase
	[self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    [self removeEventListenersAtObject:self forType:EVENT_TYPE_MOVEMENT_CHANGED];

    [_distanceField release];
	[_ryu release];
    [_target.fire release];
    [_target release];
    [_bonusDistances release];
    [_bonusImages release];
    [_bonus release];
    
    _distanceField = nil;
	_ryu = nil;
    _target.fire = nil;
    _target = nil;
    _bonusDistances = nil;
    _bonusImages = nil;
    _bonus = nil;
}

- (void)dealloc
{
    // release any resources here
    [Media releaseAtlas];
    [Media releaseSound];
    
    //event listeners must be removed in the dealloc phase
	[self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
    [self removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    [self removeEventListenersAtObject:self forType:EVENT_TYPE_MOVEMENT_CHANGED];

    [self removeChild:_movementControls];
    [self removeChild:_target.fire];
    [self removeChild:_target];
    [self removeChild:_ryu];
    [self removeChild:_speedGaugeImg];
    [self removeChild:_targetGaugeImg];
    
    [_speedGauge removeFromSuperview];
    [_bulletsGauge removeFromSuperview];
    
    [_adBannerView release];
    [_distanceField release];
	[_ryu release];
    [_target.fire release];
    [_target release];
    [_bonusDistances release];
    [_bonusImages release];
    [_bonus release];
    
	[super dealloc];
}

#pragma mark - Setups

- (void)setupTarget
{
    _target = [[Target alloc] initWithContentsOfFile:@"egg.png"];
    _target.y = (GAME_HEIGHT / 2) - 100;
    _target.x = GAME_WIDTH * 1.5;
    
    _target.fire = [[SXParticleSystem alloc] initWithContentsOfFile:@"fire.pex"];
    [self addChild:_target.fire];
    [Sparrow.juggler addObject:_target.fire];
    [self addChild:_target];
    
    SPTween *tween = [SPTween tweenWithTarget:_target time:3.0f transition:SP_TRANSITION_LINEAR];
    [tween moveToX:0 y:GAME_HEIGHT - 30];
    [tween animateProperty:@"rotation" targetValue:PI];
    tween.onUpdate = ^{
        if (_target.hasBeenKicked)
        {
            [self initGame];
            [Sparrow.currentController.view addSubview:self.adBannerView];
            [Sparrow.juggler removeObject:tween];
        }
    };
    [Sparrow.juggler addObject:tween];
}

- (void)setupControls
{
    _movementControls = [MovementControls new];
    _movementControls.y = GAME_HEIGHT - 230;
    _movementControls.x = -(GAME_WIDTH / 3) - 10;
    [self addChild:_movementControls];
    [self addEventListener:@selector(onMovementChanged:) atObject:self forType:EVENT_TYPE_MOVEMENT_CHANGED];
}

- (void)initSounds
{
    _bonusSoundList = [NSMutableArray new];
    [_bonusSoundList addObject:[[SPSound alloc] initWithContentsOfFile:@"sound.caf"]];
    [_bonusSoundList addObject:[[SPSound alloc] initWithContentsOfFile:@"Game-Break.mp3"]];
    [_bonusSoundList addObject:[[SPSound alloc] initWithContentsOfFile:@"Game-Death.mp3"]];
    [_bonusSoundList addObject:[[SPSound alloc] initWithContentsOfFile:@"Game-Shot.mp3"]];
}

- (void)setupKicker
{
    _ryu = [[Kicker alloc] init];
    [self addChild:_ryu];
    
    [self addEventListener:@selector(playKicker:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
    [_ryu addEventListenerForType:SP_EVENT_TYPE_COMPLETED block:^(id event)
     {
         _currentKickTime = 0.0f;
         [self stopKicker:event];
     }];
}

- (void)setup
{
    [SPAudioEngine start];
    
    [Media initAtlas];
    [Media initSound];
    
    [self initWorld];
    [self initSounds];
    [self setupKicker];
    [self setupTarget];
    
    _bonus = [NSMutableDictionary new];
    _bonusImages = [NSMutableDictionary new];
    _bonusDistances = [NSMutableDictionary new];
    
    _distanceField = [[SPTextField alloc] initWithWidth:100 height:17 text:@" " fontName:@"Georgia-Bold" fontSize:SP_DEFAULT_FONT_SIZE color:SP_WHITE];
    _distanceField.hAlign = SPHAlignCenter;
    _distanceField.vAlign = SPVAlignBottom;
    _distanceField.x = (GAME_WIDTH / 2) - 100;
    _distanceField.y = (GAME_HEIGHT - 100);
    [self addChild:_distanceField];
    
    _step = NONE;
    
    _totalBonusGenerated = 0;
    _totalTime = 0.0f;
    _currentKickTime = 0.0f;
    _distance = 0.0f;
    
    [self addEventListener:@selector(onFallingTarget:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
}

#pragma mark - Frames

- (void)onFallingTarget:(SPEnterFrameEvent *)event
{
	float passedTime = (float)event.passedTime;
    _totalTime += passedTime;
    
    _currentKickTime += (float)event.passedTime;
    
    SPRectangle *firstBounds = _ryu.bounds;
    SPRectangle *secondBounds = _target.bounds;
    firstBounds.width -= 10.0f;
    firstBounds.height -= 10.0f;
    
    if (_ryu.kickerPlaying && _target.hasBeenKicked == NO && [firstBounds intersectsRectangle:secondBounds])
    {
        _target.hasBeenKicked = YES;
        if ((_currentKickTime > 0.0 && _currentKickTime <= 0.1) ||
            (_currentKickTime > 0.30 && _currentKickTime <= 0.49))
            _target.speed = 400.0f;
        else if (_currentKickTime > 0.1 && _currentKickTime <= 0.20)
            _target.speed = 550.0f;
        else if (_currentKickTime > 0.20 && _currentKickTime <= 0.30)
            _target.speed = 680.0f;
        
        [_bonusSoundList[2] play];

        [self removeEventListener:@selector(onFallingTarget:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self removeEventListener:@selector(playKicker:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
        
        [self addEventListener:@selector(onGoing:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self addEventListener:@selector(generateBonus:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
        [self addEventListener:@selector(updateBonusPosition:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];

        if (_userControls == YES)
            [self setupControls];
        _totalTime = 0.0f;
    }
}

#pragma mark - 
#pragma mark Kicker methods

- (void)playKicker:(SPEvent *)event
{
    if (_ryu.kickerPlaying == NO)
    {
        _currentKickTime = 0.0f;
        _ryu.kickerPlaying = YES;
        [Sparrow.juggler addObject:_ryu];
    }
}

- (void)stopKicker:(SPEvent *)event
{
    _ryu.kickerPlaying = NO;
    [Sparrow.juggler removeObject:_ryu];
}

#pragma mark -
#pragma mark - Bonus methods

- (void)removeBonusInfo:(Bonus*)bonus
{
    [self removeChild:[_bonusImages objectForKey:bonus->_id]];
    [self removeChild:[_bonusDistances objectForKey:bonus->_id]];
    [_bonusDistances removeObjectForKey:bonus->_id];
    [_bonusImages removeObjectForKey:bonus->_id];
}

- (void)removeBullet:(SPImage*)bullet
{
    [self removeChild:bullet];
    [_target.bullets removeObject:bullet];
}

- (void)removeBonus:(Bonus*)bonus
{
    [self removeChild:[_bonus objectForKey:bonus->_id]];
    [_bonus removeObjectForKey:bonus->_id];
}

- (void)updateBulletsPosition:(SPEnterFrameEvent *)event
{
    for (SPImage *bullet in [_target.bullets copy])
    {
        bullet.y -= (_target.speed * (float)event.passedTime);
        for (Bonus *bonus in [[_bonus allValues] copy])
        {
            SPRectangle *firstBounds = bullet.bounds;
            SPRectangle *secondBounds = bonus.bounds;
            if ([firstBounds intersectsRectangle:secondBounds])
            {
                [self removeBonusInfo:bonus];
                [self removeBonus:bonus];
                [self removeBullet:bullet];
            }
        }
    }
}

- (void)updateBonusPosition:(SPEnterFrameEvent *)event
{
    float passedTime = (float)event.passedTime;
    if (!_bonus)
        return;
    
    for (Bonus *bonus in [[_bonus allValues] copy])
    {
        if (bonus->_type == BONUS_BIRD || bonus->_type == BONUS_ROCK || bonus->_type == BONUS_THUNDER)
            [bonus rotateBonus:_bonusImages andBonusDistances:_bonusDistances];
        bonus.y += _target.speed * passedTime;
        [[_bonusDistances objectForKey:bonus->_id] setText:[NSString stringWithFormat:@"%d m", (int)bonus.y]];
        
        // Handle intersection
        if (bonus.y > 0)
        {
            SPRectangle *firstBounds = _target.bounds;
            if (_target.speed >= 1000)
                firstBounds.height += 300;
            SPRectangle *secondBounds = bonus.bounds;
            if ([firstBounds intersectsRectangle:secondBounds])
            {
                switch (bonus->_type) {
                    case BONUS_SPEEDUP:
                        _target.speed += 600;
                        [_bonusSoundList[2] play];
                        break;
                    case BONUS_GRAVITY:
                        _target.gravity += 5;
                        [_bonusSoundList[3] play];
                        break;
                    case BONUS_ROCK:
                        _target.speed -= 500;
                        [_bonusSoundList[1] play];
                        break;
                    case BONUS_BIRD:
                        _target.speed -= 300;
                        [_bonusSoundList[1] play];

                        break;
                    case BONUS_THUNDER:
                        _target.speed -= 300;
                        [_bonusSoundList[1] play];
                        break;
                    case BONUS_GRAVITY_INVERSE:
                        _target.gravityStyle = !_target.gravityStyle;
                        [_bonusSoundList[1] play];
                        break;
                    case BONUS_WEAPON:
                        [_target initWeapon];
                        _bulletsGauge.numBars = NB_BULLETS_BY_BONUS;
                        if (!_bulletTimer)
                        {
                            _bulletTimer = [NSTimer scheduledTimerWithTimeInterval:2.0f invocation:[NSInvocation invocationWithTarget:self selector:@selector(generateBullet)] repeats:YES];
                            [self addEventListener:@selector(updateBulletsPosition:) atObject:self forType:SP_EVENT_TYPE_ENTER_FRAME];
                        }
                        [_bonusSoundList[1] play];
                        break;
                    default:
                        break;
                }
                [self removeBonus:bonus];
            }
            // Remove missed bonus
            if (bonus.y > 0)
                [self removeBonusInfo:bonus];
            if (bonus.y > GAME_HEIGHT)
            {
                [self removeBonus:bonus];
            }
        }
    }
}

- (void)generateBullet
{
    --_target.remainingBullets;
    SPImage *newBullet = [[SPImage alloc] initWithContentsOfFile:@"rocket.png"];
    newBullet.x = _target.x + (_target.width / 2);
    newBullet.y = _target.y;
    [_target.bullets addObject:newBullet];
    [self addChild:newBullet];
    if (_target.remainingBullets == 0)
    {
        [_bulletTimer invalidate];
        _bulletTimer = nil;
        [_target stopWeapon];
    }
}

- (void)generateBonus:(SPEnterFrameEvent *)event
{
    // Generate bonus randomly
    if (_bonus && _step != NONE && _bonus.count < (2 + _step) && arc4random() % 50 == 1)
    {
        ++_totalBonusGenerated;
        int random = arc4random() % 100;
        int bonusType;
       if (random >= 0 && random <= 45)
       {
           bonusType = BONUS_SPEEDUP;
       }
       else if (random > 45 && random <= 80)
       {
           switch (_step) {
               case FIRST_STEP:
                   bonusType = BONUS_BIRD;
                   break;
               case SECOND_STEP:
                   bonusType = BONUS_THUNDER;
                   break;
                default:
                   bonusType = BONUS_ROCK;
                   break;
           }
       }
       else if (random > 80 && random <= 85)
           bonusType = BONUS_GRAVITY_INVERSE;
       else if (random > 85 && random <= 90)
           bonusType = BONUS_WEAPON;
        else
            bonusType = BONUS_GRAVITY;
        
        BonusDirection direction = (bonusType == BONUS_BIRD || bonusType == BONUS_ROCK || bonusType == BONUS_THUNDER) ? (arc4random() % 2 == 1 ? DIRECTION_RIGHT : DIRECTION_LEFT) : DIRECTION_NONE;
        Bonus *newBonus = [[Bonus alloc] initWithBonusType:bonusType andId:[NSString stringWithFormat:@"%d", _totalBonusGenerated] andDirection:direction];
        newBonus.x = SIDE_SIZE + (arc4random_uniform((u_int32_t)(GAME_WIDTH - 60)));
        newBonus.y = -_target.speed - (int)(arc4random_uniform(3000));
        
        SPImage *bonusImage = [[SPImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%i_simple.png", newBonus->_type]];
        bonusImage.x = newBonus.x;
        bonusImage.y = 20.0f + (bonusType * 10);

        SPTextField *bonusDistance = [[SPTextField alloc] initWithWidth:60 height:20 text:[NSString stringWithFormat:@"%d m", (int)(newBonus.y + GAME_HEIGHT / 2)]];
        bonusDistance.width = 100;
        bonusDistance.x = newBonus.x - newBonus.width;
        bonusDistance.y = -5.0  + (bonusType * 10);
        bonusDistance.hAlign = SPHAlignCenter;
        bonusDistance.vAlign = SPVAlignCenter;
        bonusDistance.fontSize = 12;
        bonusDistance.fontName = @"Georgia-Bold";
        bonusDistance.color = (bonusType == BONUS_SPEEDUP || bonusType == BONUS_GRAVITY || bonusType == BONUS_WEAPON) ? SP_LIME : SP_WHITE;
        
        [_bonus setValue:newBonus forKey:newBonus->_id];
        [_bonusDistances setValue:bonusDistance forKey:newBonus->_id];
        [_bonusImages setValue:bonusImage forKey:newBonus->_id];
        
        [self addChild:newBonus];
        [self addChild:bonusImage];
        [self addChild:bonusDistance];

        [newBonus release];
        [bonusImage release];
        [bonusDistance release];
    }
}

#pragma mark - 
#pragma mark - Updating game & events

- (void)showFirstTuto
{
    _clicCount = 0;
    _tutoImage = [[SPImage alloc] initWithContentsOfFile:@"tuto1.png"];
    _tutoImage.width = GAME_WIDTH;
    _tutoImage.height = GAME_HEIGHT;
    [self addChild:_tutoImage];
    
    [_tutoImage addEventListener:@selector(showSecondTuto:) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)showSecondTuto:(SPEnterFrameEvent*)event
{
    [_tutoImage removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
    [self removeChild:_tutoImage];
    [_tutoImage release];
    
    _tutoImage = [[SPImage alloc] initWithContentsOfFile:@"tuto2.png"];
    _tutoImage.width = GAME_WIDTH;
    _tutoImage.height = GAME_HEIGHT;
    [self addChild:_tutoImage];

    [_tutoImage addEventListener:@selector(beginGame) atObject:self forType:SP_EVENT_TYPE_TOUCH];
}

- (void)beginGame
{
    ++_clicCount;
    if (_clicCount == 2)
    {
        [_tutoImage removeEventListenersAtObject:self forType:SP_EVENT_TYPE_TOUCH];
        [self removeChild:_tutoImage];
        [_tutoImage release];
        
        [self setup];
    }
}

- (BOOL)aroundDistance:(int)distance
{
    return distance >= 50000 && distance % 50000 < 50 ? YES : NO;
}

- (void)onGoing:(SPEnterFrameEvent *)event
{
   	float passedTime = (float)event.passedTime;
    
    if (_userControls == NO)
        [self processAccelloration];
    
    _totalTime += passedTime;
    _distance += (_target.speed * passedTime);
    _target.speed -= (_totalTime / (_target.gravity / 2));

    // Change gravity depending on game time
    if ([self aroundDistance:(int)_distance] == YES)
        _target.gravity -= 3;
    
    _target.fire.scaleX = _target.fire.scaleY = (_target.speed / 1000) / 3;
    _target.y -= (_target.speed * passedTime);
    
    if (_target.speed <= -30.0f) // Stop the game
    {
        [self cleanBeforeReplay];
        self = [self init];
        return;
    }

    // Move ruy to hide it
    if (_target.y < (GAME_HEIGHT / 1.5))
    {
        [self moveWorldWithDistance:(_target.speed * passedTime)];
        _target.y = GAME_HEIGHT / 1.5;
        _ryu.y += _target.speed * passedTime;
    }
    
    // Steps and background handlers
    if (_distance >= GAME_HEIGHT - 20 && _step == NONE)
        [super initRepeatedBackgroundForStep:FIRST_STEP];
    
    else if (_distance >= (GAME_HEIGHT * 40) && _step == FIRST_STEP)
        [super initRepeatedBackgroundForStep:SECOND_STEP];
    
    else if (_distance >= DISTANCE_BETWEEN_WORLDZ * (_step - 1) && _step == SECOND_STEP)
        [super initRepeatedBackgroundForStep:THIRD_STEP];
    
    else if (_distance >= DISTANCE_BETWEEN_WORLDZ * (_step - 1) && _step == THIRD_STEP)
        [super initRepeatedBackgroundForStep:FOURTH_STEP];
    
    else if (_distance >= DISTANCE_BETWEEN_WORLDZ * (_step - 1) && _step == FOURTH_STEP)
        [super initRepeatedBackgroundForStep:FIFTH_STEP];
    
    else if (_distance >= DISTANCE_BETWEEN_WORLDZ * (_step - 1) && _step == FIFTH_STEP)
        [super initRepeatedBackgroundForStep:SIXTH_STEP];
    
    else if (_distance >= DISTANCE_BETWEEN_WORLDZ * (_step - 1) && _step == SIXTH_STEP)
        [super initRepeatedBackgroundForStep:SEVENTH_STEP];
    
    else if (_distance >= DISTANCE_BETWEEN_WORLDZ * (_step - 1) && _step == SEVENTH_STEP)
        [super initRepeatedBackgroundForStep:EIGHTH_STEP];
    
    // Update graphical content
    _speedGauge.value = ((_target.speed / 1000) * 15) / 100;
    _bulletsGauge.value = ((_target.remainingBullets * 100.0f) / _bulletsGauge.numBars) / 100.0f;
    _gravityGauge.value = ((_target.gravity * 100) / _gravityGauge.numBars) / 100.0f;
    
    _distanceField.text = [NSString stringWithFormat:@"%i km", (int)_distance / 1000];
}


- (void)onMovementChanged:(MovementControlsEvent *)event
{
    _target.movementType = event.movementType;
}

#pragma mark - 
#pragma mark - iAd

- (void) adjustBannerView
{
    CGRect contentViewFrame = CGRectMake(0, GAME_HEIGHT - 50, GAME_WIDTH, 50);
    CGRect adBannerFrame = self.adBannerView.frame;
    _adBannerView.backgroundColor = [UIColor whiteColor];

    if ([self.adBannerView isBannerLoaded])
    {
        CGSize bannerSize = [ADBannerView sizeFromBannerContentSizeIdentifier:self.adBannerView.currentContentSizeIdentifier];
        contentViewFrame.size.height = contentViewFrame.size.height - bannerSize.height;
        adBannerFrame.origin.y = GAME_HEIGHT - 50;
    }   
    else
    {
        adBannerFrame.origin.y = GAME_HEIGHT - 50;
    }
    [UIView animateWithDuration:2.0 animations:^{
        self.adBannerView.frame = adBannerFrame;
    }];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self adjustBannerView];
   
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (_adBannerView)
    {
        _adBannerView.alpha = 0.0f;
    
        if ([_adBannerView respondsToSelector:@selector(removeFromSuperview)])
            [UIView animateWithDuration:2.0 animations:^{
                [_adBannerView removeFromSuperview];
            }];
        _adBannerView = nil;
    
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    NSLog(@"finish");
}

- (void) createAdBannerView
{
    _adBannerView = [[ADBannerView alloc] initWithFrame:CGRectMake(0, GAME_HEIGHT - 50, GAME_WIDTH, 50)];
    _adBannerView.backgroundColor = [UIColor clearColor];
    _adBannerView.alpha = 1.0f;
    CGRect bannerFrame = self.adBannerView.frame;
    bannerFrame.origin.y = GAME_HEIGHT - 50;
    self.adBannerView.frame = bannerFrame;
    
    self.adBannerView.delegate = self;
    self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierPortrait, ADBannerContentSizeIdentifierLandscape, nil];
}

#pragma mark -
#pragma mark - Accelerometer

- (void)processAccelloration
{
    float accelX = 0.0f;
    
    [_rawAccelX insertObject:[NSNumber numberWithFloat:_motionManager.accelerometerData.acceleration.x] atIndex:0];
    [_rawAccelX removeObjectAtIndex:NUM_FILTER_POINT];
    
    for (NSNumber *raw in _rawAccelX)
    {
        accelX += [raw floatValue];
    }
    accelX *= ACCEL_FACTOR / NUM_FILTER_POINT;
    
    [self accellorateByX:accelX];
}

- (void)accellorateByX:(int)x
{
    _target.xFactor = x;
    if (x < 70 && x > -70)
        _target.movementType = PlayerMovementTypeStop;
    else if (x < -70)
        _target.movementType = PlayerMovementTypeLeft;
    else if (x > 70)
        _target.movementType = PlayerMovementTypeRight;
}
@end
