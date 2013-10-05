//
//  MathSolver.m
//  Coco's Math Workshop
//
//  Created by Kevin Huang on 9/13/13.
//  Copyright (c) 2013 The Company. All rights reserved.
//

#import "MathSolver.h"

@implementation MathSolver
@synthesize returnToMain;
static MathSolver *instance;

+ (MathSolver *) instance {
    if (instance == NULL) {
        instance = [[MathSolver alloc] init];
    }
    
    return instance;
}

- (double) solve: (NSString*)equation {
    NSMutableArray *eq = [self parseEquation: equation];
    
    return [self solveEquation:eq];
}

- (double) solveEquation: (NSMutableArray *) eq {
    
    while (eq.count > 1) {
        NSMutableArray *p = [self getIndexForParenthesis:eq];
        if ([p objectAtIndex:0] != [NSNumber numberWithInt:-1]) {
            int start = [[p objectAtIndex:0] intValue] +1;
            int end = [[p objectAtIndex:1] intValue];
            
            NSMutableArray *sub = [[NSMutableArray alloc] initWithArray: [eq subarrayWithRange:NSMakeRange(start, end-start)]];
            double r = [self solveEquation:sub];
            [self replace:eq startAt:start-1 endAt:end withValue:r];
        }
        else {
            int i = [self getIndexForOp:eq];
            while (i != -1) {
                NSString *op = [eq objectAtIndex:i];
                double a = [[eq objectAtIndex:i-1] doubleValue];
                double b = [[eq objectAtIndex:i+1] doubleValue];
                
                double result = 0.0;
                
                if ([op isEqualToString:@"+"]) {
                    result = a + b;
                } else if ([op isEqualToString:@"-"]) {
                    result = a - b;
                } else if ([op isEqualToString:@"*"]) {
                    result = a * b;
                } else if ([op isEqualToString:@"/"]) {
                    result = a / b;
                } else if ([op isEqualToString:@"^"]) {
                    result = pow(a, b);
                }
                
                [self replace:eq startAt:i-1 endAt:i+1 withValue:result];
                i = [self getIndexForOp:eq];
            }
        }
    }
    return [[eq objectAtIndex:0] doubleValue];
}


- (NSMutableArray *) getIndexForParenthesis: (NSMutableArray *) eq {
    int index[] = {-1, -1};
    int last = -1;
    
    for (int i = 0; i < eq.count; i++) {
        NSString *s = [eq objectAtIndex:i];
        
        if ([s isEqualToString:@"("]) {
            last = i;
        } else if ([s isEqualToString:@")"]) {
            index[0] = last;
            index[1] = i;
            break;
        }
    }
    
   return[[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:index[0]], [NSNumber numberWithInt:index[1]], nil];
}

- (int) getIndexForOp: (NSMutableArray *) eq {
    for (int i = 0; i < eq.count; i++) {
        if ([[eq objectAtIndex:i] isEqualToString:@"^"]) {
            return i;
        }
    }
    
    for (int i = 0; i < eq.count; i++) {
        if ([[eq objectAtIndex:i] isEqualToString:@"*"] || [[eq objectAtIndex:i] isEqualToString:@"/"]) {
            return i;
        }
    }
    
    for (int i = 0; i < eq.count; i++) {
        if ([[eq objectAtIndex:i] isEqualToString:@"+"] || [[eq objectAtIndex:i] isEqualToString:@"-"]) {
            return i;
        }
    }

    return -1;
}


- (NSMutableArray *) parseEquation: (NSString *)equation {
    NSMutableArray *eq = [[NSMutableArray alloc] init];
    
    int i = 0;
    int eqIndex = 0;
    
    while (i < equation.length) {
        char c = [equation characterAtIndex:i++];
        if (isdigit(c)) {
            if (eqIndex >= eq.count) {
                [eq addObject:[NSString stringWithFormat:@"%c", c]];
            } else {
                NSString *tmp = [eq objectAtIndex:eqIndex];
                [eq setObject:[NSString stringWithFormat:@"%@%c", tmp, c] atIndexedSubscript:eqIndex];
            }        
        } else {
            [eq addObject:[NSString stringWithFormat:@"%c", c]];
            eqIndex += 2;
        }
    }
    
//    for (NSString *s in eq) {
//        NSLog(@"%@", s);
//    }
    
    return eq;
}

- (void) replace: (NSMutableArray *) eq startAt: (int) start endAt:(int) end withValue: (double) value {
    for (int i = end; i > start; i--) {
        [eq removeObjectAtIndex:i];
    }
    [eq setObject:[NSString stringWithFormat:@"%f", value] atIndexedSubscript:start];
}

- (NSString *) newEquationforLevel: (int) level {
    NSMutableArray *operations = [self getOpsForLevel:level];
    
    return [self newEquationforLevel:level andOperations:operations andType:1];
}

- (NSString *) newEquationforLevel:(int)level andOperations: (NSMutableArray *) operations andType: (int) type{
    int low = 0, high = 0;
    int ops = 1;
    if (type == 1) {
        if (level <= 10) {
            low = low + (level-1) * 2;
            high = high + (level-1) * 10;
        } else if (level <= 20) {
            ops = 2;
            low = low + (level-10) * 2;
            high = high + (level-10) * 10;
        } else if (level <= 30) {
            ops = 3;
            low = low + (level-20) * 1;
            high = high + (level-20) * 5;
        } else if (level <= 40) {
            ops = 4;
            low = low + (level-30) * 1;
            high = high + (level-30) * 5;
        } else if (level <= 50) {
            ops = 5;
            low = low + (level-40) * 1;
            high = high + (level-40) * 5;
        } else if (level > 50) {
            ops = 6;
            low = low + (level-60) * 2;
            high = high + (level-60) * 10;
            low = MIN(30, low);
            high = MAX(100, high);
        }
    } else if (type == 2) {
        low = level * 1;
        high = high + level * 5;
    }
    
    int num = (arc4random() % (high - low)) + low;
    ops = arc4random() % ops + 1;
    
    NSString *retVal = [NSString stringWithFormat:@"%i", num];
    for (int i = 0; i < ops; i++) {
        int n = arc4random() % operations.count;
        NSString *op = [operations objectAtIndex:n];
        
        if ([op isEqualToString:@"^"]) {
            num = (arc4random() % 3) + 1;
        } else {
            num = (arc4random() % (high - low)) + low;
        }
        
        retVal = [NSString stringWithFormat:@"%@%@%i", retVal, op, num];
    }
    
    return retVal;
}

- (NSMutableArray *) getOpsForLevel: (int) level {
    NSMutableArray *operations = [[NSMutableArray alloc] init];
    
    if (level >= 1)
        [operations addObject:[NSString stringWithFormat:@"+"]];
    
    if (level >= 6)
        [operations addObject:[NSString stringWithFormat:@"-"]];

    if (level >= 11)
        [operations addObject:[NSString stringWithFormat:@"*"]];
    
    if (level >= 16)
        [operations addObject:[NSString stringWithFormat:@"/"]];
    
//    if (level >= 21)
//        [operations addObject:[NSString stringWithFormat:@"^"]];
    
    return operations;
}

- (NSString *) formatEquation: (NSString *) eq {
    NSString *result = @"";
    NSMutableArray *superscripts = [[NSMutableArray alloc] initWithObjects:@"\u00B9", @"\u00B2", @"\u00B3", nil];
    
    int i = 0;
    
    while (i < eq.length) {
        char c = [eq characterAtIndex:i++];
        if (isdigit(c)) {
            result = [NSString stringWithFormat:@"%@%c", result, c];    
        } else {
            if (c == '+' || c == '-') {
                result = [NSString stringWithFormat:@"%@%c", result, c];
            } else if (c == '*') {
                result = [NSString stringWithFormat:@"%@\u00D7", result];
            } else if (c == '/') {
                result = [NSString stringWithFormat:@"%@\u00F7", result];
            } else if (c == '^') {
                int val = [[eq substringWithRange:NSMakeRange(i++, 1)] intValue];
                NSLog(@"Exponent value: %i", val);
                result = [NSString stringWithFormat:@"%@%@", result, [superscripts objectAtIndex:(val-1)]];
                NSLog(@"Added Exponent: %@", result);
            }
        }
    }
    
    return result;
}

@end
