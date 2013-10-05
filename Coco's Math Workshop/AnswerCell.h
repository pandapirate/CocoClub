//
//  AnswerCell.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/5/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerCell : UITableViewCell

@property (nonatomic, strong) Question *question;

@property (strong, nonatomic) IBOutlet UILabel *QuestionLabel;
@property (strong, nonatomic) IBOutlet UILabel *AnswerLabel;
@property (strong, nonatomic) IBOutlet UILabel *CorrectLabel;

- (void) setLabels;
@end
