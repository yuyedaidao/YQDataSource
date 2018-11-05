//
//  YQDataSourceTests.m
//  YQDataSourceTests
//
//  Created by 王叶庆 on 2018/11/5.
//  Copyright © 2018 王叶庆. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Diff.h"

@interface Diff (test)

+ (NSDictionary<NSString *, NSNumber *> *)sectionIndexes:(NSArray<YQSectionModel *> *)sections;
+ (void)calculateSectionMovementsWithInitialArray:(NSArray<YQSectionModel *> *)initialSections finalArray:(NSArray<YQSectionModel *> *)finalSections initialYQAssociatedDataArray:(YQAssociatedData **)initialYQAssociatedDataArray finalYQAssociatedDataArray:(YQAssociatedData **)finalYQAssociatedDataArray;
@end

@interface YQDataSourceTests : XCTestCase

@end

@implementation YQDataSourceTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}


- (void)testSectionIndexes {
    YQSectionModel *model1 = [[YQSectionModel alloc] initWithIdentifier:@"A" items:@[@1,@2,@3]];
    YQSectionModel *model2 = [[YQSectionModel alloc] initWithIdentifier:@"B" items:@[@1,@2,@3]];
    YQSectionModel *model3 = [[YQSectionModel alloc] initWithIdentifier:@"C" items:@[@1,@2,@3]];
    //    YQSectionModel *model4 = [[YQSectionModel alloc] initWithIdentifier:@"D" items:@[@1,@2,@3]];
    //    YQSectionModel *model5 = [[YQSectionModel alloc] initWithIdentifier:@"E" items:@[@1,@2,@3]];
    //    YQSectionModel *model6 = [[YQSectionModel alloc] initWithIdentifier:@"F" items:@[@1,@2,@3]];
    //    YQSectionModel *model7 = [[YQSectionModel alloc] initWithIdentifier:@"G" items:@[@1,@2,@3]];
    //    YQSectionModel *model8 = [[YQSectionModel alloc] initWithIdentifier:@"H" items:@[@1,@2,@3]];
    //
    NSArray *array = @[model1, model2, model3];
    NSDictionary *dic = [Diff sectionIndexes:array];
    XCTAssertTrue([dic[@"A"] integerValue] == 0);
    XCTAssertTrue([dic[@"B"] integerValue] == 1);
    XCTAssertTrue([dic[@"C"] integerValue] == 2);
    
}

- (void)testMemcpy {
    YQAssociatedData defaultData = {YQItemActionHolding, 0, NSNotFound, 98};
    YQAssociatedData *initialSectionsAssociatedData = MEMSET_ASSOCIATEDDATA(defaultData, 3);
    XCTAssertTrue(initialSectionsAssociatedData[0].action == YQItemActionHolding);
    XCTAssertTrue(initialSectionsAssociatedData[0].moveIndex == NSNotFound);
    XCTAssertTrue(initialSectionsAssociatedData[0].indexAfterDelete == 0);
    XCTAssertTrue(initialSectionsAssociatedData[0].itemCount == 98);
    
    XCTAssertTrue(initialSectionsAssociatedData[1].action == YQItemActionHolding);
    XCTAssertTrue(initialSectionsAssociatedData[1].moveIndex == NSNotFound);
    XCTAssertTrue(initialSectionsAssociatedData[1].indexAfterDelete == 0);
    XCTAssertTrue(initialSectionsAssociatedData[1].itemCount == 98);
    
    XCTAssertTrue(initialSectionsAssociatedData[2].action == YQItemActionHolding);
    XCTAssertTrue(initialSectionsAssociatedData[2].moveIndex == NSNotFound);
    XCTAssertTrue(initialSectionsAssociatedData[2].indexAfterDelete == 0);
    XCTAssertTrue(initialSectionsAssociatedData[2].itemCount == 98);
}

- (void)testCalculateSectionMovements {
    YQSectionModel *model1 = [[YQSectionModel alloc] initWithIdentifier:@"A" items:@[@1,@2,@3]];
    YQSectionModel *model2 = [[YQSectionModel alloc] initWithIdentifier:@"B" items:@[@1,@2,@3]];
    YQSectionModel *model3 = [[YQSectionModel alloc] initWithIdentifier:@"C" items:@[@1,@2,@3]];
    //    YQSectionModel *model4 = [[YQSectionModel alloc] initWithIdentifier:@"D" items:@[@1,@2,@3]];
    //    YQSectionModel *model5 = [[YQSectionModel alloc] initWithIdentifier:@"E" items:@[@1,@2,@3]];
    //    YQSectionModel *model6 = [[YQSectionModel alloc] initWithIdentifier:@"F" items:@[@1,@2,@3]];
    //    YQSectionModel *model7 = [[YQSectionModel alloc] initWithIdentifier:@"G" items:@[@1,@2,@3]];
    //    YQSectionModel *model8 = [[YQSectionModel alloc] initWithIdentifier:@"H" items:@[@1,@2,@3]];
    
    NSArray *array1 = @[model1, model2, model3];
    NSArray *array2 = @[model1, model2];
    NSArray *array3 = @[model2, model1, model3];
    
    YQAssociatedData *initialSectionsAssociatedData, *finalSectionsAssociatedData;
//    [Diff calculateSectionMovementsWithInitialArray:array1 finalArray:array2 initialYQAssociatedDataArray:&initialSectionsAssociatedData finalYQAssociatedDataArray:&finalSectionsAssociatedData];
//    XCTAssertTrue(initialSectionsAssociatedData[0].action == YQItemActionHolding);
//    XCTAssertTrue(initialSectionsAssociatedData[1].action == YQItemActionHolding);
//    XCTAssertTrue(initialSectionsAssociatedData[2].action == YQItemActionDelete);
//
//    XCTAssertTrue(finalSectionsAssociatedData[0].action == YQItemActionHolding);
//    XCTAssertTrue(finalSectionsAssociatedData[1].action == YQItemActionHolding);
//
//    free(initialSectionsAssociatedData);
//    free(finalSectionsAssociatedData);
    
    [Diff calculateSectionMovementsWithInitialArray:array1 finalArray:array3 initialYQAssociatedDataArray:&initialSectionsAssociatedData finalYQAssociatedDataArray:&finalSectionsAssociatedData];
    
    XCTAssertTrue(finalSectionsAssociatedData[0].moveIndex == 1);
    XCTAssertTrue(finalSectionsAssociatedData[1].moveIndex == 0);
    XCTAssertTrue(finalSectionsAssociatedData[2].moveIndex == 2);
    
    XCTAssertTrue(initialSectionsAssociatedData[0].action == YQItemActionMove);
    XCTAssertTrue(initialSectionsAssociatedData[1].action == YQItemActionMove);
    XCTAssertTrue(initialSectionsAssociatedData[2].action == YQItemActionHolding);
    
    XCTAssertTrue(finalSectionsAssociatedData[0].action == YQItemActionMove);
    XCTAssertTrue(finalSectionsAssociatedData[1].action == YQItemActionMove);
    XCTAssertTrue(finalSectionsAssociatedData[2].action == YQItemActionHolding);
    
    free(initialSectionsAssociatedData);
    free(finalSectionsAssociatedData);
    
//    [Diff calculateSectionMovementsWithInitialArray:array2 finalArray:array3 initialYQAssociatedDataArray:&initialSectionsAssociatedData finalYQAssociatedDataArray:&finalSectionsAssociatedData];
//    XCTAssertTrue(initialSectionsAssociatedData[0].action == YQItemActionMove);
//    XCTAssertTrue(initialSectionsAssociatedData[1].action == YQItemActionMove);
//
//    XCTAssertTrue(finalSectionsAssociatedData[0].action == YQItemActionMove);
//    XCTAssertTrue(finalSectionsAssociatedData[1].action == YQItemActionMove);
//    //    XCTAssertTrue(finalSectionsAssociatedData[2].action == YQItemActionInsert);
//
//    free(initialSectionsAssociatedData);
//    free(finalSectionsAssociatedData);
}


@end
