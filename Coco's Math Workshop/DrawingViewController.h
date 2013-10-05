//
//  DrawingViewController.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/24/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawingViewController : UIViewController{
    
    CGPoint lastPoint;
    BOOL mouseSwiped;
}

@property (strong, nonatomic) IBOutlet UILabel *Equation;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;
@property (strong, nonatomic) IBOutlet UIImageView *tempDrawImage;

@property (strong, nonatomic) NSString *eq;

- (IBAction)ClearImage:(UIButton *)sender;
- (IBAction)GoBack:(UIButton *)sender;
@end
