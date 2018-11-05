//
//  RACSectionModel.h
//  RACDataSource
//
//  Created by WYQ on 2018/10/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YQSectionModel<ItemType: NSObject *> : NSObject
- (instancetype)initWithIdentifier:(NSString *)identifier items:(nullable NSArray<ItemType> *)items;
@property (copy, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSArray<ItemType> *items;
@end

NS_ASSUME_NONNULL_END
