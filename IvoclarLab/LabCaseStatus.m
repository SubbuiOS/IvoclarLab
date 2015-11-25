//
//  LabCaseStatus.m
//  IvoclarLab
//
//  Created by Mac on 24/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "LabCaseStatus.h"

@interface LabCaseStatus ()

@end

@implementation LabCaseStatus

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"Ivoclar Lab";
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //    statusArray = [[NSMutableArray alloc]initWithObjects:@"In-Process",@"Out for Dispatch",@"Delivered", nil];
    //    _statusPicker.hidden = YES;
    //    _statusPicker.delegate = self;
    //    _statusPicker.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [statusArray objectAtIndex:row];
    
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    [_statusButtonOutlet setTitle:[statusArray objectAtIndex:row]  forState:UIControlStateNormal];
    _statusPicker.hidden = YES;
    
}




- (IBAction)statusButtonAction:(id)sender {
    
    
    _statusPicker.hidden = NO;
    
    
    
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
