//
//  NCUsersTVC.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "NCUsersTVC.h"

@implementation NCUsersTVC

- (void)awakeFromNib {
    _avatar.layer.cornerRadius = _avatar.frame.size.width / 2;
    _avatar.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
