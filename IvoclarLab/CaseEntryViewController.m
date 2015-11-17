//
//  CaseEntryViewController.m
//  IvoclarLab
//
//  Created by Mac on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CaseEntryViewController.h"
#import "SWRevealViewController.h"
#import "PartnersCustomCell.h"
#import "MainViewController.h"

@interface CaseEntryViewController ()

@end

UITableView * natureOfWorkTV;
UITableView * crownBrandTV;
UITableView * typeOfCaseTV;
UITableView * partnerMTV;
UITableView * partnerLTV;
UITableViewCell * cell;

NSMutableArray * natureOfWorkArray;
NSMutableArray * crownBrandArray;
NSMutableArray * typeOfCaseArray;
NSMutableDictionary * partnerMDict;
NSMutableDictionary * partnerLDict;


NSMutableData * webData;
NSURLConnection * urlConnection;
NSString * currentDescription;
NSString * filteredDoctorID;
NSString * filteredDoctorName;

UIAlertView * partnerAlert;
UIAlertView * submitCEAlert;
UIAlertView * trackAlert;
UIAlertView * confirmationAlert;
UIView * partnerLView;
UIButton * partnerLbutton;

@implementation CaseEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController * revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.CESidebarButton setTarget: self.revealViewController];
        [self.CESidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }

    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    _partnerNameLabel.hidden = YES;
    _partnerNameTitle.hidden = YES;
    
    
    natureOfWorkTV = [[UITableView alloc]initWithFrame:CGRectMake(33 ,215, 300, 150) style:UITableViewStylePlain];
    
    natureOfWorkArray = [[NSMutableArray alloc]initWithObjects:@"Select Nature Of Work",@"Ceramic",@"PFM",nil];
    
    crownBrandTV = [[UITableView alloc]initWithFrame:CGRectMake(43 ,280 , 180, 150) style:UITableViewStylePlain];
    
    crownBrandArray = [[NSMutableArray alloc]initWithObjects:@"Zenostar",@"e.max", nil];
    
    
    
    typeOfCaseTV = [[UITableView alloc]initWithFrame:CGRectMake(33, 380, 200, 150) style:UITableViewStylePlain];
    typeOfCaseArray = [[NSMutableArray alloc]initWithObjects:@"Crowns",@"Bridges",@"Veneer", nil];
    
    
    partnerLbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [partnerLbutton setTitle:@"Ok" forState:UIControlStateNormal];
    partnerLbutton.frame = CGRectMake(150, 640, 100, 40);
    [partnerLbutton addTarget:self action:@selector(partnerLbuttonIsClicked) forControlEvents:UIControlEventTouchUpInside];
    [partnerLbutton setBackgroundColor:[UIColor redColor]];
    
    //partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];
    
    //partnerLTV = [[UITableView alloc]initWithFrame:CGRectMake(30, 70, 300, 550) style:UITableViewStylePlain];
    
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
        NSLog(@"contant array is %@",contentArray);
        
    }
    
    //print the plist result data on console
    for (int i= 0; i<[contentArray count]; i++) {
        
        data= [contentArray objectAtIndex:i];
        
        if ([data objectForKey:@"DoctorID"])
        {
            
            NSString * drId = [data objectForKey:@"DoctorID"];
        
            NSCharacterSet *invCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
            filteredDoctorID = [[drId componentsSeparatedByCharactersInSet:invCharSet]componentsJoinedByString:@""];
            
            
        }
        else
        {
            NSString *drName = [data objectForKey:@"DoctorName"];
        
            NSCharacterSet *invalidCharSet = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"""]invertedSet]invertedSet];
            filteredDoctorName = [[drName componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
            
            NSString * appendString = @"Welcome Dr.";
            
            NSString * welcomeString = [appendString stringByAppendingString:filteredDoctorName];
            
        
            _welcomeNameLabel.text = welcomeString;
            NSLog(@"doc name :%@",welcomeString);
        
        }
        
    }

    
    
    NSString * profile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetCaseId xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetCaseId>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[profile length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/GetCaseId" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
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

- (IBAction)natureOfWork:(id)sender {
    
    
    natureOfWorkTV.hidden = NO;
    
    natureOfWorkTV.delegate = self;
    natureOfWorkTV.dataSource = self;
    [self.view addSubview:natureOfWorkTV];
    
    _crownBrandDDOutlet.titleLabel.text = nil;
    
}

- (IBAction)crownBrandDD:(id)sender
{
    
    
    if ([_natureOfWorkOutlet.titleLabel.text isEqual:@"Ceramic"]) {
        
        
        crownBrandTV.hidden = NO;
        
        crownBrandTV.delegate = self;
        crownBrandTV.dataSource = self;
        [self.view addSubview:crownBrandTV];
        
        
        
    }
    
}
- (IBAction)typeOfCase:(id)sender {
    
    typeOfCaseTV.hidden = NO;
    
    typeOfCaseTV.delegate = self;
    typeOfCaseTV.dataSource = self;
    [self.view addSubview:typeOfCaseTV];
    
    
    
    
}
- (IBAction)selectPartner:(id)sender {
    
    NSString * profile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetMPartners xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetMPartners>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[profile length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/GetMPartners" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
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

- (IBAction)submitCaseEntry:(id)sender {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //uncomment to get the time only
    //[formatter setDateFormat:@"hh:mm a"];
    //[formatter setDateFormat:@"MMM dd, YYYY"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    
    //get the date today
    NSString *dateToday = [formatter stringFromDate:[NSDate date]];
    
    
    NSString * text = [NSString stringWithFormat:@"Please note that your order has been sent to %@ dates %@ for %@ Bridges.You will be contacted shortly.You are Requested to please click on Received option once your case is delivered to you to close the complete order cycle.",_partnerNameLabel.text, dateToday,_noOfUnitsTF.text];
    
    
     submitCEAlert = [[UIAlertView alloc]initWithTitle:@"Success :" message:text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [submitCEAlert show];
    
    

    
    NSString * submitCE = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<InsertCases xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "<CrownBrand>%@</CrownBrand>\n"
                          "<NoofUnits>%@</NoofUnits>\n"
                          "<CrownType>%@</CrownType>\n"
                          "<PartnerName>%@</PartnerName>\n"
                          "<CaseId>%@</CaseId>\n"
                          "</InsertCases>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID,_crownBrandDDOutlet.titleLabel.text,_noOfUnitsTF.text,_typeOfCaseOutlet.titleLabel.text,_partnerNameLabel.text,_caseIdLabel.text];
    

    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[submitCE length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/InsertCases" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [submitCE dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    
    if ([elementName isEqual:@"GetCaseIdResult"]) {
        
        NSLog(@"\n\ncase id :%@",currentDescription);
        
        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
        NSString * caseId = [[currentDescription componentsSeparatedByCharactersInSet:invalidCharSet]componentsJoinedByString:@""];
        
        _caseIdLabel.text = caseId;
        
    }
    
    if ([elementName isEqual:@"GetMPartnersResult"]) {
        
        NSLog(@"Mpartner :%@",currentDescription);
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        partnerMDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",partnerMDict);
        
        partnerAlert = [[UIAlertView alloc]initWithTitle:@"Select Partner" message:@"\n" delegate:self cancelButtonTitle:@"More" otherButtonTitles:nil, nil];
        
        partnerMTV = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, 200, 150) style:UITableViewStylePlain];

        
        [partnerAlert setValue:partnerMTV forKey:@"accessoryView"];
    
        partnerMTV.delegate = self;
        partnerMTV.dataSource = self;
        
        [partnerAlert show];
        
    }
    
    if ([elementName isEqual:@"GetLPartnersResult"]) {
        
        NSLog(@"Lpartner: %@",currentDescription);
        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        partnerLDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"partner dictionary :%@",partnerLDict);
        
        
      partnerLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 800)];
        partnerLView.alpha=1;
        partnerLView.backgroundColor = [UIColor grayColor];
        
        [partnerLView addSubview:partnerLbutton];
        
        partnerLTV = [[UITableView alloc]initWithFrame:CGRectMake(30, 70, 300, 550) style:UITableViewStylePlain];

        [partnerLView addSubview:partnerLTV];
        partnerLTV.delegate = self;
        partnerLTV.dataSource = self;

        [self.view addSubview:partnerLView];
        
         //self.view.alpha=0.2;

    }
    
    if ([elementName isEqual:@"InsertCasesResult"]) {
        
        NSLog(@"\n\nInsert cases %@",currentDescription);
        
    }
    
    
    
}

-(void)partnerLbuttonIsClicked
{
    [partnerLView removeFromSuperview];
    self.view.alpha = 1;
    [partnerMTV removeFromSuperview];
    [partnerLTV removeFromSuperview];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    
    if (alertView == partnerAlert) {
        
           //[partnerAlert setValue:partnerTV forKey:@"accessoryView"];
    
    
    NSString * profile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<GetLPartners xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "</GetLPartners>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID];

    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[profile length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/GetLPartners" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
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
    
    else if (alertView == submitCEAlert)
    {
        
        trackAlert = [[UIAlertView alloc]initWithTitle:@"Success :" message:@"You Can Track your case in the Track your case Status menu appearing on the Home Screen" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [trackAlert show];
        
    }
    
    else if (alertView == trackAlert)
    {
        confirmationAlert = [[UIAlertView alloc]initWithTitle:@"Confirmation" message:@"Choose here" delegate:self cancelButtonTitle:@"Place another Order" otherButtonTitles:@"Go to Homepage", nil];
        
        [confirmationAlert show];
        
    }
    
    else if(alertView == confirmationAlert)
    {
        if (buttonIndex==0) {
            
            //NSLog(@"title0 %@",[alertView buttonTitleAtIndex:buttonIndex]);
            
            _natureOfWorkOutlet.titleLabel.text = nil;
            _crownBrandDDOutlet.titleLabel.text = nil;
            _noOfUnitsTF.text = nil;
            _noOfUnitsTF.placeholder = @"No of units";
            _typeOfCaseOutlet.titleLabel.text = nil;
            _partnerNameLabel.text = nil;
            _partnerNameLabel.hidden = YES;
            _partnerNameTitle.hidden = YES;
            
            
        }
        else
        {
           // NSLog(@"title1 %@",[alertView buttonTitleAtIndex:buttonIndex]);
            
            MainViewController * homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
            
            [self presentViewController:homePage animated:YES completion:nil];
            
            

        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == natureOfWorkTV) {
        
        return natureOfWorkArray.count;

    }
    else if (tableView == crownBrandTV)
    {
        return crownBrandArray.count;

    }
    else if (tableView == typeOfCaseTV)
    {
        return typeOfCaseArray.count;
    }
    else if (tableView == partnerMTV)
    {
        return partnerMDict.count;
    }
    else
    {
        return partnerLDict.count+1;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    if (!((tableView == partnerMTV)||(tableView == partnerLTV))) {
        
    
    
    NSString * cellIdentifier = @"cell";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
    }
    if (tableView == natureOfWorkTV)
    {
        
      cell.textLabel.text = [natureOfWorkArray objectAtIndex:indexPath.row];

    }
    else if (tableView == crownBrandTV)
    {
       cell.textLabel.text = [crownBrandArray objectAtIndex:indexPath.row];

    }
    else if (tableView == typeOfCaseTV)
    {
        cell.textLabel.text = [typeOfCaseArray objectAtIndex:indexPath.row];
    }
    }
    
    else
    {
        
        PartnersCustomCell * partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
        if (partnerCell == nil) {
            
            [tableView registerNib:[UINib nibWithNibName:@"PartnersCustomCell" bundle:nil] forCellReuseIdentifier:@"partnerCell"];
            partnerCell = [tableView dequeueReusableCellWithIdentifier:@"partnerCell"];
        }

        
            if (tableView == partnerMTV)
            {
                partnerCell.partnerName.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:0];
            
                partnerCell.partnerMobile.text = [[partnerMDict valueForKey:@"Mobile"]objectAtIndex:0];
            
                partnerCell.partnerLocation.text = [[partnerMDict valueForKey:@"Address"]objectAtIndex:0];
                    
                
                
            }
            else
            {
                
                if (indexPath.row == 0) {
                    
                    partnerCell.partnerName.text = [[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:0];
                    
                    partnerCell.partnerMobile.text = [[partnerMDict valueForKey:@"Mobile"]objectAtIndex:0];
                    
                    partnerCell.partnerLocation.text = [[partnerMDict valueForKey:@"Address"]objectAtIndex:0];
                }
                else
                {
                    partnerCell.partnerName.text = [[partnerLDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row-1];
                
                    partnerCell.partnerMobile.text = [[partnerLDict valueForKey:@"Mobile"]objectAtIndex:indexPath.row-1];
                
                    partnerCell.partnerLocation.text = [[partnerLDict valueForKey:@"Address"]objectAtIndex:indexPath.row-1];
                    // [partnerCell.partnerLocation sizeToFit];
                    //partnerCell.partnerLocation.numberOfLines=0;
                }
            
                
            }
        
        
        return partnerCell;

        }
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == natureOfWorkTV) {
        
        [_natureOfWorkOutlet setTitle:[natureOfWorkArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        natureOfWorkTV.hidden = YES;

    }
    else if (tableView == crownBrandTV)
    {
        
        crownBrandTV.hidden = YES;

        
        if ([[crownBrandArray objectAtIndex:indexPath.row] isEqual:@"e.max"])
        {
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Note" message:@"Please note this App is being updated for PFM and Ips e.max labs.You can however register and start the High Quality Zirconia Work-Zenostar immediately from Your Closest Ivoclar Vivadent Recognised Lab" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [alert show];
            
            
        }
        
        else
        {
        
            [_crownBrandDDOutlet setTitle:[crownBrandArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        }
        
    }
    
    else if (tableView == typeOfCaseTV)
    {
        [_typeOfCaseOutlet setTitle:[typeOfCaseArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        typeOfCaseTV.hidden = YES;

    }
    
    else if(tableView == partnerLTV)
    {
        
        _partnerNameTitle.hidden = NO;
        _partnerNameLabel.hidden = NO;
        if (indexPath.row == 0) {
            
            _partnerNameLabel.text =[[partnerMDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row];

        }
        
        else
        {
            _partnerNameLabel.text = [[partnerLDict valueForKey:@"PartnerName"]objectAtIndex:indexPath.row-1];
        }
        
        
        
        [self partnerLbuttonIsClicked];
        
        
    }
    
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((tableView == partnerLTV) || (tableView == partnerMTV)) {
        return 150.00;

    }
    
    return 45;
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












