//
//  ReadMoreIPSScreen.m
//  IvoclarLab
//
//  Created by Subramanyam on 27/01/16.
//  Copyright (c) 2016 Ivoclar Vivadent. All rights reserved.
//

#import "ReadMoreIPSScreen.h"

@interface ReadMoreIPSScreen ()

@end

@implementation ReadMoreIPSScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [_backButtonOutlet setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:52.0/255.0 alpha:1]];
    
    _backButtonOutlet.layer.cornerRadius = 6;
    _backButtonOutlet.clipsToBounds = YES;
    
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

@end
