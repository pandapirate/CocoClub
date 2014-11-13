//
//  MasterViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/12/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "MasterViewController.h"
#import "MathSolver.h"
#import "QuizPageViewController.h"


@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize StartButton;

Question *question;
Quiz *quiz;
int total, correct;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void) viewDidAppear:(BOOL)animated {
    if ([MathSolver instance].toNextLevel) {
        [MathSolver instance].toNextLevel = NO;
        [self performSegueWithIdentifier:@"AutoLevelSegue" sender:self];
    }
    [MathSolver instance].returnToMain = NO;
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"] == 1) {
        [StartButton setTitle:@"Start" forState:UIControlStateNormal];
        [StartButton setTitle:@"Start" forState:UIControlStateSelected];
    } else {
        [StartButton setTitle:@"Continue" forState:UIControlStateNormal];
        [StartButton setTitle:@"Continue" forState:UIControlStateSelected];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"]){
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"CurrentPlayerLevel"];
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"] == 1) {
        [StartButton setTitle:@"Start" forState:UIControlStateNormal];
        [StartButton setTitle:@"Start" forState:UIControlStateSelected];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[MathSolver instance] playSound];
    
    if ([[segue identifier] isEqualToString:@"AutoLevelSegue"]) {
        
        QuizPageViewController *dest = [segue destinationViewController] ;
        
        dest.difficulty = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"];
        
        if ([MathSolver instance].retryLevel > 0) {
            dest.difficulty = [MathSolver instance].retryLevel;
            [MathSolver instance].retryLevel = -1;
        }
        
        dest.numOfQuestions = 10;
        dest.type = 1;
        
    } else if ([[segue identifier] isEqualToString:@"CustomLevelSegue"]) {
        [MathSolver instance].returnToMain = NO;
    }
}

@end
