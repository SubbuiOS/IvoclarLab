//
//  UpdateMobileScreen.h
//  IvoclarLab
//
//  Created by Subramanyam on 20/11/15.
//  Copyright (c) 2015 Ivoclar Vivadent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonAppManager.h"

@interface UpdateMobileScreen : UIViewController<NSXMLParserDelegate,UITextFieldDelegate>


{
    
    NSString * filteredDoctorID;
    NSString * filteredDoctorMobile;
    NSString * response;

}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateMobileSideMenu;

@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTF;


@property (weak, nonatomic) IBOutlet UIButton *updateMobileButtonOutlet;

- (IBAction)updateMobile:(id)sender;

-(void)connectionData:(NSData*)data status:(BOOL)status;







@end
