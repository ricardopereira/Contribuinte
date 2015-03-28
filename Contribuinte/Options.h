//
//  Options.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OptionItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *title;

- (instancetype)init:(NSString *)key withTitle:(NSString *)title;
- (void)load;

@end


@interface OptionItemState : OptionItem

@property (nonatomic) BOOL enabled;

@end


@interface Options : NSObject

@property (nonatomic, strong) NSArray *items;

- (instancetype)init;
- (void)load;

@end
