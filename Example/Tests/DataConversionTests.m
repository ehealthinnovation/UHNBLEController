//
//  DataConversionTests.m
//  UHNBLEController
//
//  Created by Nathaniel Hamming on 2015-02-12.
//  Copyright (c) 2015 University Health Network.
//

#import <UHNBLEController/NSData+ConversionExtensions.h>

SpecBegin(DataConversionSpecs)

describe(@"Converting from data to native types", ^{

    it(@"should convert data to NSUInteger", ^{
        uint8_t bit8 = 7;
        uint16_t bit16 = 1023;
        uint32_t bit32 = 99999999;

        NSUInteger NSUIbit8 = 7;
        NSUInteger NSUIbit16 = 1023;
        NSUInteger NSUIbit32 = 99999999;
        
        NSData *data = [NSData dataWithBytes:(char[]){0xFF, 0xFF, 0xFF, bit8, 0xFF, 0xFF, bit16, bit16 >> 8, 0xFF, 0xFF, bit32, bit32 >> 8, bit32 >> 16, bit32 >> 24} length:14];
        
        expect(NSUIbit8).to.equal([data unsignedIntegerAtRange: (NSRange){3,1}]);
        expect(NSUIbit16).to.equal([data unsignedIntegerAtRange: (NSRange){6,2}]);
        expect(NSUIbit32).to.equal([data unsignedIntegerAtRange: (NSRange){10,4}]);
    });
    
    it(@"should convert data to NSInteger", ^{
        int8_t bit8 = -7;
        int16_t bit16 = -1023;
        int32_t bit32 = -99999999;
        
        NSInteger NSIbit8 = -7;
        NSInteger NSIbit16 = -1023;
        NSInteger NSIbit32 = -99999999;
        
        NSData *data = [NSData dataWithBytes:(char[]){0xFF, 0xFF, 0xFF, bit8, 0xFF, 0xFF, bit16, bit16 >> 8, 0xFF, 0xFF, bit32, bit32 >> 8, bit32 >> 16, bit32 >> 24} length:14];
        
        expect(NSIbit8).to.equal([data integerAtRange: (NSRange){3,1}]);
        expect(NSIbit16).to.equal([data integerAtRange: (NSRange){6,2}]);
        expect(NSIbit32).to.equal([data integerAtRange: (NSRange){10,4}]);
    });
    
    it(@"should convert data to NSString", ^{
        NSString *string = @"Hello world";
        const char *charString = [string cStringUsingEncoding: NSUTF8StringEncoding];
    
        NSMutableData *data = [NSMutableData dataWithBytes:(char[]){0xFF, 0xFF} length:2];
        [data appendData:[NSData dataWithBytes: charString length: 11]];
        [data appendData:[NSMutableData dataWithBytes:(char[]){0xFF, 0xFF} length:2]];
    
        expect(string).to.equal([data stringAtRange: (NSRange){2,11}]);
    });
    
    it(@"should convert data to NSDate", ^{
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [dateFormatter setDateFormat:dateFormat];
        
        NSString *nowAsString = [dateFormatter stringFromDate: now];
        const char *charString = [nowAsString cStringUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableData *data = [NSMutableData dataWithBytes:(char[]){0xFF, 0xFF} length:2];
        [data appendData:[NSData dataWithBytes: charString length: 19]];
        [data appendData:[NSMutableData dataWithBytes:(char[]){0xFF, 0xFF} length:2]];
        
        NSDate *testDate = [data parseDateFromStringWithFormat:dateFormat andRange: (NSRange){2,19}];
        expect([now isEqualToDate:testDate]).to.beTruthy;
    });
    
    it(@"should convert data (timestamp) to NSDate", ^{
        NSDate *now = [NSDate date];
        uint32_t secToNow = [now timeIntervalSinceReferenceDate]/1;
        
        NSMutableData *data = [NSMutableData dataWithBytes:(char[]){0xFF, 0xFF} length:2];
        [data appendData:[NSData dataWithBytes: &secToNow length: sizeof(uint32_t)]];
        [data appendData:[NSMutableData dataWithBytes:(char[]){0xFF, 0xFF} length:2]];
        
        NSDate *testDate = [data parseDateWithSecondsSinceReferenceDateWithRange: (NSRange){2,4}];
        expect([now isEqualToDate:testDate]).to.beTruthy;
    });
    
    it(@"should convert data (short float) to float", ^{
        uint16_t mantissa = 716;
        int8_t exponent = -2;
        uint16_t shortFloat = (exponent << 12) + mantissa;
        float numberAsFloat = 7.16;

        NSData *data = [NSData dataWithBytes:(char[]){0xFF, 0xFF, 0xFF, shortFloat, shortFloat >> 8, 0xFF} length:6];
        expect(numberAsFloat).to.equal([data shortFloatAtRange:(NSRange){3,2}]);
    });
});

SpecEnd
