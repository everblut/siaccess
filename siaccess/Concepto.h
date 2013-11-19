//
//  Concepto.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 18/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Concepto : NSManagedObject

@property (nonatomic, retain) NSString * identificador;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * costo;

@end
