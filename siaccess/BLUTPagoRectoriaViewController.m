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
#import "Rectoria.h"
#import "Concepto.h"

@interface BLUTPagoRectoriaViewController ()

@end

@implementation BLUTPagoRectoriaViewController
@synthesize managedObjectContext;
@synthesize indx;
@synthesize boleta;
@synthesize detalles;
@synthesize empty;




- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Pago Rectoria"];
    BLUTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
    boleta = (Rectoria *) [self getBoleta];
    detalles = [NSArray arrayWithArray:[[boleta valueForKey:@"toConcept"] allObjects]];
    empty = [detalles count] > 0 ? NO : YES;
    if(!empty) detalles = [self moveDetalles];
}
- (NSArray *) moveDetalles{
    NSMutableArray *d = [[NSMutableArray alloc] initWithArray:detalles];
    Concepto *f;
    for(Concepto *c in d){
        if ([[c nombre] isEqualToString:@"total"]){
            [d removeObjectAtIndex:[d indexOfObject:c]];
            f = c;
            break;
        }
    }
    [d insertObject:f atIndex:[d count]];
    return [NSArray arrayWithArray:d];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (empty) return 1;
    return 3;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (empty) return @"Boleta no liberada";
    switch (section) {
        case 0:
            return @"Información bancaria";
            break;
        case 1:
            return @"Periodo y vencimiento";
            break;
        case 2:
            return @"Detalle";
        default:
            return 0;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (empty) return 1;
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return [detalles count];
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (empty) {
        [cell.textLabel setText:@"La Boleta no se encuentra liberada"];
        [cell.detailTextLabel setText:@""];
        return cell;
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Banco"];
                    [cell.detailTextLabel setText:@"BANORTE"];
                    break;
                case 1:
                    [cell.textLabel setText:@"No. de Empresa"];
                    [cell.detailTextLabel setText:[boleta banco]];
                    break;
                case 2:
                    [cell.textLabel setText:@"Referencia"];
                    [cell.detailTextLabel setText:[boleta referencia]];
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    [cell.detailTextLabel setText:@"Vencimiento"];
                    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
                    [cell.textLabel setTextColor:[UIColor redColor]];
                    [cell.textLabel setText:[[boleta vencimiento] lowercaseString]];
                    break;
                case 1:
                    [cell.detailTextLabel setText:@"Periodo"];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.textLabel setText:[[boleta periodo] lowercaseString]];
                default:
                    break;
            }
            
            break;
        case 2:
            [cell.textLabel setText:[[detalles objectAtIndex:indexPath.row] nombre]];
            [cell.detailTextLabel setText:[[detalles objectAtIndex:indexPath.row] costo]];
            if(indexPath.row == [detalles count]-1){
                [cell.detailTextLabel setFont:[UIFont boldSystemFontOfSize:18]];
                [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            }
            break;
    }
    return cell;
}

- (NSArray *) getBoleta{
    NSString *mat = [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"];
    NSString *idx = [NSString stringWithFormat:@"%d",indx];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(matricula =%@ AND carrera = %@)", mat, idx];
    if ([CoreDataHelper countForEntity:@"Rectoria" withPredicate:pred andContext:[self managedObjectContext]] > 0){
        return [self getDetails:pred];
    }else{
        //guardalos
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
        NSDictionary *d = [BLUTActionHelper getBoletaRectoria:mat password:pass choice:indx];
        if ([d objectForKey:@"0"] == NULL) return nil;
        if([self saveBoleta:d] == YES){
            return [self getDetails:pred];
        }else{
            NSLog(@"Pero algo salio mal");
            return nil;
        }
    }
}
- (BOOL) saveBoleta:(NSDictionary *)datos{
    Rectoria *r = (Rectoria *) [NSEntityDescription insertNewObjectForEntityForName:@"Rectoria" inManagedObjectContext:[self managedObjectContext]];
    Concepto *c;
    NSError *err;
    [r setBanco:   [datos objectForKey:[NSString stringWithFormat:@"%d",0]]];
    [r setReferencia: [[datos objectForKey:[NSString stringWithFormat:@"%d",1]] lowercaseString]];
    [r setVencimiento: [datos objectForKey:[NSString stringWithFormat:@"%d",2]]];
    [r setPeriodo: [datos objectForKey:[NSString stringWithFormat:@"%d",3]]];
    [r setCarrera: [NSString stringWithFormat:@"%d",indx]];
    [r setMatricula: [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"]];
    NSDictionary *det = [datos objectForKey:[NSString stringWithFormat:@"%d",4]];
    for(NSString *key in [det allKeys]){
        c = (Concepto *) [NSEntityDescription insertNewObjectForEntityForName:@"Concepto" inManagedObjectContext:[self managedObjectContext]];
        [c setIdentificador:  [[det objectForKey:key] objectForKey:[NSString stringWithFormat:@"%d",0]]];
        [c setNombre:  [[[det objectForKey:key] objectForKey:[NSString stringWithFormat:@"%d",1]] lowercaseString]];
        [c setCosto:  [[[det objectForKey:key] objectForKey:[NSString stringWithFormat:@"%d",2]] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        [[r mutableSetValueForKey:@"toConcept"] addObject:c ];
        if(![self.managedObjectContext save:&err]){
            NSLog(@"Fallo agregar la boleta con error: %@",[err domain]);
            return NO;
        }
    }
    
    if(![self.managedObjectContext save:&err]){
        NSLog(@"Fallo agregar la boleta con error: %@",[err domain]);
        return NO;
    }
    return YES;
}
- (NSArray *) getDetails:(NSPredicate *)pred{
    return [[NSArray arrayWithArray:[CoreDataHelper searchObjectsForEntity:@"Rectoria" withPredicate:pred andSortKey:nil andSortAscending:NO andContext:[self managedObjectContext]]] objectAtIndex:0];
}
- (BOOL) deleteAllDetalles{
    return [CoreDataHelper deleteAllObjectsForEntity:@"Rectoria" andContext:[self managedObjectContext]];
}
@end
