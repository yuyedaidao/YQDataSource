//
//  Diff.h
//  RACDataSource
//
//  Created by WYQ on 2018/11/1.
//

#import <Foundation/Foundation.h>
#import "YQSectionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, YQItemAction) {
    YQItemActionNone,
    YQItemActionDelete,
    YQItemActionInsert,
    YQItemActionMove,
    YQItemActionUpdate,
    YQItemActionHolding
};

typedef struct {
    YQItemAction action;
    NSInteger indexAfterDelete;
    NSInteger moveIndex;
    NSInteger itemCount;
} YQAssociatedData;


static inline YQAssociatedData * MEMSET_ASSOCIATEDDATA(YQAssociatedData initialData, NSInteger count) {
    YQAssociatedData *array = malloc(count * sizeof(YQAssociatedData));
    for (NSInteger i = 0; i < count; i++) {
        memcpy(&(array[i]), &initialData, sizeof(YQAssociatedData));
    }
    return array;
}

@interface Change : NSObject

@end

@interface Diff : NSObject
+ (NSArray<Change *> *)differencesForDataArrays:(NSArray<YQSectionModel *> *)initialArray finalArray:(NSArray<YQSectionModel *> *)finalArray;

@end

NS_ASSUME_NONNULL_END
