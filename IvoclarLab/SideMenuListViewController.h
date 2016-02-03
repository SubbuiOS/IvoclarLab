//
//  SideMenuListViewController.h
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "ViewController.h"
#import "SWRevealViewController.h"
#import "CommonAppManager.h"

@interface SideMenuListViewController : ViewController<UITableViewDataSource,UITableViewDelegate>

{
    NSMutableArray * menuArray;
    UITableViewCell * cell;
    NSMutableArray * cellImages;
    
}


@property (weak, nonatomic) IBOutlet UITableView *sidebarMenuTV;

-(void) sideMenuList : (NSMutableArray *) sideMenuListArray images : (NSMutableArray *) cellImagesArray;


@end
