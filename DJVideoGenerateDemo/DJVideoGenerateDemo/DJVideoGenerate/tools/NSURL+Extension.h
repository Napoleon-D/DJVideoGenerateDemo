//
//  NSURL+Extension.h
//  DJVideoGenerateDemo
//
//  Created by Tommy on 2019/3/12.
//  Copyright © 2019年 Tommy. All rights reserved.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (Extension)

+(NSURL *)safeUrlForString:(NSString *)urlStr;

@end

NS_ASSUME_NONNULL_END
