//
//  SlideMenu.m
//  Contribuinte
//
//  Created by Roshan Balaji on 3/28/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import "SlideMenu.h"
#import <QuartzCore/QuartzCore.h>

#define CELLIDENTIFIER @"menubutton"
#define MENU_BOUNCE_OFFSET 10
#define PANGESTURE_ENABLE 1
#define MAX_PAN 260
#define VELOCITY_TRESHOLD 1000
#define AUTOCLOSE_VELOCITY 1200

@interface SlideMenuItem ()

// MenuButton
@property(strong, nonatomic)UIButton *menuButton;

@end

@implementation SlideMenuItem


-(SlideMenuItem *)initMenuItemWithTitle:(NSString *)title withCompletionHandler:(void (^)(BOOL))completion;
{
    self.title = title;
    self.completion = completion;
    return self;
}

@end

@interface SlideMenu ()

@property(nonatomic, strong)NSArray *menuItems;
@property(nonatomic, strong)UITableView *menuContentTable;
@property(nonatomic, weak)UIViewController *contentController;

@end

@implementation SlideMenu

NSString *const MENU_ITEM_DEFAULT_FONTNAME = @"HelveticaNeue-Light";
NSInteger const MENU_ITEM_DEFAULT_FONTSIZE = 25;
NSInteger const STARTINDEX = 1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.currentMenuState = SlideMenuClosedState;
        self.titleFont = [UIFont fontWithName:MENU_ITEM_DEFAULT_FONTNAME size:MENU_ITEM_DEFAULT_FONTSIZE];
    }
    return self;
}


#pragma mark initializers

-(SlideMenu *)initWithItems:(NSArray *)menuItems
       andTextAlignment:(SlideMenuAlignment)titleAlignment
       forViewController:(UIViewController *)viewController
{
    return [self initWithItems:menuItems
                     textColor:[UIColor grayColor]
           hightLightTextColor:[UIColor blackColor]
               backgroundColor:[UIColor whiteColor]
             andTextAlignment:titleAlignment
             forViewController:viewController];
}

-(SlideMenu *)initWithItems:(NSArray *)menuItems
               textColor:(UIColor *)textColor
     hightLightTextColor:(UIColor *)hightLightTextColor
         backgroundColor:(UIColor *)backGroundColor
       andTextAlignment:(SlideMenuAlignment)titleAlignment
       forViewController:(UIViewController *)viewController
{
    self = [[SlideMenu alloc] init];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.height = CGRectGetHeight(screenRect);
    
    self.frame = CGRectMake(0, 0, CGRectGetWidth(screenRect), self.height);
    self.menuItems = menuItems;
    self.titleAlignment = titleAlignment;
    self.textColor = textColor;
    self.highLightTextColor = hightLightTextColor;
    self.backgroundColor = backGroundColor;
    self.contentController = viewController;
    
    return self;
}

#pragma mark setter


-(void)setBackgroundColor:(UIColor *)backgroundColor {
    
    if(self.backgroundColor != backgroundColor) {
        
        [self.menuContentTable setBackgroundColor:backgroundColor];
        
    }
    
}

-(void)setHeight:(CGFloat)height {
    
    if(_height != height) {
        
        CGRect menuFrame = self.frame;
        menuFrame.size.height = height;
        _menuContentTable.frame = menuFrame;
        _height = height;
    }

}

- (void)setContentController:(UIViewController *)contentController {
    
    if (_contentController != contentController) {
        
        if (contentController.navigationController)
            _contentController = contentController.navigationController;
        else
            _contentController = contentController;
        
        
        if (PANGESTURE_ENABLE) {
            [_contentController.view addGestureRecognizer:[[UIPanGestureRecognizer alloc]
                                                           initWithTarget:self action:@selector(didPan:)]];
        }
        
        // Touch to dismiss
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                       initWithTarget:self action:@selector(didTouch:)]];
        
        
        
        [self setShadowProperties];
        
        [_contentController.view setAutoresizingMask:UIViewAutoresizingNone];
        
        UIViewController *menuController = [[UIViewController alloc] init];
        menuController.view = self;
        
        [[[[UIApplication sharedApplication] delegate] window] setRootViewController:menuController];
        [[[[UIApplication sharedApplication] delegate] window] addSubview:_contentController.view];
    }

}

-(void)setMenuContentTable:(UITableView *)menuContentTable
{
    if (_menuContentTable != menuContentTable) {
        
        [menuContentTable setDelegate:self];
        [menuContentTable setDataSource:self];
        [menuContentTable setShowsVerticalScrollIndicator:NO];
        [menuContentTable setSeparatorColor:[UIColor clearColor]];
        [menuContentTable setBackgroundColor:[UIColor whiteColor]];
        [menuContentTable setAllowsMultipleSelection:NO];
        _menuContentTable = menuContentTable;
        [self addSubview:_menuContentTable];
        
    }
}

-(void)setShadowProperties
{
    [_contentController.view.layer setShadowOffset:CGSizeMake(0, 1)];
    [_contentController.view.layer setShadowRadius:4.0];
    [_contentController.view.layer setShadowColor:[UIColor lightGrayColor].CGColor];
    [_contentController.view.layer setShadowOpacity:0.4];
    [_contentController.view.layer setShadowPath:[UIBezierPath
                                                  bezierPathWithRect:_contentController.view.bounds].CGPath];
}


#pragma mark Layout method

-(void)layoutSubviews {
    
    self.currentMenuState = SlideMenuClosedState;
    self.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), self.height);
    self.contentController.view.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]));
    [self setShadowProperties];
    self.menuContentTable = [[UITableView alloc] initWithFrame:self.frame];

}


#pragma mark Menu interactions

-(void)showMenu {
    
    if (self.currentMenuState == SlideMenuShownState || self.currentMenuState == SlideMenuDisplayingState) {
        if (self.currentMenuState == SlideMenuShownState || self.currentMenuState == SlideMenuDisplayingState) {
            [self animateMenuClosingWithCompletion:nil];
        }
    } else {
        self.currentMenuState = SlideMenuDisplayingState;
        [self animateMenuOpening];
    }
    
}

-(void)dismissMenu {
    
    if(self.currentMenuState == SlideMenuShownState || self.currentMenuState == SlideMenuDisplayingState){
        
        [self closeMenuFromCenterWithVelocity:AUTOCLOSE_VELOCITY];
        self.currentMenuState = SlideMenuClosedState;
    }
    
}

-(void)didPan:(UIPanGestureRecognizer *)panRecognizer {
    
    __block CGPoint viewCenter = panRecognizer.view.center;
    
    if (panRecognizer.state == UIGestureRecognizerStateBegan || panRecognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [panRecognizer translationInView:panRecognizer.view.superview];
        
        if (viewCenter.x >= [[UIScreen mainScreen] bounds].size.width / 2 &&
            viewCenter.x <= (([[UIScreen mainScreen] bounds].size.width / 2 + MAX_PAN) - MENU_BOUNCE_OFFSET)) {
            
            self.currentMenuState = SlideMenuDisplayingState;
            viewCenter.x = ABS(viewCenter.x + translation.x);
            
            if (viewCenter.x >= [[UIScreen mainScreen] bounds].size.width / 2 &&
                viewCenter.x < [UIScreen mainScreen].bounds.size.width / 2 + MAX_PAN - MENU_BOUNCE_OFFSET) {
                
                _contentController.view.center = viewCenter;
            }
            
            [panRecognizer setTranslation:CGPointZero inView:_contentController.view];
        }
        
    }
    else if (panRecognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [panRecognizer velocityInView:panRecognizer.view.superview];
        
        if (velocity.x > VELOCITY_TRESHOLD)
            [self openMenuFromCenterWithVelocity:velocity.x];
        else if (velocity.x < -VELOCITY_TRESHOLD)
            [self closeMenuFromCenterWithVelocity:ABS(velocity.x)];
        else if (viewCenter.x <  ([[UIScreen mainScreen] bounds].size.width / 2 + (MAX_PAN / 2)))
            [self closeMenuFromCenterWithVelocity:AUTOCLOSE_VELOCITY];
        else if (viewCenter.x <= ([[UIScreen mainScreen] bounds].size.width / 2 + MAX_PAN - MENU_BOUNCE_OFFSET))
            [self openMenuFromCenterWithVelocity:AUTOCLOSE_VELOCITY];
        
    }

}

-(void)didTouch:(UITapGestureRecognizer *)recognizer {
    
    [self dismissMenu];
    
}

#pragma mark animation and menu operations

-(void)animateMenuOpening{
    
    if(self.currentMenuState != SlideMenuShownState){
        
        [UIView animateWithDuration:.2 animations:^{
            
            //pushing the content controller down
            _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                         [[UIScreen mainScreen] bounds].size.height / 2 + _height);
        }completion:^(BOOL finished){
            
            [UIView animateWithDuration:.2 animations:^{
                
                _contentController.view.center = CGPointMake(_contentController.view.center.x,
                                                             [[UIScreen mainScreen] bounds].size.height / 2 + _height - MENU_BOUNCE_OFFSET);
                
            }completion:^(BOOL finished){
                
                self.currentMenuState = SlideMenuShownState;
                
            }];
            
        }];
    }
}

-(void)animateMenuClosingWithCompletion:(void (^)(BOOL))completion{
    
    [UIView animateWithDuration:.2 animations:^{
        
        //pulling the contentController up
        _contentController.view.center = CGPointMake(_contentController.view.center.x + MENU_BOUNCE_OFFSET,
                                                     _contentController.view.center.y);
        
        
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 animations:^{
            
            //pushing the menu controller down
            _contentController.view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2,
                                                         _contentController.view.center.y);
            
        } completion:^(BOOL finished){
            
            if (finished) {
                self.currentMenuState = SlideMenuClosedState;
                if (completion)
                    completion(finished);
            }
            
        }];
        
    }];
    
    
}

-(void)closeMenuFromCenterWithVelocity:(CGFloat)velocity {
    
    CGFloat viewCenterX = [[UIScreen mainScreen] bounds].size.width / 2;
    
    self.currentMenuState = SlideMenuDisplayingState;
    [UIView animateWithDuration:((_contentController.view.center.x - viewCenterX) / velocity)  animations:^{
        
        _contentController.view.center = CGPointMake(viewCenterX,
                                                     _contentController.view.center.y);
        
    }completion:^(BOOL completed) {
        
        self.currentMenuState = SlideMenuClosedState;
        
    }];
    
}

-(void)openMenuFromCenterWithVelocity:(CGFloat)velocity {
    
    CGFloat viewCenterX = [[UIScreen mainScreen] bounds].size.width / 2 + MAX_PAN - MENU_BOUNCE_OFFSET;
    
    self.currentMenuState = SlideMenuDisplayingState;
    [UIView animateWithDuration:((viewCenterX - _contentController.view.center.x) / velocity)  animations:^{
        
        _contentController.view.center = CGPointMake(viewCenterX, _contentController.view.center.y);
        
    }completion:^(BOOL completed){
        
        self.currentMenuState = SlideMenuShownState;
        
    }];
    
}

#pragma mark UITableViewDelegates

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.menuItems count] + 2 * STARTINDEX;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *menuCell = [tableView dequeueReusableCellWithIdentifier:CELLIDENTIFIER];
    SlideMenuItem *menuItem;
    
    if(menuCell == nil)
    {
        menuCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLIDENTIFIER];
        [self setMenuTitleAlligmentForCell:menuCell];
        menuCell.backgroundColor = [UIColor clearColor];
        menuCell.selectionStyle = UITableViewCellSelectionStyleNone;
        menuCell.textLabel.textColor = self.textColor;
        [menuCell.textLabel setFont:self.titleFont];
        
    }
  
    if(indexPath.row >= STARTINDEX && indexPath.row <= ([self.menuItems count] - 1 + STARTINDEX))
        menuItem = (SlideMenuItem *)[self.menuItems objectAtIndex:indexPath.row - STARTINDEX];
            menuCell.textLabel.text =  menuItem.title;
    
    
    return menuCell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.textLabel.textColor = self.textColor;
    [cell.textLabel setFont:self.titleFont];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < STARTINDEX || indexPath.row > [self.menuItems count] - 1 + STARTINDEX) {
        [self dismissMenu];
        return;
    }
    
    [self.menuContentTable reloadData];
    SlideMenuItem *selectedItem = [self.menuItems objectAtIndex:indexPath.row - STARTINDEX];
    [self animateMenuClosingWithCompletion:selectedItem.completion];
    
}

#pragma mark display modifications

-(void)setMenuTitleAlligmentForCell:(UITableViewCell *)cell{
    
    if (self.titleAlignment) {
        
        switch (self.titleAlignment) {
                
            case SlideMenuTextAlignmentLeft:
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
            case SlideMenuTextAlignmentCenter:
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                break;
            case SlideMenuTextAlignmentRight:
                cell.textLabel.textAlignment = NSTextAlignmentRight;
                break;
            default:
                break;
                
        }
        
    }
    
}

@end
