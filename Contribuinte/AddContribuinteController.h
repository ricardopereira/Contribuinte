//
//  AddContribuinteController.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 10/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddContribuinteController : UIAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message withAcceptHandler:(void(^)(AddContribuinteController *sender))acceptHandler;

@end
