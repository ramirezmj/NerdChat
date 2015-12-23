//
//  ReceiverImageTVC.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 17/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "ReceiverImageTVC.h"

@implementation ReceiverImageTVC

- (void)awakeFromNib {
    _seenView.layer.cornerRadius  = 5;
    _seenView.layer.masksToBounds = YES;
    
    _photoIV.layer.cornerRadius  = 5;
    _photoIV.layer.masksToBounds = YES;
}

@end
