//
//  ChatRoomVC.h
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatRoomVC : UIViewController <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) UIImage *avatar;

@end
