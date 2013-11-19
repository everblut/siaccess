//
//  BLUTPagoInternoViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 19/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTPagoInternoViewController.h"
#import "BLUTAppDelegate.h"
#import "BLUTActionHelper.h"
#import "Concepto.h"
#import "Interno.h"
#import "CoreDataHelper.h"

@interface BLUTPagoInternoViewController ()

@end

@implementation BLUTPagoInternoViewController
@synthesize managedObjectContext;
@synthesize index;
@synthesize boleta;
@synthesize detalles;
@synthesize empty;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Pago Interno"];
    BLUTAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = delegate.managedObjectContext;
    boleta = (Interno *) [self getBoleta];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (empty) return 1;
    return 4;
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
            return @"Fecha de adeudo e inscripción";
            break;
        case 3:
            return @"Detalle";
            break;
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
            return 2;
            break;
        case 3:
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
                    [cell.detailTextLabel setText:@"Banco"];
                    [cell.textLabel setText:@"BANORTE"];
                    break;
                case 1:
                    [cell.detailTextLabel setText:@"No. de Empresa"];
                    [cell.textLabel setText:[boleta banco]];
                    break;
                case 2:
                    [cell.detailTextLabel setText:@"Referencia"];
                    [cell.textLabel setText:[boleta referencia]];
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
            switch (indexPath.row) {
                case 0:
                    [cell.detailTextLabel setText:@"Fecha limite para adeudos"];
                    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:13]];
                    [cell.textLabel setText:[[boleta limiteAdeudos] lowercaseString]];
                    break;
                case 1:
                    [cell.detailTextLabel setText:@"Fecha de inscripción"];
                    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
                    [cell.textLabel setText:[[boleta fechaInscripcion] lowercaseString]];
                default:
                    break;
            }
            break;
        case 3:
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
    NSString *idx = [NSString stringWithFormat:@"%d",index];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(matricula =%@ AND carrera = %@)", mat, idx];
    if ([CoreDataHelper countForEntity:@"Interno" withPredicate:pred andContext:[self managedObjectContext]] > 0){
        return [self getDetails:pred];
    }else{
        //guardalos
        NSString *pass = [[NSUserDefaults standardUserDefaults] objectForKey:@"pass"];
        NSDictionary *d = [BLUTActionHelper getBoletaRectoria:mat password:pass choice:index];
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
    NSLog(@"%@",datos);
    Interno *r = (Interno *) [NSEntityDescription insertNewObjectForEntityForName:@"Interno" inManagedObjectContext:[self managedObjectContext]];
    Concepto *c;
    NSError *err;
    [r setBanco:   [datos objectForKey:[NSString stringWithFormat:@"%d",0]]];
    [r setReferencia: [[datos objectForKey:[NSString stringWithFormat:@"%d",1]] lowercaseString]];
    [r setVencimiento: [datos objectForKey:[NSString stringWithFormat:@"%d",2]]];
    [r setPeriodo: [datos objectForKey:[NSString stringWithFormat:@"%d",3]]];
    [r setCarrera: [NSString stringWithFormat:@"%d",index]];
    [r setMatricula: [[NSUserDefaults standardUserDefaults] objectForKey:@"mat"]];
    [r setLimiteAdeudos: [datos objectForKey:[NSString stringWithFormat:@"%d",4]]];
    [r setFechaInscripcion: [datos objectForKey:[NSString stringWithFormat:@"%d",5]]];
    NSDictionary *det = [datos objectForKey:[NSString stringWithFormat:@"%d",6]];
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
    return [[NSArray arrayWithArray:[CoreDataHelper searchObjectsForEntity:@"Interno" withPredicate:pred andSortKey:nil andSortAscending:NO andContext:[self managedObjectContext]]] objectAtIndex:0];
}
- (BOOL) deleteAllDetalles{
    return [CoreDataHelper deleteAllObjectsForEntity:@"Interno" andContext:[self managedObjectContext]];
}

@end
