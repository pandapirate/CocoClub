//
//  QuizResultViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/8/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuizResultViewController : UIViewController

@property (strong, nonatomic) Quiz *quiz;
@property (strong, nonatomic) IBOutlet UILabel *Exclaimation;
@property (strong, nonatomic) IBOutlet UILabel *Score;
@property (strong, nonatomic) IBOutlet UIButton *NextLevelButton;
@property (strong, nonatomic) IBOutlet UILabel *TimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *BestTimeLabel;

- (IBAction)BacktoMain:(UIButton *)sender;
- (IBAction)NextLevel:(UIButton *)sender;
- (IBAction)RetryLevel:(UIButton *)sender;
@end
