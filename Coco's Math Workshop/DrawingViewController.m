//
//  DrawingViewController.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/24/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "DrawingViewController.h"

@interface DrawingViewController ()

@end

@implementation DrawingViewController
@synthesize mainImage, tempDrawImage, Equation, eq;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if (eq != NULL) {
        Equation.text = eq;
    } else {
        Equation.text = @"";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(tempDrawImage.frame.size);
    [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 7 );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255, 255, 255, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [tempDrawImage setAlpha:1.0];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[MathSolver instance] playSound];
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 7);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255, 255, 255, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [mainImage.image drawInRect:CGRectMake(0, 0, mainImage.frame.size.width, mainImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [tempDrawImage.image drawInRect:CGRectMake(0, 0, tempDrawImage.frame.size.width, tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)ClearImage:(UIButton *)sender {
    [[MathSolver instance] playSound];
    tempDrawImage.image = nil;
    mainImage.image = nil;
}

- (IBAction)GoBack:(UIButton *)sender {
    [[MathSolver instance] playSound];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[MathSolver instance] playSound];
}
@end
