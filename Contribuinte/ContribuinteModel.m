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
        
        // Check if exist
        NSPredicate *query = [NSPredicate predicateWithFormat:@"number = %d", number];
        RLMResults *res = [Contribuinte objectsWithPredicate:query];
        
        if (res.count <= 0) {
            // Save object
            [realm beginWriteTransaction];
            [realm addObject:contribuinte];
            [realm commitWriteTransaction];
        }
    }
    else {
        // Add to array
    }
}

- (void)removeContribuinte:(NSInteger)number
{
    if (FEATURE_REALM) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        // Query
        RLMResults *result = [Contribuinte objectsWhere:[NSString stringWithFormat:@"number = %ld", (long)number]];
        if (result.count == 0)
            return;

        // Save object
        [realm beginWriteTransaction];
        [realm deleteObject:result.firstObject];
        [realm commitWriteTransaction];
    }
    else {
        // Add to array
    }
}

@end