//
//  HistoryCell.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/21/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *QuizTitle;
@property (strong, nonatomic) IBOutlet UILabel *QuizDate;
@property (strong, nonatomic) IBOutlet UILabel *QuizScore;
@property (strong, nonatomic) Quiz *quiz;

- (void) setValues;

@end
