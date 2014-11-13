//
//  LevelSelectViewController.m
//  Coco's Club
//
//  Created by Kevin Huang on 10/13/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "LevelSelectViewController.h"
#import "QuizPageViewController.h"

@interface LevelSelectViewController ()

@end

@implementation LevelSelectViewController
@synthesize TitleLabel, LeftButton, RightButton, LevelButtons, Score, quizzes;
int set, selectedQuiz;

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

- (void) viewDidAppear:(BOOL)animated {
    if ([MathSolver instance].returnToMain) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    set = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"] / 10;
    
    switch (set) {
        case 0:
            TitleLabel.text = @"Operations: +";
            break;
        case 1:
            TitleLabel.text = @"Operations: + -";
            break;
        case 2:
            TitleLabel.text = @"Operations: + - \u00D7";
            break;
        case 3:
            TitleLabel.text = @"Operations: + - \u00D7 \u00F7";
            break;
        default:
            TitleLabel.text = @"Operations: + - \u00D7 \u00F7";
            break;
    }
    
    if (set == 0)
        LeftButton.hidden = YES;
    
    NSLog(@"Operations: + - \u00D7 \u00F7");
    
    [self fetchQuizzes];
    [self setButtonLabel];
    [self setScoreLabel];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setButtonLabel {
    int maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"];
    
    for (UIButton *b in LevelButtons) {
        int level = set * 10 + b.tag;
        NSString *val = [NSString stringWithFormat:@"%i", level];
        [b setTitle:val forState:UIControlStateNormal];
        [b setTitle:val forState:UIControlStateSelected];

        if (level > maxLevel) {
            b.enabled = NO;
        } else {
            b.enabled = YES;
        }
    }
}

- (void) setScoreLabel {
    int maxLevel = [[NSUserDefaults standardUserDefaults] integerForKey:@"CurrentPlayerLevel"];
    for (UILabel *label in Score) {
        int level = set * 10 + label.tag;

        if (level <= maxLevel) {
            if (label.tag-1 < quizzes.count) {
                Quiz *q = [quizzes objectAtIndex:(label.tag-1)];
                label.text = [NSString stringWithFormat:@"%@", q.score];
//                NSLog(@"Button tag : %i, quiz level: %i, score: %@", label.tag, [q.level intValue], q.score);
            } else {
                label.text = @"New";
            }
            
            label.hidden = NO;
        } else {
            label.hidden = YES;
        }
    }
}

- (void) fetchQuizzes {
    quizzes = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [AppDelegate sharedAppDelegate].managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Quiz" inManagedObjectContext:context];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:entityDescription];
    
    int min = set * 10 + 1;
    int max = min + 9;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(level >= %i) AND (level <= %i)", min, max];
    [fetch setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"level" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    [fetch setSortDescriptors:@[sort, sort2]];
    
    NSArray *results = [context executeFetchRequest:fetch error:nil];
    
    NSMutableArray *used = [[NSMutableArray alloc] init];
    
    for (Quiz *q in results) {
        if (![used containsObject:q.level]) {
            [quizzes addObject:q];
            [used addObject:q.level];
        }
    }
}


- (IBAction)ChangeSet:(UIButton *)sender {
    if (sender.tag == 1) {
        if (set == 0)
            return;

        set--;
        
        if (set == 0) {
            LeftButton.hidden = YES;
        }
    } else {
        set++;
        if (set >= 0) {
            LeftButton.hidden = NO;
        }
    }
    
    [self fetchQuizzes];
    [self setButtonLabel];
    [self setScoreLabel];
}


- (IBAction)BackButton:(UIButton *)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)SelectLevel:(UIButton *)sender {
    NSLog(@"Selected: %i", sender.tag);
    selectedQuiz = set * 10 + sender.tag;
    [self performSegueWithIdentifier:@"BeginSelectedQuiz" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[MathSolver instance] playSound];
    if ([[segue identifier] isEqualToString:@"BeginSelectedQuiz"]) {
        
        QuizPageViewController *dest = [segue destinationViewController] ;
        
        dest.difficulty = selectedQuiz;
        dest.numOfQuestions = 10;
        dest.type = 1;
    }
}
@end
