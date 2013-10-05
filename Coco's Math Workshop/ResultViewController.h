//
//  ResultViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/1/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) Quiz *quiz;
@property (strong, nonatomic) NSMutableArray *results;
@property (strong, nonatomic) IBOutlet UITableView *ComparisonTable;
- (IBAction)BackButton:(UIButton *)sender;
@end
