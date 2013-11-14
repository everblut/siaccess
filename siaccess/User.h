//
//  User.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 22/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSNumber * matricula;
@property (nonatomic, retain) NSString * password;

@end
