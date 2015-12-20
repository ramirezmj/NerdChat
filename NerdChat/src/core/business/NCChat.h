//
//  NCChat.h
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 18/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ChatData_Message = 0,
    ChatData_Image,
    ChatData_None
}ChatDataType;

@interface NCChat : NSObject

@property (nonatomic, copy) NSString *message;
@property (strong, nonatomic) NSDate *time;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic, assign) BOOL isMine;
@property (nonatomic, assign) ChatDataType chatDataType;

@end
