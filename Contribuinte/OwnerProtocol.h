//
//  PresentProtocol.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 11/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OwnerProtocol <NSObject>

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^)(void))completion;
- (void)showViewController:(UIViewController *)vc sender:(id)sender;

@end
