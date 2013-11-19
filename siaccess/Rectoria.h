//
//  Rectoria.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 18/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Concepto;

@interface Rectoria : NSManagedObject

@property (nonatomic, retain) NSString * referencia;
@property (nonatomic, retain) NSString * banco;
@property (nonatomic, retain) NSString * matricula;
@property (nonatomic, strong) NSString * carrera;
@property (nonatomic, retain) NSSet *toConcept;
@property (nonatomic, strong) NSString *vencimiento;
@property (nonatomic, strong) NSString *periodo;
@end

@interface Rectoria (CoreDataGeneratedAccessors)

- (void)addToConceptObject:(Concepto *)value;
- (void)removeToConceptObject:(Concepto *)value;
- (void)addToConcept:(NSSet *)values;
- (void)removeToConcept:(NSSet *)values;

@end
