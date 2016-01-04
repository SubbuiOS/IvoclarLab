//
//  CaseDelivery.m
//  IvoclarLab
//
//  Created by Subramanyam on 21/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CaseDelivery.h"
#import "SWRevealViewController.h"

@interface CaseDelivery ()

@end

@implementation CaseDelivery

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self caseDeliveryDidLoad];

    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        _caseIdLabel.frame = CGRectMake(_caseIdDDOutlet.frame.origin.x+135, _caseIdDDOutlet.frame.origin.y+15, 150, 32);
        
    }
    
    _confirmButtonOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _confirmButtonOutlet.clipsToBounds = YES;
}

-(void) caseDeliveryDidLoad
{
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        
        [self.caseDeliverySideMenu setTarget:self.revealViewController];
        [self.caseDeliverySideMenu setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"RegisteredUser" forKey:@"User"];

    
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    // self.navigationItem.title = @"Ivoclar Lab";
    
//    _caseIdPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _caseIdPicker.layer.borderWidth = 1;
//    _caseIdPicker.backgroundColor = [UIColor lightGrayColor];
//    _caseIdPicker.hidden = YES;
    _caseReceivedButtonOulet.hidden = NO;
    _caseReceivedLabel.hidden = NO;
    _confirmButtonOutlet.hidden = NO;
    
    
    caseRecievedCheckBoxSelected = NO;
    

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
        
        if ([data objectForKey:@"DoctorID"]) {
            
            NSString *drID = [data objectForKey:@"DoctorID"];
            
            NSLog(@"dr id :%@",drID);
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        }
        
        
        
    }
    
    
}



- (IBAction)caseIdDDAction:(id)sender
{
    
    [commonView removeFromSuperview];
    [caseIdTV removeFromSuperview];

    
    [caseIdTV reloadData];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_caseIdView.frame.origin.x+140, _caseIdView.frame.origin.y+100, _caseIdView.frame.size.width, 150)];
        
        
    }
    else
    {
    
    commonView = [[UIView alloc]initWithFrame:CGRectMake(_caseIdView.frame.origin.x+17, _caseIdView.frame.size.height+_caseIdView.frame.origin.y-20, _caseIdView.frame.size.width+200, 350)];
        
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    
//    [_caseIdPicker reloadAllComponents];
//    [_caseIdPicker selectRow:0 inComponent:0 animated:YES];
    
    
    [self getDataFromPlist];
    
    NSString * caseId = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<GetCaseIds xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                         "<DoctorId>%@</DoctorId>\n"
                         "</GetCaseIds>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",filteredDoctorID];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseId soapActionString:@"GetCaseIds" withDelegate:self];
    
       
    
}

-(void)connectionData:(NSData*)data status:(BOOL)status
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
    
    if ([elementName isEqual:@"UpdateCaseStatusDResult"]) {
        
        NSLog(@"UpdateCaseStatusD response :%@",response);
        
        if ([response isEqual:@"\"Y\"" ]) {
            
            UIAlertView * updateCaseStatusD = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Status of the case is successfully updated" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [updateCaseStatusD show];
            
            CaseDelivery * caseDelivery = [self.storyboard instantiateViewControllerWithIdentifier:@"caseDelivery"];
            [self.revealViewController pushFrontViewController:caseDelivery animated:YES];
        }
        
        
    }
    
    if ([elementName isEqual:@"GetCaseIdsResult"]) {
        
        //NSLog(@"Case Ids :%@",response);
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        caseIdDictionary = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",caseIdDictionary);
        
        caseIdTV.hidden = NO;
        
        caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 150) style:UITableViewStylePlain];
        caseIdTV.delegate = self;
        caseIdTV.dataSource = self;
        
        [commonView addSubview:caseIdTV];
        
       // _caseIdPicker.hidden = NO;
        
        _caseReceivedButtonOulet.hidden = YES;
        _caseReceivedLabel.hidden = YES;
        _confirmButtonOutlet.hidden = YES;
        
//        _caseIdPicker.dataSource = self;
//        _caseIdPicker.delegate = self;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count :%lu",(unsigned long)caseIdDictionary.count);

    return caseIdDictionary.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"CaseDelivery";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];

    }
    if (tableView == caseIdTV)
    {
            cell.textLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row];
        
    }
    cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == caseIdTV) {
        
        _caseIdLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row];
        
        caseIdTV.hidden=YES;
        _caseReceivedButtonOulet.hidden = NO;
        _caseReceivedLabel.hidden = NO;
        _confirmButtonOutlet.hidden = NO;
        [commonView removeFromSuperview];
        [caseIdTV removeFromSuperview];

    }
    
    
}

//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return caseIdDictionary.count;
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//    return [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
//    
//}
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
//    pickerViewLabel.text =[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
//    pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
//    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
//    
//    return pickerViewLabel;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//
//    _caseIdLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
//    
//    _caseIdPicker.hidden=YES;
//    _caseReceivedButtonOulet.hidden = NO;
//    _caseReceivedLabel.hidden = NO;
//    _confirmButtonOutlet.hidden = NO;
//    
//}
//



- (IBAction)caseReceivedButtonAction:(id)sender
{
    
    if (caseRecievedCheckBoxSelected == NO){
        [_caseReceivedButtonOulet setSelected:YES];
        
        caseReceived = @"Y";
        caseRecievedCheckBoxSelected = YES;
    } else {
        [_caseReceivedButtonOulet setSelected:NO];
        caseReceived = @"N";
        caseRecievedCheckBoxSelected = NO;
    }
    

    
}

- (IBAction)confirmCaseDelivery:(id)sender
{
    //PUSH NOTIFICATIONS
    
    if ([_caseIdLabel.text isEqual:@"Select CaseId"]) {
        
        UIAlertView * caseDeliveryAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Select a case ID" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [caseDeliveryAlert show];
        
        
    }
    
    else
    {
    
    NSString * caseDelivery = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<UpdateCaseStatusD xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                         "<CaseId>%@</CaseId>\n"
                         "<Status>%@</Status>\n"
                         "</UpdateCaseStatusD>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",_caseIdLabel.text,caseReceived];
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseDelivery soapActionString:@"UpdateCaseStatusD" withDelegate:self];
    
    }
    
    
}
@end
