//
//  AppDelegate.h
//  tvOSGridTest
//
//  Created by Kevin Bradley on 3/23/23.
//

#import <UIKit/UIKit.h>
#import "KBShelfViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) KBShelfViewController *shelfViewController;
@property (weak, nonatomic) UITabBarController *tabBarController;


@end

