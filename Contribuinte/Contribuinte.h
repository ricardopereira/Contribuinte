//
//  Contribuinte.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 09/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#define LENGTH_DESCRIPTION = 20;
#define LENGTH_NUMBER = 9;

@interface Contribuinte : RLMObject

@property NSString *description;
@property NSInteger number;

@end