//
//  BLUTPagoInternoViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 19/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Interno.h"

@interface BLUTPagoInternoViewController : UITableViewController <UITableViewDataSource>

@property (nonatomic,strong)  NSManagedObjectContext * managedObjectContext;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Interno * boleta;
@property (nonatomic, strong) NSArray * detalles;
@property (nonatomic, assign) BOOL empty;

@end
