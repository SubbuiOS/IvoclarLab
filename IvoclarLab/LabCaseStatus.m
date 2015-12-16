//
//  LabCaseStatus.m
//  IvoclarLab
//
//  Created by Subramanyam on 24/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "LabCaseStatus.h"
#import "CommonAppManager.h"

@interface LabCaseStatus ()

@end



@implementation LabCaseStatus

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.caseStatusSideMenu setTarget: self.revealViewController];
        [self.caseStatusSideMenu setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    //self.navigationItem.title = @"Ivoclar lab";
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
//    [self.navigationController.navigationBar
//     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Customising the navigation Title
    // Taken a view and added a label to it with our required font
    CGRect frame = CGRectMake(0, 0, 200, 44);
    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
    navigationTitleView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, -2, 200, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:25.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"Ivoclar Lab";
    
    [navigationTitleView addSubview:label];
    self.navigationItem.titleView = navigationTitleView;
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    //self.navigationItem.title = @"Ivoclar Lab";
    
        statusArray = [[NSMutableArray alloc]initWithObjects:@"In-Process",@"Out for Dispatch",@"Delivered", nil];
        _statusPicker.hidden = YES;
        _caseIdPicker.hidden = YES;
    
    
   
    _caseIdPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _caseIdPicker.layer.borderWidth = 1;
    _caseIdPicker.backgroundColor = [UIColor lightGrayColor];
    
}


-(void) getDataFromPlist
{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSMutableArray *contentArray= [[NSMutableArray alloc]init];
    
    if (![fileManager fileExistsAtPath: plistFilePath])
    {
        NSLog(@"file does not exist");
        
        // If the file doesn’t exist, create an empty plist file
        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
        
    }
    else{
        
        NSLog(@"File exists, Get data if anything stored");
        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
        NSLog(@"content array is %@",contentArray);
        
    }
    
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        
        data= [contentArray objectAtIndex:i];
        if ([data objectForKey:@"LabPersonID"]) {
            
            
            
            NSString *labID = [data objectForKey:@"LabPersonID"];
            
            NSLog(@"dr id :%@",labID);
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredlabCaseId = [[labID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            NSLog(@"lab id :%@",filteredlabCaseId);
            
        }
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)statusButtonAction:(id)sender {
    
    
    [_statusPicker reloadAllComponents];
    [_statusPicker selectRow:0 inComponent:0 animated:YES];
    
    _statusPicker.hidden = NO;
    _statusPicker.delegate = self;
    _statusPicker.dataSource = self;
    _submitCaseIdButtonOutlet.hidden = YES;
    
    _statusPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _statusPicker.layer.borderWidth = 1;
    _statusPicker.backgroundColor = [UIColor lightGrayColor];
    
    
    
    
}


- (IBAction)labCaseIdButtonAction:(id)sender
{
    
    [_caseIdPicker reloadAllComponents];
    [_caseIdPicker selectRow:0 inComponent:0 animated:YES];
    
    [self getDataFromPlist];
    
    NSString * labLoginCheck =  [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<GetLabCaseIds xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                 "<LabId>%@</LabId>\n"
                                 "</GetLabCaseIds>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n",filteredlabCaseId];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:labLoginCheck soapActionString:@"GetLabCaseIds" withDelegate:self];
    

    
}

-(void)connectionData:(NSData *)data status:(BOOL)status
{
    if (status) {
        
        
        
        NSData *connectionData = data;
        
        NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:connectionData];
        
        xmlParser.delegate = self;
        
        [xmlParser parse];
        
        
    }
    else{
        
        
        UIAlertView * connectionError = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Error in Connection....Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [connectionError show];
    }
    
    
}

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    currentDescription = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentDescription = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    //[spinner stopAnimating];
    
    //NSLog(@"element names :%@\n\n",elementName);
    
    if ([elementName isEqual:@"GetLabCaseIdsResult"]) {
        
        NSLog(@"lab login :%@",currentDescription);
        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        labCaseIdDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"case id's %@",labCaseIdDict);
        
        _caseIdPicker.hidden = NO;
        _caseIdPicker.delegate = self;
        _caseIdPicker.dataSource = self;
        
        _submitCaseIdButtonOutlet.hidden = YES;
        _statusButtonOutlet.hidden = YES;
        _statusLabel.hidden = YES;
        
        
        
        
    }
    
}


- (IBAction)submitCaseStatus:(id)sender
{
    
    //PUSH NOTIFICATIONS
    
}




- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (pickerView == _caseIdPicker) {
        
        return labCaseIdDict.count;
    }
    else
    {
        return statusArray.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _caseIdPicker) {
        
        return [[labCaseIdDict valueForKey:@"CaseId"]objectAtIndex:row];
        
    }
    else
    {
        return [statusArray objectAtIndex:row];
        
    }
    
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerViewLabel = (id)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    }
    
    pickerViewLabel.backgroundColor = [UIColor whiteColor];
    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
    
    if (pickerView == _caseIdPicker)
    {
        pickerViewLabel.text =[[labCaseIdDict valueForKey:@"CaseId" ]objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:18];
        
    }
    else if (pickerView == _statusPicker)
        
    {
        pickerViewLabel.text =[statusArray objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:16];
        
    }
    
    return pickerViewLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == _caseIdPicker) {
        
        [_caseIdLabel setText:[[labCaseIdDict valueForKey:@"CaseId"]objectAtIndex:row]];
        _caseIdPicker.hidden = YES;
        _statusLabel.hidden = NO;
        _statusButtonOutlet.hidden = NO;
        _submitCaseIdButtonOutlet.hidden = NO;
        
        
    }
    
    else
    {
        
        [_statusLabel setText:[statusArray objectAtIndex:row]];
        
        _statusPicker.hidden = YES;
        _submitCaseIdButtonOutlet.hidden = NO;
        
    }
    
    
    
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
