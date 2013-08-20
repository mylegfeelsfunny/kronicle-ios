//
//  AddTimeCell.m
//  Kronicle
//
//  Created by Scott on 8/17/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "AddTimeCell.h"
#import "CreateStepTimeView.h"
#import "ContentWithLabelView.h"
#import "KRClockManager.h"

@interface AddTimeCell () {
    @private
    ContentWithLabelView *_duration;
    ContentWithLabelView *_hours;
    ContentWithLabelView *_minutes;
    ContentWithLabelView *_seconds;
}

@end


@implementation AddTimeCell


+ (CGFloat)cellHeight {
    return 80.f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeChangeNoticificatioReceived:) name:kTimeUnitCompleted object:nil];
        
        _duration = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(kPadding, 0, 60, 80)
                                                       andTitle:@"Duration"
                                                       andImage:[UIImage imageNamed:@"duration"]];
        [self.contentView addSubview:_duration];
        
        _hours = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(_duration.frame.origin.x + _duration.frame.size.width + (kPadding*2), _duration.frame.origin.y, 70, 70)
                                                    andTitle:@"hour"
                                                andTextValue:@"00"];
        [_hours addTarget:self withSelector:@selector(hoursTapped:)];
        [self.contentView addSubview:_hours];
        
        _minutes = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(_hours.frame.origin.x + _hours.frame.size.width, _duration.frame.origin.y, 70, 70)
                                                      andTitle:@"min"
                                                  andTextValue:@"00"];
        [_minutes addTarget:self withSelector:@selector(minutesTapped:)];
        [self.contentView addSubview:_minutes];
        
        _seconds = [[ContentWithLabelView alloc] initWithFrame:CGRectMake(_minutes.frame.origin.x + _minutes.frame.size.width, _duration.frame.origin.y, 70, 70)
                                                      andTitle:@"sec"
                                                  andTextValue:@"00"];
        [_seconds addTarget:self withSelector:@selector(secondsTapped:)];
        [self.contentView addSubview:_seconds];
        
        self.selectionStyle                                 = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor                    = [KRColorHelper turquoise];
    }
    return self;
}

- (void)prepareForUserWithTime:(NSInteger)time {
    NSDictionary *timeDict                                  = [KRClockManager getTimeUnits:time];
    
    NSInteger hours                                         = [[timeDict objectForKey:@"hours"] integerValue];
    NSInteger minutes                                       = [[timeDict objectForKey:@"minutes"] integerValue];
    NSInteger seconds                                       = [[timeDict objectForKey:@"seconds"] integerValue];
    
    _hours.textValue     =(hours < 10) ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    _minutes.textValue   =(minutes < 10) ? [NSString stringWithFormat:@"0%d", minutes] : [NSString stringWithFormat:@"%d", minutes];
    _seconds.textValue   =(seconds < 10) ? [NSString stringWithFormat:@"0%d", seconds] : [NSString stringWithFormat:@"%d", seconds];
}

#pragma request view for time creation
- (void)requestSeconds:(CreateStepTimeUnitType)type andCurrentValue:(NSInteger)currentValue {
    NSDictionary *aDictionary                                 = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                 [NSNumber numberWithInteger:type], @"unit",
                                                                 [NSNumber numberWithInteger:currentValue], @"currentValue",
                                                                 nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRequestTimeUnitEdit object:nil userInfo:aDictionary];
}

#pragma received time notification
-(void)timeChangeNoticificatioReceived:(NSNotification *)anote {
    NSDictionary *dict                                      = [anote userInfo];
    NSInteger timeValue                                     = [[dict objectForKey:@"currentValue"] integerValue];
    CreateStepTimeUnitType unit                             = [[dict objectForKey:@"unit"] integerValue];
    
    NSString *timeString =(timeValue < 10) ? [NSString stringWithFormat:@"0%d", timeValue] : [NSString stringWithFormat:@"%d", timeValue];
    switch (unit) {
        case CreateStepTimeUnitHours:
            _hours.textValue = timeString;
            break;
        case CreateStepTimeUnitMinutes:
            _minutes.textValue = timeString;
            break;
        case CreateStepTimeUnitSeconds:
            _seconds.textValue = timeString;
            break;
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma button time actions
- (IBAction)hoursTapped:(id)sender {
    NSInteger currentValue                                  = [_hours.textValue integerValue];
    [self requestSeconds:CreateStepTimeUnitHours andCurrentValue:currentValue];
}

- (IBAction)minutesTapped:(id)sender {
    NSInteger currentValue                                  = [_minutes.textValue integerValue];
    [self requestSeconds:CreateStepTimeUnitMinutes andCurrentValue:currentValue];
}

- (IBAction)secondsTapped:(id)sender {
    NSInteger currentValue                                  = [_seconds.textValue integerValue];
    [self requestSeconds:CreateStepTimeUnitSeconds andCurrentValue:currentValue];
}


@end