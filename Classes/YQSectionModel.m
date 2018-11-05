//
//  RACSectionModel.m
//  RACDataSource
//
//  Created by WYQ on 2018/10/31.
//

#import "YQSectionModel.h"

@implementation YQSectionModel
- (instancetype)init {
    return [self initWithIdentifier:[NSUUID UUID].UUIDString items:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier items:(NSArray *)items {
    if (self = [super init]) {
        _identifier = identifier;
        _items = items;
    }
    return self;
}

- (NSUInteger)hash {
    return [_identifier hash] ^ [_items hash];
}

- (BOOL)isEqual:(YQSectionModel *)object {
    if (![_identifier isEqualToString:object.identifier]) return NO;
    if (self.items.count != object.items.count) return NO;
    for (int i = 0; i < self.items.count; i++) {
        if (![self.items[i] isEqual:object.items[i]]) {
            return NO;
        }
    }
    return YES;
}
@end
