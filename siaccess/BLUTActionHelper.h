//
//  BLUTActionHelper.h
//  siaccess
//
//  Created by Everardo Medina Palomo on 08/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUTActionHelper : NSObject

+ (NSDictionary *) getKardex:(NSString *)matricula password:(NSString *)password choice:(int)choice;
+ (NSDictionary *) getBoletaRectoria:(NSString *)matricula password:(NSString *)password choice:(int)choice;
+ (NSDictionary *) getBoletaInterna:(NSString *)matricula password:(NSString *)password choice:(int)choice;
+ (NSDictionary *) getCarreras:(NSString *)matricula password:(NSString *)password;

@end
