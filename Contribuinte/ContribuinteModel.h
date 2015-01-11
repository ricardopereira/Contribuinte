//
//  ContribuinteModel.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 11/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "Features.h"
#import "Contribuinte.h"

@interface ContribuinteModel : NSObject

- (void)addContribuinte:(NSString*)description withNumber:(NSInteger)number;
- (void)removeContribuinte:(NSInteger)number;

@end
