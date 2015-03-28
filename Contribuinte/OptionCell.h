//
//  OptionCell.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 21/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Options.h"

@interface OptionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

- (void)configure:(OptionItem *)option;

@end
