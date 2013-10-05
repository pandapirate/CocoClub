//
//  HistoryCell.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/21/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell
@synthesize QuizDate, QuizScore, QuizTitle, quiz;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setValues {

    switch ([quiz.type intValue]) {
        case 1:
            QuizTitle.text = [NSString stringWithFormat:@"Standard Level: %@", quiz.level];
            break;
        case 2:
            QuizTitle.text = [NSString stringWithFormat:@"Custom Level: %@ Q#: %@", quiz.level, quiz.number];
            break;
        default:
            break;
    }
    
    QuizScore.text = [NSString stringWithFormat:@"%@", quiz.score];

    NSDateFormatter *format = [NSDateFormatter new];
    [format setDateFormat:@"EEEE MMMM dd, yyyy"];
    //NSLocale* currentLoc = [NSLocale currentLocale];
//    NSLog(@"%@",[[NSDate date] descriptionWithLocale:currentLoc]);
    QuizDate.text = [format stringFromDate:quiz.date];
}

@end
