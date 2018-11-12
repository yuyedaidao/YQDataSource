//
//  TableViewController.m
//  YQDataSource
//
//  Created by 王叶庆 on 2018/11/7.
//  Copyright © 2018 王叶庆. All rights reserved.
//

#import "TableViewController.h"
#import "YQTableViewDataSource.h"
#import "ItemModel.h"

@interface TableViewController ()
@property (strong, nonatomic) YQTableViewDataSource *dataSource;
@property (strong, nonatomic) RACBehaviorSubject *dataSignal;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableArray *items = @[].mutableCopy;
     for (int i = 0; i < 9; i++) {
        ItemModel *item = [ItemModel new];
        item.index = i;
        [items addObject:item];
    }
    YQSectionModel *section = [[YQSectionModel alloc] initWithIdentifier:@"A" items:items];
    YQSectionModel *section1 = [[YQSectionModel alloc] initWithIdentifier:@"B" items:items];
    YQSectionModel *section2 = [[YQSectionModel alloc] initWithIdentifier:@"C" items:items];
    YQSectionModel *section3 = [[YQSectionModel alloc] initWithIdentifier:@"D" items:items];
    YQSectionModel *section4 = [[YQSectionModel alloc] initWithIdentifier:@"E" items:items];
    YQSectionModel *section5 = [[YQSectionModel alloc] initWithIdentifier:@"F" items:items];
    
    NSArray *sections = @[section, section1, section2, section3, section4, section5];
    self.dataSignal = [RACBehaviorSubject behaviorSubjectWithDefaultValue:sections];
    self.dataSource = [[YQTableViewDataSource alloc] initWithConfigureCell:^__kindof UITableViewCell * _Nonnull(YQTableViewDataSource * _Nonnull dataSource, UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath, ItemModel * _Nonnull item) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = [@(item.index) stringValue];
        return cell;
    }];
    self.dataSource.animated = ^BOOL(YQTableViewDataSource * _Nonnull dataSource) {
        return YES;
    };
    [self.tableView rac_dataSource:self.dataSource bindSignal: self.dataSignal];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *array = sections.mutableCopy;
//        [array removeObjectAtIndex:1];
////        [array addObject:sections.firstObject];
//        [array insertObject:sections.firstObject atIndex:2];
        
        id a = sections.firstObject;
        id b = sections[2];
        [array replaceObjectAtIndex:2 withObject:a];
        [array replaceObjectAtIndex:0 withObject:b];

        [self.dataSignal sendNext:array];
    });
}

#pragma mark - Table view data source
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
