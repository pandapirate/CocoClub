//
//  CustomLevelViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/21/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "CustomLevelViewController.h"
#import "QuizPageViewController.h"
#import "MathSolver.h"

@interface CustomLevelViewController ()

@end

NSString * const NOTIF_LoggingOut_Settings = @"goToView2";

@implementation CustomLevelViewController
@synthesize DifficultyLabel, NumberLabel, operations, multi, divide;
int difficulty = 1;
int questions = 5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    if ([MathSolver instance].returnToMain) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    DifficultyLabel.text = @"1";
    NumberLabel.text = @"5";
    [multi setTitle:@"\u00D7" forState:UIControlStateNormal];
    [multi setTitle:@"\u00D7" forState:UIControlStateSelected];
    
    [divide setTitle:@"\u00F7" forState:UIControlStateNormal];
    [divide setTitle:@"\u00F7" forState:UIControlStateSelected];
    operations = [[NSMutableArray alloc] initWithObjects:@"+", @"-", @"*", @"/", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"BeginQuizSegue"]) {
        
        QuizPageViewController *dest = [segue destinationViewController] ;
        
        dest.difficulty = [DifficultyLabel.text intValue];
        dest.numOfQuestions = [NumberLabel.text intValue];
        dest.type = 2;
        dest.operations = operations;
    }
}

- (IBAction)Increments:(UIButton *)sender {
    int diff = [DifficultyLabel.text intValue];
    int num = [NumberLabel.text intValue];
    
    switch (sender.tag) {
        case 0:
            if (diff - 1 > 0) {
                DifficultyLabel.text = [NSString stringWithFormat:@"%i", (diff - 1)];
            }
            break;
        case 1:
            DifficultyLabel.text = [NSString stringWithFormat:@"%i", (diff + 1)];
            break;
        case 2:
            if (num - 1 > 4) {
                NumberLabel.text = [NSString stringWithFormat:@"%i", (num - 1)];
            }
            break;
        case 3:
            NumberLabel.text = [NSString stringWithFormat:@"%i", (num + 1)];
            break;
        default:
            break;
    }
}

- (IBAction)IncludeOperations:(UIButton *)sender {
    if (operations.count == 1 && !sender.selected) {
        return;
    }
    
    NSString *op = @"";
    switch (sender.tag) {
        case 0:
            op = @"+";
            break;
        case 1:
            op = @"-";
            break;
        case 2:
            op = @"*";
            break;
        case 3:
            op = @"/";
            break;
        default:
            break;
    }
    
    if (sender.selected) {
        [sender setSelected:NO];
        [operations addObject:op];
    } else {
        [sender setSelected:YES];
        [operations removeObject:op];
    }
}

- (IBAction)GoBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
    [self setDifficultyLabel:nil];
    [self setNumberLabel:nil];
    [super viewDidUnload];
}
@end
