//
//  OptionCell.h
//  Contribuinte
//
//  Created by Ricardo Pereira on 21/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OptionCell : UITableViewCell

@property (nonatomic, strong) NSString *userDefaultName;
@property (weak, nonatomic) IBOutlet UISwitch *option;

@end
