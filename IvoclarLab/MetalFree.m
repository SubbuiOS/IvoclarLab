//
//  MetalFree.m
//  IvoclarLab
//
//  Created by Subramanyam on 11/01/16.
//  Copyright (c) 2016 Ivoclar Vivadent. All rights reserved.
//

#import "MetalFree.h"
#import "SWRevealViewController.h"
#import "DoctorLogin.h"

@interface MetalFree ()

@end

@implementation MetalFree

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    _clickToOrderButtonOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _clickToOrderButtonOutlet.clipsToBounds = YES;
    [_titleLabel setBackgroundColor:[UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1]];
    
    
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

- (IBAction)clickToOrder:(id)sender
{
    
    // If already login as a doctor it will be redirected to caseEntry

    
    NSString *loginStatusString = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginStatus"];
    
    
    if ([loginStatusString isEqual:@"DocLoginSuccess"] ) {
        
       
            
            
            SWRevealViewController * caseEntry = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
            
            //[self.revealViewController pushFrontViewController:caseEntry animated:YES];
            
            [self presentViewController:caseEntry animated:YES completion:nil];
            
            
        
//        else if ([loginStatusString isEqual:@"LabLoginSuccess"])
//        {
//            
//            SWRevealViewController * labCaseStatus = [self.storyboard instantiateViewControllerWithIdentifier:@"LabSWRevealViewController"];
//            
//            [self presentViewController:labCaseStatus animated:YES completion:nil];
//            
//        }
//        
        
        
    }
    
    else
    {
        
       // LoginPage * loginScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        
        DoctorLogin * doctorLoginPage = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorLogin"];
        
        //[self.navigationController pushViewController:doctorLoginPage animated:YES];

        [self presentViewController:doctorLoginPage animated:YES completion:nil];
        
        UIAlertView * clickToOrderAlert = [[UIAlertView alloc]initWithTitle:@"Order" message:@"Please Login as a DOCTOR to order" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [clickToOrderAlert show];
        
        
    }

    
}

- (IBAction)readMoreZenostar:(id)sender
{
    
    
}

- (IBAction)readMoreIPSEmax:(id)sender
{
    
    
}

- (IBAction)backButton:(id)sender {
}
@end
