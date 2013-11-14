//
//  BLUTPagoRectoriaViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 11/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTPagoRectoriaViewController.h"
#import "BLUTAppDelegate.h"
#import "BLUTActionHelper.h"
#import "CoreDataHelper.h"
#import "Materia.h"

@interface BLUTPagoRectoriaViewController ()

@end

@implementation BLUTPagoRectoriaViewController
@synthesize managedObjectContext;
@synthesize index;
@synthesize kardex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Kardex"];
    BLUTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 // Return the number of rows in the section.
    return [[self kardex] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSArray *) getKdx{
    NSString *mat = [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"];
    NSString *idx = [NSString stringWithFormat:@"%d",index];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(matricula = %@ AND carrera = %@ )", mat, idx];
    if ([CoreDataHelper countForEntity:@"Materia" withPredicate:pred andContext:[self managedObjectContext]] > 0){
        return [NSArray arrayWithArray:[CoreDataHelper searchObjectsForEntity:@"Materia" withPredicate:pred andSortKey:@"posicion" andSortAscending:NO andContext:[self managedObjectContext]]];
    }else{
        //guardalos ;_;
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
        NSDictionary *d = [BLUTActionHelper getKardex:mat password:pass choice:index];
        if([self saveMateria:d] == YES){
            return [self getKdx];
        }else{
            NSLog(@"Pero algo salio mal :c");
            return nil;
        }
    }
}
- (BOOL) saveMateria:(NSDictionary *)materias{
    Materia *m;
    NSError *error;
    int i = 0;
    NSArray *keys = [[materias allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for(NSString *key in keys){
        for (id k in [materias objectForKey:key]){
            NSDictionary *mtr = [materias objectForKey:k];
            m = (Materia *) [NSEntityDescription insertNewObjectForEntityForName:@"Materia" inManagedObjectContext:[self managedObjectContext]];
            [m setSemestre:    [mtr objectForKey:[NSString stringWithFormat:@"%d",0]]];
            [m setClave:       [mtr objectForKey:[NSString stringWithFormat:@"%d",2]]];
            [m setNombre:      [mtr objectForKey:[NSString stringWithFormat:@"%d",3]]];
            [m setPrimera:     [mtr objectForKey:[NSString stringWithFormat:@"%d",4]]];
            [m setSegunda:     [mtr objectForKey:[NSString stringWithFormat:@"%d",5]]];
            [m setTercera:     [mtr objectForKey:[NSString stringWithFormat:@"%d",6]]];
            [m setCuarta:      [mtr objectForKey:[NSString stringWithFormat:@"%d",7]]];
            [m setQuinta:      [mtr objectForKey:[NSString stringWithFormat:@"%d",8]]];
            [m setSexta:       [mtr objectForKey:[NSString stringWithFormat:@"%d",9]]];
            [m setLaboratorio: [mtr objectForKey:[NSString stringWithFormat:@"%d",10]]];
            [m setCarrera:     [NSString stringWithFormat:@"%d",index]];
            [m setMatricula:   [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"]];
            [m setPosicion:    [NSNumber numberWithInt:i]];
            
            if (![self.managedObjectContext save:&error]){
                NSLog(@"Fallo agregar la materia with error: %@", [error domain]);
                return NO;
            }else{
                i++;
            }
        }
    }
    return YES;
}

- (NSString *)getString:(int)idx js:(NSDictionary *)js {
    return [js objectForKey:[NSString stringWithFormat:@"%d",idx]];
}

@end
