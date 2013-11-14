//
//  BLUTKardexViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 30/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTKardexViewController.h"
#import "BLUTActionHelper.h"
#import "BLUTAppDelegate.h"
#import "BLUTMateriaViewController.h"
#import "CoreDataHelper.h"
#import "Materia.h"

@interface BLUTKardexViewController ()

@end

@implementation BLUTKardexViewController
@synthesize index;
@synthesize materias;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Kardex"];
    BLUTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
    //dame las calificaciones
    materias = [self getKdx];
    NSLog(@"%d",[materias count]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self materias]  count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *nameIdentifier = @"materiaCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nameIdentifier];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setNumberOfLines:3];
    Materia *m = [materias objectAtIndex:indexPath.row];
    [cell.textLabel setText:m.nombre];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"verMateria"]){
        BLUTMateriaViewController * mv =[segue destinationViewController];
        mv.materia = [materias objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

- (NSArray *) getKdx{
    NSString *mat = [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"];
    NSString *idx = [NSString stringWithFormat:@"%d",index];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(matricula = %@ AND carrera = %@ )", mat, idx];
    if ([CoreDataHelper countForEntity:@"Materia" withPredicate:pred andContext:[self managedObjectContext]] > 0){
        return [self getMaterias:pred];
    }else{
        //guardalos ;_;
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
        NSDictionary *d = [BLUTActionHelper getKardex:mat password:pass choice:index];
        if([self saveMateria:d] == YES){
            return [self getMaterias:pred];
        }else{
            NSLog(@"Pero algo salio mal :c");
            return nil;
        }
    }
}

- (NSArray *) getMaterias:(NSPredicate *)predicado{
    return [NSArray arrayWithArray:[CoreDataHelper searchObjectsForEntity:@"Materia" withPredicate:predicado andSortKey:@"posicion" andSortAscending:YES andContext:[self managedObjectContext]]];
}
- (BOOL) saveMateria:(NSDictionary *)mtrs{
    [self deleteAllMaterias];
    Materia *m;
    NSError *error;
    int i = 0;
    NSNumberFormatter *n = [[NSNumberFormatter alloc] init];
    [n setNumberStyle:NSNumberFormatterDecimalStyle];
    NSArray *keys = [[mtrs allKeys] sortedArrayUsingSelector: @selector(compare:)];
    for(NSString *key in keys){
            NSDictionary *mtr = [mtrs objectForKey:key];
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
            [m setPosicion:    [n numberFromString:key]];
        
            if (![self.managedObjectContext save:&error]){
                NSLog(@"Fallo agregar la materia with error: %@", [error domain]);
                return NO;
            }else{
                i++;
            }
    }
    return YES;
}
- (BOOL) deleteAllMaterias{
    return [CoreDataHelper deleteAllObjectsForEntity:@"Materia" andContext:[self managedObjectContext]];
}
@end
