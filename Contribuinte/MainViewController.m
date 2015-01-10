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
    self.stackView.pagesHaveShadows = YES;
    self.views = [[NSMutableArray alloc] init];
    self.lastBrightness = -1;

    // Teste - Remove default Realm
    if (FEATURE_REALM && FEATURE_DEBUG) {
        [[NSFileManager defaultManager] removeItemAtPath:[RLMRealm defaultRealmPath] error:nil];
    }

    RLMResults *contribuintes = [Contribuinte allObjects];

    if (contribuintes.count == 0) {
        self.buttonAdd.hidden = false;
        self.stackView.hidden = true;
    }

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

        thisView.layer.cornerRadius = 5;
        thisView.layer.masksToBounds = YES;
    }
    return thisView;
}

- (NSInteger)numberOfPagesForStackView:(SSStackedPageView *)stackView
{
    return [self.views count];
}

- (void)stackView:(SSStackedPageView *)stackView selectedPageAtIndex:(NSInteger) index withView:(UIView*)page
{
    [page setBackgroundColor:[UIColor blueColor]];

    ViewContribuinte* currentPage = (ViewContribuinte*)page;

    currentPage.labelContribuinte.transform = CGAffineTransformScale(currentPage.labelContribuinte.transform, 1, 1);
    [UIView animateWithDuration:1.0 animations:^{
        currentPage.labelContribuinte.transform = CGAffineTransformMakeRotation(M_PI / 2);
        currentPage.labelContribuinte.transform = CGAffineTransformScale(currentPage.labelContribuinte.transform, 1.6, 1.6);
    }];

    // Set Brightness
    self.lastBrightness = [UIScreen mainScreen].brightness;
    [[UIScreen mainScreen] setBrightness:1.0];
}

- (void)stackView:(SSStackedPageView *)stackView deselectedPageAtIndex:(NSInteger) index withView:(UIView*)page
{
    // Already closed
    if (self.lastBrightness == -1)
        return;

    [page setBackgroundColor:[UIColor whiteColor]];

    ViewContribuinte* currentPage = (ViewContribuinte*)page;

    currentPage.labelContribuinte.transform = CGAffineTransformScale(currentPage.labelContribuinte.transform, 1, 1);
    [UIView animateWithDuration:1.0 animations:^{
        currentPage.labelContribuinte.transform = CGAffineTransformMakeRotation(2*M_PI);
        currentPage.labelContribuinte.transform = CGAffineTransformScale(currentPage.labelContribuinte.transform, 1, 1);
    }];

    // Unset Brightness
    [[UIScreen mainScreen] setBrightness:self.lastBrightness];
    self.lastBrightness = -1;
}

- (void)loadViewContribuintes:(RLMResults*)list
{
    for (Contribuinte *item in list) {
        // Create view
        ViewContribuinte *thisView = [[[NSBundle mainBundle] loadNibNamed:@"ViewContribuinte" owner:self options:nil] objectAtIndex:0];

        [thisView initLayout:item withRoot:self.view];
        
        [self.views addObject:thisView];
    }
}

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

        //RLMRealm *realm = [RLMRealm defaultRealm];
    }];
    actionAdd.enabled = false;

    // Cancel action
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"Cancelar" style:UIAlertActionStyleCancel handler:nil];

    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Descrição";

        [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:textField queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            // Check if is empty
            actionAdd.enabled = ![textField.text isEqualToString:@""];
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
