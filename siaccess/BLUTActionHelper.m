//
//  BLUTActionHelper.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 08/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTActionHelper.h"
#import "SBJson.h"

@implementation BLUTActionHelper

NSString *kardexURL =       @"http://localhost/cgi-bin/sc/getKardex.py";
NSString *carrerasURL =     @"http://localhost/cgi-bin/sc/getCarrera.py";
NSString *pagoRectoriaURL = @"http://localhost/cgi-bin/sc/getPagoRectoria.py";
NSString *pagoInternoURL =  @"http://localhost/cgi-bin/sc/getPagoInterno.py";

+ (NSDictionary *) getKardex:(NSString *)matricula password:(NSString *)password choice:(int)choice{
    
    NSString *post = [[NSString alloc] initWithFormat:@"user=%@&pass=%@&chx=%d",matricula,password,choice];
    NSDictionary *jsonData = [self serverRequest:post withURL:kardexURL];
    if ([[jsonData objectForKey:@"0"] objectForKey:@"0"] != NULL){
       NSLog(@"kardex SUCCESS");
       return jsonData;
    }else{
       NSLog(@"kardex No success");
       return nil;
    }
}

+ (NSDictionary *) getBoletaRectoria:(NSString *)matricula password:(NSString *)password choice:(int)choice{
    
    NSString *post = [[NSString alloc] initWithFormat:@"user=%@&pass=%@&chx=%d",matricula,password,choice];
    NSDictionary *jsonData = [self serverRequest:post withURL:pagoRectoriaURL];
    if ([jsonData objectForKey:@"0"] != NULL){
        NSLog(@"Boleta rectoria SUCCESS!");
        return jsonData;
    }else{
        NSLog(@"boleta rectoria FAIL!");
        return nil;
    }
    
}

+ (NSDictionary *) getBoletaInterna:(NSString *)matricula password:(NSString *)password choice:(int)choice{
    
    NSString *post = [[NSString alloc] initWithFormat:@"user=%@&pass=%@&chx=%d",matricula,password,choice];
    NSDictionary *jsonData = [self serverRequest:post withURL:pagoInternoURL];
    if ([jsonData objectForKey:@"0"] != NULL){
        NSLog(@"Boleta rectoria SUCCESS!");
        return jsonData;
    }else{
        NSLog(@"boleta rectoria FAIL!");
        return nil;
    }
}

+ (NSDictionary *) getCarreras:(NSString *)matricula password:(NSString *)password{
    
    NSString *post = [[NSString alloc] initWithFormat:@"user=%@&pass=%@",matricula,password];
    NSDictionary *jsonData = [self serverRequest:post withURL:carrerasURL];
    if ([jsonData objectForKey:@"0"] != NULL){
        NSLog(@"Login SUCCESS");
        return jsonData;
    }else{
        NSLog(@"Login No success");
        return nil;
    }
}

+ (NSDictionary *) serverRequest:(NSString *)post withURL:(NSString *)url{
    
    @try {
        NSData *data = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setHTTPBody:data];
        
        NSError *err = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request
                                                returningResponse:&response error:&err];
        if( [response statusCode] >= 200 && [response statusCode] < 300){
            NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
            NSLog(responseData);
            return (NSDictionary *) [[SBJsonParser new] objectWithString:responseData error:nil];
        }else{
            NSLog(@"Err %@ Response code %d",[err domain],[response statusCode]);
            return nil;
        }
    }@catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

@end
