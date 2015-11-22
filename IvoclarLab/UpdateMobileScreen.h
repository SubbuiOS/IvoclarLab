//
//  UpdateMobileScreen.h
//  IvoclarLab
//
//  Created by Mac on 20/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdateMobileScreen : UIViewController<NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *updateMobileSideMenu;

@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTF;
- (IBAction)updateMobile:(id)sender;








@end
