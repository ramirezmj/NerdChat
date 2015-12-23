//
//  NCFriends.m
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import "NCFriends.h"

@implementation NCFriends

- (NSArray *)friends
{
    NCUser *user1 = [[NCUser alloc] init];
    user1.name    = @"Clare Smith";
    user1.phone   = @"+36 904 713 586";
    user1.avatar  = [UIImage imageNamed:@"girl1"];
    
    NCUser *user2 = [[NCUser alloc] init];
    user2.name    = @"Marta Garcia";
    user2.phone   = @"+30 159 205 955";
    user2.avatar  = [UIImage imageNamed:@"girl2"];
    
    NCUser *user3 = [[NCUser alloc] init];
    user3.name    = @"Sofia Hernandez";
    user3.phone   = @"+37 902 700 506";
    user3.avatar  = [UIImage imageNamed:@"girl3"];
    
    NCUser *user4 = [[NCUser alloc] init];
    user4.name    = @"Somai Berg";
    user4.phone   = @"+34 122 345 863";
    user4.avatar  = [UIImage imageNamed:@"girl4"];
    
    NCUser *user5 = [[NCUser alloc] init];
    user5.name    = @"Marina Grey";
    user5.phone   = @"+36 675 681 048";
    user5.avatar  = [UIImage imageNamed:@"girl5"];
    
    NCUser *user6 = [[NCUser alloc] init];
    user6.name    = @"Mark Pleiton";
    user6.phone   = @"+38 893 414 180";
    user6.avatar  = [UIImage imageNamed:@"guy1"];
    
    NCUser *user7 = [[NCUser alloc] init];
    user7.name    = @"Lucas Aguilar";
    user7.phone   = @"+34 101 014 804";
    user7.avatar  = [UIImage imageNamed:@"guy2"];
    
    NCUser *user8 = [[NCUser alloc] init];
    user8.name    = @"Daniel Alonso";
    user8.phone   = @"+35 403 719 774";
    user8.avatar  = [UIImage imageNamed:@"guy3"];
    
    
    NSArray *friends = @[user1, user2, user3, user4, user5, user6, user7, user8];

    return friends;
}

@end
