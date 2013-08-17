//
//  KRPlaybackViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRHomeViewController.h"
#import "KRKronicle.h"
#import "MediaView.h"

typedef enum {
    KRKronicleViewingStateView,
    KRKronicleViewingStatePreview
} KRKronicleViewingState;

@interface KRPlaybackViewController : UIViewController
//<KRSwipeUpScrollViewDelegate, KRDiagramViewDelegate, KRClockDelegate, KRKronicleNavViewDelegate>
{

//    KRSwipeUpScrollView *_scrollView;
//    KRDiagramView *_circleDiagram; 
////    UIImageView *_circleDiagramBackup; 
//    MediaView *_mediaViewA; 
//    MediaView *_mediaViewB;  
//    MediaView *_activeMedia;  
//    IBOutlet UIImageView *_playpauseButton;
//    UIButton *_listViewButton;
//    int _currentStep;
//    KRKronicleNavView *_navView;
//    KRClock *_clock;
//    id activePlayer;
//    UIView *_progressbar;
//    UIView *_totalbar;
}

@property (nonatomic, strong) KRKronicle *kronicle;

- (id)initWithKronicle:(KRKronicle *)kronicle andViewingState:(KRKronicleViewingState)viewingState;
- (id)initWithKronicle:(KRKronicle *)kronicle ;

@end