//
//  Quiz.h
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 10/5/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Question;

@interface Quiz : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * level;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *questions;
@end

@interface Quiz (CoreDataGeneratedAccessors)

- (void)addQuestionsObject:(Question *)value;
- (void)removeQuestionsObject:(Question *)value;
- (void)addQuestions:(NSSet *)values;
- (void)removeQuestions:(NSSet *)values;

@end
