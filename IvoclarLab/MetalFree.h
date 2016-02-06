//
//  MetalFree.h
//  IvoclarLab
//
//  Created by Subramanyam on 11/01/16.
//  Copyright (c) 2016 Ivoclar Vivadent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MetalFree : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *clickToOrderButtonOutlet;

- (IBAction)clickToOrder:(id)sender;

- (IBAction)readMoreZenostar:(id)sender;

- (IBAction)readMoreIPSEmax:(id)sender;



@property (weak, nonatomic) IBOutlet UIButton *backButtonOutlet;

- (IBAction)backButton:(id)sender;

@end
