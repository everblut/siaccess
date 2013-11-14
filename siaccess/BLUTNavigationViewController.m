//
//  BLUTNavigationViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 06/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTNavigationViewController.h"
#import "BLUTCarrerasViewController.h"
#import "BLUTAppDelegate.h"
#import "CoreDataHelper.h"
#import "Carrera.h"

@interface BLUTNavigationViewController ()

@end

@implementation BLUTNavigationViewController
@synthesize managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    id root;
    BLUTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;

    if([self logged] == YES){
        BLUTCarrerasViewController *cv = [self.storyboard instantiateViewControllerWithIdentifier:@"carrerasView"];
        NSString *mat = [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"];
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
        cv.carreras = [self getCarreras:mat :pass];
        cv.mat = mat;
        root = cv;
    }else{
        root = [self.storyboard instantiateViewControllerWithIdentifier:@"loginView"];
    }
    [self setViewControllers:@[root] animated:YES];

}

- (BOOL)logged{
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"userExists"];
}
            
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSDictionary *) getCarreras:(NSString *)mat :(NSString *)pass{
    if(mat != nil && pass != nil){
        NSMutableDictionary *all = [[NSMutableDictionary alloc]init];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"(matricula = %@)", mat];
        NSMutableArray *a = [CoreDataHelper searchObjectsForEntity:@"Carrera" withPredicate:pred andSortKey:nil andSortAscending:NO andContext:[self managedObjectContext]];
        for (Carrera *carr in a){
            [all setObject:[carr nombre] forKey:[carr chx] ];
        }
        return [[NSDictionary alloc] initWithDictionary:all];
    }
    return nil;
    
}


@end
