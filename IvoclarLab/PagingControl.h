//
//  PagingControl.h
//  IvoclarLab
//
//  Created by Subramanyam on 19/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GUITabPagerViewController.h"

@interface PagingControl : GUITabPagerViewController<GUITabPagerDataSource,GUITabPagerDelegate>



//@property (strong, nonatomic) UIPageViewController *pageController;

@property NSUInteger index;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *pageControlSideMenu;

@end
