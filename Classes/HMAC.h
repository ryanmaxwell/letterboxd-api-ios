//
//  HMAC.h
//  Pods
//
//  Created by Ryan Maxwell on 29/06/17.
//
//

#import <Foundation/Foundation.h>

@interface HMAC : NSObject

typedef NS_ENUM(NSInteger, HMACAlgorithm) {
    HMACAlgorithmSHA1,
    HMACAlgorithmMD5,
    HMACAlgorithmSHA256,
    HMACAlgorithmSHA384,
    HMACAlgorithmSHA512,
    HMACAlgorithmSHA224
};

+ (nonnull NSString *)signData:(nonnull NSData *)data withKey:(nonnull NSString *)key usingAlgorithm:(HMACAlgorithm)algorithm;

@end
