//
//  UIView+Animations.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "UIView+Animations.h"

@implementation UIView (Animations)

- (void)shakeAnimation;
{
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"position"];
    [shake setDuration:0.1];
    [shake setRepeatCount:4];
    [shake setFromValue:[NSValue valueWithCGPoint: CGPointMake(self.center.x - 5,self.center.y)]];
    [shake setToValue:[NSValue valueWithCGPoint: CGPointMake(self.center.x + 5,self.center.y)]];
    
    [self.layer addAnimation:shake forKey:@"shake"];
}

@end
