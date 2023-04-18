//
//  UIView+UIView_RecursiveFind.h
//  tvOSGridTest
//
//  Created by Kevin Bradley on 3/12/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIView (RecursiveFind)

- (BOOL)darkMode;
- (UIView *)findFirstSubviewWithClass:(Class)theClass;
- (void)printRecursiveDescription;
- (void)removeAllSubviews;
- (void)printAutolayoutTrace;
//- (NSString *)recursiveDescription;
- (id)_recursiveAutolayoutTraceAtLevel:(long long)arg1;

- (id)initForAutoLayout;
- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToMargins;
- (NSArray <NSLayoutConstraint *> *)autoCenterInSuperview;
- (NSLayoutConstraint *)autoCenterHorizontallyInSuperview;
- (NSLayoutConstraint *)autoCenterVerticallyInSuperview;
- (NSLayoutConstraint *)autoAlignAxisToSuperviewAxis:(NSLayoutAttribute)axis;
- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToSuperviewEdges;
- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsets)inset;
- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsets)inset excludingEdge:(UIRectEdge)edge;
- (NSArray <NSLayoutConstraint *> *)autoConstrainToSize:(CGSize)size;
- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size;
- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size relation:(NSLayoutRelation)relation;
@end
