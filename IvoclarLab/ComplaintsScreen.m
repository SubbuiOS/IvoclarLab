//
//  ComplaintsScreen.m
//  IvoclarLab
//
//  Created by Mac on 20/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ComplaintsScreen.h"
#import "SWRevealViewController.h"

@interface ComplaintsScreen ()

@end

NSString *currentDescription;
NSMutableData * webData;
NSURLConnection * urlConnection;
NSString * filteredDoctorID;
NSDictionary * caseIdDictionary;

NSString * materialQuality;
NSString * labService;
NSString * callBackFromCompany;
NSString * callBackFromLab;

UITextField * otherComplaints;



@implementation ComplaintsScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    SWRevealViewController * revealViewController = self.revealViewController;
    if (revealViewController) {
        
        [self.complaintsSideMenu setTarget:self.revealViewController];
        [self.complaintsSideMenu setAction:@selector(revealToggle:)];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor whiteColor]}];
    
    
    complaintTypeArray = [[NSMutableArray alloc]initWithObjects:@"Case Related Complaint",@"Others", nil];
    
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
    
    complaintTypeTV.hidden = NO;
    
    [self.view addSubview:complaintTypeTV];
    
    complaintTypeTV.dataSource = self;
    complaintTypeTV.delegate = self;
    
    
    
    
    
    
}
- (IBAction)getCaseIds:(id)sender {
    
    
    
    [self getDataFromPlist];
    
    
    NSString * profile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetCaseIds xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetCaseIds>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[profile length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/GetCaseIds" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [profile dataUsingEncoding:NSUTF8StringEncoding]];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( urlConnection )
    {
        webData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    NSString *data = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",data);
    
    NSData * myData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:myData];
    
    xmlParser.delegate = self;
    
    [xmlParser parse];
    
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
        
        caseIdTV.hidden = NO;

        [self.view addSubview:caseIdTV];
        caseIdTV.dataSource = self;
        caseIdTV.delegate = self;
        
        
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
        
    
    
    [_complaintTypeDDOutlet setTitle:[complaintTypeArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    complaintTypeTV.hidden = YES;
    
    
    if (indexPath.row == 1)
    {
        
        _caseIdDDOutlet.hidden=YES;
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
        [_caseIdDDOutlet setTitle:[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        caseIdTV.hidden=YES;
    }
    

    
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
                                  "</soap:Envelope>\n",filteredDoctorID,_complaintTypeDDOutlet.titleLabel.text,_caseIdDDOutlet.titleLabel.text,otherComplaints,materialQuality,labService,_commentsTF.text,callBackFromCompany,callBackFromLab];
    
    NSURL * url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    
    NSString * msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[insertComplaint length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"http://www.kurnoolcity.com/wsdemo/InsertComplaints" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:@"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPMethod:@"POST"];
    
    [request setHTTPBody:[insertComplaint dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (urlConnection) {
        
        webData = [NSMutableData data];
    }
    else
    {
        NSLog(@"urlConnection is NULL");
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




@end
