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

NSString *kardexURL = @"http://localhost/cgi-bin/sc/getKardex.py";
NSString *carrerasURL = @"http://localhost/cgi-bin/sc/getCarrera.py";


+ (NSDictionary *) getKardex:(NSString *)matricula password:(NSString *)password choice:(int)choice{
    
    @try {
        NSString *post = [[NSString alloc] initWithFormat:@"user=%@&pass=%@&chx=%d",matricula,password,choice];
    
        NSURL *url = [NSURL URLWithString:kardexURL];
        NSData *data = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
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
            SBJsonParser *jsonParser = [SBJsonParser new];
            NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
            if ([[jsonData objectForKey:@"0"] objectForKey:@"0"] != NULL){
                NSLog(@"kardex SUCCESS");
                return jsonData;
            }else{
                NSLog(@"kardex No success");
                return nil;
            }
        }else{
            NSLog(@"Err Response code %d",[response statusCode]);
            return nil;
        }
    }@catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
    }
}

+ (NSDictionary *) getCarreras:(NSString *)matricula password:(NSString *)password{
    @try {
            NSString *post = [[NSString alloc] initWithFormat:@"user=%@&pass=%@",matricula,password];
            
            NSURL *url = [NSURL URLWithString:carrerasURL];
            NSData *data = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d",[data length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:url];
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
                SBJsonParser *jsonParser = [SBJsonParser new];
                NSDictionary *jsonData = (NSDictionary *) [jsonParser objectWithString:responseData error:nil];
                if ([jsonData objectForKey:@"0"] != NULL){
                    NSLog(@"Login SUCCESS");
                    return jsonData;
                }else{
                    NSLog(@"Login No success");
                    return nil;
                }
            }else{
                if (err) NSLog(@"Error: %@", err);
                return nil;
            }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception: %@", exception);
        return nil;
    }
}

@end
