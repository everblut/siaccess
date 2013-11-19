//
//  BLUTPagoRectoriaViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 11/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rectoria.h"

@interface BLUTPagoRectoriaViewController : UITableViewController <UITableViewDataSource>

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, assign) NSInteger indx;
@property (nonatomic, strong) Rectoria * boleta;
@property (nonatomic, strong) NSArray * detalles;
@property (nonatomic, assign) BOOL empty;

@end
