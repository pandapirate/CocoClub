//
//  QuizPageViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/15/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "QuizPageViewController.h"
#import "MathSolver.h"
#import "MasterViewController.h"
#import "DrawingViewController.h"
#import "QuizResultViewController.h"

@interface QuizPageViewController ()

@end

@implementation QuizPageViewController
@synthesize Equation, Solution, difficulty, numOfQuestions, type, Level, QuestionCount, operations, EnterButton, TimeLabel, timer;

Question *question;
Quiz *quiz;
int total, correct, seconds, pastTime;
NSManagedObjectContext  *context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (id) initWithLevel:(int)level andNumberOfQuestions: (int) number{
    self = [super init];
    
    difficulty = level;
    numOfQuestions = number;
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated {
    if ([MathSolver instance].returnToMain) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Solution.text = @"";
    Level.text = [NSString stringWithFormat:@"Level: %i", difficulty];
    total = 0;
    correct = 0;
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;
    quiz = [NSEntityDescription insertNewObjectForEntityForName:@"Quiz" inManagedObjectContext:context];
    
    quiz.date = [NSDate date];
    quiz.level = [NSNumber numberWithInt:difficulty];
    quiz.number = [NSNumber numberWithInt:numOfQuestions];
    quiz.type = [NSNumber numberWithInt:type];

    [EnterButton setTitle:@"\u21B5" forState:UIControlStateNormal];
    [EnterButton setTitle:@"\u21B5" forState:UIControlStateSelected];

    TimeLabel.text = @"00:00";

    [self newEquation];

    seconds = 0;
    pastTime = -1;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)EnterNumber:(UIButton *)sender {
    [[MathSolver instance] playSound];
    
    if (sender.tag == 11) {
        Solution.text = [NSString stringWithFormat:@"%@-", Solution.text];
    } else if (sender.tag == 12) {
        Solution.text = [NSString stringWithFormat:@"%@.", Solution.text];
    } else if (sender.tag == 13 && Solution.text.length > 0) {
        Solution.text = [NSString stringWithFormat:@"%@", [Solution.text substringToIndex:Solution.text.length-1]];
    } else {
        Solution.text = [NSString stringWithFormat:@"%@%i", Solution.text, sender.tag];
    }
}

- (IBAction)VerifyAnswer:(UIButton *)sender {
    [[MathSolver instance] playSound];
    
    double value = [Solution.text doubleValue];
    double sol = [question.answer doubleValue];
    
    question.userans = [NSNumber numberWithDouble:value];
    
    if (pastTime == -1) {
        question.time = [NSNumber numberWithInt:seconds];
    } else {
        question.time = [NSNumber numberWithInt:seconds - pastTime];
    }
    pastTime = seconds;
    
    // check answer
    if (fabs(value - sol) <= 0.01) {
        correct++;
    }
    
    total++;
    
    if (total == numOfQuestions) {
        [self endQuiz];
    } else {
        Solution.text = @"";
        [self newEquation];
    }
}

- (void) newEquation {
    
    NSString *eq = @"";
    
    if (operations != NULL) {
        eq = [[MathSolver instance] newEquationforLevel:difficulty andOperations:operations andType:2];
    } else {
        eq = [[MathSolver instance] newEquationforLevel:difficulty];
    }
//    NSLog(@"Equation: %@", eq);
    
    double res = [[MathSolver instance] solve:eq];
//    NSLog(@"Solution: %f", res);
    
    NSString *formatedEQ = [[MathSolver instance] formatEquation:eq];
//    NSLog(@"Formatted: %@", formatedEQ);
    
    [Equation setText:formatedEQ];
    
    question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
    
    question.equation = eq;
    question.answer = [NSNumber numberWithDouble:res];
    question.number = [NSNumber numberWithInteger:(total + 1)];
    
    [quiz addQuestionsObject:question];
    
    QuestionCount.text = [NSString stringWithFormat:@"%i/%i", total+1, numOfQuestions];
    

}

- (void) endQuiz {
    // record score
    [timer invalidate];
    quiz.score = [NSNumber numberWithInt:((100 * correct)/numOfQuestions)];
    [context save:nil];
    
    if (type == 1 && [quiz.score intValue] >= 70) {
        int curLvl = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"];
        
        if (curLvl == difficulty)
            [[NSUserDefaults standardUserDefaults] setInteger:(curLvl+1) forKey:@"CurrentPlayerLevel"];
    }
    
    [self performSegueWithIdentifier:@"ViewResultsSegue" sender:self];
}

- (IBAction)QuitQuiz:(UIButton *)sender {
    [timer invalidate];
    [context reset];
    [[MathSolver instance] playSound];
    [MathSolver instance].returnToMain = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[MathSolver instance] playSound];
    if ([[segue identifier] isEqualToString:@"ScratchPadSegue"]) {
        DrawingViewController *dest = [segue destinationViewController] ;
        
        dest.eq = Equation.text;
    } else if ([[segue identifier] isEqualToString:@"ViewResultsSegue"]) {
        QuizResultViewController *dest = [segue destinationViewController];
        
        dest.quiz = quiz;
    }
}

- (void) timeCount {
    seconds += 1;
    int hour = seconds/3600;
    int minute = (seconds - 3600 * hour)/60;
    int second = (seconds - 3600 * hour - minute * 60);
    
    TimeLabel.text = [NSString stringWithFormat:@"%02i:%02i", minute, second];
}

- (void)viewDidUnload {
    [self setSolution:nil];
    [self setLevel:nil];
    [self setQuestionCount:nil];
    timer = nil;
    [super viewDidUnload];
}
@end
