//
//  AppDelegate.m
//  tvOSGridTest
//
//  Created by Kevin Bradley on 3/23/23.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (NSArray *)loadData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"tuyu_featured" ofType:@"plist"];
    DLog(@"filePath: %@", filePath);
    NSArray *initialArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    __block NSMutableArray *returnArray = [NSMutableArray new];
    [initialArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        KBSection *section = [[KBSection alloc] initWithSectionDictionary:obj];
        if (section != nil) {
            //DLog(@"section: %@", section);
            if (section.items.count > 0) {
                [returnArray addObject:section];
            } else {
                DLog(@"this section doesn't have any compatible packages: %@, skipping!", section.sectionName);
            }
        }
    }];
    return returnArray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.shelfViewController = [[KBShelfViewController alloc] init];
    self.shelfViewController.placeholderImage = [UIImage imageNamed:@"YTPlaceholder.png"];
    self.shelfViewController.itemSelectedBlock = ^(KBModelItem * _Nonnull item) {
        DLog(@"item selected block: %@", item);
    };
    NSArray *loadedData = [self loadData];
    self.shelfViewController.sections = loadedData;
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.shelfViewController];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


@end
