//
//  HistoryRecordViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/1/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryRecordViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *HistoryRecordView;

- (IBAction)BackButton:(UIButton *)sender;
@property (nonatomic, strong) NSMutableArray *historyList;

@end
