//
//  OptionCell.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 21/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "OptionCell.h"

@interface OptionCell()

@property (nonatomic, weak) OptionItem *optionItem;

@end

@implementation OptionCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)configure:(OptionItem *)optionItem
{
    self.optionItem = optionItem;
    
    if ([optionItem isKindOfClass:[OptionItemState class]]) {
        // Cell with enabled and disabled state
        self.switchButton.on = ((OptionItemState *)optionItem).enabled;
    }
    else {
        
    }
    
    // Update
    if (self.textLabel) {
        self.textLabel.text = optionItem.title;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didSwitchValueChanged:(id)sender
{
    if (!self.optionItem)
        return;
    UISwitch *senderSwitch = (UISwitch *)sender;
    // ToDo
    // Persistent data
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:senderSwitch.on forKey:self.optionItem.name];
    [defaults synchronize];
}

@end
