//
//  OptionsTableDelegate.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Options;

@interface OptionsTableViewDelegate : NSObject <UITableViewDelegate>

@property (nonatomic, strong) Options *options;

- (instancetype)initWith:(Options *)options;

@end
