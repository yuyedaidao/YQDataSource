//
//  RACTableViewDataSource.m
//  RACDataSource
//
//  Created by WYQ on 2018/10/31.
//

#import "YQTableViewDataSource.h"
#import <objc/runtime.h>
#import <IGListKit/IGListDiff.h>

@interface YQTableViewDataSource ()
@property (weak, nonatomic) UITableView *tableView;
@end

@implementation YQTableViewDataSource

- (instancetype)initWithConfigureCell:(__kindof UITableViewCell * _Nonnull (^)(YQTableViewDataSource * _Nonnull, UITableView * _Nonnull, NSIndexPath * _Nonnull, id _Nonnull))configureCell {
    if (self = [super init]) {
        _configureCell = configureCell;
        [self commonInit];
    }
    return self;
}

- (instancetype)init {
    return [self initWithConfigureCell:nil];
}

- (void)commonInit {
   //nothing
}

#pragma mark set && get

- (void)setDataArray:(NSArray<YQSectionModel *> *)dataArray {
    BOOL animated = NO;
    if (_animated) {
        animated = self.animated(self);
    }
    if (animated) {
        
        if (self.tableView.window == nil) {
            _dataArray = dataArray;
            [self.tableView reloadData];
        } else {
            NSArray<YQSectionModel *> *oldArray = _dataArray;
            IGListIndexSetResult *sectionsResult = IGListDiff(oldArray, dataArray, IGListDiffEquality).resultForBatchUpdates;
            NSMutableArray *rowInserts = @[].mutableCopy;
            NSMutableArray *rowDeletes = @[].mutableCopy;
            NSMutableArray *rowUploads = @[].mutableCopy;
            NSMutableArray<IGListMoveIndexPath *> *rowMoves = @[].mutableCopy;
            [dataArray enumerateObjectsUsingBlock:^(YQSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger oldIndex = [sectionsResult oldIndexForIdentifier:obj.diffIdentifier];
                if (oldIndex != NSNotFound) {//移动或更新
                    YQSectionModel *oldSection = oldArray[oldIndex];
                    IGListIndexPathResult* result = IGListDiffPaths(idx, idx, oldSection.items, obj.items, IGListDiffEquality);
                    [rowInserts addObjectsFromArray:result.inserts];
                    [rowDeletes addObjectsFromArray:result.deletes];
                    [rowUploads addObjectsFromArray:result.updates];
                    [rowMoves addObjectsFromArray:result.moves];
                }
            }];

            //REMARK:先计算section变化，执行动画，然后计算剩下的section里的items,再执行动画
            void (^update)(void) = ^{
                if (sectionsResult.deletes.count) {
                    [self.tableView deleteSections:sectionsResult.deletes withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                if (sectionsResult.updates.count) {
                    [self.tableView reloadSections:sectionsResult.updates withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                }
                if (sectionsResult.inserts.count) {
                    [self.tableView insertSections:sectionsResult.inserts withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                if (sectionsResult.moves.count) {
                    [sectionsResult.moves enumerateObjectsUsingBlock:^(IGListMoveIndex * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.tableView moveSection:obj.from toSection:obj.to];
                    }];
                }
               
                if (rowDeletes.count) {
                    [self.tableView deleteRowsAtIndexPaths:rowDeletes withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                if (rowUploads.count) {
                    [self.tableView reloadRowsAtIndexPaths:rowUploads withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                if (rowInserts.count) {
                    [self.tableView insertRowsAtIndexPaths:rowInserts withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                [rowMoves enumerateObjectsUsingBlock:^(IGListMoveIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.tableView moveRowAtIndexPath:obj.from toIndexPath:obj.to];
                }];

            };
            if (@available(iOS 11.0, *)) {
                [self.tableView performBatchUpdates:^{
                    _dataArray = dataArray;
                    update();
                } completion:^(BOOL finished) {
                }];

            } else {
                // Fallback on earlier versions
                [self.tableView beginUpdates];
                update();
                [self.tableView endUpdates];
            }
        }
    } else {
        if (_dataArray != dataArray) {
            _dataArray = dataArray;
            [self.tableView reloadData];
        }
    }
}

#pragma mark dataSource

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSAssert(self.configureCell, @"configureCell不能为空");
    return self.configureCell(self, tableView, indexPath, self.dataArray[indexPath.section].items[indexPath.row]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray[section].items.count;
}

/*
 
 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented
 
 - (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
 - (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;
 
 // Editing
 
 // Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;
 
 // Moving/reordering
 
 // Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;
 
 // Index
 
 - (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView;                               // return list of section titles to display in section index view (e.g. "ABCD...Z#")
 - (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index;  // tell table which section corresponds to section title/index (e.g. "B",1))
 
 // Data manipulation - insert and delete support
 
 // After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
 // Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
 
 // Data manipulation - reorder / moving support
 
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
 

 */


#pragma mark 下标取值
- (YQSectionModel *)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.dataArray[idx];
}

- (id)objectForKeyedSubscript:(NSIndexPath *)key {
    return self.dataArray[key.section].items[key.row];
}

#pragma mark set & get

@end

@implementation UITableView (RACTableViewDataSource)

- (void)rac_dataSource:(YQTableViewDataSource *)dataSource bindSignal:(RACSignal *)signal {
    NSParameterAssert(dataSource);
    NSParameterAssert(signal);
    objc_setAssociatedObject(self, _cmd, dataSource, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    self.dataSource = dataSource;
    dataSource.tableView = self;
    [signal subscribeNext:^(id x) {
        dataSource.dataArray = x;
    } completed:^{
        NSLog(@"订阅结束");
        objc_setAssociatedObject(self, _cmd, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }];
}

@end
