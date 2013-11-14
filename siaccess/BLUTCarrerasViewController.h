//
//  BLUTCarrerasViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 29/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface BLUTCarrerasViewController : UITableViewController <UITableViewDataSource>
@property (nonatomic,retain) NSDictionary *carreras;
@property (nonatomic,weak) NSString *mat;
@end
