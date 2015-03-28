//
//  BlurView.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurView : NSObject

+ (UIView *)insertBlurView:(UIView*)view withStyle:(UIBlurEffectStyle)style;

@end