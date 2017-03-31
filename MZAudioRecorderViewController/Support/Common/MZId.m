//
//  MZId.m
//  TotalWorkout
//
//  Created by Mészáros Zoltán on 30/08/16.
//  Copyright © 2016 XL Solutions. All rights reserved.
//

#import "MZId.h"

typedef NSInteger NumberType;
static const NSUInteger sizeOfUuid = 16;
static const NSUInteger sizeOfType = sizeof(NumberType);

@interface MZID() {
    uuid_t mUUID;
    NSUInteger mBytesUsed;
}
+ (void)packNumber:(NSNumber*)number toBytes:(uuid_t)bytes;
+ (NSNumber*)unpackNumberFromBytes:(const uuid_t)bytes;

/* private can be called from init, because it cannot be overridden by subclass */
- (void)setStringPrivate:(NSString *)string;
- (void)setNumberPrivate:(NSNumber *)number;
@end

@implementation MZID

+ (void)packNumber:(NSNumber*)number toBytes:(uuid_t)bytes {
    if (number) {
        NumberType tmp = number.integerValue;
        
        NSData *data = [NSData dataWithBytes:&tmp length:sizeOfType];
        const char *raw = data.bytes;
        
        for (NSUInteger i = 0; i < sizeOfUuid; ++i)
            bytes[i] = i < sizeOfType ? raw[i] : 0;
    }
}

+ (NSNumber*)unpackNumberFromBytes:(const uuid_t)bytes {
    NumberType tmp;
    
    NSData *data = [NSData dataWithBytes:bytes length:sizeOfUuid];
    [data getBytes:&tmp length:sizeOfType];
    
    return [NSNumber numberWithInteger:tmp];
}

+ (instancetype)ID {
    return [[self alloc] init];
}

+ (instancetype)IDWithNumber:(NSNumber*)number {
    return [[self alloc] initWithNumber:number];
}

+ (instancetype)IDWithString:(NSString*)string {
    return [[self alloc] initWithString:string];
}

+ (instancetype)IDWithBytes:(const uuid_t)bytes {
    return [[self alloc] initWithBytes:bytes];
}

- (instancetype)init {
    return [self initWithString:[NSUUID UUID].UUIDString];
}

- (instancetype)initWithString:(NSString*)string {
    self = string && [string isKindOfClass:NSString.class] ?
        [super init] :
        nil;
    if (self)
        [self setStringPrivate:string];
    return self;
}

- (instancetype)initWithNumber:(NSNumber*)number {
    self = number && [number isKindOfClass:NSNumber.class] ?
        [super init] :
        nil;
    if (self)
        [self setNumberPrivate:number];
    return self;
}

- (instancetype)initWithBytes:(const uuid_t)bytes {
    return [self initWithNumber:[self.class unpackNumberFromBytes:bytes]];
}

- (void)setNumber:(NSNumber*)number {
    [self setNumberPrivate:number];
}

- (void)setNumberPrivate:(NSNumber *)number {
    _number = number;
    [self.class packNumber:_number toBytes:mUUID];
    mBytesUsed = sizeOfType;
}

- (void)setString:(NSString*)string {
    [self setStringPrivate:string];
}

- (void)setStringPrivate:(NSString *)string {
    [[[NSUUID alloc] initWithUUIDString:string] getUUIDBytes:mUUID];
    _number = [self.class unpackNumberFromBytes:mUUID];
    mBytesUsed = sizeOfUuid;
}

- (NSString*)string {
    return [[NSUUID alloc] initWithUUIDBytes:mUUID].UUIDString;
}

- (unsigned char*)UUID {
    return mUUID;
}

- (BOOL)hasUUID {
    return mBytesUsed == sizeOfUuid;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithString:self.string];
}

#pragma mark - comparision
- (BOOL)isCompatibleWithID:(MZID*)ID {
    return ID && self.hasUUID == ID.hasUUID;
}

- (BOOL)isEqual:(id)object {
    return self == object
        || (    object && [object isMemberOfClass:self.class]
            && [self isEqualToID:(MZID *)object]);
}

- (BOOL)isEqualToID:(MZID*)ID {
    BOOL out = ID != nil;
    for (NSUInteger i = 0; out && i < mBytesUsed; ++i)
        out &= mUUID[i] == ID.UUID[i];
    return out;
}

- (NSComparisonResult)compare:(MZID*)object {
    NSComparisonResult out = NSOrderedSame;
    if (object && [object isMemberOfClass:self.class]) {
        /* NUMBER -> not really needed, just included for better debugging */
        if (mBytesUsed == sizeOfType)
            out = [_number compare:object.number];
        /* BYTE-BY-BYTE */
        else {
            for (NSUInteger i = 0; out == NSOrderedSame && i < mBytesUsed; ++i) {
                /**/ if (mUUID[i] < object.UUID[i])
                    out = NSOrderedAscending;
                else if (mUUID[i] > object.UUID[i])
                    out = NSOrderedDescending;
            }
        }
    }
    return out;
}

@end
