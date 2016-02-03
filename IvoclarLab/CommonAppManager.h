//
//  CommonAppManager.h
//  IvoclarLab
//
//  Created by Subramanyam on 05/11/15.
//  Copyright(c) 2015 Subramanyam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorLogin.h"
#import "LabPersonLogin.h"
#import "SideMenuListViewController.h"
#import "DoctorAlreadyRegistered.h"
#import "NewUserOTPScreen.h"
#import "ProfileScreen.h"
#import "CaseEntryViewController.h"
#import "CaseHistory.h"
#import "UpdateMobileScreen.h"
#import "ComplaintsScreen.h"
#import "CaseDelivery.h"
#import "LabCaseStatus.h"
#import "LabCaseHistory.h"
#import "PasswordGenarationScreen.h"

#define MainURL  @"http://www.kurnoolcity.com/wsdemo"
@interface CommonAppManager : NSObject{
    
    
    NSURLConnection *URLConnection;
    NSMutableData *webData;
    NSMutableArray * menuArray;
    NSMutableArray * cellImages;
    
    id delegate;
    
}

+(id)sharedAppManager;
-(void) soapServiceMessage: (NSString * )message soapActionString:appendingString withDelegate:(id)viewController;

-(void)viewController:viewControllerName;


@end
