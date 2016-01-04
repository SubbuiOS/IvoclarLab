//
//  SideMenuListViewController.m
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "SideMenuListViewController.h"
#import "UpdateMobileScreen.h"
#import "ComplaintsScreen.h"
#import "ViewController.h"
#import "LabCaseStatus.h"
#import "ProfileScreen.h"
#import "PagingControl.h"
#import "CaseHistory.h"
#import "FeedbackViewController.h"
#import "LabCaseHistory.h"


@interface SideMenuListViewController ()

@end

@implementation SideMenuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [_sidebarMenuTV reloadData];

    
    if (_sidebarMenuTV.tag == 2)
    {
        self.view.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];

        _sidebarMenuTV.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    }
    else
    {
        
        self.view.backgroundColor = [UIColor colorWithRed:21.0f/225.0f green:75.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
        
        _sidebarMenuTV.backgroundColor = [UIColor colorWithRed:21.0f/225.0f green:75.0f/255.0f blue:145.0f/255.0f alpha:1.0f];


    }
    
  
    // This View Controller is for displaying the contents in sidemenu
    
    
    [[CommonAppManager sharedAppManager]viewController:self];
    
    

    
    
  //  menuArray = [[NSMutableArray alloc]initWithObjects:@"CaseEntry",@"Profile",@"CaseHistory",@"Feedback",@"Update Mobile",@"Complaints",@"CaseDelivery",@"Home", nil];
   
    
    
    _sidebarMenuTV.delegate = self;
    _sidebarMenuTV.dataSource = self;

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

        if (tableView.tag==2) {
            
            cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
        }
 
    }
    
    if (tableView.tag==1)
    {
        cell.backgroundColor = [UIColor colorWithRed:21.0f/225.0f green:75.0f/255.0f blue:145.0f/255.0f alpha:1.0f];
    }

    cell.textLabel.text = [menuArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

  //  ProfileScreen * profilePage = [self.storyboard instantiateViewControllerWithIdentifier:@"newProfile"];
    
    //    if ((profilePage.doctorNameTF.text == nil) && (profilePage.areaNameTF.text == nil) && (profilePage.emailTF.text == nil) && (profilePage.pincodeTF.text == nil) && (profilePage.stateDDOutlet.titleLabel.text == nil) && (profilePage.cityDDOutlet.titleLabel.text == nil)) {
    
      //      UIAlertView * profileAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all the details in profile" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        //    [profileAlert show];
            
      //     ProfileScreen * profile = [self.storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
            
      //      [self.revealViewController pushFrontViewController:profile animated:YES];
    
      //  }
    
//    else
//    {
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"User"] isEqual:@"NewUser"]) {
        
        ProfileScreen * profilePage = [self.storyboard instantiateViewControllerWithIdentifier:@"newProfile"];
        
        if ((profilePage.doctorNameTF.text == nil) || (profilePage.areaNameTF.text == nil) || (profilePage.emailTF.text == nil) || (profilePage.pincodeTF.text == nil) || (profilePage.stateDDOutlet.titleLabel.text == nil) || (profilePage.cityDDOutlet.titleLabel.text == nil))
            
            {
                UIAlertView * profileAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please fill all the details in profile" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [profileAlert show];
            }
        
    }
    
    else
    {
    
    if (tableView.tag == 1) {
        
        
        
        if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"CaseEntry"]) {
            
            PagingControl * pageControl = [self.storyboard instantiateViewControllerWithIdentifier:@"pageControl"];
            
            [self.revealViewController pushFrontViewController:pageControl animated:YES];
            
            
        }
        else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"Profile"]) {
            
            ProfileScreen * profilePage = [self.storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
            
            [self.revealViewController pushFrontViewController:profilePage animated:YES];
            
            
            
        }
        else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"CaseHistory"]) {
            
            CaseHistory * caseHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"caseHistory"];
            
            [self.revealViewController pushFrontViewController:caseHistory animated:YES];
            
        }
//        else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"Feedback"]) {
//           
//           FeedbackViewController * caseHistory = [self.storyboard instantiateViewControllerWithIdentifier:@"feedback"];
//           
//           [self.revealViewController pushFrontViewController:caseHistory animated:YES];
//           
//       }
       else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"Update Mobile"]) {
           
           UpdateMobileScreen * updateMobile = [self.storyboard instantiateViewControllerWithIdentifier:@"updateMobile"];
           
           [self.revealViewController pushFrontViewController:updateMobile animated:YES];
           
       }
       else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"Complaints"]) {
           
           ComplaintsScreen * complaints = [self.storyboard instantiateViewControllerWithIdentifier:@"complaints"];
           
           [self.revealViewController pushFrontViewController:complaints animated:YES];
           
       }
       else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"CaseDelivery"]) {
           
           CaseDelivery * caseDelivery = [self.storyboard instantiateViewControllerWithIdentifier:@"caseDelivery"];
           
           [self.revealViewController pushFrontViewController:caseDelivery animated:YES];
           
       }
       else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"Home"]) {
           
           ViewController * homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
           
           
           homePage.modalTransitionStyle = UIModalTransitionStylePartialCurl;
           
          [self presentViewController:homePage animated:YES completion:nil];
           
           
       }
        
        
    }
    }
    
    if (tableView.tag == 2) {
       
        if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"CaseStatus"])
        {
            LabCaseStatus * caseStatus = [self.storyboard instantiateViewControllerWithIdentifier:@"labCaseStatus"];
            [self.revealViewController pushFrontViewController:caseStatus animated:YES];
            
        }
        
       else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"CaseHistory"]) {
           
            LabCaseHistory * caseHistoryLab = [self.storyboard instantiateViewControllerWithIdentifier:@"labCaseHistory"];
            [self.revealViewController pushFrontViewController:caseHistoryLab animated:YES];
           
           
        }
//        else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"View Complaints"]) {
//            
//            LabCaseStatus * viewComplaints = [self.storyboard instantiateViewControllerWithIdentifier:@"viewComplaints"];
//            [self.revealViewController pushFrontViewController:viewComplaints animated:YES];
//            
//
//        }
        else if ([[menuArray objectAtIndex:indexPath.row ] isEqual:@"Home"]) {
            
            ViewController * homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
            
            
            homePage.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            
            [self presentViewController:homePage animated:YES completion:nil];
            
            
            
        }
        
        
        
        
        
    }
        
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
  // if ([[segue identifier] isEqualToString:@"updateMobile"]) {
        
    //    UpdateMobileScreen * mobileUpdate = [segue destinationViewController];
        
      //  [self.revealViewController pushFrontViewController:mobileUpdate animated:YES];
        
    //}
    //else if ([[segue identifier] isEqualToString:@"complaintSegue"])
    //{
        
        
    //}
    
    
    
}


@end
