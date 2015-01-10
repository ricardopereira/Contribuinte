//
//  MainViewController.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 09/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "MainViewController.h"
#import "ViewContribuinte.h"
#import "SSStackedPageView.h"

#import <Realm/Realm.h>

#import "Contribuinte.h"

@interface MainViewController () <SSStackedViewDelegate>

@property (nonatomic) NSMutableArray *views;
@property (nonatomic) CGFloat lastBrightness;

@property (nonatomic) IBOutlet SSStackedPageView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Config
    self.stackView.delegate = self;
    self.stackView.pagesHaveShadows = true;

    self.views = [[NSMutableArray alloc] init];
    self.lastBrightness = -1;

    [self.buttonAdd setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.stackView setBackgroundColor:[UIColor colorWithRed:0 green:0.42 blue:0.68 alpha:1]];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0.42 blue:0.68 alpha:1]];

    if (FEATURE_REALM && FEATURE_REALM_REINIT) {
        // Remove persistent data
        [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    }

    // Config
    [self loadContribuintes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (FEATURE_ORIENTATION)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (FEATURE_ORIENTATION)
        [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if (self.lastBrightness != -1)
        [self unsetFullBrightness];
}

- (BOOL)prefersStatusBarHidden
{
    return !FEATURE_STATUSBAR;
}


#pragma mark - StackedPage delegate

- (UIView *)stackView:(SSStackedPageView *)stackView pageForIndex:(NSInteger)index
{
    UIView *thisView = [stackView dequeueReusablePage];
    if (!thisView) {
        thisView = [self.views objectAtIndex:index];

        thisView.layer.cornerRadius = 5;
        thisView.layer.masksToBounds = true;
    }
    return thisView;
}

- (NSInteger)numberOfPagesForStackView:(SSStackedPageView *)stackView
{
    return [self.views count];
}


#pragma mark - Model

- (void)loadContribuintes
{
    RLMResults *contribuintes = [Contribuinte allObjects];

    self.buttonAdd.hidden = contribuintes.count != 0;
    self.stackView.hidden = contribuintes.count == 0;

    [self loadViewContribuintes:contribuintes];
    [self.stackView resetPages];
    [self.stackView setNeedsDisplay];
    [self.stackView setNeedsLayout];
}

- (void)loadViewContribuintes:(RLMResults*)list
{
    for (Contribuinte *item in list) {
        // Create view
        ViewContribuinte *thisView = [[[NSBundle mainBundle] loadNibNamed:@"ViewContribuinte" owner:self options:nil] objectAtIndex:0];

        [thisView setupLayout:item withRoot:self.view];

        [self.views addObject:thisView];
    }
}

- (void)portraitMode:(ViewContribuinte*)page
{
    // Already deselected
    if (self.lastBrightness == -1)
        return;

    if (FEATURE_COLORSELECTED)
        [page setBackgroundColor:[UIColor whiteColor]];

    page.labelContribuinte.transform = CGAffineTransformScale(page.labelContribuinte.transform, 1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        page.labelContribuinte.transform = CGAffineTransformMakeRotation(2*M_PI);
        page.labelContribuinte.transform = CGAffineTransformScale(page.labelContribuinte.transform, 1, 1);
    }];

    // Unset Brightness
    [self unsetFullBrightness];
}

- (void)landscapeMode:(ViewContribuinte*)page
{
    [self landscapeMode:page rotateLeft:true];
}

- (void)landscapeMode:(ViewContribuinte*)page rotateLeft:(BOOL)left
{
    // Already selected
    if (self.lastBrightness != -1)
        return;

    if (FEATURE_COLORSELECTED)
        [page setBackgroundColor:[UIColor blueColor]];

    void (^blockAnimation)(void);

    page.labelContribuinte.transform = CGAffineTransformScale(page.labelContribuinte.transform, 1, 1);
    if (left) {
        blockAnimation = ^{
            page.labelContribuinte.transform = CGAffineTransformMakeRotation(-M_PI / 2);
            page.labelContribuinte.transform = CGAffineTransformScale(page.labelContribuinte.transform, 1.6, 1.6);
        };
    }
    else {
        blockAnimation = ^{
            page.labelContribuinte.transform = CGAffineTransformMakeRotation(M_PI / 2);
            page.labelContribuinte.transform = CGAffineTransformScale(page.labelContribuinte.transform, 1.6, 1.6);
        };
    }
    [UIView animateWithDuration:0.3 animations:blockAnimation];

    // Set Brightness
    [self setFullBrightness];
}

- (void)setFullBrightness
{
    self.lastBrightness = [UIScreen mainScreen].brightness;
    if (FEATURE_BRIGHTNESS)
        [[UIScreen mainScreen] setBrightness:1.0];
}

- (void)unsetFullBrightness
{
    [self unsetFullBrightness:false];
}

- (void)unsetFullBrightness:(BOOL)keepLastBrightness
{
    if (self.lastBrightness == -1)
        return;

    if (FEATURE_BRIGHTNESS)
        [[UIScreen mainScreen] setBrightness:self.lastBrightness];
    if (!keepLastBrightness)
        self.lastBrightness = -1;
}


#pragma mark - Notification handlers

- (void)orientationChanged:(NSNotification *)notification
{
    switch ([UIDevice currentDevice].orientation)
    {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            if (self.views.count == 1) {
                [self portraitMode:self.views.firstObject];
            }
            break;
        case UIInterfaceOrientationLandscapeLeft:
            if (self.views.count == 1) {
                [self landscapeMode:self.views.firstObject rotateLeft:true];
            }
            break;
        case UIInterfaceOrientationLandscapeRight:
            if (self.views.count == 1) {
                [self landscapeMode:self.views.firstObject rotateLeft:false];
            }
            break;
        default:
            break;
    }
}


#pragma mark - Stacked Delegate

- (void)stackView:(SSStackedPageView *)stackView selectedPageAtIndex:(NSInteger) index withView:(UIView*)page
{
    ViewContribuinte* currentPage = (ViewContribuinte*)page;

    [self landscapeMode:currentPage];
}

- (void)stackView:(SSStackedPageView *)stackView deselectedPageAtIndex:(NSInteger) index withView:(UIView*)page
{
    ViewContribuinte* currentPage = (ViewContribuinte*)page;

    [self portraitMode:currentPage];
}


#pragma mark - IBActions

- (IBAction)didTouchButtonAdd:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Contribuinte" message:@"Indique o número de identificação fiscal" preferredStyle:UIAlertControllerStyleAlert];

    // Add action
    UIAlertAction *actionAdd = [UIAlertAction actionWithTitle:@"Adicionar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // On action
        UITextField *fieldDescription = [[alertController textFields] firstObject];
        UITextField *fieldNumber = [[alertController textFields] lastObject];

        Contribuinte *contribuinte = [[Contribuinte alloc] init];
        contribuinte.description = fieldDescription.text;
        contribuinte.number = fieldNumber.text.integerValue;

        if (FEATURE_REALM) {
            RLMRealm *realm = [RLMRealm defaultRealm];
            // Save object
            [realm beginWriteTransaction];
            [realm addObject:contribuinte];
            [realm commitWriteTransaction];
        }
        else {
            // Add to array
        }
        [self loadContribuintes];
    }];
    actionAdd.enabled = false;

    // Cancel action
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Descrição";

        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // Check if is empty
            if ([textField.text isEqualToString:@""])
                actionAdd.enabled = false;
        }];
    }];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Número";
        textField.keyboardType = UIKeyboardTypeNumberPad;

        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // Check if is empty
            actionAdd.enabled = ![textField.text isEqualToString:@""];
            actionAdd.enabled = actionAdd.enabled && textField.text.length <= 9;
            actionAdd.enabled = actionAdd.enabled && textField.text.integerValue > 0;
        }];
    }];

    [alertController addAction:actionAdd];
    [alertController addAction:actionCancel];

    [self presentViewController:alertController animated:true completion:^{
        // Finish


    }];
}

@end
