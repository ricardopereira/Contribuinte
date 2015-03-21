//
//  OptionCell.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 21/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "OptionCell.h"

@implementation OptionCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSwitchValueChanged:(id)sender
{
    UISwitch *senderSwitch = (UISwitch *)sender;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:senderSwitch.on forKey:self.userDefaultName];
    [defaults synchronize];
}

@end
