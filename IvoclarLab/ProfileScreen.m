//
//  ProfileScreen.m
//  IvoclarLab
//
//  Created by Mac on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ProfileScreen.h"
#import "SWRevealViewController.h"
#import "PagingControl.h"

@interface ProfileScreen ()

@end

@implementation ProfileScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    statesTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 300, 340, 150) style:UITableViewStylePlain];
    
    cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 350, 340, 150) style:UITableViewStylePlain];
    
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

- (void)saveDataInPlist:(NSString *)doctorName {
    
    //get the plist document path
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    NSMutableArray *contentArray= [[NSMutableArray alloc]init];
    
    if (![fileManager fileExistsAtPath: plistFilePath])
    {
        NSLog(@"File does not exist");
        
        // If the file doesn’t exist, create an empty plist file
        plistFilePath = [documentsDirectory stringByAppendingPathComponent:@"OTPResult.plist"];
        //NSLog(@"path is %@",plistFilePath);
        
    }
    else{
        NSLog(@"File exists, Get data if anything stored");
        
        contentArray = [[NSMutableArray alloc] initWithContentsOfFile:plistFilePath];
    }
    
    
    NSString *docName = doctorName;
    
    //check all the textfields have values
    if ([docName length] >0) {
        
        //add values to dictionary
        [data setValue:docName forKey:@"DoctorName"];
        
        //add dictionary to array
        [contentArray addObject:data];
        
        //write array to plist file
        if([contentArray writeToFile:plistFilePath atomically:YES]){
            
            //NSLog(@"saved");
            
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alert show];
            
        }
        else {
            NSLog(@"Couldn't saved");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Saved in plist" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}


- (IBAction)profileSubmit:(id)sender {
    
    
    
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
    
    //Update Profile
    
    NSString * profile = [NSString stringWithFormat:
                          @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                          "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                          "<soap:Body>\n"
                          "<UpdateProfile xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                          "<DoctorId>%@</DoctorId>\n"
                          "<DoctorName>%@</DoctorName>\n"
                          "<Email>%@</Email>\n"
                          "<City>%@</City>\n"
                          "<AreaName>%@</AreaName>\n"
                          "<Pincode>%@</Pincode>\n"
                          "<StateName>%@</StateName>\n"
                          "</UpdateProfile>\n"
                          "</soap:Body>\n"
                          "</soap:Envelope>\n",filteredDoctorID,_doctorNameTF.text,_emailTF.text,_cityDDOutlet.titleLabel.text,_areaNameTF.text,_pincodeTF.text,_stateDDOutlet.titleLabel.text];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[profile length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
        [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/UpdateProfile" forHTTPHeaderField:@"SOAPAction"];
        
    
    
    
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
    
    myData = [data dataUsingEncoding:NSUTF8StringEncoding];

    
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
    
    
    if ([elementName isEqual:@"UpdateProfileResult"]) {
        
        NSLog(@"Status :%@",currentDescription);
        
        if ([currentDescription isEqual:@"\"Y\""]) {
            
            // If Y, profile is updated successfully
            
            PagingControl * caseEntry = [self.storyboard instantiateViewControllerWithIdentifier:@"pageControl"];
            
            [self.revealViewController pushFrontViewController:caseEntry animated:YES];
            
            [self saveDataInPlist:_doctorNameTF.text];
            
        }
        
    }
    if ([elementName isEqual:@"GetStatesResult"]) {
    
        NSLog(@"%@",currentDescription);
        
        // We have to convert the current Description text to JSON format
        // And we are Storing the data into a mutabledictionary
        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        jsonStatesData = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        
       // NSLog(@"json data %@",json);
       
        statesTableView.delegate = self;
        statesTableView.dataSource = self;
        statesTableView.hidden = NO;
        
        [self.view addSubview:statesTableView];
        
    
    }
    
    if ([elementName isEqual:@"GetCityResult"]) {
        
        NSLog(@"%@",currentDescription);
        
        // We have to convert the current Description text to JSON format
        // And we are Storing the data into a mutabledictionary

        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        jsonCityData = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        
        // NSLog(@"json data %@",json);
        
        cityTableView.delegate = self;
        cityTableView.dataSource = self;
        cityTableView.hidden = NO;
        
        [self.view addSubview:cityTableView];
    }
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == statesTableView) {
        return jsonStatesData.count;

    }
    else
    {
        return jsonCityData.count;

    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identifier = @"DropDown";
    
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (tableView == statesTableView) {
        
        cell.textLabel.text = [[jsonStatesData valueForKey:@"StateName"]objectAtIndex:indexPath.row];
    }
    
    else if (tableView == cityTableView) {
        
        cell.textLabel.text = [[jsonCityData valueForKey:@"CityName"]objectAtIndex:indexPath.row];
    }

    
    
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == statesTableView) {
        
        [_stateDDOutlet setTitle:[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        statesTableView.hidden = YES;

    }
    if (tableView == cityTableView) {
        
        [_cityDDOutlet setTitle:[[jsonCityData valueForKey:@"CityName"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];

        cityTableView.hidden = YES;

    }
    
   
    
}



- (IBAction)stateDropDown:(id)sender {
    
    
    // This is a Drop Down Menu created by using a button and tableview(statesTV)
    // And Getting the states by calling the below service
    
    NSString * states = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<GetStates xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                         "<temp>-</temp>\n"
                         "</GetStates>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n"];
    
    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[states length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/GetStates" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [states dataUsingEncoding:NSUTF8StringEncoding]];
    
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
- (IBAction)cityDropDown:(id)sender {
    
    

    
    // This is a Drop Down Menu created by using a button and tableview(cityTV)
    // And Getting the City names by calling the below service
    
    
    NSString * city = [NSString stringWithFormat:
                         @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                         "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                         "<soap:Body>\n"
                         "<GetCity xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                         "<StateName>%@</StateName>\n"
                         "</GetCity>\n"
                         "</soap:Body>\n"
                         "</soap:Envelope>\n",_stateDDOutlet.titleLabel.text];
   

    
    NSURL *url = [NSURL URLWithString:@"http://www.kurnoolcity.com/wsdemo/zenoservice.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[city length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [theRequest addValue: @"http://www.kurnoolcity.com/wsdemo/GetCity" forHTTPHeaderField:@"SOAPAction"];
    
    
    
    
    [theRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [city dataUsingEncoding:NSUTF8StringEncoding]];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( urlConnection )
    {
        webData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }
    
    //}
    
    
    
    
}
@end
