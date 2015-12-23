//
//  NCHelper.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "NCHelper.h"
#import "NCReplies.h"

@implementation NCHelper

+ (NSString *)getRandomReply
{
    NCReplies *repliesFactory = [[NCReplies alloc] init];
    NSArray *replies = [repliesFactory replies];
    
    int dice = arc4random() % [replies count];
    
    return replies[dice];
}

@end
