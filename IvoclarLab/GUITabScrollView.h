//
//  GUITabScrollView.h
//  IvoclarLab
//
//  Created by Subramanyam on 20/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GUITabScrollDelegate;

@interface GUITabScrollView : UIScrollView

@property (weak, nonatomic) id<GUITabScrollDelegate> tabScrollDelegate;

- (instancetype)initWithFrame:(CGRect)frame tabViews:(NSArray *)tabViews tabBarHeight:(CGFloat)height tabColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor selectedTabIndex:(NSInteger)index;
- (instancetype)initWithFrame:(CGRect)frame tabViews:(NSArray *)tabViews tabBarHeight:(CGFloat)height tabColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor;

- (void)animateToTabAtIndex:(NSInteger)index;
- (void)animateToTabAtIndex:(NSInteger)index animated:(BOOL)animated;


@end

@protocol GUITabScrollDelegate <NSObject>

- (void)tabScrollView:(GUITabScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index;

@end
