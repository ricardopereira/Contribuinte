//
//  SlideMenu.h
//  Contribuinte
//
//  Created by Roshan Balaji on 3/28/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SlideMenuShownState,
    SlideMenuClosedState,
    SlideMenuDisplayingState
} SlideMenuState;

typedef enum {
    SlideMenuTextAlignmentLeft,
    SlideMenuTextAlignmentRight,
    SlideMenuTextAlignmentCenter
} SlideMenuAlignment;


@interface SlideMenuItemCell : UITableViewCell

@end


@interface SlideMenuItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) void (^completion)(BOOL);

// Initialization methods
- (SlideMenuItem *)initMenuItemWithTitle:(NSString *)title withCompletionHandler:(void (^)(BOOL))completion;

@end

@interface SlideMenu : UIView<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic) SlideMenuState currentMenuState;
@property(nonatomic) CGFloat height;
@property(nonatomic, strong) UIColor *textColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, strong) UIColor *highLightTextColor;
@property(nonatomic) SlideMenuAlignment titleAlignment;

// Create Menu with white background
- (SlideMenu *)initWithItems:(NSArray *)menuItems andTextAlignment:(SlideMenuAlignment)titleAlignment forViewController:(UIViewController *)viewController;

- (SlideMenu *)initWithItems:(NSArray *)menuItems
               textColor:(UIColor *)textColor
     hightLightTextColor:(UIColor *)hightLightTextColor
         backgroundColor:(UIColor *)backGroundColor
       andTextAlignment:(SlideMenuAlignment)titleAlignment
       forViewController:(UIViewController *)viewController;

- (void)showMenu;

@end
