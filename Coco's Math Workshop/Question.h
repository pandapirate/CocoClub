//
//  Question.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/5/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Question : NSManagedObject

@property (nonatomic, retain) NSNumber * answer;
@property (nonatomic, retain) NSNumber * correct;
@property (nonatomic, retain) NSNumber * userans;
@property (nonatomic, retain) NSString * equation;

@end
