//
//  BLUTViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 20/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTViewController.h"
#import "SBJson.h"
#import "Carrera.h"
#import "User.h"
#import "CoreDataHelper.h"
#import "BLUTAppDelegate.h"
#import "BLUTCarrerasViewController.h"
#import "BLUTActionHelper.h"

@interface BLUTViewController ()
@end

@implementation BLUTViewController
@synthesize matriculaInput;
@synthesize passwordInput;
@synthesize carreras;
@synthesize user;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BLUTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
    [self setTitle:@"Siaccess"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)tF {
    [tF resignFirstResponder];
    return NO;
}

- (IBAction)btnEnter:(id)sender {
    if ([matriculaInput.text length] != 0 && [passwordInput.text length] != 0) {
        self.carreras = [BLUTActionHelper getCarreras:[matriculaInput text] password:[passwordInput text]];
        if( carreras != nil){
            user = [self saveUser:[matriculaInput text] password:[passwordInput text]];
            [self showCarreras];
        }
    }else{
        NSLog(@"matricula o password vacios...");
    }
}


- (User *) saveUser:(NSString *)matricula password:(NSString *)password{
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(matricula = %@ AND password = %@ )", matricula, password];
    if ([CoreDataHelper countForEntity:@"User" withPredicate:pred andContext:[self managedObjectContext]] > 0){
       user = [[CoreDataHelper searchObjectsForEntity:@"User" withPredicate:pred andSortKey:nil andSortAscending:NO andContext:[self managedObjectContext]] objectAtIndex:0];
        NSLog(@" EL usuario ya existe.");
        return user;
    }else{
        
        user = (User *) [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext: [self managedObjectContext]];
        NSNumberFormatter *n = [[NSNumberFormatter alloc] init];
        [n setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber *num = [n numberFromString:matricula];
        [user setMatricula:num];
        [user setPassword:password];
        
        NSError *error;
        if (![self.managedObjectContext save:&error]){
            NSLog(@"Fallo agregar el usuario with error: %@", [error domain]);
            return nil;
        }else{
            return user;
        }
    }
    
}
- (void) saveCarreras{
    for( NSString *key in carreras){
        Carrera *c = [NSEntityDescription insertNewObjectForEntityForName:@"Carrera" inManagedObjectContext:[self managedObjectContext]];
        [c setNombre:[carreras objectForKey:key]];
        [c setChx:key];
        [c setMatricula:[[user matricula] stringValue]];
        
        NSError *error;
        if (![[self managedObjectContext] save:&error]){
            NSLog(@"Fallo agregar la carrera %@ with error: %@",[c nombre], [error domain]);
        }else{
            NSLog(@"Se agrego la carrera: %@", [c nombre]);
        }
    }
}

- (void) showCarreras{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setBool:YES forKey:@"userExists"];
    [pref setObject:[user.matricula stringValue] forKey:@"mat"];
    [pref setObject:[user password] forKey:@"pass"];
    [pref synchronize];
    [self saveCarreras];
    [self performSegueWithIdentifier:@"carrerasView" sender:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"carrerasView"]) {
        BLUTCarrerasViewController *cv =[segue destinationViewController];
        cv.carreras = self.carreras;
        cv.mat = [matriculaInput text];
    }
}


@end
