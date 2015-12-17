//
//  NCUsersTVC.h
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NCUsersTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end
