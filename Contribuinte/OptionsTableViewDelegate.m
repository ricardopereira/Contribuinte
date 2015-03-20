//
//  OptionsTableDelegate.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "OptionsTableViewDelegate.h"
#import "Options.h"

@implementation OptionsTableViewDelegate

- (instancetype)initWith:(Options *)options
{
    if (self = [super init]) {
        self.options = options;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionItem *optionItem = self.options.items[indexPath.row];
    
    if ([optionItem isKindOfClass:[OptionItemState class]]) {
        // Cell with enabled and disabled state
        
    }
    else {
        
    }
    
    // Update
    if (cell.textLabel) {
        cell.textLabel.text = optionItem.description;
    }
}

@end
