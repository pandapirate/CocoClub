//
//  QuizPageViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/15/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizPageViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *Equation;
@property (strong, nonatomic) IBOutlet UILabel *Solution;
@property (strong, nonatomic) IBOutlet UILabel *Level;
@property (strong, nonatomic) IBOutlet UILabel *QuestionCount;
@property (strong, nonatomic) IBOutlet UIButton *EnterButton;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;

@property (nonatomic, retain) NSTimer *timer;

@property int difficulty;
@property int numOfQuestions;
@property int type;
@property (strong, nonatomic) NSMutableArray *operations;

- (IBAction)VerifyAnswer:(UIButton *)sender;
- (id) initWithLevel: (int) level andNumberOfQuestions: (int) number;
- (IBAction)EnterNumber:(UIButton *)sender;
- (IBAction)QuitQuiz:(UIButton *)sender;


@end
