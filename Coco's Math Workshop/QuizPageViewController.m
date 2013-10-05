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

@interface QuizPageViewController ()

@end

@implementation QuizPageViewController
@synthesize Equation, Solution, difficulty, numOfQuestions, type, Level, QuestionCount, operations, EnterButton, FloatWarning;

Question *question;
Quiz *quiz;
int total, correct;
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
    FloatWarning.hidden = YES;
    
    [self newEquation];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)EnterNumber:(UIButton *)sender {
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
    double value = [Solution.text doubleValue];
    double sol = [question.answer doubleValue];
    
    question.userans = [NSNumber numberWithDouble:value];
 
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
    
    context = [AppDelegate sharedAppDelegate].managedObjectContext;

    question = [NSEntityDescription insertNewObjectForEntityForName:@"Question" inManagedObjectContext:context];
    
    question.equation = eq;
    question.answer = [NSNumber numberWithDouble:res];
    
    [quiz addQuestionsObject:question];
    
    QuestionCount.text = [NSString stringWithFormat:@"%i/%i", total+1, numOfQuestions];
    
    if (res - (int) res != 0.000) {
        FloatWarning.hidden = NO;
    } else {
        FloatWarning.hidden = YES;
    }
}

- (void) endQuiz {
    // record score
    quiz.score = [NSNumber numberWithInt:((100 * correct)/numOfQuestions)];
    [context save:nil];
    
    if (type == 1 && [quiz.score intValue] >= 70) {
        int curLvl = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"];
        [[NSUserDefaults standardUserDefaults] setInteger:(curLvl+1) forKey:@"CurrentPlayerLevel"];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Quiz Completed" message:[NSString stringWithFormat:@"Correct: %i/%i", correct, total] delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:nil, nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1) {
        [MathSolver instance].returnToMain = YES;
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (IBAction)QuitQuiz:(UIButton *)sender {
    
    
    [MathSolver instance].returnToMain = YES;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ScratchPadSegue"]) {
        
        DrawingViewController *dest = [segue destinationViewController] ;
        
        dest.eq = Equation.text;
    }
}

- (void)viewDidUnload {
    [self setSolution:nil];
    [self setLevel:nil];
    [self setQuestionCount:nil];
    [super viewDidUnload];
}
@end
