//
//  NCHelper.h
//  NerdChat
//
//  Created by Jose Manuel Ramírez Martínez on 16/12/15.
//  Copyright © 2015 Jose Manuel Ramírez Martínez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCHelper : NSObject

#pragma mark - Helper methods
/**
* Nos devuelve un número aleatorio entre dos valores.
*
* @param from From value of the interval.
* @param to to Value of the interval.
*
* @return Random number.
*/
+ (NSString *)getRandomReply;

@end
