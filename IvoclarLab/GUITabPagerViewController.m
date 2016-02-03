//
//  GUITabPagerViewController.m
//  IvoclarLab
//
//  Created by Subramanyam on 20/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "GUITabPagerViewController.h"
#import "GUITabScrollView.h"

@interface GUITabPagerViewController () <GUITabScrollDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) GUITabScrollView *header;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) NSMutableArray *tabTitles;
@property (strong, nonatomic) UIColor *headerColor;
@property (strong, nonatomic) UIColor *tabBackgroundColor;
@property (assign, nonatomic) CGFloat headerHeight;

@end

@implementation GUITabPagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    [self setPageViewController:[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                                navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                              options:nil]];
    
    for (UIView *view in [[[self pageViewController] view] subviews]) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView *)view setCanCancelContentTouches:YES];
            [(UIScrollView *)view setDelaysContentTouches:NO];
        }
    }
    
    [[self pageViewController] setDataSource:self];
    [[self pageViewController] setDelegate:self];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self reloadTabs];
}



#pragma mark - Page View Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [[self viewControllers] indexOfObject:viewController];
    return pageIndex > 0 ? [self viewControllers][pageIndex - 1]: nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [[self viewControllers] indexOfObject:viewController];
    return pageIndex < [[self viewControllers] count] - 1 ? [self viewControllers][pageIndex + 1]: nil;
}

#pragma mark - Page View Delegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
    NSInteger index = [[self viewControllers] indexOfObject:pendingViewControllers[0]];
    [[self header] animateToTabAtIndex:index];
    
    if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
        [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    [self setSelectedIndex:[[self viewControllers] indexOfObject:[[self pageViewController] viewControllers][0]]];
    [[self header] animateToTabAtIndex:[self selectedIndex]];
    
    if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
        [[self delegate] tabPager:self didTransitionToTabAtIndex:[self selectedIndex]];
    }
}

#pragma mark - Tab Scroll View Delegate

- (void)tabScrollView:(GUITabScrollView *)tabScrollView didSelectTabAtIndex:(NSInteger)index {
    if (index != [self selectedIndex]) {
        if ([[self delegate] respondsToSelector:@selector(tabPager:willTransitionToTabAtIndex:)]) {
            [[self delegate] tabPager:self willTransitionToTabAtIndex:index];
        }
        
        [[self pageViewController]  setViewControllers:@[[self viewControllers][index]]
                                             direction:(index > [self selectedIndex]) ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                              animated:YES
                                            completion:^(BOOL finished) {
                                                [self setSelectedIndex:index];
                                                
                                                if ([[self delegate] respondsToSelector:@selector(tabPager:didTransitionToTabAtIndex:)]) {
                                                    [[self delegate] tabPager:self didTransitionToTabAtIndex:[self selectedIndex]];
                                                }
                                            }];
    }
}

- (void)reloadData {
    [self setViewControllers:[NSMutableArray array]];
    [self setTabTitles:[NSMutableArray array]];
    
    for (int i = 0; i < [[self dataSource] numberOfViewControllers]; i++) {
        UIViewController *viewController;
        
        if ((viewController = [[self dataSource] viewControllerForIndex:i]) != nil) {
            [[self viewControllers] addObject:viewController];
        }
        
        if ([[self dataSource] respondsToSelector:@selector(titleForTabAtIndex:)]) {
            NSString *title;
            if ((title = [[self dataSource] titleForTabAtIndex:i]) != nil) {
                [[self tabTitles] addObject:title];
            }
        }
    }
    
    [self reloadTabs];
    
    CGRect frame = [[self view] frame];
    frame.origin.y = [self headerHeight];
    frame.size.height -= [self headerHeight];
    
    [[[self pageViewController] view] setFrame:frame];
    
    [self.pageViewController setViewControllers:@[[self viewControllers][0]]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:NO
                                     completion:nil];
    [self setSelectedIndex:0];
}

- (void)reloadTabs {
    if ([[self dataSource] numberOfViewControllers] == 0)
        return;
    
    if ([[self dataSource] respondsToSelector:@selector(tabHeight)]) {
        [self setHeaderHeight:[[self dataSource] tabHeight]];
    } else {
        [self setHeaderHeight:44.0f];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(tabColor)]) {
        [self setHeaderColor:[[self dataSource] tabColor]];
    } else {
        [self setHeaderColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg.jpg"]]];
    }
    
    if ([[self dataSource] respondsToSelector:@selector(tabBackgroundColor)]) {
        [self setTabBackgroundColor:[[self dataSource] tabBackgroundColor]];
    } else {
        [self setTabBackgroundColor:[UIColor colorWithWhite:0.95f alpha:1.0f]];
    }
    
    _tabViews = [[NSMutableArray alloc]init];
    if ([[self dataSource] respondsToSelector:@selector(viewForTabAtIndex:)]) {
        for (int i = 0; i < [[self viewControllers] count]; i++) {
            UIView *view;
            if ((view = [[self dataSource] viewForTabAtIndex:i]) != nil) {
                [_tabViews addObject:view];
                
            
            }
        }
    } else {
        UIFont *font;
        if ([[self dataSource] respondsToSelector:@selector(titleFont)]) {
            font = [[self dataSource] titleFont];
        } else {
            font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
        }
        
        UIColor *color;
        if ([[self dataSource] respondsToSelector:@selector(titleColor)]) {
            color = [[self dataSource] titleColor];
        } else {
            color = [UIColor blackColor];
        }
        
        for (NSString *title in [self tabTitles]) {
            UILabel * tabLabel = [UILabel new];
            [tabLabel setText:title];
            [tabLabel setTextAlignment:NSTextAlignmentCenter];
            [tabLabel setFont:font];
            [tabLabel setTextColor:color];
            [tabLabel sizeToFit];
//            UIButton * tabButton = [UIButton buttonWithType:UIButtonTypeSystem];
//            [tabButton setTitle:title forState:UIControlStateNormal];
//            tabButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//            [tabButton setTitleColor:color forState:UIControlStateNormal];
//            [tabButton sizeToFit];
//            
//            CGRect frame = [tabButton frame];
            
            // If we want to change the width of tab change the below 85
            CGRect frame = [tabLabel frame];
            frame.size.width = MAX(frame.size.width + 20, 85);
            [tabLabel setFrame:frame];
            
            
            
            

            
         // tab outlook
            //[tabButton setFrame:frame];
            //[_tabViews addObject:tabButton];
            [_tabViews addObject:tabLabel];
        }
    }
    
    [_tabViews[0] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tab_bg.jpg"]]];
    
    // tab round corner
    
    
    
    UIBezierPath *maskPath;
//    maskPath = [UIBezierPath bezierPathWithRoundedRect:[_tabViews[0] bounds]
//                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
//                                           cornerRadii:CGSizeMake(10.0, 10.0)];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
          maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake([_tabViews[0]frame].origin.x, [_tabViews[0]frame].origin.y, [_tabViews[0]frame].size.width, [_tabViews[0]frame].size.height+100) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
        
    }
    
    else
    {
        maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake([_tabViews[0]frame].origin.x, [_tabViews[0]frame].origin.y, [_tabViews[0]frame].size.width, [_tabViews[0]frame].size.height+50) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
        

    }
    
  
    
    
   // maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(5, 0, 100, 60) byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = [_tabViews[0] bounds];
    maskLayer.path = maskPath.CGPath;
    [_tabViews[0] layer].mask = maskLayer;
    
    if ([self header]) {
        [[self header] removeFromSuperview];
    }
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    frame.size.height = [self headerHeight];
    [self setHeader:[[GUITabScrollView alloc] initWithFrame:frame tabViews:_tabViews tabBarHeight:[self headerHeight] tabColor:[self headerColor] backgroundColor:[self tabBackgroundColor] selectedTabIndex:self.selectedIndex]];
    [[self header] setTabScrollDelegate:self];
    
    [[self view] addSubview:[self header]];
}

#pragma mark - Public Methods

- (void)selectTabbarIndex:(NSInteger)index {
    [self selectTabbarIndex:index animation:NO];
}

- (void)selectTabbarIndex:(NSInteger)index animation:(BOOL)animation {
    [self.pageViewController setViewControllers:@[[self viewControllers][index]]
                                      direction:UIPageViewControllerNavigationDirectionReverse
                                       animated:animation
                                     completion:nil];
    [[self header] animateToTabAtIndex:index animated:animation];
    
    [self setSelectedIndex:index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
