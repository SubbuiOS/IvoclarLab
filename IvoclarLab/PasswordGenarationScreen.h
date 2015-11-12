//
//  PasswordGenarationScreen.h
//  IvoclarLab
//
//  Created by Mac on 09/11/15.
//  Copyright (c) 2015 Subramanyam. All rights reserved.
//

#import "ViewController.h"

@interface PasswordGenarationScreen : ViewController
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;


@property (weak, nonatomic) IBOutlet UITextField *reenterPasswordTF;

- (IBAction)passwordSubmit:(id)sender;







@end
