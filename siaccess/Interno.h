//
//  Interno.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 19/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Concepto;

@interface Interno : NSManagedObject

@property (nonatomic, retain) NSString * referencia;
@property (nonatomic, retain) NSString * periodo;
@property (nonatomic, retain) NSString * vencimiento;
@property (nonatomic, retain) NSString * fechaInscripcion;
@property (nonatomic, retain) NSString * banco;
@property (nonatomic, retain) NSString * carrera;
@property (nonatomic, retain) NSString * matricula;
@property (nonatomic, retain) NSString * limiteAdeudos;
@property (nonatomic, retain) Concepto *toConcept;

@end
