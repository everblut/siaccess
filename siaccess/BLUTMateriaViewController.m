//
//  BLUTMateriaViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 11/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTMateriaViewController.h"

@interface BLUTMateriaViewController ()
@property (strong,nonatomic) NSMutableArray *op;
@property (strong,nonatomic) NSMutableArray *names;
@end

@implementation BLUTMateriaViewController
@synthesize materia;
@synthesize op;
@synthesize names;

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
    [self oportunidad];
    [self setTitle:materia.nombre];
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Información de la materia";
            break;
        case 1:
            return @"Oportunidades";
            break;
        case 2:
            return @"Laboratorio";
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            NSLog(@"OP count: %d",[op count]);
            return [op count];
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"detalleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
   
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    [cell.textLabel setText:@"Semestre"];
                    [cell.detailTextLabel setText:materia.semestre];
                    break;
                case 1:
                    [cell.textLabel setText:@"Clave"];
                    [cell.detailTextLabel setText:materia.clave];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            [cell.textLabel setText:[names objectAtIndex:indexPath.row]];
            [cell.detailTextLabel setText:[op objectAtIndex:indexPath.row]];
            break;
        case 2:
            [cell.textLabel setText:@"Laboratorio"];
            NSString *l = [materia.laboratorio isEqualToString:@" "] ? @"Sin calificacion": materia.laboratorio ;
            [cell.detailTextLabel setText:l];
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)oportunidad{
    op = [[NSMutableArray alloc] init];
    names = [[NSMutableArray alloc] init];
    NSString *cal = [materia.primera isEqualToString:@" "] ? @"Sin calificación" : materia.primera;
    [names addObject:@"Primera"];
    [op addObject:cal];
    if(![materia.segunda isEqualToString:@" "]){
        [names addObject:@"Segunda"];
        [op addObject:materia.segunda];
    }
    if(![materia.tercera isEqualToString:@" "]){
        [names addObject:@"Tercera"];
        [op addObject:materia.tercera];
    }
    if(![materia.cuarta isEqualToString:@" "]){
        [names addObject:@"Cuarta"];
        [op addObject:materia.cuarta];
    }
    if(![materia.quinta isEqualToString:@" "]){
        [names addObject:@"Quinta"];
        [op addObject:materia.quinta];
    }
    if(![materia.sexta isEqualToString:@" "]){
        [names addObject:@"Sexta"];
        [op addObject:materia.sexta];
    }
}

@end
