//
//  DTCellFactory.m
//  DTTableViewController
//
//  Created by Denys Telezhkin on 6/19/12.
//  Copyright (c) 2012 MLSDev. All rights reserved.
//

#import "ANTableViewFactory.h"
#import "DTModelTransfer.h"
#import "DTRuntimeHelper.h"

@interface ANTableViewFactory ()

@property (nonatomic,strong) NSMutableDictionary* cellMappingsDictionary;
@property (nonatomic,strong) NSMutableDictionary* headerMappingsDictionary;
@property (nonatomic,strong) NSMutableDictionary* footerMappingsDictionary;

@end

@implementation ANTableViewFactory

- (NSMutableDictionary *)cellMappingsDictionary
{
    if (!_cellMappingsDictionary)
    {
        _cellMappingsDictionary = [NSMutableDictionary new];
    }
    return _cellMappingsDictionary;
}

- (NSMutableDictionary *)headerMappingsDictionary
{
    if (!_headerMappingsDictionary)
    {
        _headerMappingsDictionary = [NSMutableDictionary new];
    }
    return _headerMappingsDictionary;
}

- (NSMutableDictionary *)footerMappingsDictionary
{
    if (!_footerMappingsDictionary)
    {
        _footerMappingsDictionary = [NSMutableDictionary new];
    }
    return _footerMappingsDictionary;
}

#pragma mark - class mapping

- (void)registerCellClass:(Class)cellClass forModelClass:(Class)modelClass
{
    NSParameterAssert([cellClass isSubclassOfClass:[UITableViewCell class]]);
    NSParameterAssert([cellClass conformsToProtocol:@protocol(DTModelTransfer)]);
    NSParameterAssert(modelClass);
    
    NSString * reuseIdentifier = [DTRuntimeHelper classStringForClass:cellClass];
    [[self.delegate tableView] registerClass:cellClass
                      forCellReuseIdentifier:reuseIdentifier];
    
    [self.cellMappingsDictionary setObject:[DTRuntimeHelper classStringForClass:cellClass]
                                    forKey:[DTRuntimeHelper modelStringForClass:modelClass]];
}

- (void)registerSupplementayClass:(Class)supplementaryClass forModelClass:(Class)modelClass type:(ANSupplementaryViewType)type
{
    NSAssert(([supplementaryClass isSubclassOfClass:[UITableViewHeaderFooterView class]]), @"Class must be UITableViewHeaderFooterView object");
    [[self.delegate tableView] registerClass:supplementaryClass
          forHeaderFooterViewReuseIdentifier:NSStringFromClass(supplementaryClass)];
    
    BOOL isHeader = (type == ANSupplementaryViewTypeHeader);
    NSMutableDictionary* mappings = isHeader ? self.headerMappingsDictionary : self.footerMappingsDictionary;
    
    [mappings setObject:NSStringFromClass(supplementaryClass)
                                      forKey:[DTRuntimeHelper modelStringForClass:modelClass]];
}

#pragma mark - View creation

- (UITableViewCell *)cellForModel:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = [self _cellReuseIdentifierForModel:model];
    UITableViewCell <DTModelTransfer> * cell;
    cell = [[self.delegate tableView] dequeueReusableCellWithIdentifier:reuseIdentifier
                                                           forIndexPath:indexPath];
    [cell updateWithModel:model];
    return cell;
}


- (UIView *)supplementaryViewForModel:(id)model type:(ANSupplementaryViewType)type
{
    Class supplementaryClass = [self _supplementaryClassForModel:model type:type];
    UIView <DTModelTransfer> * view = (id)[self _headerFooterViewForViewClass:supplementaryClass];
    [view updateWithModel:model];
    
    return view;
}

#pragma mark - Private Helpers

- (NSString *)_cellReuseIdentifierForModel:(id)model
{
    NSString* modelClassName = [DTRuntimeHelper modelStringForClass:[model class]];
    NSString* cellClassString = [self.cellMappingsDictionary objectForKey:modelClassName];
    NSAssert(cellClassString, @"%@ does not have cell mapping for model class: %@",[self class], [model class]);
    
    return cellClassString;
}

- (UIView *)_headerFooterViewForViewClass:(Class)viewClass
{
    NSString * reuseIdentifier = [DTRuntimeHelper classStringForClass:viewClass];
    UIView * view = [[self.delegate tableView] dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    
    return view;
}

- (NSMutableDictionary*)_supplementaryMappingsForType:(ANSupplementaryViewType)type
{
    switch (type)
    {
        case ANSupplementaryViewTypeHeader: return self.headerMappingsDictionary; break;
        case ANSupplementaryViewTypeFooter: return self.footerMappingsDictionary; break;
        default: return nil; break;
    }
}

- (Class)_supplementaryClassForModel:(id)model type:(ANSupplementaryViewType)type
{
    NSString* modelClassName = [DTRuntimeHelper modelStringForClass:[model class]];
    NSString* supplClassString = [[self _supplementaryMappingsForType:type] objectForKey:modelClassName];
    NSAssert(supplClassString, @"DTCellFactory does not have supplementary mapping for model class: %@",[model class]);
    
    return NSClassFromString(supplClassString);
}

@end