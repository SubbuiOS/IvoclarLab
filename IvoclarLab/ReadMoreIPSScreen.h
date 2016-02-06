//
//  ReadMoreIPSScreen.h
//  IvoclarLab
//
//  Created by Subramanyam on 27/01/16.
//  Copyright (c) 2016 Ivoclar Vivadent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadMoreIPSScreen : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;


@end
