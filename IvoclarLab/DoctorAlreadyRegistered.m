//
//  DoctorAlreadyRegistered.m
//  IvoclarLab
//
//  Created by Mac on 08/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "DoctorAlreadyRegistered.h"

@interface DoctorAlreadyRegistered ()

@end

@implementation DoctorAlreadyRegistered

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    UIAlertView * alreadyRegisteredAlert = [[UIAlertView alloc]initWithTitle:@"You are already registered" message:@"Pls Login with the details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alreadyRegisteredAlert show];
    
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

- (IBAction)registeredSubmit:(id)sender {
}

- (IBAction)forgotPassword:(id)sender {
}

- (IBAction)newUserRegistration:(id)sender {
}
@end
