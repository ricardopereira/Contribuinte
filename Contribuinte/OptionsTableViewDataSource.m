//
//  OptionsDataSource.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "OptionsTableViewDataSource.h"
#import "Options.h"

@interface OptionsTableViewDataSource()

@end

@implementation OptionsTableViewDataSource

- (instancetype)initWith:(Options *)options
{
    if (self = [super init]) {
        self.options = options;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    OptionItem *optionItem = self.options.items[indexPath.row];
    
    if ([optionItem isKindOfClass:[OptionItemState class]]) {
        // Cell with enabled and disabled state
        cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"OptionCell" bundle:nil] forCellReuseIdentifier:@"optionCell"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"optionCell"];
        }
    }
    else {
        // Classic cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        if (!cell) {
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"textCell"];
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"textCell"];
        }
    }
    
    return cell;
}

@end
