//
//  Materia.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 08/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Materia : NSManagedObject

@property (nonatomic, retain) NSString * carrera;
@property (nonatomic, retain) NSString * matricula;
@property (nonatomic, retain) NSString * clave;
@property (nonatomic, retain) NSString * cuarta;
@property (nonatomic, retain) NSString * laboratorio;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * primera;
@property (nonatomic, retain) NSString * quinta;
@property (nonatomic, retain) NSString * segunda;
@property (nonatomic, retain) NSString * semestre;
@property (nonatomic, retain) NSString * sexta;
@property (nonatomic, retain) NSString * tercera;
@property (nonatomic, retain) NSNumber * posicion;
@end
