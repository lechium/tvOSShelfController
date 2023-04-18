//
//  KBModelItem.m
//  tvOSGridTest
//
//  Created by Kevin Bradley on 4/16/23.
//

#import "KBModelItem.h"

@implementation KBModelItem

- (NSString *)description {
    NSString *og = [super description];
    return [NSString stringWithFormat:@"%@ title: %@ id: %@", og, self.title, self.uniqueID];
}

@end
