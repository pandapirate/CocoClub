//
//  ResultViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/1/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "ResultViewController.h"
#import "AnswerCell.h"
@interface ResultViewController ()

@end

@implementation ResultViewController
@synthesize quiz, ComparisonTable, results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ComparisonTable.delegate = self;
    ComparisonTable.dataSource = self;
    ComparisonTable.backgroundColor = [UIColor clearColor];
    [self loadResults];
    
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
    return [results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"AnswerCell";
    AnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.question = [results objectAtIndex:indexPath.row];
    [cell setLabels];
    
    UIView *blank = [[UIView alloc] init];
    blank.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = blank;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void) loadResults {
    NSLog(@"Total: %@", quiz.number);
    results = [[NSMutableArray alloc] initWithCapacity:[quiz.number intValue]];

    for (Question *q in quiz.questions) {
        [results addObject:q];
    }
    
    for (Question *q in quiz.questions) {
        [results replaceObjectAtIndex:([q.number intValue]-1) withObject:q];
    }
    
    [ComparisonTable reloadData];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[MathSolver instance] playSound];
}

- (IBAction)BackButton:(UIButton *)sender {
    [[MathSolver instance] playSound];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
