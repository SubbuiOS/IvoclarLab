//
//  SideMenuListViewController.m
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "SideMenuListViewController.h"

@interface SideMenuListViewController ()

@end

@implementation SideMenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // This View Controller is for displaying the contents in sidemenu
    
    
    menuArray = [[NSMutableArray alloc]initWithObjects:@"CaseEntry",@"Profile",@"CaseHistory",@"Feedback",@"Update Mobile",@"Complaints",@"CaseDelivery",@"Home", nil];
    _sidebarMenuTV.delegate = self;
    _sidebarMenuTV.dataSource = self;
    
    //self.view.backgroundColor = [UIColor blueColor];
    
    
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
}


@end
