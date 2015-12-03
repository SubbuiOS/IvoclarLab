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
    
    
//    CGRect frame = CGRectMake(0, 0, 200, 44);
//    
//    UIView * navigationTitleView = [[UIView alloc]initWithFrame:frame];
//    navigationTitleView.backgroundColor = [UIColor clearColor];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 3, 200, 40)];
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont boldSystemFontOfSize:25.0];
//    
//    //label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor whiteColor];
//    label.text = @"Ivoclar Lab";
//    
//    [navigationTitleView addSubview:label];
//    self.navigationItem.titleView = navigationTitleView;
    
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    self.navigationItem.title = @"Ivoclar Lab";
    
    //statesTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 300, 340, 150) style:UITableViewStylePlain];
    
    //cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 350, 340, 150) style:UITableViewStylePlain];
    
    _statePicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _statePicker.layer.borderWidth = 1;
    _statePicker.hidden = YES;
    
    _statePicker.layer.borderColor = [UIColor whiteColor].CGColor;
    _statePicker.layer.borderWidth = 1;
    _statePicker.hidden = YES;
    
    
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
    
    
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(170, 525);
    //spinner.tag = 12;
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    
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
                          "</soap:Envelope>\n",filteredDoctorID,_doctorNameTF.text,_emailTF.text,_selectYourCityLabel.text,_areaNameTF.text,_pincodeTF.text,_selectYourStateLabel.text];
    
    [[CommonAppManager sharedAppManager]soapService:profile url:@"UpdateProfile" withDelegate:self];
    

    
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
    
    
    
    if ([elementName isEqual:@"UpdateProfileResult"]) {
        
        NSLog(@"Status :%@",currentDescription);
        
        [spinner stopAnimating];
        
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
//       
//        statesTableView.delegate = self;
//        statesTableView.dataSource = self;
//        statesTableView.hidden = NO;
//        
//        [self.view addSubview:statesTableView];
        
        
        _statePicker.hidden = NO;
        
        _statePicker.delegate = self;
        _statePicker.dataSource = self;
        
        _selectYourCityLabel.alpha = 0.05;
        _cityDDOutlet.alpha = 0.05;
        _areaNameTF.alpha = 0.05;
        _pincodeTF.alpha = 0.05;
        
        
    
    }
    
    if ([elementName isEqual:@"GetCityResult"]) {
        
        NSLog(@"%@",currentDescription);
        
        // We have to convert the current Description text to JSON format
        // And we are Storing the data into a mutabledictionary

        
        NSData *objectData = [currentDescription dataUsingEncoding:NSUTF8StringEncoding];
        jsonCityData = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        
        // NSLog(@"json data %@",json);
        
//        cityTableView.delegate = self;
//        cityTableView.dataSource = self;
//        cityTableView.hidden = NO;
//        
//        [self.view addSubview:cityTableView];
        
        _cityPicker.hidden = NO;
        
        _cityPicker.delegate = self;
        _cityPicker.dataSource = self;
        
        //_selectYourCityLabel.alpha = 0.05;
        //_cityDDOutlet.alpha = 0.05;
        _areaNameTF.alpha = 0.05;
        _pincodeTF.alpha = 0.05;
        
        
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
    
    
    
    [_selectYourCityLabel setText:@"Select Your City"];
    
    [_statePicker reloadAllComponents];
    [_statePicker selectRow:0 inComponent:0 animated:YES];
    

    
    
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
    
    
    [[CommonAppManager sharedAppManager]soapService:states url:@"GetStates" withDelegate:self];
    
    
    
    
}
- (IBAction)cityDropDown:(id)sender {
    
    

    [_cityPicker reloadAllComponents];
    [_cityPicker selectRow:0 inComponent:0 animated:YES];
    

    
    
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
                         "</soap:Envelope>\n",_selectYourStateLabel.text];
   

    [[CommonAppManager sharedAppManager]soapService:city url:@"GetCity" withDelegate:self];
    
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == _statePicker) {
        return jsonStatesData.count;
        
    }
    else
    {
        return jsonCityData.count;
        
    }
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == _statePicker)
    {
        return [[jsonStatesData valueForKey:@"StateName"]objectAtIndex:row];
    }
    
    else {
        
        return [[jsonCityData valueForKey:@"CityName"]objectAtIndex:row];
    }
    
    
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *pickerViewLabel = (id)view;
    
    if (!pickerViewLabel) {
        pickerViewLabel= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width - 10.0f, [pickerView rowSizeForComponent:component].height)];
    }
    
    pickerViewLabel.backgroundColor = [UIColor clearColor];
    
    if (pickerView == _statePicker)
    {
        pickerViewLabel.text =[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:row];
        
    }
    
    else
    {
        pickerViewLabel.text =[[jsonCityData valueForKey:@"CityName"]objectAtIndex:row];

    }
    pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
    
    return pickerViewLabel;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (pickerView == _statePicker) {
        
        [_selectYourStateLabel setText:[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:row]];
        
        
        _statePicker.hidden = YES;
        
        _selectYourCityLabel.alpha = 1;
        _cityDDOutlet.alpha = 1;
        _areaNameTF.alpha = 1;
        _pincodeTF.alpha = 1;
        
        
        
    }
    if (pickerView == _cityPicker) {
        
        [_selectYourCityLabel setText:[[jsonCityData valueForKey:@"CityName"]objectAtIndex:row]];
        
        
        _cityPicker.hidden = YES;
        
        //_selectYourCityLabel.alpha = 1;
        //_cityDDOutlet.alpha = 1;
        _areaNameTF.alpha = 1;
        _pincodeTF.alpha = 1;
        
        
    }
    

    
    
    
}





@end
