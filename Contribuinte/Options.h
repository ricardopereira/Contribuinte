//
//  Options.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionItem : NSObject

@property (nonatomic, strong) NSString * description;

- (instancetype)init:(NSString *)value;

@end


@interface OptionItemState : OptionItem

@property (nonatomic) BOOL enabled;

- (instancetype)init:(NSString *)description withState:(BOOL)enabled;

@end


@interface Options : NSObject

@property (nonatomic, strong) NSArray *items;

- (instancetype)init;

@end
