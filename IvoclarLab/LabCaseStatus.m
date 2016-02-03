//
//  LabCaseStatus.m
//  IvoclarLab
//
//  Created by Subramanyam on 24/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import "LabCaseStatus.h"
#import "CommonAppManager.h"

@interface LabCaseStatus ()

@end

@implementation LabCaseStatus

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self labCaseStatusDidLoad];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        _caseIdLabel.frame = CGRectMake(_caseIdButtonOutlet.frame.origin.x+145, _caseIdButtonOutlet.frame.origin.y+18, 200, 32);
        
        _statusLabel.frame = CGRectMake(_statusButtonOutlet.frame.origin.x+145, _statusButtonOutlet.frame.origin.y+18, 200, 32);
        
    }
    
    _submitCaseIdButtonOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _submitCaseIdButtonOutlet.clipsToBounds = YES;
    
}


-(void) labCaseStatusDidLoad
{
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.caseStatusSideMenu setTarget: self.revealViewController];
        [self.caseStatusSideMenu setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    
    //self.navigationItem.title = @"Ivoclar lab";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:71.0f/255.0f green:118.0f/255.0f blue:172.0f/255.0f alpha:1];
    

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
    //self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    //self.navigationItem.title = @"Ivoclar Lab";
    
    statusArray = [[NSMutableArray alloc]initWithObjects:@"In-Process",@"Out for Dispatch",@"Delivered", nil];
    caseIdTV.hidden = YES;
    caseStatusTV.hidden = YES;
    
    
//    _caseIdPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _caseIdPicker.layer.borderWidth = 1;
//    _caseIdPicker.backgroundColor = [UIColor lightGrayColor];
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
    
    
    [commonView removeFromSuperview];
    [caseStatusTV removeFromSuperview];
    
    
    [caseStatusTV reloadData];
    
    caseStatusTV.hidden = NO;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_labCaseStatusView.frame.origin.x+137, _labCaseStatusView.frame.size.height+_labCaseStatusView.frame.origin.y-20, _labCaseStatusView.frame.size.width+200, 350)];

        
        caseStatusTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-320, 250) style:UITableViewStylePlain];
        
        
    }
    else
    {
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_labCaseStatusView.frame.origin.x+17, _labCaseStatusView.frame.size.height+_labCaseStatusView.frame.origin.y-20, _labCaseStatusView.frame.size.width+200, 350)];
        

        
        caseStatusTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 250) style:UITableViewStylePlain];
    }
    
    
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    


    caseStatusTV.delegate = self;
    caseStatusTV.dataSource = self;
    
    [commonView addSubview:caseStatusTV];
    
  //  [_statusPicker reloadAllComponents];
    //[_statusPicker selectRow:0 inComponent:0 animated:YES];
    
   // _statusPicker.hidden = NO;
   // _statusPicker.delegate = self;
   // _statusPicker.dataSource = self;
    _submitCaseIdButtonOutlet.hidden = YES;
    
//    _statusPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _statusPicker.layer.borderWidth = 1;
//    _statusPicker.backgroundColor = [UIColor lightGrayColor];
//    
    
    
    
}


- (IBAction)labCaseIdButtonAction:(id)sender
{
    
    [commonView removeFromSuperview];
    [caseIdTV removeFromSuperview];
    
     if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
     {
         commonView = [[UIView alloc]initWithFrame:CGRectMake(_labCaseIdView.frame.origin.x+137, _labCaseIdView.frame.size.height+_labCaseIdView.frame.origin.y-20, _labCaseIdView.frame.size.width+200, 350)];
     }
    else
    {
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_labCaseIdView.frame.origin.x+17, _labCaseIdView.frame.size.height+_labCaseIdView.frame.origin.y-20, _labCaseIdView.frame.size.width+200, 350)];
    }
    
    
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    
    [caseIdTV reloadData];
    
//    [_caseIdPicker reloadAllComponents];
//    [_caseIdPicker selectRow:0 inComponent:0 animated:YES];
//    
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
    response = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    response = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    //[spinner stopAnimating];
    
    //NSLog(@"element names :%@\n\n",elementName);
    
    if ([elementName isEqual:@"UpdateCaseStatusLabResult"]) {
        
        NSLog(@"UpdateCaseStatusLab response :%@",response);
        
        if ([response isEqual:@"\"Y\""]) {
            
            UIAlertView * caseStatusSubmitAlert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Case Updated Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [caseStatusSubmitAlert show];
            
            LabCaseStatus *labCaseStatus = [self.storyboard instantiateViewControllerWithIdentifier:@"labCaseStatus"];
            [self.revealViewController pushFrontViewController:labCaseStatus animated:YES];
        }
    }
    
    
    if ([elementName isEqual:@"GetLabCaseIdsResult"]) {
        
        NSLog(@"lab login :%@",response);
        
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        labCaseIdDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"case id's %@",labCaseIdDict);
        
        
        caseIdTV.hidden  = NO;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            
            caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-320, 250) style:UITableViewStylePlain];
            
        }
        
        else
        {
            caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 250) style:UITableViewStylePlain];
        }
        
        

        caseIdTV.dataSource = self;
        caseIdTV.delegate = self;
        
        [commonView addSubview:caseIdTV];
//        _caseIdPicker.hidden = NO;
//        _caseIdPicker.delegate = self;
//        _caseIdPicker.dataSource = self;
        
        _submitCaseIdButtonOutlet.hidden = YES;
        _statusButtonOutlet.hidden = YES;
        _statusLabel.hidden = YES;
        
        
        
        
    }
    
}


- (IBAction)submitCaseStatus:(id)sender
{
    
    if ([_statusLabel.text isEqual:@"Status"] || [_caseIdLabel.text isEqual:@"Select CaseId"]) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please select a CaseID and Status " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    else
    {
    
    //PUSH NOTIFICATIONS
    NSString * caseStatusSubmit =  [NSString stringWithFormat:
                                 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                 "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                 "<soap:Body>\n"
                                 "<UpdateCaseStatusLab xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                 "<CaseId>%@</CaseId>\n"
                                 "<Status>%@</Status>\n"
                                 "</UpdateCaseStatusLab>\n"
                                 "</soap:Body>\n"
                                 "</soap:Envelope>\n",_caseIdLabel.text,_statusLabel.text];
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseStatusSubmit soapActionString:@"UpdateCaseStatusLab" withDelegate:self];
    
    
    
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == caseStatusTV)
    {
        return statusArray.count;
    }
    else
    {
        return labCaseIdDict.count;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"lab";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];

    }
    
    if (tableView == caseStatusTV) {
        
        cell.textLabel.text = [statusArray objectAtIndex:indexPath.row];
        
    }
    else
    {
        cell.textLabel.text = [[labCaseIdDict valueForKey:@"CaseId"]objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];

    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == caseIdTV) {
        
        [_caseIdLabel setText:[[labCaseIdDict valueForKey:@"CaseId"]objectAtIndex:indexPath.row]];
        caseIdTV.hidden = YES;
        _statusLabel.hidden = NO;
        _statusButtonOutlet.hidden = NO;
        _submitCaseIdButtonOutlet.hidden = NO;
        
        
    }
    
    else
    {
        
        [_statusLabel setText:[statusArray objectAtIndex:indexPath.row]];
        
        caseStatusTV.hidden = YES;
        _submitCaseIdButtonOutlet.hidden = NO;
        
    }

    [commonView removeFromSuperview];
    [tableView removeFromSuperview];
    
}


//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    
//    if (pickerView == _caseIdPicker) {
//        
//        return labCaseIdDict.count;
//    }
//    else
//    {
//        return statusArray.count;
//    }
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView == _caseIdPicker) {
//        
//        return [[labCaseIdDict valueForKey:@"CaseId"]objectAtIndex:row];
//        
//    }
//    else
//    {
//        return [statusArray objectAtIndex:row];
//        
//    }
//    
//}
//
//
//
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
//{
//    
//    UILabel *pickerViewLabel = (id)view;
//    
//    if (!pickerViewLabel) {
//        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
//    }
//    
//    pickerViewLabel.backgroundColor = [UIColor whiteColor];
//    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
//    
//    if (pickerView == _caseIdPicker)
//    {
//        pickerViewLabel.text =[[labCaseIdDict valueForKey:@"CaseId" ]objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:18];
//        
//    }
//    else if (pickerView == _statusPicker)
//        
//    {
//        pickerViewLabel.text =[statusArray objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:16];
//        
//    }
//    
//    return pickerViewLabel;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    if (pickerView == _caseIdPicker) {
//        
//        [_caseIdLabel setText:[[labCaseIdDict valueForKey:@"CaseId"]objectAtIndex:row]];
//        _caseIdPicker.hidden = YES;
//        _statusLabel.hidden = NO;
//        _statusButtonOutlet.hidden = NO;
//        _submitCaseIdButtonOutlet.hidden = NO;
//        
//        
//    }
//    
//    else
//    {
//        
//        [_statusLabel setText:[statusArray objectAtIndex:row]];
//        
//        _statusPicker.hidden = YES;
//        _submitCaseIdButtonOutlet.hidden = NO;
//        
//    }
//    
//    
//    
//}
//



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
