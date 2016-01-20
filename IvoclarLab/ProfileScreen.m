//
//  ProfileScreen.m
//  IvoclarLab
//
//  Created by Subramanyam on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ProfileScreen.h"
#import "SWRevealViewController.h"
#import "PagingControl.h"

@interface ProfileScreen ()

@end

NSMutableDictionary * profileDetailsDict;
UITapGestureRecognizer * tapRecognizer;


@implementation ProfileScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self profileScrenDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    [self getDocId];
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // iPad
        
        _selectYourStateLabel.frame = CGRectMake(_selectYourStateLabel.frame.origin.x+130, _selectYourStateLabel.frame.origin.y+10, 150, 32);
        
        _selectYourCityLabel.frame = CGRectMake(_selectYourCityLabel.frame.origin.x+130, _selectYourCityLabel.frame.origin.y+10, 150, 32);
        
    }
    
    _emailTF.layer.borderColor=[[UIColor blueColor]CGColor];
    _emailTF.layer.borderWidth=1.0;
    
    _doctorNameTF.layer.borderColor = [[UIColor blueColor]CGColor];
    _doctorNameTF.layer.borderWidth = 1.0;
    
    _areaNameTF.layer.borderColor = [[UIColor blueColor]CGColor];
    _areaNameTF.layer.borderWidth = 1.0;
    
    _pincodeTF.layer.borderColor = [[UIColor blueColor]CGColor];
    _pincodeTF.layer.borderWidth = 1.0;
    
    
    
    if (![[[NSUserDefaults standardUserDefaults]valueForKey:@"User"] isEqual:@"NewUser"]) {
        
    
    
    NSString * getProfileDetails = [NSString stringWithFormat:
                                    @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                                    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                                    "<soap:Body>\n"
                                    "<GetProfileDetails xmlns=\"http://www.kurnoolcity.com/wsdemo\">"
                                    "<DoctorId>%@</DoctorId>\n"
                                    "</GetProfileDetails>\n"
                                    "</soap:Body>\n"
                                    "</soap:Envelope>\n",filteredDoctorID];

    [[CommonAppManager sharedAppManager]soapServiceMessage:getProfileDetails soapActionString:@"GetProfileDetails" withDelegate:self];
    }
    
}


-(void) profileScrenDidLoad
{
 
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    defaults = [NSUserDefaults standardUserDefaults];

    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0f/255.0f green:128.0f/255.0f blue:255.0f/255.0f alpha:1];
    // self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
    // [self.navigationController.navigationBar
    // setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
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
    
    
    // Animating the navigation Bar
    CATransition *fadeTextAnimation = [CATransition animation];
    fadeTextAnimation.duration = 1;
    fadeTextAnimation.type = kCATransitionPush;
    
    [self.navigationController.navigationBar.layer addAnimation: fadeTextAnimation forKey: @"fadeText"];
    // self.navigationItem.title = @"Ivoclar Lab";
    
   
//    _statePicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _statePicker.backgroundColor = [UIColor lightGrayColor];
//    _statePicker.layer.borderWidth = 1;
//
//    _statePicker.hidden = YES;
//    
//    _cityPicker.layer.borderColor = [UIColor whiteColor].CGColor;
//    _cityPicker.backgroundColor = [UIColor lightGrayColor];
//    _cityPicker.layer.borderWidth = 1;
//
//    _cityPicker.hidden = YES;
//    
    
    _doctorNameTF.delegate = self;
    _emailTF.delegate = self;
    _emailTF.keyboardType = UIKeyboardTypeEmailAddress;
    _areaNameTF.delegate = self;
    _pincodeTF.delegate = self;
    _pincodeTF.keyboardType = UIKeyboardTypeNumberPad;
    
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(didTapAnywhere:)];
    
    _profileSubmitOutlet.layer.cornerRadius = 10; // this value vary as per your desire
    _profileSubmitOutlet.clipsToBounds = YES;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:tapRecognizer];
}
-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [_areaNameTF resignFirstResponder];
    [_doctorNameTF resignFirstResponder];
    [_pincodeTF resignFirstResponder];
    [_emailTF resignFirstResponder];
    
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
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Couldn't Save" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}


-(void) getDocId
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

- (IBAction)profileSubmit:(id)sender {
    
    
    if ([_doctorNameTF.text isEqual:@""] || [_emailTF.text isEqual:@""] || [_selectYourCityLabel.text isEqual:@"Select City"] || [_selectYourStateLabel isEqual:@"Select State"] || [_areaNameTF.text isEqual:@""] || [_pincodeTF.text isEqual:@""]) {
        
        UIAlertView * profileAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"Please enter all the profile details" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [profileAlert show];
    }
    
    else
    {
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.center = CGPointMake(170, _profileSubmitOutlet.frame.size.height+_profileSubmitOutlet.frame.origin.y+30);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    
    [self getDocId];
    
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
    
    NSLog(@"profile :%@",profile);

    
    [[CommonAppManager sharedAppManager]soapServiceMessage:profile soapActionString:@"UpdateProfile" withDelegate:self];
    
    }

    
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
    
    if ([elementName isEqual:@"GetProfileDetailsResult"]) {
        
        NSLog(@"\n\n Profile Details :%@",response);
        
        if ((response!=nil)&&(![response isEqual:@"[]"]))
        {
            NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
            profileDetailsDict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"profile dictionary :%@",profileDetailsDict);
            
            _areaNameTF.text = [[profileDetailsDict valueForKey:@"AreaName"]objectAtIndex:0];
            [_selectYourCityLabel setText:[[profileDetailsDict valueForKey:@"City"]objectAtIndex:0]];
            _doctorNameTF.text = [[profileDetailsDict valueForKey:@"DoctorName"]objectAtIndex:0];
            _emailTF.text = [[profileDetailsDict valueForKey:@"Email"]objectAtIndex:0];
            _pincodeTF.text = [[profileDetailsDict valueForKey:@"Pincode"]objectAtIndex:0] ;
            [_selectYourStateLabel setText:[[profileDetailsDict valueForKey:@"StateName"]objectAtIndex:0]];
            
            
        }
        if ([response isEqual:@"[]"]) {
            
            
            _areaNameTF.text = @"";
            [_selectYourCityLabel setText:@"Select City"];
            _doctorNameTF.text = @"";
            _emailTF.text = @"";
            _pincodeTF.text = @"";
            [_selectYourStateLabel setText:@"Select State"];
            
        }
        
    }
    
    if ([elementName isEqual:@"UpdateProfileResult"]) {
        
        NSLog(@"Status :%@",response);
        
        [spinner stopAnimating];
        
        if ([response isEqual:@"\"Y\""]) {
            
            // If Y, profile is updated successfully
            
            UIAlertView * updateProfileAlert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Profile Updated Successfully" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [updateProfileAlert show];
            
            
            PagingControl * caseEntry = [self.storyboard instantiateViewControllerWithIdentifier:@"pageControl"];
            
            [self.revealViewController pushFrontViewController:caseEntry animated:YES];
            
            [self saveDataInPlist:_doctorNameTF.text];
            
            [defaults setObject:@"DocLoginSuccess" forKey:@"loginStatus"];
            [defaults synchronize];
            
        }
        
    }
    if ([elementName isEqual:@"GetStatesResult"]) {
    
        NSLog(@"%@",response);
        
        // We have to convert the response text to JSON format
        // And we are Storing the data into a mutabledictionary
        
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        jsonStatesData = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        
       // NSLog(@"json data %@",json);
       statesTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 150) style:UITableViewStylePlain];
        
        statesTableView.delegate = self;
        statesTableView.dataSource = self;
        statesTableView.hidden = NO;
        
        [commonView addSubview:statesTableView];
        
        
//        _statePicker.hidden = NO;
//        
//        _statePicker.delegate = self;
//        _statePicker.dataSource = self;
        
        _selectYourCityLabel.hidden = YES;
        _cityDDOutlet.hidden = YES;
        _areaNameTF.hidden = YES;
        _pincodeTF.hidden = YES;
        
        
    
    }
    
    if ([elementName isEqual:@"GetCityResult"]) {
        
        NSLog(@"%@",response);
        
        // We have to convert the response text to JSON format
        // And we are Storing the data into a mutabledictionary

        
        NSData *objectData = [response dataUsingEncoding:NSUTF8StringEncoding];
        jsonCityData = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:nil];
        
        if ([jsonCityData isEqual:nil]) {
            
            UIAlertView * cityAlert = [[UIAlertView alloc]initWithTitle:@"Warning" message:@"No cities Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [cityAlert show];
            
        }
        
        else
        {
        // NSLog(@"json data %@",json);
            
        cityTableView = [[UITableView alloc]initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-50, 150) style:UITableViewStylePlain];
            
        cityTableView.delegate = self;
        cityTableView.dataSource = self;
        cityTableView.hidden = NO;
        
        [commonView addSubview:cityTableView];
        
//        _cityPicker.hidden = NO;
//        
//        _cityPicker.delegate = self;
//        _cityPicker.dataSource = self;
        
        //_selectYourCityLabel.alpha = 0.05;
        //_cityDDOutlet.alpha = 0.05;
        _areaNameTF.hidden = YES;
        _pincodeTF.hidden = YES;
        _profileSubmitOutlet.hidden = YES;
        
        }
        
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
        
        cell.backgroundColor = [UIColor colorWithRed:115.0f/225.0f green:153.0f/255.0f blue:203.0f/255.0f alpha:1.0f];
    }
    
    if (tableView == statesTableView) {
        
        cell.textLabel.text = [[jsonStatesData valueForKey:@"StateName"]objectAtIndex:indexPath.row];
    }
    
    else if (tableView == cityTableView) {
        
        cell.textLabel.text = [[jsonCityData valueForKey:@"CityName"]objectAtIndex:indexPath.row];
    }

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:20];
    
    return cell;
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView == statesTableView) {
        
        //[_stateDDOutlet setTitle:[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        
        [_selectYourStateLabel  setText:[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:indexPath.row]];
        
        statesTableView.hidden = YES;
        
        _selectYourCityLabel.hidden = NO;
        _cityDDOutlet.hidden = NO;
        _areaNameTF.hidden = NO;
        _pincodeTF.hidden = NO;
        
        [commonView removeFromSuperview];
        [statesTableView removeFromSuperview];

        
    }
    if (tableView == cityTableView) {
        
       // [_cityDDOutlet setTitle:[[jsonCityData valueForKey:@"CityName"]objectAtIndex:indexPath.row] forState:UIControlStateNormal];

        [_selectYourCityLabel setText:[[jsonCityData valueForKey:@"CityName"]objectAtIndex:indexPath.row]];
        
        cityTableView.hidden = YES;
        
        _areaNameTF.hidden = NO;
        _pincodeTF.hidden = NO;
        _profileSubmitOutlet.hidden = NO;
        [commonView removeFromSuperview];
        
        [cityTableView removeFromSuperview];


    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}



- (IBAction)stateDropDown:(id)sender {
    
    
    
    [_selectYourCityLabel setText:@"Select City"];
    
    [commonView removeFromSuperview];
    [statesTableView removeFromSuperview];
    
    [statesTableView reloadData];
   // [cityTableView reloadData];
    
//    [_statePicker reloadAllComponents];
//    [_statePicker selectRow:0 inComponent:0 animated:YES];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_stateView.frame.origin.x+150, _stateView.frame.origin.y+_stateView.frame.size.height+5, _stateView.frame.size.width, 150)];
        
        
    }
    
    else
    {
    
    commonView = [[UIView alloc]initWithFrame:CGRectMake(_stateView.frame.origin.x+20, _stateView.frame.size.height+_stateView.frame.origin.y-10, _stateView.frame.size.width+200, 350)];
        
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    

    
    
    // This is a Drop Down Menu created by using a button and pickerview(statePicker)
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
    
    
    [[CommonAppManager sharedAppManager]soapServiceMessage:states soapActionString:@"GetStates" withDelegate:self];
    
    
    
    
}
- (IBAction)cityDropDown:(id)sender {
    
    

//    [_cityPicker reloadAllComponents];
//    [_cityPicker selectRow:0 inComponent:0 animated:YES];
//
    
    [cityTableView reloadData];
    [commonView removeFromSuperview];
    [cityTableView removeFromSuperview];
    
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        commonView = [[UIView alloc]initWithFrame:CGRectMake(_cityView.frame.origin.x+150, _cityView.frame.origin.y+_cityView.frame.size.height+5, _cityView.frame.size.width, 150)];
        
        
    }
    
    else
    {
        

    commonView = [[UIView alloc]initWithFrame:CGRectMake(_cityView.frame.origin.x+20, _cityView.frame.size.height+_cityView.frame.origin.y-10, _cityView.frame.size.width, 350)];
        
    }
    commonView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commonView];
    
    // This is a Drop Down Menu created by using a button and pickerview(cityPicker)
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
   

    [[CommonAppManager sharedAppManager]soapServiceMessage:city soapActionString:@"GetCity" withDelegate:self];
    
    
}



//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 1;
//}
//
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    if (pickerView == _statePicker) {
//        return jsonStatesData.count;
//        
//    }
//    else
//    {
//        return jsonCityData.count;
//        
//    }
//}
//
//
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    if (pickerView == _statePicker)
//    {
//        return [[jsonStatesData valueForKey:@"StateName"]objectAtIndex:row];
//    }
//    
//    else {
//        
//        return [[jsonCityData valueForKey:@"CityName"]objectAtIndex:row];
//    }
//    
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
//    if (pickerView == _statePicker)
//    {
//        pickerViewLabel.text =[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:row];
//        
//    }
//    
//    else
//    {
//        pickerViewLabel.text =[[jsonCityData valueForKey:@"CityName"]objectAtIndex:row];
//
//    }
//    pickerViewLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:17];
//    pickerViewLabel.textAlignment = NSTextAlignmentCenter;
//
//    
//    
//    return pickerViewLabel;
//}
//
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    if (pickerView == _statePicker) {
//        
//        [_selectYourStateLabel setText:[[jsonStatesData valueForKey:@"StateName"]objectAtIndex:row]];
//        
//        
//        _statePicker.hidden = YES;
//        
//        _selectYourCityLabel.hidden = NO;
//        _cityDDOutlet.hidden = NO;
//        _areaNameTF.hidden = NO;
//        _pincodeTF.hidden = NO;
//        
//        
//    }
//    if (pickerView == _cityPicker) {
//        
//        [_selectYourCityLabel setText:[[jsonCityData valueForKey:@"CityName"]objectAtIndex:row]];
//        
//        
//        _cityPicker.hidden = YES;
//        
//        //_selectYourCityLabel.alpha = 1;
//        //_cityDDOutlet.alpha = 1;
//        _areaNameTF.hidden = NO;
//        _pincodeTF.hidden = NO;
//        _profileSubmitOutlet.hidden = NO;
//        
//        
//    }
//    
//    
//}
//
//-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
//{
//    return 40.0f;
//}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}


@end
