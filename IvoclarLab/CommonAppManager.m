//
//  CommonAppManager.m
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "CommonAppManager.h"


@implementation CommonAppManager

static CommonAppManager *_sharedAppManager;


#pragma mark -
#pragma mark init and dealloc Methods
#pragma mark -

+(id)sharedAppManager
{
	if(_sharedAppManager == nil)
	{
        
		_sharedAppManager = [[CommonAppManager alloc] init];
        
	}
	return _sharedAppManager;
}

- (id)init
{
    Class myClass = [self class];
    @synchronized(myClass) {
        if (_sharedAppManager == nil) {
            if (self = [super init]) {

            }
        }
    }
    return self;
}





-(void) soapServiceMessage:(NSString *)message soapActionString:(id)appendingString withDelegate:(id)viewController
{
    
    delegate = viewController;
    
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/zenoservice.asmx",MainURL]];
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:URL];
    
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[message length]];
    
    [URLRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [URLRequest addValue: [NSString stringWithFormat:@"%@/%@",MainURL,appendingString] forHTTPHeaderField:@"SOAPAction"];
  
    
    
    [URLRequest addValue: @"www.kurnoolcity.com" forHTTPHeaderField:@"Host"];
    
    [URLRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [URLRequest setHTTPMethod:@"POST"];
    [URLRequest setHTTPBody: [message dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    webData = [NSMutableData data];

    URLConnection = [[NSURLConnection alloc] initWithRequest:URLRequest delegate:self];
    
    if( URLConnection )
    {
    }
    else
    {
        NSLog(@"URLConnection is NULL");
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
    NSLog(@"ERROR with theConenction  %@",error);

        
        if ([delegate isKindOfClass:[DoctorLogin class]])
        {
            [(DoctorLogin*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[LabPersonLogin class]])
        {
            [(LabPersonLogin*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[NewUserOTPScreen class]])
        {
            [(NewUserOTPScreen*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[ProfileScreen class]])
        {
            [(ProfileScreen*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[CaseEntryViewController class]])
        {
            [(CaseEntryViewController*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[CaseHistory class]])
        {
            [(CaseHistory*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[UpdateMobileScreen class]])
        {
            [(UpdateMobileScreen*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[ComplaintsScreen class]])
        {
            [(ComplaintsScreen*)delegate connectionData:nil status:NO];
        }
        else if([delegate isKindOfClass:[CaseDelivery class]])
        {
            [(CaseDelivery*)delegate connectionData:nil status:NO];
        }
        else if ([delegate isKindOfClass:[LabCaseStatus class]])
        {
            [(LabCaseStatus*)delegate connectionData:nil status:NO];
        }
        else if ([delegate isKindOfClass:[LabCaseHistory class]])
        {
            [(LabCaseHistory*)delegate connectionData:nil status:NO];
        }
        else if ([delegate isKindOfClass:[PasswordGenarationScreen class]])
        {
            [(PasswordGenarationScreen*)delegate connectionData:nil status:NO];
        }
   
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // NSLog(@"DONE. Received Bytes: %lu", (unsigned long)[webData length]);
    NSString *data = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
    
   // NSLog(@"%@",data);
    
    NSData *encodedData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    if ([delegate isKindOfClass:[DoctorLogin class]])
    {
        [(DoctorLogin*)delegate connectionData:encodedData status:YES];
    }
    
    else if([delegate isKindOfClass:[LabPersonLogin class]])
    {
        [(LabPersonLogin *)delegate connectionData:encodedData status:YES];
        
    }
    
    else if ([delegate isKindOfClass:[DoctorAlreadyRegistered class]])
    {
        [(DoctorAlreadyRegistered *)delegate connectionData:encodedData status:YES];
    }
    
    else if([delegate isKindOfClass:[NewUserOTPScreen class]])
    {
        [(NewUserOTPScreen*)delegate connectionData:encodedData status:YES];
    }
    else if([delegate isKindOfClass:[ProfileScreen class]])
    {
        [(ProfileScreen*)delegate connectionData:encodedData status:YES];
    }
    else if([delegate isKindOfClass:[CaseEntryViewController class]])
    {
        [(CaseEntryViewController*)delegate connectionData:encodedData status:YES];
    }
    else if([delegate isKindOfClass:[CaseHistory class]])
    {
        [(CaseHistory*)delegate connectionData:encodedData status:YES];
    }
    else if([delegate isKindOfClass:[UpdateMobileScreen class]])
    {
        [(UpdateMobileScreen*)delegate connectionData:encodedData status:YES];
    }
    else if([delegate isKindOfClass:[ComplaintsScreen class]])
    {
        [(ComplaintsScreen*)delegate connectionData:encodedData status:YES];
    }
    else if([delegate isKindOfClass:[CaseDelivery class]])
    {
        [(CaseDelivery*)delegate connectionData:encodedData status:YES];
    }
    else if ([delegate isKindOfClass:[LabCaseStatus class]])
    {
        [(LabCaseStatus*)delegate connectionData:encodedData status:YES];
    }
    else if ([delegate isKindOfClass:[LabCaseHistory class]])
    {
        [(LabCaseHistory*)delegate connectionData:encodedData status:YES];
    }
    else if ([delegate isKindOfClass:[PasswordGenarationScreen class]])
    {
        [(PasswordGenarationScreen*)delegate connectionData:encodedData status:YES];
    }


    
    
}

-(void)viewController:(id)viewControllerName
{
    
    delegate = viewControllerName;
    
    if ([delegate isKindOfClass:[SideMenuListViewController class]]) {
        
    NSString * loginStatus = [[NSUserDefaults standardUserDefaults]stringForKey:@"loginStatus"];
        
        if ([loginStatus isEqual:@"DocLoginSuccess"]) {
            
            menuArray = [[NSMutableArray alloc]initWithObjects:@"CaseEntry",@"Profile",@"CaseHistory",@"Update Mobile",@"Complaints",@"CaseDelivery",@"Home", nil];
            
        }
        
        else if ([loginStatus isEqual:@"LabLoginSuccess"])
        {
            menuArray = [[NSMutableArray alloc]initWithObjects:@"CaseStatus",@"CaseHistory",@"Home", nil];
            
        }
        
        NSLog(@"menu array :%@",menuArray);

        [(SideMenuListViewController*)delegate sideMenuList:menuArray];
    }
    
    
}


@end
