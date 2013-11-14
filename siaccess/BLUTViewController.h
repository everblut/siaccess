//
//  BLUTViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 20/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface BLUTViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) IBOutlet UITextField *matriculaInput;
@property (strong, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) NSDictionary * carreras;
@property (strong, nonatomic) User *user;


- (IBAction)btnEnter:(id)sender;

@end
