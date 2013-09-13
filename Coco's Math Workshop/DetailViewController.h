//
//  DetailViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/12/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
