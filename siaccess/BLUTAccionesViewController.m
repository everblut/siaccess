//
//  BLUTAccionesViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 06/11/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTAccionesViewController.h"
#import "BLUTKardexViewController.h"
#import "BLUTPagoRectoriaViewController.h"
#import "BLUTPagoInternoViewController.h"

@interface BLUTAccionesViewController ()

@end

@implementation BLUTAccionesViewController
@synthesize choice;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"accionKardex"]){
        BLUTKardexViewController * kv =[segue destinationViewController];
        [kv setIndex:choice];
    }
    if([[segue identifier] isEqualToString:@"accionPagoRectoria"]){
        BLUTPagoRectoriaViewController * prv = [segue destinationViewController];
        [prv setIndx:choice];
    }
    if([[segue identifier] isEqualToString:@"accionPagoInterno"]){
        BLUTPagoInternoViewController *piv = [segue destinationViewController];
        [piv setIndex:choice];
    }
}

@end
