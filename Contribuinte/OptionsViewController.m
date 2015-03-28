//
//  OptionsViewController.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 20/03/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "OptionsViewController.h"
#import "Options.h"
#import "OptionsTableViewDataSource.h"
#import "OptionsTableViewDelegate.h"

#import "BlurView.h"

@interface OptionsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) Options* options;

@property (nonatomic, strong) OptionsTableViewDelegate *tableViewDelegate;
@property (nonatomic, strong) OptionsTableViewDataSource *tableViewDataSource;

@end

@implementation OptionsViewController

- (void)loadView
{
    [super loadView];
    self.options = [[Options alloc] init];
    self.tableViewDelegate = [[OptionsTableViewDelegate alloc] initWith:self.options];
    self.tableViewDataSource = [[OptionsTableViewDataSource alloc] initWith:self.options];

    UIView *blurView = [BlurView insertBlurView:self.view withStyle:UIBlurEffectStyleDark];
    [blurView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchClose:)]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Table
    self.tableView.delegate = self.tableViewDelegate;
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.scrollEnabled = false;
}

- (BOOL)prefersStatusBarHidden
{
    return true;
}

- (IBAction)didTouchClose:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
