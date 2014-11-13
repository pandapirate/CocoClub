//
//  CustomLevelViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/21/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomLevelViewController : UIViewController

extern NSString * const NOTIF_LoggingOut_Settings;
@property (strong, nonatomic) IBOutlet UIButton *multi;
@property (strong, nonatomic) IBOutlet UIButton *divide;

@property (strong, nonatomic) IBOutlet UILabel *DifficultyLabel;
@property (strong, nonatomic) IBOutlet UILabel *NumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *PlusCross;
@property (strong, nonatomic) IBOutlet UIImageView *MinusCross;
@property (strong, nonatomic) IBOutlet UIImageView *MultiCross;
@property (strong, nonatomic) IBOutlet UIImageView *DivCross;

@property (strong, nonatomic) NSMutableArray *operations;

- (IBAction)Increments:(UIButton *)sender;
- (IBAction)IncludeOperations:(UIButton *)sender;
- (IBAction)GoBack:(UIButton *)sender;
@end
