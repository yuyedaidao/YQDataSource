//
//  ItemModel.h
//  YQDataSource
//
//  Created by 王叶庆 on 2018/11/7.
//  Copyright © 2018 王叶庆. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IGListKit/IGListDiffable.h>
NS_ASSUME_NONNULL_BEGIN

@interface ItemModel : NSObject<IGListDiffable, NSCopying>
@property (assign, nonatomic) NSInteger index;
@end

NS_ASSUME_NONNULL_END
