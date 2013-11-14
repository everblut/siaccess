//
//  BLUTCarrerasViewController.m
//  siaccess
//
//  Created by Everardo Medina Palomo on 29/10/13.
//  Copyright (c) 2013 Everardo Medina Palomo. All rights reserved.
//

#import "BLUTCarrerasViewController.h"
#import "BLUTAccionesViewController.h"
#import "Materia.h"


@interface BLUTCarrerasViewController()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation BLUTCarrerasViewController
@synthesize carreras;
@synthesize mat;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCarreras];
    [self setTitle:@"Carreras"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initCarreras{
    self.tableView.dataSource = self;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [carreras count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.detailTextLabel setNumberOfLines:4];
    [cell.detailTextLabel setText:(NSString *)[carreras objectForKey:[NSString stringWithFormat:@"%d",indexPath.row]]];
    [cell.textLabel setText:mat];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"verAcciones" sender:self.view];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"verAcciones"]){
        BLUTAccionesViewController * av =[segue destinationViewController];
        av.choice = [self.tableView indexPathForSelectedRow].row;
    }
}



@end
