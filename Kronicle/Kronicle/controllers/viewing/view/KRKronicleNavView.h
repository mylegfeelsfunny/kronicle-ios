//
//  KRKronicleNavView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRClock.h"

#define kNavHeight 94.f

@class KRKronicleNavView;
@protocol KRKronicleNavViewDelegate <NSObject>
    @optional
    - (void)navViewBack:(KRKronicleNavView*)navView;
    - (void)navViewPlayPause:(KRKronicleNavView*)navView;

@end

@interface KRKronicleNavView : UIView {
    @private
    UIButton *_backButton;
    UIButton *_pauseButton;
    UILabel *_timeLabel;
    UILabel *_smallLabel;
    UIImageView *_backgroundView;
    UIImageView *_highlightView;
    
}

@property (nonatomic, strong) id <KRKronicleNavViewDelegate> delegate;
@property (nonatomic, strong) UIButton *pauseButton;

- (void)setTitleText:(NSString*)text;
- (void)setSubText:(NSString*)text;
- (void)isCurrentStep:(BOOL)isCurrentStep;
- (void)hidePausePlay;

@end