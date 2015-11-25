//
//  SideMenuListViewController.m
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "SideMenuListViewController.h"
#import "UpdateMobileScreen.h"
#import "ComplaintsScreen.h"


@interface SideMenuListViewController ()

@end

@implementation SideMenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    // This View Controller is for displaying the contents in sidemenu
    
    [[CommonAppManager sharedAppManager]viewController:self];
    
    
    
  //  menuArray = [[NSMutableArray alloc]initWithObjects:@"CaseEntry",@"Profile",@"CaseHistory",@"Feedback",@"Update Mobile",@"Complaints",@"CaseDelivery",@"Home", nil];
    _sidebarMenuTV.delegate = self;
    _sidebarMenuTV.dataSource = self;
    _sidebarMenuTV.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    
    //self.view.backgroundColor = [UIColor blueColor];
    
    
}

-(void) sideMenuList:(NSMutableArray *)sideMenuListArray
{
    menuArray = sideMenuListArray;
    NSLog(@"sidemenu list : %@",sideMenuListArray);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - sidemenuTableview

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return menuArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = [menuArray objectAtIndex:indexPath.row];
    
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];

    
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.backgroundColor = [UIColor blueColor];

    }
    

    
    return cell;
    
    
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"updateMobile"]) {
        
        UpdateMobileScreen * mobileUpdate = [segue destinationViewController];
        
        [self.revealViewController pushFrontViewController:mobileUpdate animated:YES];
        
    }
    else if ([[segue identifier] isEqualToString:@"complaintSegue"])
    {
        
        
    }
    
    
    
}


@end
