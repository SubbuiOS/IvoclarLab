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
    
    caseIdTV = [[UITableView alloc]initWithFrame:CGRectMake(16, 230, 350, 300) style:UITableViewStylePlain];
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
    
    NSURL * url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    NSString * msgLength = [NSString stringWithFormat:@"%lu",(unsigned long)[caseId length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"http://www.kurnoolcity.com/wsdemo/GetCaseIds" forHTTPHeaderField:@"SOAPAction"];
    
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    
    [request addValue:@"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[caseId dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * urlConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if (urlConnection) {
        
        webData = [NSMutableData alloc];
    }
    else
    {
        NSLog(@"connection is NULL");
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
        
        [_caseIdDDOutlet setTitle:[[caseIdDictionary valueForKey:@"CaseId"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        caseIdTV.hidden=YES;
    }
    
    
    
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
