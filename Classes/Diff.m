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
//            initialSectionsAssociatedData[initialSectionIndex] = finalSectionsAssociatedData[idx] = (ini)
            NSLog(@"I moveIndex: %ld F moveIndex: %ld", idx, initialSectionIndex);
        }
    }];
    
    // get deleted sections
    NSInteger sectionIndexAfterDelete = 0;
    for (NSInteger i = 0; i < initialSections.count; i++) {
        initialSectionsAssociatedData[i].itemCount = initialSections[i].items.count;
        if (initialSectionsAssociatedData[i].moveIndex == NSNotFound) {//上一步没有修改moveIndex,说明已经不在新数组中了 **剩下的要么是move,要么是holding
            initialSectionsAssociatedData[i].action = YQItemActionDelete;
            NSLog(@"I (%ld) action: %ld", i, YQItemActionDelete);
            continue;
        }
        initialSectionsAssociatedData[i].indexAfterDelete = sectionIndexAfterDelete ++;
        NSLog(@"I (%ld) indexAfterDelete: %ld", i, sectionIndexAfterDelete - 1);
    }
    
    // get moved sections and inserted sections
    NSInteger noActionIndex = 0;
    NSInteger (^findNextNoActionIndex)(NSInteger index) =  ^(NSInteger index) {
        if (index != NSNotFound) {
            NSInteger i = index;
            while (i < initialSections.count) {
                if (finalSectionsAssociatedData[i].moveIndex == NSNotFound && initialSectionsAssociatedData[i].action == YQItemActionNone) {
                    return i;
                }
                i ++;
            }
        }
        return NSNotFound;
    };
    for (NSInteger i = 0; i < finalSections.count; i++) {
        noActionIndex = findNextNoActionIndex(noActionIndex);
        NSInteger oldSectionIndex = finalSectionsAssociatedData[i].moveIndex;
        if (oldSectionIndex == NSNotFound) {//说明旧数组中没有
            if (finalSectionsAssociatedData[i].action == YQItemActionNone) {
                NSLog(@"F (%ld) action: %ld", i, YQItemActionInsert);
                finalSectionsAssociatedData[i].action =  YQItemActionInsert;
            }
        } else {//说明旧数组中有，必定是move或原地不动
            YQItemAction action = (oldSectionIndex == noActionIndex ? YQItemActionHolding : YQItemActionMove);
            initialSectionsAssociatedData[oldSectionIndex].action = finalSectionsAssociatedData[i].action = action;
            NSLog(@"I (%ld) and F (%ld) action: %ld", oldSectionIndex, i, action);
        }
    }
    
    *initialYQAssociatedDataArray = initialSectionsAssociatedData;
    *finalYQAssociatedDataArray = finalSectionsAssociatedData;
}


@end
