//
//  BlurView.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "BlurView.h"

@implementation BlurView

+ (UIView *)insertBlurView:(UIView*)view withStyle:(UIBlurEffectStyle)style
{
    view.backgroundColor = [UIColor clearColor];
    
    UIBlurEffect* blurEffect = [UIBlurEffect effectWithStyle:style];
    UIVisualEffectView* blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    
    blurEffectView.frame = view.bounds;
    [view insertSubview:blurEffectView atIndex:0];
    
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false;
    
    NSArray* constraints = @[
                             [NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                             [NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                             [NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0],
                             [NSLayoutConstraint constraintWithItem:blurEffectView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0]
                             ];
    
    [view addConstraints:constraints];
    return blurEffectView;
}

@end