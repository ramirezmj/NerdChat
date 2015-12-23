//
//  NCDefaultMessages.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 18/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "NCDefaultMessages.h"
#import "NCChat.h"

@implementation NCDefaultMessages

- (NSArray *)defaultMessages
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    comps.hour = 17;
    comps.minute = 15;
    comps.day = 18;
    NSDate *yesterday = [calendar dateFromComponents:comps];
    
    
    NCChat *message1        = [[NCChat alloc] init];
    message1.message        = @"Hi!";
    message1.time           = yesterday;
    message1.isMine         = YES;
    message1.chatDataType   = ChatData_Message;
    
    NCChat *message2        = [[NCChat alloc] init];
    message2.message        = @"Hi..!";
    message2.time           = yesterday;
    message2.isMine         = NO;
    message2.chatDataType   = ChatData_Message;
    
    NCChat *message3        = [[NCChat alloc] init];
    message3.message        = @"How you doing?";
    message3.time           = [NSDate date];
    message3.isMine         = YES;
    message3.chatDataType   = ChatData_Message;
    
    NCChat *message35       = [[NCChat alloc] init];
    message35.image         = [UIImage imageNamed:@"company"];
    message35.time          = yesterday;
    message35.isMine        = YES;
    message35.chatDataType  = ChatData_Image;
    
    NCChat *message4        = [[NCChat alloc] init];
    message4.message        = @"Fine... And you?";
    message4.time           = [NSDate date];
    message4.isMine         = NO;
    message4.chatDataType   = ChatData_Message;
    
    NCChat *message5        = [[NCChat alloc] init];
    message5.message        = @"I don't know...";
    message5.time           = [NSDate date];
    message5.isMine         = YES;
    message5.chatDataType   = ChatData_Message;
    
    NCChat *message6        = [[NCChat alloc] init];
    message6.message        = @"What..?";
    message6.time           = [NSDate date];
    message6.isMine         = NO;
    message6.chatDataType   = ChatData_Message;
    
    NCChat *message65       = [[NCChat alloc] init];
    message65.image         = [UIImage imageNamed:@"company"];
    message65.time          = yesterday;
    message65.isMine        = NO;
    message65.chatDataType  = ChatData_Image;
    
    NCChat *message7        = [[NCChat alloc] init];
    message7.message        = @"It's just... I...";
    message7.time           = [NSDate date];
    message7.isMine         = YES;
    message7.chatDataType   = ChatData_Message;
    
    NCChat *message8        = [[NCChat alloc] init];
    message8.message        = @"Yes?";
    message8.time           = [NSDate date];
    message8.isMine         = NO;
    message8.chatDataType   = ChatData_Message;
    
    
    NSArray *array = @[message1, message35, message2, message65, message3,
                       message4, message5, message6, message7, message8];
    
    return array;
}

@end
