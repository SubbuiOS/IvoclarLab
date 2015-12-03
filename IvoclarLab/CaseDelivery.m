//
//  CaseDelivery.m
//  IvoclarLab
//
//  Created by Mac on 21/11/15.
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
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        
        [self.caseDeliverySideMenu setTarget:self.revealViewController];
        [self.caseDeliverySideMenu setAction:@selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = @"Ivoclar Lab";
    
    _caseIdPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _caseIdPicker.layer.borderWidth = 1;
    _caseIdPicker.hidden = YES;
    _caseReceivedButtonOulet.hidden = NO;
    _caseReceivedLabel.hidden = NO;
    _confirmButtonOutlet.hidden = NO;
    
  //  caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(16, 230, 350, 300) style:UITableViewStylePlain];
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
    
    
    [_caseIdPicker reloadAllComponents];
    [_caseIdPicker selectRow:0 inComponent:0 animated:YES];
    
    
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
    
    
    [[CommonAppManager sharedAppManager]soapService:caseId url:@"GetCaseIds" withDelegate:self];
    
       
    
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
    currentDescription = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentDescription = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    if ([elementName isEqual:@"GetCaseIdsResult"]) {
        
        //NSLog(@"Case Ids :%@",currentDescription);
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        caseIdDictionary = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",caseIdDictionary);
        
        //caseIdTV.hidden = NO;
        
        //[self.view addSubview:caseIdTV];
        
        _caseIdPicker.hidden = NO;
        
        _caseReceivedButtonOulet.hidden = YES;
        _caseReceivedLabel.hidden = YES;
        _confirmButtonOutlet.hidden = YES;
        
        _caseIdPicker.dataSource = self;
        _caseIdPicker.delegate = self;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return caseIdDictionary.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"CaseDelivery";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == caseIdTV)
    {
            cell.textLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row];
        
    }
    
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == caseIdTV) {
        
        _caseIdLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row];
        
        caseIdTV.hidden=YES;
    }
    
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return caseIdDictionary.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerViewLabel = (id)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    }
    
    pickerViewLabel.backgroundColor = [UIColor clearColor];
    pickerViewLabel.text =[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
    pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
    
    return pickerViewLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    _caseIdLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
    
    _caseIdPicker.hidden=YES;
    _caseReceivedButtonOulet.hidden = NO;
    _caseReceivedLabel.hidden = NO;
    _confirmButtonOutlet.hidden = NO;
    
}




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
    
    
}
@end
