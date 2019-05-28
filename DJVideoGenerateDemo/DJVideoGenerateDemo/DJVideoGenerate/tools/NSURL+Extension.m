//
//  NSURL+Extension.m
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//

#import "NSURL+Extension.h"
#import "NSString+Tool.h"

@implementation NSURL (Extension)

+(NSURL *)safeUrlForString:(NSString *)urlStr{
    if ([NSString isBlankString:urlStr]) {
        return [NSURL URLWithString:@""];
    }else{
        return [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
