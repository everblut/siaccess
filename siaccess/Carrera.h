//
//  Carrera.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 30/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Carrera : NSManagedObject

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * chx;
@property (nonatomic, retain) NSString * matricula;
@end
