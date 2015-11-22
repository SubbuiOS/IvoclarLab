//
//  PasswordGenarationScreen.m
//  IvoclarLab
//
//  Created by Mac on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "PasswordGenarationScreen.h"
#import "ProfileScreen.h"
#import "SWRevealViewController.h"

@interface PasswordGenarationScreen ()

@end

@implementation PasswordGenarationScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)passwordSubmit:(id)sender {
    
    if ([_passwordTF.text isEqual:_reenterPasswordTF.text]) {
        
        ProfileScreen * sideMenu = [self.storyboard instantiateViewControllerWithIdentifier:@"profilePage"];
        
        [self.revealViewController pushFrontViewController:sideMenu animated:YES];
        //[self presentViewController:sideMenu animated:YES completion:nil];
        
    }
    
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Passwords are not matching..Please enter correctly" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        _passwordTF.text = nil;
        _reenterPasswordTF.text= nil;
    }
    
    
}
@end
