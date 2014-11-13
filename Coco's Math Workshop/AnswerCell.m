//
//  AnswerCell.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/5/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "AnswerCell.h"

@implementation AnswerCell
@synthesize question, QuestionLabel, AnswerLabel, CorrectLabel, TimeLabel;

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

- (void) setLabels {
    double value = [question.userans doubleValue];
    double sol = [question.answer doubleValue];
    
    // check answer
    if (fabs(value - sol) <= 0.01) {
        [CorrectLabel setText:@"\u2713"];
        [CorrectLabel setTextColor:[UIColor whiteColor]];
    } else {
        [CorrectLabel setText:@"\u00D7"];
        [CorrectLabel setTextColor:[UIColor redColor]];
    }
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setMaximumFractionDigits:2];
    
    NSString *formattedEq = [[MathSolver instance] formatEquation:question.equation];
    
    QuestionLabel.text = [NSString stringWithFormat:@"%@. %@ = %@", question.number, formattedEq, [f stringFromNumber:question.answer]];
    AnswerLabel.text = [NSString stringWithFormat:@"%@", [f stringFromNumber:question.userans]];
    
    int seconds = [question.time intValue];
    int hour = seconds/3600;
    int minute = (seconds - 3600 * hour)/60;
    int second = (seconds - 3600 * hour - minute * 60);
    
    TimeLabel.text = [NSString stringWithFormat:@"%02i:%02i", minute, second];
}
@end
