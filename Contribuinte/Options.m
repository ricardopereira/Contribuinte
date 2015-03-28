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

- (instancetype)init:(NSString *)name withTitle:(NSString *)title
{
    if (self = [super init]) {
        self.name = name;
        self.title = title;
        [self load];
    }
    return self;
}

- (void)load
{
    
}

@end


@implementation OptionItemState

- (void)load
{
    // Persistent data
    self.enabled = [[NSUserDefaults standardUserDefaults] integerForKey:self.name];
}

@end


@implementation Options

- (instancetype)init
{
    if (self = [super init]) {
        self.items = @[
                       [[OptionItemState alloc] init:@"brightnessAdjustment" withTitle:@"Ajustar brilho"],
                       [[OptionItem alloc] init:@"cleanDatabase" withTitle:@"Remover contribuintes"]
                       ];
    }
    return self;
}

@end
