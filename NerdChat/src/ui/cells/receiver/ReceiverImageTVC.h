//
//  ReceiverImageTVC.h
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 17/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverImageTVC : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIView *seenView;

@end
