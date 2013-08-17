//
//  KRPlaybackViewController.m
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRPlaybackViewController.h"
#import "KRStep.h"
#import "DescriptionView.h"
//#import "KRViewListTypeViewController.h"
#import "KRColorHelper.h"
#import "KRFontHelper.h"


#import "KRGlobals.h"
#import "KRClockManager.h"
#import "KRKronicleManager.h"
#import "KRStepNavigation.h"
#import "KRScrollView.h"
#import "KRGraphView.h"
#import "KRStepListContainerView.h"
#import "MediaView.h"
#import "KRCircularKronicleGraph.h"
#import "KRNavigationViewController.h"


#define kScrollViewNormal 320.f
#define kScrollViewUp 180.f

@interface KRPlaybackViewController () <KRClockManagerDelegate, KRKronicleManagerDelegate, KRStepNavigationDelegate, KRScrollViewDelegate,  MediaViewDelegate,   KRStepListContainerViewDelegate> {
    @private
    CGRect _bounds;
    UIScrollView *_sview;
    UIButton *_backButton;
    UIButton *_publishButton;
    int _publishButtonHeight;
    KRKronicleManager *_kronicleManager;
    KRClockManager *_clockManager;
    KRStepNavigation *_stepNavigation;
    KRScrollView *_scrollView;
    KRGraphView *_graphView;
    KRStepListContainerView *_stepListContainerView;
    MediaView *_mediaView;
    KRCircularKronicleGraph *_circularGraphView;
    KRKronicleViewingState _viewingState;
}

@end

@implementation KRPlaybackViewController

- (id)initWithKronicle:(KRKronicle *)kronicle andViewingState:(KRKronicleViewingState)viewingState {
    self = [self initWithKronicle:kronicle];
    if (self) {
        _viewingState = viewingState;
        
    }
    return self;
}

- (id)initWithKronicle:(KRKronicle *)kronicle {
    self = [super initWithNibName:@"KRPlaybackViewController" bundle:nil];
    if (self) {
        self.kronicle = kronicle;

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    _bounds = [UIScreen mainScreen].bounds;
    _sview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _bounds.size.width, _bounds.size.height-20)];
    _sview.showsVerticalScrollIndicator = YES;
    _sview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_sview];
    
    _kronicleManager = [[KRKronicleManager alloc] initWithKronicle:self.kronicle];
    _kronicleManager.delegate = self;
    
    _clockManager = [[KRClockManager alloc] initWithKronicle:self.kronicle];
    _clockManager.delegate = self;
    
    _mediaView = [[MediaView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    _mediaView.delegate = self;
    [_sview addSubview:_mediaView];
    
    _graphView = [[KRGraphView alloc] initWithFrame:CGRectMake(0, _mediaView.frame.origin.y + _mediaView.frame.size.height, 320, 80)];
    [_sview addSubview:_graphView];

    _scrollView = [[KRScrollView alloc] initWithFrame:CGRectMake(0, _graphView.frame.origin.y, 320, 310) andKronicle:self.kronicle];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(320 * [self.kronicle.steps count], _scrollView.frame.size.height);
    _scrollView.scrollDelegate = self;
    [_sview addSubview:_scrollView];
    
    _stepNavigation = [[KRStepNavigation alloc] initWithFrame:CGRectMake(0, _graphView.frame.origin.y-40, 320, 100)];
    _stepNavigation.delegate = self;
    [_sview addSubview:_stepNavigation];
    
    int y = _scrollView.frame.origin.y + _scrollView.frame.size.height;
    _stepListContainerView = [[KRStepListContainerView alloc] initWithFrame:CGRectMake(0, y, 320, 0) andSteps:_kronicle.steps];
    _stepListContainerView.delegate = self;
    [_sview addSubview:_stepListContainerView];

    y = _stepListContainerView.frame.origin.y + _stepListContainerView.frame.size.height;
    _circularGraphView = [[KRCircularKronicleGraph alloc] initWithFrame:CGRectMake(0, y, 320, 340) andKronicle:self.kronicle];
    [_sview addSubview:_circularGraphView];
    
    _sview.contentSize = CGSizeMake(_bounds.size.width, _circularGraphView.frame.origin.y + _circularGraphView.frame.size.height + 70);
    
    _backButton       = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];

    if (_viewingState == KRKronicleViewingStateView) {
        [_backButton setBackgroundImage:[UIImage imageNamed:@"x-button"] forState:UIControlStateNormal];
        _backButton.backgroundColor = [KRColorHelper grayMedium];
        _backButton.frame = CGRectMake(5, 5, 26, 26);
    } else {
        [_backButton setTitle:@"Edit" forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backButton.backgroundColor = [KRColorHelper grayMedium];
        _backButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:14];
        _backButton.frame = CGRectMake(5, 5, 40, 26);
        
        _publishButtonHeight = 42;
        _publishButton       = [UIButton buttonWithType:UIButtonTypeCustom];
        _publishButton.backgroundColor = [KRColorHelper turquoise];
        [_publishButton setTitle:@"Publish" forState:UIControlStateNormal];
        [_publishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishButton.titleLabel.font = [KRFontHelper getFont:KRBrandonRegular withSize:14];
        _publishButton.frame = CGRectMake(_bounds.size.width - 82, _bounds.size.height-(_publishButtonHeight+20), 82, _publishButtonHeight);
        [_publishButton addTarget:self action:@selector(publishKronicle:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_publishButton];
    }
//    _sview.contentOffset = CGPointMake(0, _sview.contentSize.height - _sview.frame.size.height);
    [self setStep:0];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [(KRNavigationViewController *)self.navigationController navbarHidden:YES];

}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)publishKronicle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)dealloc {
    [_mediaView stop];
    _mediaView = nil;

}

#pragma KRClockManager delegate
- (void)manager:(KRClockManager *)manager updateTimeWithString:(NSString *)timeString
   andStepRatio:(CGFloat)stepRatio
 andGlobalRatio:(CGFloat)globalRatio {
    [_scrollView updateCurrentStepClock:timeString];
    [_graphView showDisplayForRatio:stepRatio];
    [_stepListContainerView updateCurrentStepWithRatio:stepRatio];
    
    [_circularGraphView updateForCurrentStep:_kronicleManager.currentStepIndex andRatio:globalRatio andTimeCompleted:(globalRatio * _kronicle.totalTime)];
}

- (void)manager:(KRClockManager *)manager stepComplete:(int)stepIndex {
    [self setStep:stepIndex + 1];
}


#pragma KRKronicleManager delegate
- (void)manager:(KRKronicleManager *)manager updateUIForStep:(KRStep*)step {
    if (_kronicleManager.currentStepIndex == _kronicleManager.previewStepIndex) {
        [_stepNavigation animateNavbarOut];
    }
    if (_clockManager.isPaused) {
        [self togglePlayPause];
    }
    
    [_clockManager setTimeForStep:step.indexInKronicle];
    [_stepListContainerView adjustStepListForCurrentStep:step.indexInKronicle];
    [_scrollView setCurrentStep:step.indexInKronicle];
    
    if (_kronicleManager.requestedDirection == KronicleManagerLeft) {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewLeft];
    } else {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewRight];
    }
    
}

- (void)manager:(KRKronicleManager *)manager previewUIForStep:(KRStep*)step {
    if (_kronicleManager.currentStepIndex == _kronicleManager.previewStepIndex) {
        [_stepNavigation animateNavbarOut];
        [_graphView showDisplayWithReset:NO];
    } else {
        [_stepNavigation animateNavbarIn];
        [_graphView showPreview:(_kronicleManager.currentStepIndex > step.indexInKronicle)];
    }
    [_scrollView scrollToPage:step.indexInKronicle];

    if (_kronicleManager.requestedDirection == KronicleManagerLeft) {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewLeft];
    } else {
        [_mediaView setMediaPath:step.imageUrl andType:MediaViewRight];
    }
}

- (void)kronicleComplete:(KRKronicleManager *)manager {
    [_graphView updateForLastStep];
    [_scrollView updateForLastStep];
    [_stepListContainerView updateForLastStep];
    [_circularGraphView updateForLastStep];
}


#pragma KRStepNavigator delegate
- (void)controls:(KRStepNavigation *)controls navigationRequested:(KRStepNavigationRequest)type {
    switch (type) {
        case KRStepNavigationRequestForward:
            [self previewStep:_kronicleManager.previewStepIndex + 1];
            break;
        case KRStepNavigationRequestBackward:
            [self previewStep:_kronicleManager.previewStepIndex - 1];
            break;
        case KRStepNavigationRequestResume:
            [self previewStep:_kronicleManager.currentStepIndex];
            break;
        case KRStepNavigationRequestSkip:
            [self setStep:_kronicleManager.previewStepIndex];
            break;
        case KRStepNavigationRequestStartOver:
            [self setStep:0];
            break;
    }

}


#pragma KRSwipeUpScrollView delegate
- (void)scrollView:(KRScrollView *)scrollView pageToIndex:(int)stepIndex {
    [_kronicleManager setPreviewStep:stepIndex];
}


#pragma KRStepListView delegate
- (void)stepListContainerView:(KRStepListContainerView*)stepListContainerView selectedByIndex:(int)stepIndex {
    [self setStep:stepIndex];
}

#pragma MediaView delegate
- (void)mediaViewScreenTapped:(MediaView *)mediaView {
    [self togglePlayPause];
}


#pragma private methods
- (void)previewStep:(int)step {
    [_kronicleManager setPreviewStep:step];
}

- (void)setStep:(int)step {
    [_graphView showDisplayWithReset:YES];
    [_kronicleManager setStep:step];
    [_kronicleManager setPreviewStep:step];
}

- (void)togglePlayPause {
    [_clockManager togglePlayPause];
    [_mediaView togglePlayPause:_clockManager.isPaused];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end