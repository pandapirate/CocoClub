//
//  LevelSelectViewController.h
//  Coco's Club
//
//  Created by Kevin Huang on 10/13/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelSelectViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *LeftButton;
@property (strong, nonatomic) IBOutlet UIButton *RightButton;
@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *LevelButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *Score;
@property (strong, nonatomic) NSMutableArray *quizzes;

- (IBAction)BackButton:(UIButton *)sender;
- (IBAction)ChangeSet:(UIButton *)sender;
- (IBAction)SelectLevel:(UIButton *)sender;

@end
