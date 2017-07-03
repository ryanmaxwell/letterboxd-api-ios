//
//  HMAC.m
//  Pods
//
//  Created by Ryan Maxwell on 29/06/17.
//
//

#import "HMAC.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation HMAC

+ (NSString *)signData:(NSData *)data withKey:(NSString *)key usingAlgorithm:(HMACAlgorithm)algorithm {
    const char *hKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const void *hData = data.bytes;
    unsigned char cHMAC[[HMAC digestLengthForAlgorithm:algorithm]];
    
    CCHmacAlgorithm ccAlgorithm = [HMAC CCHmacAlgorithmForAlgorithm: algorithm];
    CCHmac(ccAlgorithm, hKey, strlen(hKey), hData, data.length, cHMAC);
    NSData *resultData = [[NSData alloc] initWithBytes:cHMAC
                                                length:sizeof(cHMAC)];
    char *utf8;
    utf8 = (char *)[resultData bytes];
    NSMutableString *hex = [NSMutableString string];
    for (int i = 0; i < resultData.length; i++) {
        [hex appendFormat:@"%02X" , *(utf8 + i) & 0x00FF];
    }
    return [hex copy];
}

+ (CCHmacAlgorithm)CCHmacAlgorithmForAlgorithm:(HMACAlgorithm)algorithm {
    switch (algorithm) {
        case HMACAlgorithmMD5:
            return kCCHmacAlgMD5;
        case HMACAlgorithmSHA1:
            return kCCHmacAlgSHA1;
        case HMACAlgorithmSHA224:
            return kCCHmacAlgSHA224;
        case HMACAlgorithmSHA256:
            return kCCHmacAlgSHA256;
        case HMACAlgorithmSHA384:
            return kCCHmacAlgSHA384;
        case HMACAlgorithmSHA512:
            return kCCHmacAlgSHA512;
    }
}

+ (int)digestLengthForAlgorithm:(HMACAlgorithm)algorithm {
    switch (algorithm) {
        case HMACAlgorithmMD5:
            return CC_MD5_DIGEST_LENGTH;
        case HMACAlgorithmSHA1:
            return CC_SHA1_DIGEST_LENGTH;
        case HMACAlgorithmSHA224:
            return CC_SHA224_DIGEST_LENGTH;
        case HMACAlgorithmSHA256:
            return CC_SHA256_DIGEST_LENGTH;
        case HMACAlgorithmSHA384:
            return CC_SHA384_DIGEST_LENGTH;
        case HMACAlgorithmSHA512:
            return CC_SHA512_DIGEST_LENGTH;
    }
}

@end
