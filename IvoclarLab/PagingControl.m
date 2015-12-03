//
//  PagingControl.m
//  IvoclarLab
//
//  Created by Mac on 19/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "PagingControl.h"
#import "CaseEntryViewController.h"
#import "CaseHistory.h"
#import "SWRevealViewController.h"

@interface PagingControl ()

@end

@implementation PagingControl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.pageControlSideMenu setTarget: self.revealViewController];
        [self.pageControlSideMenu setAction: @selector( revealToggle: )];
        //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = @"Ivoclar Lab";
    
    [self setDataSource:self];
    [self setDelegate:self];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Tab Pager Data Source

- (NSInteger)numberOfViewControllers {
    return 2;
}

- (UIViewController *)viewControllerForIndex:(NSInteger)index {
    
    
    if (index == 0) {
        CaseEntryViewController *CEVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ce"];
        CEVC.index = index;
        
        return CEVC;
        
    }
    
    else
    {
        CaseHistory * CHVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ch"];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        CHVC.index = index;
        //index++;
        return CHVC;
        
    }
    
}

// Implement either viewForTabAtIndex: or titleForTabAtIndex:
//- (UIView *)viewForTabAtIndex:(NSInteger)index {
//  return <#UIView#>;
//}

- (NSString *)titleForTabAtIndex:(NSInteger)index {
    if (index == 0) {
        return @"Case Entry";
        
    }
    else
    {
        return @"Track your Case";
    }
    
}

- (CGFloat)tabHeight {
    // Default: 44.0f
    return 30.0f;
}

- (UIColor *)tabColor {
    // Default: [UIColor orangeColor];
    return [UIColor purpleColor];
}

- (UIColor *)tabBackgroundColor {
    // Default: [UIColor colorWithWhite:0.95f alpha:1.0f];
    return [UIColor lightTextColor];
}

- (UIFont *)titleFont {
    // Default: [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
    return [UIFont fontWithName:@"HelveticaNeue-Regular" size:20.0f];
}

- (UIColor *)titleColor {
    // Default: [UIColor blackColor];
    return [UIColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:1.0f];
}

#pragma mark - Tab Pager Delegate

- (void)tabPager:(GUITabPagerViewController *)tabPager willTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Will transition from tab %ld to %ld", (long)[self selectedIndex], (long)index);
}

- (void)tabPager:(GUITabPagerViewController *)tabPager didTransitionToTabAtIndex:(NSInteger)index {
    NSLog(@"Did transition to tab %ld", (long)index);
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/













@end
