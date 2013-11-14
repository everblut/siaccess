//
//  BLUTMateriaViewController.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 11/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Materia.h"

@interface BLUTMateriaViewController : UITableViewController <UITableViewDataSource>

@property (nonatomic,strong) Materia *materia;

@end
