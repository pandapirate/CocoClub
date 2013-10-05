//
//  HistoryRecordViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/1/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "HistoryRecordViewController.h"
#import "HistoryCell.h"
#import "ResultViewController.h"

@interface HistoryRecordViewController ()

@end

@implementation HistoryRecordViewController
@synthesize historyList, HistoryRecordView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HistoryRecordView.delegate = self;
    [self loadHistory];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [historyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"HistoryCell";
    HistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.quiz = [historyList objectAtIndex:indexPath.row];
    [cell setValues];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row selected: %i", indexPath.row);
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void) loadHistory {
    historyList = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    NSError *error;
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    NSEntityDescription *obj = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    [fetch setSortDescriptors:@[sortDescriptor]];
    [fetch setEntity:obj];
    NSArray *objects = [context executeFetchRequest:fetch error:&error];
    
    for (Quiz *o in objects) {
        [historyList addObject:o];
        //        NSLog(@"Level: %@", o.level);
    }
    
    [self.HistoryRecordView reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ViewQuizResultSegue"]) {
        
        ResultViewController *dest = [segue destinationViewController] ;
        NSIndexPath *index = [HistoryRecordView indexPathForSelectedRow];
        
        dest.quiz = [historyList objectAtIndex:index.row];
    }
}

- (IBAction)BackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
