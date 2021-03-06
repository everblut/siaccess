
//
//  BLUTAppDelegate.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 20/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTAppDelegate.h"
#import "User.h"
#import "Carrera.h"
#import "BLUTCarrerasViewController.h"
#import "CoreDataHelper.h"

@implementation BLUTAppDelegate

@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
      return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSError *error = nil;
    if (managedObjectContext != nil){
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@", error);
            abort();
        }
    }
}

//Managed object methods
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator  = [self persistentStoreCoordinator];
    if (coordinator != nil){
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}
- (NSManagedObjectModel *) managedObjectModel{
    if ( managedObjectContext != nil){
        return managedObjectModel;
    }else{
        managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
        return managedObjectModel;
    }
}
- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil){
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Model.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]){
        NSLog(@"Unresolved error %@", error);
        abort();
    }
    return persistentStoreCoordinator;
}
- (NSString *) applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
