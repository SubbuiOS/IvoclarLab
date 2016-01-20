//
//  ViewController.m
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    CGRect frame = CGRectMake(0, 0, 400, 44);
//    
//    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
//    navigationTitleView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:25.0];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = @"Ivoclar Lab";
    

    
    
//    [navigationTitleView addSubview:label];
//    self.navigationItem.titleView = navigationTitleView;
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _getStartedButtonOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _getStartedButtonOutlet.clipsToBounds = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getStartedButtonAction:(id)sender
{
    
    
    NSString *loginStatusString = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginStatus"];
    
    if (loginStatusString.length != 0)
    {
        NSLog(@"login Status %@",loginStatusString);
    
        if ([loginStatusString isEqual:@"DocLoginSuccess"])
        {
            
            SWRevealViewController * pageController = [self.storyboard instantiateViewControllerWithIdentifier:@"DoctorSWRevealViewController"];
        
            [self presentViewController:pageController animated:YES completion:nil];
            
            // }
            
        }
         if ([loginStatusString isEqual:@"LabLoginSuccess"])
        {
            SWRevealViewController * labCaseStatus = [self.storyboard instantiateViewControllerWithIdentifier:@"LabSWRevealViewController"];
            
            //[self.revealViewController pushFrontViewController:labCaseStatus animated:YES];
            [self presentViewController:labCaseStatus animated:YES completion:nil];
            
        }

    }
    
    else if (loginStatusString.length == 0)
    {
        LoginPage * loginScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
        [self presentViewController:loginScreen animated:YES completion:nil];
    }
    

    
    
}
@end
