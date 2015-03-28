//
//  OptionsTableDelegate.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "OptionsTableViewDelegate.h"
#import "Options.h"
#import "OptionCell.h"

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
    if ([cell isKindOfClass:[OptionCell class]]) {
        OptionCell *optionCell = (OptionCell *)cell;
        [optionCell configure:optionItem];
    }
}

@end
