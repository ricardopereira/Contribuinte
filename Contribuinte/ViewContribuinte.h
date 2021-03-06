//
//  ViewContribuinte.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 08/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Features.h"
#import "Contribuinte.h"
#import "OwnerProtocol.h"

@interface ViewContribuinte : UIView

@property (weak, nonatomic) IBOutlet UILabel *labelContribuinte;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIImageView *imageCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonBarCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonRemove;
@property (weak, nonatomic) IBOutlet UIButton *buttonExpand;

- (void)assignBuffer:(Contribuinte*)contribuinte;
- (void)assignOwner:(id <OwnerProtocol>)owner;
- (void)setupLayout:(Contribuinte*)number;

@end