//
//  KRViewController.h
//  Kroncile
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "ViewController.h"
#import "KRKronicle.h"
#import "KRSwipeUpScrollView.h"
#import "MediaView.h"
#import "KRDiagramView.h"
#import "KRKronicleNavView.h"

@interface KRViewController : UIViewController
//<KRSwipeUpScrollViewDelegate, KRDiagramViewDelegate, KRClockDelegate, KRKronicleNavViewDelegate>
{
    @private
    CGRect _bounds;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_previewTimeLabel;

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

- (IBAction)goToKronicleListView:(id)sender;
- (IBAction)togglePlayPause:(id)sender;
- (IBAction)back:(id)sender;
- (id)initWithNibName:(NSString *)nibNameOrNil andKronicle:(KRKronicle *)kronicle;

@end
