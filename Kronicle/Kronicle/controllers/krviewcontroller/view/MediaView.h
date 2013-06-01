//
//  MediaView.h
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

typedef enum  {
    MediaViewImage,
    MediaViewVideo
} MediaViewType;

@interface MediaView : UIView {
    @private
    MPMoviePlayerController *_moviePlayer;
    UIImageView *_imageView;
    
}

@property (nonatomic, strong) NSString *mediaPath;


- (void)setMediaPath:(NSString*)mediaPath andType:(MediaViewType)type;
- (void)stop;
- (UIImage *)image;
@end