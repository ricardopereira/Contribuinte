//
//  SSStackView.h
//  SSStackView
//
//  Created by Stevenson on 3/10/14.
//  Copyright (c) 2014 Steven Stevenson. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SSStackedViewDelegate;

@interface SSStackedPageView : UIView<UIScrollViewDelegate>

///delegate
@property (nonatomic) id<SSStackedViewDelegate> delegate;

///user settings for pages to have shadows
@property (nonatomic) BOOL pagesHaveShadows;

///dequeue the last page in the reusable queue
- (UIView*)dequeueReusablePage;
- (void)resetPages;

@end

@protocol SSStackedViewDelegate

///method for setting the current page at the index
- (UIView*)stackView:(SSStackedPageView *)stackView pageForIndex:(NSInteger)index;

///total number of pages to present in the stack
- (NSInteger)numberOfPagesForStackView:(SSStackedPageView *)stackView;

///handler for when a page is selected
- (void)stackView:(SSStackedPageView*)stackView selectedPageAtIndex:(NSInteger)index withView:(UIView*)page;

///hanlder for when page is deselected
- (void)stackView:(SSStackedPageView*)stackView deselectedPageAtIndex:(NSInteger)index withView:(UIView*)page;

@end