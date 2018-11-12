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
   
}

#pragma mark set && get

- (void)setDataArray:(NSArray<YQSectionModel *> *)dataArray {
    BOOL animated = NO;
    if (_animated) {
        animated = self.animated(self);
    }
    if (animated) {
        NSArray<YQSectionModel *> *oldArray = _dataArray;
        IGListIndexPathResult *result = IGListDiffPaths(0, 0, oldArray, dataArray, IGListDiffEquality).resultForBatchUpdates;
        NSLog(@"result : %@",result);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _dataArray = dataArray;

            if (self.tableView.window == nil) {
                [self.tableView reloadData];
            } else {
                //REMARK:先计算section变化，执行动画，然后计算剩下的section里的items,再执行动画
                if (@available(iOS 11.0, *)) {
                    [self.tableView performBatchUpdates:^{
                        if (result.inserts.count) {
                            NSMutableIndexSet *set = [NSMutableIndexSet  indexSet];
                            [result.inserts enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [set addIndex:obj.row];
                            }];
                            [self.tableView insertSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                        }
                        if (result.deletes.count) {
                            NSMutableIndexSet *set = [NSMutableIndexSet  indexSet];
                            [result.deletes enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [set addIndex:obj.row];
                            }];

                            [self.tableView deleteSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        }
                        
                        if (result.updates.count) {
                            NSMutableIndexSet *set = [NSMutableIndexSet  indexSet];
                            [result.updates enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [set addIndex:obj.row];
                            }];

                            [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
                            
                        }
                        
                        if (result.moves.count) {
                            [result.moves enumerateObjectsUsingBlock:^(IGListMoveIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                [self.tableView moveSection:obj.from.row toSection:obj.to.row];
                            }];
                        }
                        
                    } completion:^(BOOL finished) {
                        
                    }];


                } else {
                    // Fallback on earlier versions
                    [self.tableView beginUpdates];
                    
                    [self.tableView endUpdates];
                }
                
//                [self.tableView reloadData];
            }
        });

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
