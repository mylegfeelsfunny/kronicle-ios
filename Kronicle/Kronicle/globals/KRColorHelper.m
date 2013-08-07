//
//  KRColorHelper.m
//  Kronicle
//
//  Created by Scott on 6/1/13.
//  Copyright (c) 2013 haicontrast. All rights reserved.
//

#import "KRColorHelper.h"

@implementation KRColorHelper

+ (UIColor*)lightBlue {
    return [UIColor colorWithRed:.36f green:.82f blue:.87f alpha:1];
}

+ (UIColor*)darkBlue {
    return [UIColor colorWithRed:.14f green:.68f blue:.75f alpha:1];
}

+ (UIColor*)darkGrey {
    return [UIColor colorWithRed:.32f green:.32f blue:.32f alpha:1];
}

+ (UIColor*)lightGrey {
    return [UIColor colorWithRed:.91f green:.91f blue:.91f alpha:1];
}

+ (UIColor*)orange {
    return [UIColor colorWithRed:241/255.0f green:163/255.0f blue:37/255.0f alpha:1.0f]; //f1a325
}

+ (UIColor*)orangeTransparent {
    return [UIColor colorWithRed:241/255.0f green:163/255.0f blue:37/255.0f alpha:.3f]; //f1a325
}

+ (UIColor*)turquoise {
    return [UIColor colorWithRed:64/255.0f green:188/255.0f blue:178/255.0f alpha:1.0f]; //40BCB2
}

+ (UIColor*)turquoiseTransparent {
    return [UIColor colorWithRed:64/255.0f green:188/255.0f blue:178/255.0f alpha:.30f]; //40BCB2
}

@end
