//
//  BLUTKardexViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 30/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUTKardexViewController : UITableViewController <UITableViewDataSource>

@property (nonatomic,strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSArray * materias;
@property (nonatomic, assign) NSInteger currentExpandedIndex;
@end
