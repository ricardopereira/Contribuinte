//
//  ViewController.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 08/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "ViewController.h"
#import "ViewContribuinte.h"
#import "SSStackedPageView.h"

@interface ViewController () <SSStackedViewDelegate>

@property (nonatomic) IBOutlet SSStackedPageView *stackView;
@property (nonatomic) NSMutableArray *views;

@property (nonatomic) CGFloat lastBrightness;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Config
    self.stackView.delegate = self;
    self.stackView.pagesHaveShadows = YES;
    self.views = [[NSMutableArray alloc] init];
    self.lastBrightness = -1;

    NSArray *contribuintes = @[@244413690, @13379548, @123456789];

    [self loadViewContribuintes:contribuintes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)stackView:(SSStackedPageView *)stackView pageForIndex:(NSInteger)index
{
    UIView *thisView = [stackView dequeueReusablePage];
    if (!thisView) {
        thisView = [self.views objectAtIndex:index];

        // Color
        //thisView.backgroundColor = [UIColor lightGrayColor];

        thisView.layer.cornerRadius = 5;
        thisView.layer.masksToBounds = YES;
    }
    return thisView;
}

- (NSInteger)numberOfPagesForStackView:(SSStackedPageView *)stackView
{
    return [self.views count];
}

- (void)stackView:(SSStackedPageView *)stackView selectedPageAtIndex:(NSInteger) index
{
    // ToDo! - Wrong selected view
    //ViewContribuinte *currentView = (ViewContribuinte*)[self.views objectAtIndex:index];

    // Brightness
    if (self.lastBrightness == -1) {
        self.lastBrightness = [UIScreen mainScreen].brightness;
        [[UIScreen mainScreen] setBrightness:1.0];
    }
    else {
        [[UIScreen mainScreen] setBrightness:self.lastBrightness];
        self.lastBrightness = -1;
    }
}

- (void)loadViewContribuintes:(NSArray*)list
{
    for (NSNumber *item in list) {
        // Create view
        ViewContribuinte *thisView = [[[NSBundle mainBundle] loadNibNamed:@"ViewContribuinte" owner:self options:nil] objectAtIndex:0];

        [thisView initLayout:item.integerValue withRoot:self.view];
        
        [self.views addObject:thisView];
    }
}

@end
