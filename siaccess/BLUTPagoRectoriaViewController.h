//
//  BLUTPagoRectoriaViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 11/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUTPagoRectoriaViewController : UITableViewController

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSDictionary * kardex;

@end
