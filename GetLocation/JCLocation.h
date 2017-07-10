//
//  JCLocation.h
//  AbellStar_Light
//
//  Created by apple on 2017/7/7.
//  Copyright © 2017年 xjc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface JCLocation : NSObject
{
    void(^SaveUserLocMsg)(NSString *lonAndLatStr , NSString *address , NSString *distance);
}

+(void) getUserLocationMsg:(void(^)(NSString *lonAndLatStr ,NSString *address ,NSString *distance))block;

+(void) stopGetUserLoc;

@end
