//
//  Options.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "Options.h"

@implementation OptionItem

@synthesize description;

- (instancetype)init:(NSString *)value
{
    if (self = [super init]) {
        self.description = value ;
    }
    return self;
}

@end


@implementation OptionItemState

- (instancetype)init:(NSString *)description withState:(BOOL)enabled
{
    if (self = [super init:description]) {
        self.enabled = enabled;
    }
    return self;
}

@end


@implementation Options

- (instancetype)init
{
    // Loading current options
    NSInteger brightnessAdjustment = [[NSUserDefaults standardUserDefaults] integerForKey:@"brightnessAdjustment"];
    
    if (self = [super init]) {
        self.items = @[
                       [[OptionItemState alloc] init:@"Ajustar brilho" withState:brightnessAdjustment],
                       [[OptionItem alloc] init:@"Remover contribuintes"]
                       ];
    }
    return self;
}

@end
