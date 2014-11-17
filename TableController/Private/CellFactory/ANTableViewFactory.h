//
//  ANTableViewFactoryDelegate.h
//
//  Created by Denys Telezhkin on 6/19/12.
//  Copyright (c) 2012 MLSDev. All rights reserved.
//

@protocol ANTableViewFactoryDelegate

-(UITableView *)tableView;

@end

typedef NS_ENUM(NSInteger, ANSupplementaryViewType)
{
    ANSupplementaryViewTypeNone,
    ANSupplementaryViewTypeHeader,
    ANSupplementaryViewTypeFooter
};

@interface ANTableViewFactory : NSObject

-(void)registerCellClass:(Class)cellClass forModelClass:(Class)modelClass;

- (void)registerSupplementayClass:(Class)supplementaryClass
                    forModelClass:(Class)modelClass
                             type:(ANSupplementaryViewType)type;

- (UITableViewCell *)cellForModel:(NSObject *)model atIndexPath:(NSIndexPath *)indexPath;

- (UIView *)supplementaryViewForModel:(id)model type:(ANSupplementaryViewType)type;

@property (nonatomic, weak) id <ANTableViewFactoryDelegate> delegate;

@end