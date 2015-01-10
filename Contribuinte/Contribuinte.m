//
//  Contribuinte.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 09/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "Contribuinte.h"

@implementation Contribuinte

@synthesize description;

+ (NSString*)primaryKey
{
    return @"number";
}

@end
