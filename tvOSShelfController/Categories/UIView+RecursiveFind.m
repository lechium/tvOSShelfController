//
//  UIView+UIView_RecursiveFind.m
//  tvOSGridTest
//
//  Created by Kevin Bradley on 3/12/16.
//  Copyright © 2016 nito. All rights reserved.
//

#import "UIView+RecursiveFind.h"
#import "Defines.h"
@implementation NSArray (al)

- (void)autoRemoveConstraints {
    if ([NSLayoutConstraint respondsToSelector:@selector(deactivateConstraints:)]) {
        [NSLayoutConstraint deactivateConstraints:self];
    }
}

@end

@implementation UIImage (Render)

- (UIImage *)scaledImagedToSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    CGFloat scaleFactor = 1.0;
    if (self.size.width > self.size.height ) {
        scaleFactor = self.size.width / self.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.width / scaleFactor;
    } else {
        scaleFactor = self.size.height / self.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0);
    CGRect scaledImagedRect = CGRectMake(0.0, 0.0, scaledSize.width, scaledSize.height);
    [self drawInRect:scaledImagedRect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (CGFloat)aspectRatio {
    return self.size.width/self.size.height;
}

- (UIImage *)roundedBorderImage:(CGFloat)cornerRadius borderColor:(UIColor *)color borderWidth:(CGFloat)width {
    __block UIImage *image = [UIImage renderedImage:self.size render:^(CGRect rect, CGContextRef context) {
        UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        [roundedRect addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        if (color) {
            [color setStroke];
            roundedRect.lineWidth = 2 * width;
            [roundedRect stroke];
        }
    }];
    return image;
}

+ (UIImage *)renderedImage:(CGSize)size render:(void(^)(CGRect rect, CGContextRef context))renderBlock {
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size];
    __block UIImage *image = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
        CGContextTranslateCTM(rendererContext.CGContext, 0, bounds.size.height);
        CGContextScaleCTM(rendererContext.CGContext, 1, -1);
        renderBlock(bounds, rendererContext.CGContext);
    }];
    return image;
}
@end

//-Wincomplete-implementation
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation UIView (RecursiveFind)
#pragma clang diagnostic pop

- (BOOL)darkMode {
    
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){
        return TRUE;
    }
    return FALSE;
}

- (UIView *)findFirstSubviewWithClass:(Class)theClass {
    
    if ([self isKindOfClass:theClass]) {
            return self;
        }
    
    for (UIView *v in self.subviews) {
        UIView *theView = [v findFirstSubviewWithClass:theClass];
        if (theView != nil)
        {
            return theView;
        }
    }
    return nil;
}
- (void)printAutolayoutTrace
{
    // NSString *recursiveDesc = [self performSelector:@selector(recursiveDescription)];
    //DLog(@"%@", recursiveDesc);
#if DEBUG
    NSString *trace = [self _recursiveAutolayoutTraceAtLevel:0];
    DLog(@"%@", trace);
#endif
}


- (void)printRecursiveDescription
{
//#if DEBUG

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSString *recursiveDesc = [self performSelector:@selector(recursiveDescription)];
#pragma clang diagnostic pop
    DLog(@"%@", recursiveDesc);
//#else
  //  DLog(@"BUILT FOR RELEASE, NO SOUP FOR YOU");
//#endif
}

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
}

- (NSLayoutConstraint *)autoAlignAxisToSuperviewAxis:(NSLayoutAttribute)axis {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *constraint = nil;
    switch(axis) {
        case NSLayoutAttributeCenterY:
            constraint = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor];
            break;
            
        case NSLayoutAttributeCenterX:
            constraint = [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor];
            break;
            
        default:
            break;
    }
    constraint.active = true;
    return constraint;
}

- (NSLayoutConstraint *)autoCenterHorizontallyInSuperview {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *constraint = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor];
    constraint.active = true;
    return constraint;
}

- (NSLayoutConstraint *)autoCenterVerticallyInSuperview {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *constraint = [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor];
    constraint.active = true;
    return constraint;
}

- (NSArray <NSLayoutConstraint *> *)autoConstrainToSize:(CGSize)size {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *width = [self.widthAnchor constraintEqualToConstant:size.width];
    width.active = true;
    NSLayoutConstraint *height = [self.heightAnchor constraintEqualToConstant:size.height];
    height.active = true;
    return @[width, height];
}

- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsets)inset excludingEdge:(UIRectEdge)edge {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSMutableArray *constraints = [NSMutableArray new];
    if (edge != UIRectEdgeLeft) {
        NSLayoutConstraint *leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:inset.left];
        leadingConstraint.active = true;
        [constraints addObject:leadingConstraint];
    }
    if (edge != UIRectEdgeRight) {
        NSLayoutConstraint *trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor constant:-inset.right];
        trailingConstraint.active = true;
        [constraints addObject:trailingConstraint];
    }
    if (edge != UIRectEdgeTop) {
        NSLayoutConstraint *topConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:inset.top];
        topConstraint.active = true;
        [constraints addObject:topConstraint];
    }
    if (edge != UIRectEdgeBottom) {
        NSLayoutConstraint *bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-inset.bottom];
        bottomConstraint.active = true;
        [constraints addObject:bottomConstraint];
    }
    return constraints;
}

- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToSuperviewEdgesWithInsets:(UIEdgeInsets)inset {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor constant:inset.left];
    leadingConstraint.active = true;
    NSLayoutConstraint *trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor constant:-inset.right];
    trailingConstraint.active = true;
    NSLayoutConstraint *topConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor constant:inset.top];
    topConstraint.active = true;
    NSLayoutConstraint *bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor constant:-inset.bottom];
    bottomConstraint.active = true;
    return @[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint];
}

- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToMargins {
    self.translatesAutoresizingMaskIntoConstraints = false;
    UILayoutGuide *viewMargins = self.layoutMarginsGuide;
    NSLayoutConstraint *leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:viewMargins.leadingAnchor];
    NSLayoutConstraint *trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:viewMargins.trailingAnchor];
    NSLayoutConstraint *topConstraint = [self.topAnchor constraintEqualToAnchor:viewMargins.topAnchor];
    NSLayoutConstraint *bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:viewMargins.bottomAnchor];
    leadingConstraint.active = true;
    trailingConstraint.active = true;
    topConstraint.active = true;
    bottomConstraint.active = true;
    return @[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint];
}

- (NSArray <NSLayoutConstraint *> *)autoPinEdgesToSuperviewEdges {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *leadingConstraint = [self.leadingAnchor constraintEqualToAnchor:self.superview.leadingAnchor];
    leadingConstraint.active = true;
    NSLayoutConstraint *trailingConstraint = [self.trailingAnchor constraintEqualToAnchor:self.superview.trailingAnchor];
    trailingConstraint.active = true;
    NSLayoutConstraint *topConstraint = [self.topAnchor constraintEqualToAnchor:self.superview.topAnchor];
    topConstraint.active = true;
    NSLayoutConstraint *bottomConstraint = [self.bottomAnchor constraintEqualToAnchor:self.superview.bottomAnchor];
    bottomConstraint.active = true;
    return @[leadingConstraint, trailingConstraint, topConstraint, bottomConstraint];
}

- (NSArray <NSLayoutConstraint *> *)autoCenterInSuperview {
    self.translatesAutoresizingMaskIntoConstraints = false;
    NSLayoutConstraint *yC = [self.centerYAnchor constraintEqualToAnchor:self.superview.centerYAnchor];
    yC.active = true;
    NSLayoutConstraint *xC = [self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor];
    xC.active = true;
    return @[xC, yC];
}

- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size {
    NSLayoutConstraint *constraint = nil;
    switch (dimension) {
        case NSLayoutAttributeWidth:
            constraint = [self.widthAnchor constraintEqualToConstant:size];
            break;
            
        case NSLayoutAttributeHeight:
            constraint = [self.heightAnchor constraintEqualToConstant:size];
            
        default:
            break;
    }
    constraint.active = true;
    return constraint;
}

- (NSLayoutConstraint *)autoSetDimension:(NSLayoutAttribute)dimension toSize:(CGFloat)size relation:(NSLayoutRelation)relation {
    NSLayoutConstraint *constraint = nil;
    SEL selector = @selector(constraintEqualToConstant:);
    
    switch (relation) {
        case NSLayoutRelationEqual:
            selector =  @selector(constraintEqualToConstant:);
            break;
        case NSLayoutRelationGreaterThanOrEqual:
            selector = @selector(constraintGreaterThanOrEqualToConstant:);
            break;
            
        case NSLayoutRelationLessThanOrEqual:
            selector = @selector(constraintLessThanOrEqualToConstant:);
            break;
    }
    //
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    switch (dimension) {
        case NSLayoutAttributeWidth:
            constraint = [self.widthAnchor performSelector:selector withObject:@(size)];
            break;
            
        case NSLayoutAttributeHeight:
            constraint = [self.heightAnchor performSelector:selector withObject:@(size)];
            
        default:
            break;
    }
#pragma clang diagnostic pop
    constraint.active = true;
    return constraint;
}


- (instancetype)initForAutoLayout {
    self = [self initWithFrame:CGRectZero];
    self.translatesAutoresizingMaskIntoConstraints = false;
    return self;
}

- (void)setCornerRadius:(CGFloat)radius updatingShadowPath:(BOOL)updatingShadowPath {
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = radius > 0;
    if (updatingShadowPath) {
        self.layer.shadowPath = radius > 0 ? [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath : nil;
    }
}

@end
