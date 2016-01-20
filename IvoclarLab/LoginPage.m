//
//  LoginPage.m
//  IvoclarLab
//
//  Created by Subramanyam on 23/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "LoginPage.h"
#import "DoctorLogin.h"
#import "LabPersonLogin.h"

@interface LoginPage ()

@end

@implementation LoginPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    
   // self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];

    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
    
//    CGRect frame = CGRectMake(0, 0, 200, 44);
//    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
//    navigationTitleView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:25.0];
//    label.textColor = [UIColor whiteColor];
//    label.text = @"Ivoclar Lab";
//    
//    [navigationTitleView addSubview:label];
//    self.navigationItem.titleView = navigationTitleView;
//    
//    
//    // For Changing the color of navigation bar
//    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
//
    // The below line is for changing the back button color of navigation bar 
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    


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

- (IBAction)doctorLogin:(id)sender {
    
    
    DoctorLogin * doctorLoginPage = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorLogin"];
    
    [self.navigationController pushViewController:doctorLoginPage animated:YES];

    //[self presentViewController:doctorLoginPage animated:YES completion:nil];
    
    
}

- (IBAction)labPersonLogin:(id)sender {
    
    
    LabPersonLogin * labPersonLoginPage = [self.storyboard instantiateViewControllerWithIdentifier:@"labPersonLogin"];
    
    [self.navigationController pushViewController:labPersonLoginPage animated:YES];

    //[self presentViewController:labPersonLoginPage animated:YES completion:nil];
    
    
}


@end
