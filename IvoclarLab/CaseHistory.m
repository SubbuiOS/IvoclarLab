//
//  CaseHistory.m
//  IvoclarLab
//
//  Created by Mac on 16/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CaseHistory.h"
#import "SWRevealViewController.h"
#import "CaseHistoryCustomCell.h"

@interface CaseHistory ()

@end

NSURLConnection * urlConnection;
NSMutableData * webData;
NSString * currentDescription;
NSString * filteredDoctorID;
NSMutableDictionary * CHDict;

UITableView * caseHistoryTV;

@implementation CaseHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.CHSidebarButton setTarget: self.revealViewController];
        [self.CHSidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    caseHistoryTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 105, 372, 520) style:UITableViewStylePlain];
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
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
    
    
    
    
    NSString * profile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<CaseHistory xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</CaseHistory>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[profile length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/CaseHistory" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
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
    
    NSData *myData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    
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
    
    if ([elementName isEqual:@"CaseHistoryResult"]) {
        
        NSLog(@"case history %@",currentDescription);
        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        CHDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",CHDict);
        
        
        caseHistoryTV.delegate = self;
        caseHistoryTV.dataSource = self;
        
        [self.view addSubview:caseHistoryTV];
        
        
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CHDict.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CaseHistoryCustomCell * caseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"caseHistoryCell"];
    if (caseHistoryCell == nil) {
        
        [tableView registerNib:[UINib nibWithNibName:@"CaseHistoryCustomCell" bundle:nil] forCellReuseIdentifier:@"caseHistoryCell"];
        caseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"caseHistoryCell"];
    }
    
    caseHistoryCell.cellNumberCH.text = [NSString stringWithFormat:@"%lu", indexPath.row+1];
    
    caseHistoryCell.crownBrandCH.text = [[CHDict valueForKey:@"CrownBrand"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.crownTypeCH.text = [[CHDict valueForKey:@"CrownType"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.issueDateCH.text = [[CHDict valueForKey:@"IssueDate"]objectAtIndex:indexPath.row];
    
    caseHistoryCell.noOfUnitsCH.text = [[CHDict valueForKey:@"NoofUnits"]objectAtIndex:indexPath.row];

    caseHistoryCell.caseIdCH.text = [[CHDict valueForKey:@"CaseId"]objectAtIndex:indexPath.row];

    caseHistoryCell.caseStatusCH.text = [[CHDict valueForKey:@"CaseStatus"]objectAtIndex:indexPath.row];

    
    return caseHistoryCell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 270.00;
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
