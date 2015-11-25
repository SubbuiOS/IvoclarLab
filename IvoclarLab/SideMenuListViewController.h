//
//  SideMenuListViewController.h
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "CommonAppManager.h"

@interface SideMenuListViewController : ViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * menuArray;
    UITableViewCell * cell;
}


@property (weak, nonatomic) IBOutlet UITableView *sidebarMenuTV;

-(void) sideMenuList : (NSMutableArray *) sideMenuListArray;


@end
