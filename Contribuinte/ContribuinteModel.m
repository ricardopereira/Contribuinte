//
//  ContribuinteModel.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 11/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "ContribuinteModel.h"

@implementation ContribuinteModel

- (void)addContribuinte:(NSString*)description withNumber:(NSInteger)number
{
    Contribuinte *contribuinte = [[Contribuinte alloc] init];
    contribuinte.description = description;
    contribuinte.number = number;

    if (FEATURE_REALM) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        // Save object
        [realm beginWriteTransaction];
        [realm addObject:contribuinte];
        [realm commitWriteTransaction];
    }
    else {
        // Add to array
    }
}

@end