//
//  Diff.m
//  RACDataSource
//
//  Created by WYQ on 2018/11/1.
//

#import "Diff.h"


static YQAssociatedData YQAssociatedDataDefault = {YQItemActionNone, 0, NSNotFound, 0};

@implementation Change

@end


@implementation Diff

+ (NSArray<Change *> *)differencesForDataArrays:(NSArray<YQSectionModel *> *)initialArray finalArray:(NSArray<YQSectionModel *> *)finalArray {
    YQAssociatedData *initialSectionsAssociatedData = NULL;
    YQAssociatedData *finalSectionsAssociatedData = NULL;
    [self calculateSectionMovementsWithInitialArray:initialArray finalArray:finalArray initialYQAssociatedDataArray:&initialSectionsAssociatedData finalYQAssociatedDataArray:&finalSectionsAssociatedData];
    
    free(initialSectionsAssociatedData);
    free(finalSectionsAssociatedData);
    return nil;
}

+ (NSDictionary<NSString *, NSNumber *> *)sectionIndexes:(NSArray<YQSectionModel *> *)sections {
    NSMutableDictionary<NSString *, NSNumber *> *initialIndexes = @{}.mutableCopy;
    [sections enumerateObjectsUsingBlock:^(YQSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        initialIndexes[obj.identifier] = @(idx);
    }];
    return initialIndexes;
}

+ (void)calculateSectionMovementsWithInitialArray:(NSArray<YQSectionModel *> *)initialSections finalArray:(NSArray<YQSectionModel *> *)finalSections initialYQAssociatedDataArray:(YQAssociatedData **)initialYQAssociatedDataArray finalYQAssociatedDataArray:(YQAssociatedData **)finalYQAssociatedDataArray {
    NSDictionary<NSString *, NSNumber *> *initialIndexes = [self sectionIndexes:initialSections];
    YQAssociatedData *initialSectionsAssociatedData = MEMSET_ASSOCIATEDDATA(YQAssociatedDataDefault, initialSections.count);
    YQAssociatedData *finalSectionsAssociatedData = MEMSET_ASSOCIATEDDATA(YQAssociatedDataDefault, finalSections.count);
    [finalSections enumerateObjectsUsingBlock:^(YQSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        finalSectionsAssociatedData[idx].itemCount = finalSections[idx].items.count;
        NSNumber *index = initialIndexes[obj.identifier];
        if (index) {
            NSInteger initialSectionIndex = [index integerValue];
            initialSectionsAssociatedData[initialSectionIndex].moveIndex = idx;
            finalSectionsAssociatedData[idx].moveIndex = initialSectionIndex;
            YQItemAction action = (initialSectionIndex == idx ? YQItemActionHolding : YQItemActionMove);
            initialSectionsAssociatedData[initialSectionIndex].action = finalSectionsAssociatedData[idx].action = action;
        } else {
            finalSectionsAssociatedData[idx].action = YQItemActionInsert;
        }
    }];
    
    // get deleted sections
    NSInteger sectionIndexAfterDelete = 0;
    for (NSInteger i = 0; i < initialSections.count; i++) {
        initialSectionsAssociatedData[i].itemCount = initialSections[i].items.count;
        if (initialSectionsAssociatedData[i].action == YQItemActionNone) {
            initialSectionsAssociatedData[i].action = YQItemActionDelete;
            continue;
        }
        initialSectionsAssociatedData[i].indexAfterDelete = sectionIndexAfterDelete ++;
    }
    
    *initialYQAssociatedDataArray = initialSectionsAssociatedData;
    *finalYQAssociatedDataArray = finalSectionsAssociatedData;
}


@end
