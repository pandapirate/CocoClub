//
//  QuizResultViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/8/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "QuizResultViewController.h"
#import "QuizPageViewController.h"
#import "ResultViewController.h"

@interface QuizResultViewController ()

@end

@implementation QuizResultViewController
@synthesize quiz, Exclaimation, Score, NextLevelButton, TimeLabel, BestTimeLabel;

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
    int score = [quiz.score intValue];
    
    if (score < 50) {
        Exclaimation.text = @"Better luck next time";
    } else if (score < 60) {
        Exclaimation.text = @"Nice Try";
    } else if (score < 70) {
        Exclaimation.text = @"Good Job";
    } else if (score < 80) {
        Exclaimation.text = @"Excellent";
    } else if (score < 90){
        Exclaimation.text = @"Outstanding";
    } else {
        Exclaimation.text = @"Congratulations!";
    }
    
    if ([quiz.type intValue] == 2 || ([quiz.type intValue] == 1 && score < 70) )
        NextLevelButton.hidden = YES;
    
    [self timeCount];
    [self bestTimeLabel];
    Score.text = [NSString stringWithFormat:@"%@%%", quiz.score];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) timeCount {
    int seconds = 0;
    for (Question *q in quiz.questions) {
        seconds += [q.time intValue];
    }    
    
    int hour = seconds/3600;
    int minute = (seconds - 3600 * hour)/60;
    int second = (seconds - 3600 * hour - minute * 60);
    
    TimeLabel.text = [NSString stringWithFormat:@"%02i:%02i", minute, second];
}

- (IBAction)BacktoMain:(UIButton *)sender {
    [[MathSolver instance] playSound];
    [MathSolver instance].toNextLevel = NO;
    [MathSolver instance].returnToMain = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)NextLevel:(UIButton *)sender {
    [MathSolver instance].retryLevel = [quiz.level intValue] + 1;
    
    [MathSolver instance].toNextLevel = YES;
    [MathSolver instance].returnToMain = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)RetryLevel:(UIButton *)sender {
    [MathSolver instance].retryLevel = [quiz.level intValue];
    
    NSLog(@"%i", [MathSolver instance].retryLevel);
    [MathSolver instance].toNextLevel = YES;
    [MathSolver instance].returnToMain = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    [[MathSolver instance] playSound];

    if ([[segue identifier] isEqualToString:@"QuizResultSegue"]) {
        ResultViewController *dest = [segue destinationViewController] ;
        dest.quiz = quiz;
    }
}

- (void) bestTimeLabel {
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"level = %i", [quiz.level intValue]];
    [fetch setPredicate:predicate];
    
    NSArray *results = [context executeFetchRequest:fetch error:nil];
    int best = -1;
    int time = 0;
    
    for (Quiz *q in results) {
        if ([q.score intValue] < 70) {
            continue;
        }
        time = 0;
        for (Question *q in quiz.questions) {
            time += [q.time intValue];
        }
        
        if (best == -1 || time < best) {
            best = time;
        }
    }
    if (best >= 0) {
        int hour = best/3600;
        int minute = (best - 3600 * hour)/60;
        int second = (best - 3600 * hour - minute * 60);
    
        BestTimeLabel.text = [NSString stringWithFormat:@"%02i:%02i", minute, second];
    } else {
        BestTimeLabel.text = @"N/A";
    }
}
@end
