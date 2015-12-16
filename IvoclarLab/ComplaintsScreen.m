//
//  ComplaintsScreen.m
//  IvoclarLab
//
//  Created by Subramanyam on 20/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ComplaintsScreen.h"
#import "SWRevealViewController.h"

@interface ComplaintsScreen ()

@end



@implementation ComplaintsScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self complaintScreenDidLoad];
  

    
}

-(void) complaintScreenDidLoad
{
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        
        [self.complaintsSideMenu setTarget:self.revealViewController];
        [self.complaintsSideMenu setAction:@selector(revealToggle:)];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
    }
    
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
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    // self.navigationItem.title = @"Ivoclar Lab";
    
    complaintTypeArray = [[NSMutableArray alloc]initWithObjects:@"Select Complaint Type",@"Case Related Complaint",@"Others", nil];
    
    complaintTypeTV = [[UITableView alloc]initWithFrame:CGRectMake(20, 180, 400, 100) style:UITableViewStylePlain];
    
    caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(20, 220, 400, 300) style:UITableViewStylePlain];
    
    qualityCheckboxSelected = NO;
    notSatisfiedServiceCheckboxSelected = NO;
    callBackFromCompanyCheckboxSelected = NO;
    callBackFromLabCheckboxSelected = NO;
    materialQuality = @"N";
    labService = @"N";
    callBackFromCompany = @"N";
    callBackFromLab = @"N";
    
    otherComplaints = [[UITextField alloc]initWithFrame:CGRectMake(20, 250, 320, 40)];
    otherComplaints.placeholder = @"Enter your Comments";
    otherComplaints.borderStyle = UITextBorderStyleLine;
    
    otherComplaints.hidden = YES;
    
    
    _complaintTypePicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _complaintTypePicker.backgroundColor = [UIColor lightGrayColor];
    _complaintTypePicker.layer.borderWidth = 1;
    _complaintTypePicker.hidden = YES;
    
    _caseIdPicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _caseIdPicker.backgroundColor = [UIColor lightGrayColor];
    _caseIdPicker.layer.borderWidth = 1;
    _caseIdPicker.hidden = YES;
    
    
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



- (IBAction)complaintTypeDD:(id)sender {
    
    //complaintTypeTV.hidden = NO;
    
    //[self.view addSubview:complaintTypeTV];
    
    //complaintTypeTV.dataSource = self;
    //complaintTypeTV.delegate = self;
    
    
    [_complaintTypePicker reloadAllComponents];
    [_complaintTypePicker selectRow:0 inComponent:0 animated:YES];

    
    _complaintTypePicker.hidden = NO;
    
    _complaintTypePicker.delegate = self;
    _complaintTypePicker.dataSource = self;
    
    
    _qualityButtonOutlet.alpha = 0.05;
    _qualityLabel.alpha = 0.05;
    _notSatisfiedServiceButtonOutlet.alpha = 0.05;
    _notSatisfiedServiceLabel.alpha = 0.05;
    _caseIdLabel.alpha = 0.05;
    _caseIdDDOutlet.alpha = 0.05;
    _commentsTF.alpha = 0.05;
    _callBackFromCompanyButtonOutlet.alpha = 0.05;
    _callBackFromCompanyLabel.alpha = 0.05;
    _callBackFromLabButtonOutlet.alpha = 0.05;
    _callBackFromLabLabel.alpha = 0.05;
    otherComplaints.alpha = 0.05;

    
    
    
    
    
}
- (IBAction)getCaseIds:(id)sender {
    
    
    

    [_caseIdPicker reloadAllComponents];
    [_caseIdPicker selectRow:0 inComponent:0 animated:YES];
    [self getDataFromPlist];
    
    
    NSString * caseIdList = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetCaseIds xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetCaseIds>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:caseIdList soapActionString:@"GetCaseIds" withDelegate:self];
    
    
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

       // [self.view addSubview:caseIdTV];
        //caseIdTV.dataSource = self;
        //caseIdTV.delegate = self;
        
        _caseIdPicker.hidden = NO;
        _caseIdPicker.delegate = self;
        _caseIdPicker.dataSource = self;
        
        _qualityButtonOutlet.alpha = 0.05;
        _qualityLabel.alpha = 0.05;
        _notSatisfiedServiceButtonOutlet.alpha = 0.05;
        _notSatisfiedServiceLabel.alpha = 0.05;
        _commentsTF.alpha = 0.05;
        _callBackFromCompanyButtonOutlet.alpha = 0.05;
        _callBackFromCompanyLabel.alpha = 0.05;
        _callBackFromLabButtonOutlet.alpha = 0.05;
        _callBackFromLabLabel.alpha = 0.05;
        otherComplaints.alpha = 0.05;

        
        
    }
    
    if ([elementName isEqual:@"InsertComplaintsResult"]) {
        
        NSLog(@"complaints :%@",currentDescription);
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == complaintTypeTV)
    {
        return complaintTypeArray.count;

    }
    else
    {
        return caseIdDictionary.count;

    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"Complaints";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if (tableView == complaintTypeTV)
    {
     
        cell.textLabel.text = [complaintTypeArray objectAtIndex:indexPath.row];

    }
    else
    {
        cell.textLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row];

    }
    
   
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == complaintTypeTV) {
        
        [_complaintTypeLabel setText:[complaintTypeArray objectAtIndex:indexPath.row]];
    
    complaintTypeTV.hidden = YES;
    
    
    if (indexPath.row == 2)
    {
        
        _caseIdDDOutlet.hidden=YES;
        _caseIdLabel.hidden = YES;
        _callBackFromCompanyLabel.hidden = YES;
        _callBackFromCompanyButtonOutlet.hidden = YES;
        _callBackFromLabButtonOutlet.hidden = YES;
        _callBackFromLabLabel.hidden = YES;
        _notSatisfiedServiceButtonOutlet.hidden = YES;
        _notSatisfiedServiceLabel.hidden = YES;
        _qualityButtonOutlet.hidden = YES;
        _qualityLabel.hidden = YES;
        _commentsTF.hidden = YES;
        
        otherComplaints.hidden = NO;
        [self.view addSubview:otherComplaints];
        
        
    }
    
    else
    {
        _caseIdDDOutlet.hidden=NO;
        _caseIdLabel.hidden = NO;
        _callBackFromCompanyLabel.hidden = NO;
        _callBackFromCompanyButtonOutlet.hidden = NO;
        _callBackFromLabButtonOutlet.hidden = NO;
        _callBackFromLabLabel.hidden = NO;
        _notSatisfiedServiceButtonOutlet.hidden = NO;
        _notSatisfiedServiceLabel.hidden = NO;
        _qualityButtonOutlet.hidden = NO;
        _qualityLabel.hidden = NO;
        _commentsTF.hidden = NO;
        
        otherComplaints.hidden = YES;
        
        
    }
        
    }
    else
    {
        
        [_caseIdLabel setText:[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row]];
        
        caseIdTV.hidden=YES;
    }
    

    
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _complaintTypePicker)
    {
        return complaintTypeArray.count;
    }
    else
    {
        return caseIdDictionary.count;
    }
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _complaintTypePicker)
    {
        return [complaintTypeArray objectAtIndex:row];
        
    }
    else
    {
        return [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
        
    }
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerViewLabel = (id)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    }
    
    pickerViewLabel.backgroundColor = [UIColor whiteColor];
    
    if (pickerView == _complaintTypePicker)
    {
        pickerViewLabel.text =[complaintTypeArray objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:16];

    }
    else
    {
           pickerViewLabel.text =[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:17];

    }
    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
    
    return pickerViewLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == _complaintTypePicker)
    {
        _complaintTypeLabel.text =[complaintTypeArray objectAtIndex:row];
        
        _complaintTypePicker.hidden = YES;
        
        _qualityButtonOutlet.alpha = 1;
        _qualityLabel.alpha = 1;
        _notSatisfiedServiceButtonOutlet.alpha = 1;
        _notSatisfiedServiceLabel.alpha = 1;
        _caseIdLabel.alpha = 1;
        _caseIdDDOutlet.alpha = 1;
        _commentsTF.alpha = 1;
        _callBackFromCompanyButtonOutlet.alpha = 1;
        _callBackFromCompanyLabel.alpha = 1;
        _callBackFromLabButtonOutlet.alpha = 1;
        _callBackFromLabLabel.alpha = 1;
        otherComplaints.alpha = 1;

        
        
        if (row == 2)
        {
            
            _caseIdDDOutlet.hidden=YES;
            _caseIdLabel.hidden = YES;
            _callBackFromCompanyLabel.hidden = YES;
            _callBackFromCompanyButtonOutlet.hidden = YES;
            _callBackFromLabButtonOutlet.hidden = YES;
            _callBackFromLabLabel.hidden = YES;
            _notSatisfiedServiceButtonOutlet.hidden = YES;
            _notSatisfiedServiceLabel.hidden = YES;
            _qualityButtonOutlet.hidden = YES;
            _qualityLabel.hidden = YES;
            _commentsTF.hidden = YES;
            
            otherComplaints.hidden = NO;
            [self.view addSubview:otherComplaints];
            
            
        }
        
        else
        {
            _caseIdDDOutlet.hidden=NO;
            _caseIdLabel.hidden = NO;
            _callBackFromCompanyLabel.hidden = NO;
            _callBackFromCompanyButtonOutlet.hidden = NO;
            _callBackFromLabButtonOutlet.hidden = NO;
            _callBackFromLabLabel.hidden = NO;
            _notSatisfiedServiceButtonOutlet.hidden = NO;
            _notSatisfiedServiceLabel.hidden = NO;
            _qualityButtonOutlet.hidden = NO;
            _qualityLabel.hidden = NO;
            _commentsTF.hidden = NO;
            
            otherComplaints.hidden = YES;
            
            
        }

        
        
    }
    else
    {
        _caseIdLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
        
        _caseIdPicker.hidden=YES;
        
        _qualityButtonOutlet.alpha = 1;
        _qualityLabel.alpha = 1;
        _notSatisfiedServiceButtonOutlet.alpha = 1;
        _notSatisfiedServiceLabel.alpha = 1;
        _commentsTF.alpha = 1;
        _callBackFromCompanyButtonOutlet.alpha = 1;
        _callBackFromCompanyLabel.alpha = 1;
        _callBackFromLabButtonOutlet.alpha = 1;
        _callBackFromLabLabel.alpha = 1;
        otherComplaints.alpha = 1;
        

    }
    
    
}

//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    if (pickerView == _complaintTypePicker) {
//        return 40.0f;
//    }
//    else if (pickerView == _caseIdPicker)
//    {
//        return 30.0f;
//    }
//    
//    else
//    {
//        return 25.0f;
//        
//    }
//    
//    
//}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return (40.0);
}



- (IBAction)complaintSubmit:(id)sender
{
    
    NSString * insertComplaint = [NSString stringWithFormat:
                                  @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                  "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                  "<soap:Body>\n"
                                  "<InsertComplaints xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                  "<DoctorId>%@</DoctorId>\n"
                                  "<ComplaintType>%@</ComplaintType>\n"
                                  "<CaseId>%@</CaseId>\n"
                                  "<OthersComments>%@</OthersComments>\n"
                                  "<MaterialQuality>%@</MaterialQuality>\n"
                                  "<LabService>%@</LabService>\n"
                                  "<OtherReason>%@</OtherReason>\n"
                                  "<CalBackCompany>%@</CalBackCompany>\n"
                                  "<CalBackLab>%@</CalBackLab>\n"
                                  "</InsertComplaints>\n"
                                  "</soap:Body>\n"
                                  "</soap:Envelope>\n",filteredDoctorID,_complaintTypeLabel.text,_caseIdLabel.text,otherComplaints.text,materialQuality,labService,_commentsTF.text,callBackFromCompany,callBackFromLab];
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:insertComplaint soapActionString:@"InsertComplaints" withDelegate:self];
    
    
    
}

- (IBAction)qualityButtonAction:(id)sender
{
    if (qualityCheckboxSelected == NO){
        [_qualityButtonOutlet setSelected:YES];
        materialQuality = @"Y";
        qualityCheckboxSelected = YES;
    } else {
        [_qualityButtonOutlet setSelected:NO];

        materialQuality = @"N";
        qualityCheckboxSelected = NO;
    }
}

- (IBAction)notSatisfiedServiceButtonAction:(id)sender
{
    
    if (notSatisfiedServiceCheckboxSelected == NO){
        [_notSatisfiedServiceButtonOutlet setSelected:YES];

        labService = @"Y";
        notSatisfiedServiceCheckboxSelected = YES;
    } else {
        [_notSatisfiedServiceButtonOutlet setSelected:NO];

        labService = @"N";
        notSatisfiedServiceCheckboxSelected = NO;
    }
    
}
- (IBAction)callBackFromCompanyButtonAction:(id)sender
{
    if (callBackFromCompanyCheckboxSelected == NO){
        [_callBackFromCompanyButtonOutlet setSelected:YES];
        
        callBackFromCompany = @"Y";
        callBackFromCompanyCheckboxSelected = YES;
    } else {
        [_callBackFromCompanyButtonOutlet setSelected:NO];
        callBackFromCompany = @"N";
        callBackFromCompanyCheckboxSelected = NO;
    }

    
}
- (IBAction)callBackFromLabButtonAction:(id)sender
{
    if (callBackFromLabCheckboxSelected == NO){
        [_callBackFromLabButtonOutlet setSelected:YES];
        callBackFromLab = @"Y";
        callBackFromLabCheckboxSelected = 1;
    } else {
        [_callBackFromLabButtonOutlet setSelected:NO];
        callBackFromLab = @"N";
        callBackFromLabCheckboxSelected = 0;
    }

}




@end
