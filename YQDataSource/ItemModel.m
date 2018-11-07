//
//  ItemModel.m
//  YQDataSource
//
//  Created by 王叶庆 on 2018/11/7.
//  Copyright © 2018 王叶庆. All rights reserved.
//

#import "ItemModel.h"

@implementation ItemModel

- (nonnull id<NSObject>)diffIdentifier {
    return @(_index);
}

- (BOOL)isEqualToDiffableObject:(nullable id<IGListDiffable>)object {
    return [self diffIdentifier] == [object diffIdentifier];
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    ItemModel *item = [[ItemModel allocWithZone:zone] init];
    item.index = self.index;
    return item;
}

@end
