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

UITapGestureRecognizer * tapRecognizer;


@implementation ComplaintsScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self complaintScreenDidLoad];
    
    
  

    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        
        _complaintTypeLabel.frame = CGRectMake(_complaintTypeDDOutlet.frame.origin.x+135, _complaintTypeDDOutlet.frame.origin.y+15, 150, 32);
        
        _caseIdLabel.frame = CGRectMake(_caseIdDDOutlet.frame.origin.x+135, _caseIdDDOutlet.frame.origin.y+15, 150, 32);
        
        otherComplaints = [[UITextView alloc]initWithFrame:CGRectMake(_complaintTypeDDOutlet.frame.origin.x+40, _complaintTypeDDOutlet.frame.size.height+_complaintTypeDDOutlet.frame.origin.y+260, _complaintTypeDDOutlet.frame.size.width-50, 60)];
        
    }
    else
    {
        otherComplaints = [[UITextView alloc]initWithFrame:CGRectMake(_complaintTypeDDOutlet.frame.origin.x, _complaintTypeDDOutlet.frame.size.height+_complaintTypeDDOutlet.frame.origin.y+200, _complaintTypeDDOutlet.frame.size.width, 60)];
    }
    
    _complaintButtonOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _complaintButtonOutlet.clipsToBounds = YES;
    
    otherComplaints.layer.borderColor=[[UIColor blueColor]CGColor];
    otherComplaints.layer.borderWidth=1.0;
    
    _commentsTF.layer.borderColor=[[UIColor blueColor]CGColor];
    _commentsTF.layer.borderWidth=1.0;


}


-(void) complaintScreenDidLoad
{
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        
        [self.complaintsSideMenu setTarget:self.revealViewController];
        [self.complaintsSideMenu setAction:@selector(revealToggle:)];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
    }
    [[NSUserDefaults standardUserDefaults] setValue:@"alreadyRegistered" forKey:@"User"];

    
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
    
    //    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    
    //Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    // self.navigationItem.title = @"Ivoclar Lab";
    
    complaintTypeArray = [[NSMutableArray alloc]initWithObjects:@"Select Complaint Type",@"Case Related Complaint",@"Others", nil];
    
    qualityCheckboxSelected = NO;
    notSatisfiedServiceCheckboxSelected = NO;
    callBackFromCompanyCheckboxSelected = NO;
    callBackFromLabCheckboxSelected = NO;
    materialQuality = @"N";
    labService = @"N";
    callBackFromCompany = @"N";
    callBackFromLab = @"N";
    
    
//    otherComplaints.placeholder = @"Enter your Comments";
//    otherComplaints.borderStyle = UITextBorderStyleLine;
    
    otherComplaints.hidden = YES;
    //otherComplaints.delegate = self;
    _commentsTF.delegate = self;
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    
//    _complaintTypePicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _complaintTypePicker.backgroundColor = [UIColor lightGrayColor];
//    _complaintTypePicker.layer.borderWidth = 1;
//    _complaintTypePicker.hidden = YES;
    
//    _caseIdPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _caseIdPicker.backgroundColor = [UIColor lightGrayColor];
//    _caseIdPicker.layer.borderWidth = 1;
//    _caseIdPicker.hidden = YES;
    
    
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

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}
-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [_commentsTF resignFirstResponder];
    [otherComplaints resignFirstResponder];
    
    
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
        
        if ([data objectForKey:@"DoctorID"]) {
            
            NSString *drID = [data objectForKey:@"DoctorID"];
            
            NSLog(@"dr id :%@",drID);
            
            NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drID componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        }
        
        
        
    }
    
    
}



- (IBAction)complaintTypeDD:(id)sender {
    
    
    

    complaintTypeTV.hidden = NO;
    
    [commonView removeFromSuperview];
    [complaintTypeTV removeFromSuperview];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_complaintTypeView.frame.origin.x+140, _complaintTypeView.frame.origin.y+_complaintTypeView.frame.size.height, _complaintTypeView.frame.size.width, 150)];
        
        
    }
    
    else
    {
    
    commonView = [[UIView alloc]initWithFrame:CGRectMake(_complaintTypeView.frame.origin.x+20, _complaintTypeView.frame.size.height+_complaintTypeView.frame.origin.y-10, _complaintTypeView.frame.size.width+200, 350)];
        
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    
    [complaintTypeTV reloadData];
    
    
    complaintTypeTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 150) style:UITableViewStylePlain];

    [commonView addSubview:complaintTypeTV];
    
    complaintTypeTV.dataSource = self;
    complaintTypeTV.delegate = self;
    
    
//    [_complaintTypePicker reloadAllComponents];
//    [_complaintTypePicker selectRow:0 inComponent:0 animated:YES];
//
    
//    _complaintTypePicker.hidden = NO;
//    
//    _complaintTypePicker.delegate = self;
//    _complaintTypePicker.dataSource = self;
    
    
    _qualityButtonOutlet.hidden = YES;
    _qualityLabel.hidden = YES;
    _notSatisfiedServiceButtonOutlet.hidden = YES;
    _notSatisfiedServiceLabel.hidden = YES;
    _caseIdLabel.hidden = YES;
    _caseIdDDOutlet.hidden = YES;
    _commentsTF.hidden = YES;
    _callBackFromCompanyButtonOutlet.hidden = YES;
    _callBackFromCompanyLabel.hidden = YES;
    _callBackFromLabButtonOutlet.hidden = YES;
    _callBackFromLabLabel.hidden = YES;
    otherComplaints.hidden = YES;

    
    
    
    
    
}
- (IBAction)getCaseIds:(id)sender {
    

    [commonView removeFromSuperview];
    [caseIdTV removeFromSuperview];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_caseIdView.frame.origin.x+140, _caseIdView.frame.origin.y+_caseIdView.frame.size.height, _caseIdView.frame.size.width, 150)];
        
        
    }
    
    else
    {
    
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_caseIdView.frame.origin.x+20, _caseIdView.frame.size.height+_caseIdView.frame.origin.y-10, _caseIdView.frame.size.width+200, 350)];
        
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];

    
    [caseIdTV reloadData];
    
//    [_caseIdPicker reloadAllComponents];
//    [_caseIdPicker selectRow:0 inComponent:0 animated:YES];
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
    response = [NSString alloc];
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    response = string;
}
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
    if ([elementName isEqual:@"GetCaseIdsResult"]) {
        
//NSLog(@"Case Ids :%@",response);
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        caseIdDictionary = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",caseIdDictionary);
        
        caseIdTV.hidden = NO;
        caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 150) style:UITableViewStylePlain];

        [commonView addSubview:caseIdTV];
        caseIdTV.dataSource = self;
        caseIdTV.delegate = self;
        
//        _caseIdPicker.hidden = NO;
//        _caseIdPicker.delegate = self;
//        _caseIdPicker.dataSource = self;
        
        _qualityButtonOutlet.hidden = YES;
        _qualityLabel.hidden = YES;
        _notSatisfiedServiceButtonOutlet.hidden = YES;
        _notSatisfiedServiceLabel.hidden = YES;
        _commentsTF.hidden = YES;
        _callBackFromCompanyButtonOutlet.hidden = YES;
        _callBackFromCompanyLabel.hidden = YES;
        _callBackFromLabButtonOutlet.hidden = YES;
        _callBackFromLabLabel.hidden = YES;
        otherComplaints.hidden = YES;

        
        
    }
    
    if ([elementName isEqual:@"InsertComplaintsResult"]) {
        
        NSLog(@"complaints :%@",response);
        if ([response isEqual:@"\"Y\""])
        {
            UIAlertView * insertComplaintResult = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your Complaint has been sent successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [insertComplaintResult show];
            
            ComplaintsScreen * complaints = [self.storyboard instantiateViewControllerWithIdentifier:@"complaints"];
            [self.revealViewController pushFrontViewController:complaints animated:YES];
            
            
        }
    
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
        cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];

    }
    if (tableView == complaintTypeTV)
    {
     
        cell.textLabel.text = [complaintTypeArray objectAtIndex:indexPath.row];

    }
    else
    {
        cell.textLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row];

    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];

    
    
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
        
        [commonView removeFromSuperview];
        [complaintTypeTV removeFromSuperview];

        
    }
    else
    {
        
        [_caseIdLabel setText:[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row]];
        
        caseIdTV.hidden=YES;
        _qualityButtonOutlet.hidden = NO;
        _qualityLabel.hidden = NO;
        _notSatisfiedServiceButtonOutlet.hidden = NO;
        _notSatisfiedServiceLabel.hidden = NO;
        _commentsTF.hidden = NO;
        _callBackFromCompanyButtonOutlet.hidden = NO;
        _callBackFromCompanyLabel.hidden = NO;
        _callBackFromLabButtonOutlet.hidden = NO;
        _callBackFromLabLabel.hidden = NO;
        otherComplaints.hidden = YES;
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
//    if (pickerView == _complaintTypePicker)
//    {
//        return complaintTypeArray.count;
//    }
//    else
//    {
//        return caseIdDictionary.count;
//    }
//}
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView == _complaintTypePicker)
//    {
//        return [complaintTypeArray objectAtIndex:row];
//        
//    }
//    else
//    {
//        return [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
//        
//    }
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
//    
//    if (pickerView == _complaintTypePicker)
//    {
//        pickerViewLabel.text =[complaintTypeArray objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:16];
//
//    }
//    else
//    {
//           pickerViewLabel.text =[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
//        pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:17];
//
//    }
//    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
//    
//    return pickerViewLabel;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    if (pickerView == _complaintTypePicker)
//    {
//        _complaintTypeLabel.text =[complaintTypeArray objectAtIndex:row];
//        
//        _complaintTypePicker.hidden = YES;
//        
//        _qualityButtonOutlet.hidden = NO;
//        _qualityLabel.hidden = NO;
//        _notSatisfiedServiceButtonOutlet.hidden = NO;
//        _notSatisfiedServiceLabel.hidden = NO;
//        _caseIdLabel.hidden = NO;
//        _caseIdDDOutlet.hidden = NO;
//        _commentsTF.hidden = NO;
//        _callBackFromCompanyButtonOutlet.hidden = NO;
//        _callBackFromCompanyLabel.hidden = NO;
//        _callBackFromLabButtonOutlet.hidden = NO;
//        _callBackFromLabLabel.hidden = NO;
//        otherComplaints.hidden = YES;
//
//        
//        
//        if (row == 2)
//        {
//            
//            _caseIdDDOutlet.hidden=YES;
//            _caseIdLabel.hidden = YES;
//            _callBackFromCompanyLabel.hidden = YES;
//            _callBackFromCompanyButtonOutlet.hidden = YES;
//            _callBackFromLabButtonOutlet.hidden = YES;
//            _callBackFromLabLabel.hidden = YES;
//            _notSatisfiedServiceButtonOutlet.hidden = YES;
//            _notSatisfiedServiceLabel.hidden = YES;
//            _qualityButtonOutlet.hidden = YES;
//            _qualityLabel.hidden = YES;
//            _commentsTF.hidden = YES;
//            
//            otherComplaints.hidden = NO;
//            [self.view addSubview:otherComplaints];
//            
//            
//        }
//        
//        else
//        {
//            _caseIdDDOutlet.hidden=NO;
//            _caseIdLabel.hidden = NO;
//            _callBackFromCompanyLabel.hidden = NO;
//            _callBackFromCompanyButtonOutlet.hidden = NO;
//            _callBackFromLabButtonOutlet.hidden = NO;
//            _callBackFromLabLabel.hidden = NO;
//            _notSatisfiedServiceButtonOutlet.hidden = NO;
//            _notSatisfiedServiceLabel.hidden = NO;
//            _qualityButtonOutlet.hidden = NO;
//            _qualityLabel.hidden = NO;
//            _commentsTF.hidden = NO;
//            
//            otherComplaints.hidden = YES;
//            
//            
//        }
//
//        
//        
//    }
//    else
//    {
//        _caseIdLabel.text = [[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:row];
//        
//        _caseIdPicker.hidden=YES;
//        
//        _qualityButtonOutlet.hidden = NO;
//        _qualityLabel.hidden = NO;
//        _notSatisfiedServiceButtonOutlet.hidden = NO;
//        _notSatisfiedServiceLabel.hidden = NO;
//        _commentsTF.hidden = NO;
//        _callBackFromCompanyButtonOutlet.hidden = NO;
//        _callBackFromCompanyLabel.hidden = NO;
//        _callBackFromLabButtonOutlet.hidden = NO;
//        _callBackFromLabLabel.hidden = NO;
//        otherComplaints.hidden = YES;
//        
//
//    }
//    
//    
//}

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

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return (40.0);
//}



- (IBAction)complaintSubmit:(id)sender
{
    

    if ([_complaintTypeLabel.text isEqual:@"Select Complaint Type"] || [_caseIdLabel.text isEqual:@"Select CaseId"])
    {
        
        UIAlertView * complaintAlert =[[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please Select complaint type and caseId" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [complaintAlert show];
        
    }
    
    else
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
