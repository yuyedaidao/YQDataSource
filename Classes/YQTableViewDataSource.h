//
//  RACTableViewDataSource.h
//  RACDataSource
//
//  Created by WYQ on 2018/10/31.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "YQSectionModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface YQTableViewDataSource : NSObject<UITableViewDataSource>
- (instancetype)initWithConfigureCell:(nullable  __kindof UITableViewCell *(^)(YQTableViewDataSource *dataSource, UITableView *tableView, NSIndexPath *indexPath, id item))configureCell NS_DESIGNATED_INITIALIZER;
@property (copy, nonatomic) __kindof UITableViewCell * (^configureCell)(YQTableViewDataSource *dataSource, UITableView *tableView, NSIndexPath *indexPath, id item);

/**
 是否以动画形式更新
 */
@property (copy, nonatomic) BOOL (^animated)(YQTableViewDataSource *dataSource);

@end

@interface UITableView (YQTableViewDataSource)
- (void)rac_dataSource:(YQTableViewDataSource *)dataSource bindSignal:(RACSignal *)signal;
@end

NS_ASSUME_NONNULL_END
