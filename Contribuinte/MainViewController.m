//
//  MainViewController.m
//  Contribuinte
//
//  Created by Ricardo Pereira on 09/01/2015.
//  Copyright (c) 2015 Ricardo Pereira. All rights reserved.
//

#import "MainViewController.h"
#import "ViewContribuinte.h"
#import "AddContribuinteController.h"
#import "OwnerProtocol.h"

#import "SSStackedPageView.h"
#import "SlideMenu.h"

#import <Realm/Realm.h>

#import "Contribuinte.h"
#import "ContribuinteModel.h"

@interface MainViewController () <SSStackedViewDelegate, OwnerProtocol>

@property (nonatomic) NSMutableArray *views;
@property (nonatomic) CGFloat lastBrightness;
@property (nonatomic) RLMNotificationToken *notificationToken;

@property (nonatomic) SlideMenu *menu;
@property (nonatomic) IBOutlet SSStackedPageView *stackView;
@property (weak, nonatomic) IBOutlet UIButton *buttonAdd;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Config
    self.stackView.delegate = self;
    self.stackView.pagesHaveShadows = true;

    self.lastBrightness = -1;
    
    [self buildMenu:self];

    [self.buttonAdd setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [self.stackView setBackgroundColor:[UIColor colorWithRed:0 green:0.42 blue:0.68 alpha:1]];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0.42 blue:0.68 alpha:1]];

    if (FEATURE_REALM && FEATURE_REALM_REINIT) {
        // Remove persistent data
        [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    }

    if (FEATURE_REALM) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        // Observe Realm Notifications
        self.notificationToken = [realm addNotificationBlock:^(NSString *note, RLMRealm *realm) {

            // ToDo: Poderá acontecer que um esteja selecionado e surgir notificação!
            [self loadContribuintes];
        }];
    }

    // Config
    [self loadContribuintes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (FEATURE_ORIENTATION) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    if (FEATURE_ORIENTATION) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }

    if (FEATURE_REALM && self.notificationToken != nil) {
        RLMRealm *realm = [RLMRealm defaultRealm];
        // Remove notification
        [realm removeNotification:self.notificationToken];
    }
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

- (void)buildMenu:(UIViewController*)vc
{
    if (!FEATURE_SLIDEMENU)
        return;
    
    NSMutableArray* items = [[NSMutableArray alloc] init];
    SlideMenuItem *currentItem;
    
    currentItem = [[SlideMenuItem alloc]initMenuItemWithTitle:@"Adicionar novo" withCompletionHandler:^(BOOL finished) {
        
        [self addContribuinte];
        
    }];
    [items addObject:currentItem];
    
    currentItem = [[SlideMenuItem alloc]initMenuItemWithTitle:@"Opções" withCompletionHandler:^(BOOL finished) {
        
        //ULSecondViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"secondView"];
        //[self setViewControllers:@[secondViewController] animated:NO];
    }];
    [items addObject:currentItem];
    
    currentItem = [[SlideMenuItem alloc]initMenuItemWithTitle:@"Sobre" withCompletionHandler:^(BOOL finished) {
        
        //ULSecondViewController *secondViewController = [storyboard instantiateViewControllerWithIdentifier:@"secondView"];
        //[self setViewControllers:@[secondViewController] animated:NO];
    }];
    [items addObject:currentItem];
    
    // Do any additional setup after loading the view, typically from a nib.
    _menu = [[SlideMenu alloc] initWithItems:items andTextAlignment:SlideMenuTextAlignmentLeft forViewController:vc];
}


#pragma mark - Logic

-(void)addContribuinte
{
    // Dialog
    AddContribuinteController *addContribuinteController = [AddContribuinteController alertControllerWithTitle:@"Contribuinte" message:@"Indique o número de identificação fiscal" withAcceptHandler:^(AddContribuinteController *sender) {
        // Accepted
        if (sender == nil)
            return;
        
        UITextField *fieldDescription = [[sender textFields] firstObject];
        UITextField *fieldNumber = [[sender textFields] lastObject];
        
        // Trim
        fieldDescription.text = [fieldDescription.text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        // Get max characters
        NSUInteger max = LENGTH_DESCRIPTION;
        if (fieldDescription.text.length > max)
            fieldDescription.text = [fieldDescription.text substringToIndex:max];
        
        ContribuinteModel *model = [[ContribuinteModel alloc] init];
        [model addContribuinte:fieldDescription.text withNumber:fieldNumber.text.integerValue];
    }];
    
    // Show
    [self presentViewController:addContribuinteController animated:true completion:nil];
}


#pragma mark - StackedPage delegate

- (UIView *)stackView:(SSStackedPageView *)stackView pageForIndex:(NSInteger)index
{
    ViewContribuinte *thisView = (ViewContribuinte*)[stackView dequeueReusablePage];
    if (!thisView) {
        thisView = [self.views objectAtIndex:index];

        thisView.layer.cornerRadius = 5;
        thisView.layer.masksToBounds = true;
    }

    // Update reusable with new data
    RLMResults *contribuintes = [Contribuinte allObjects];
    if (contribuintes.count > 0) {
        [thisView assignBuffer:[contribuintes objectAtIndex:index]];
        [thisView setupLayout:[contribuintes objectAtIndex:index]];
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
    self.views = [[NSMutableArray alloc] init];

    self.buttonAdd.hidden = contribuintes.count != 0;
    self.stackView.hidden = contribuintes.count == 0;

    [self loadViewContribuintes:contribuintes];
    [self.stackView resetPages];
    [self.stackView setNeedsLayout];
}

- (void)loadViewContribuintes:(RLMResults*)list
{
    for (Contribuinte *item in list) {
        // Create view
        ViewContribuinte *thisView = [[[NSBundle mainBundle] loadNibNamed:@"ViewContribuinte" owner:self options:nil] objectAtIndex:0];

        [thisView assignOwner:self];
        [thisView setupLayout:item];

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

        page.labelDescription.hidden = false;
        page.buttonAdd.hidden = false;
        page.buttonRemove.hidden = false;
    }];

    // Unset Brightness
    [self unsetFullBrightness];
}

- (void)landscapeMode:(ViewContribuinte*)page
{
    [self landscapeMode:page rotateLeft:false];
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

            page.labelDescription.hidden = true;
            page.buttonAdd.hidden = true;
            page.buttonRemove.hidden = true;
        };
    }
    else {
        blockAnimation = ^{
            page.labelContribuinte.transform = CGAffineTransformMakeRotation(M_PI / 2);
            page.labelContribuinte.transform = CGAffineTransformScale(page.labelContribuinte.transform, 1.6, 1.6);

            page.labelDescription.hidden = true;
            page.buttonAdd.hidden = true;
            page.buttonRemove.hidden = true;
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

- (IBAction)didTouchButtonAdd:(id)sender
{
    [self addContribuinte];
}

@end
