//
//  AppDelegate.m
//  tvOSGridTest
//
//  Created by Kevin Bradley on 3/23/23.
//

#import "AppDelegate.h"
@import tvOSShelfController;

@interface AppDelegate ()

@end

@implementation AppDelegate

#define MODEL(n,p,i) [[KBModelItem alloc] initWithTitle:n imagePath:p uniqueID:i]

- (NSArray *)items {
    
    KBSection *section = [KBSection new];
    section.type = @"banner";
    section.size = @"1700x525";
    section.infinite = true;
    section.autoScroll = true;
    section.order = 0;
    section.className = @"KBModelItem";
    
    KBModelItem *modelItem = MODEL(@"Drake - Worst Behavior", @"https://i.ytimg.com/vi/CccnAvfLPvE/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLBKduZRk6TRsKi8h4DE_cPajmtOcA", @"CccnAvfLPvE");
    modelItem.details = @"Drake";
    modelItem.banner = modelItem.imagePath;
    modelItem.resultType = @1;
    section.items = @[modelItem];
    
    KBSection *sectionTwo = [KBSection new];
    sectionTwo.type = @"standard";
    sectionTwo.sectionName = @"First";
    sectionTwo.size = @"320x240";
    sectionTwo.infinite = false;
    sectionTwo.autoScroll = false;
    sectionTwo.order = 1;
    sectionTwo.className = @"KBModelItem";
    sectionTwo.items = @[
        MODEL(@"God's Plan", @"https://i.ytimg.com/vi/xpVfcZ0ZcFM/hqdefault.jpg", @"xpVfcZ0ZcFM"),
        MODEL(@"Rich Flex", @"https://i.ytimg.com/vi/I4DjHHVHWAE/hqdefault.jpg", @"I4DjHHVHWAE"),
        MODEL(@"Spin Bout U", @"https://i.ytimg.com/vi/T8nbNQpRwNo/hqdefault.jpg", @"T8nbNQpRwNo"),
        MODEL(@"MIA", @"https://i.ytimg.com/vi/NveQffpaOlU/hqdefault.jpg", @"NveQffpaOlU"),
        MODEL(@"Search & Rescue", @"https://i.ytimg.com/vi/tVthyPOWc-E/hqdefault.jpg", @"tVthyPOWc-E"),
    ];
    
    KBSection *sectionThree = [KBSection new];
    sectionThree.type = @"standard";
    sectionThree.sectionName = @"Second";
    sectionThree.size = @"640x480";
    sectionThree.infinite = false;
    sectionThree.autoScroll = false;
    sectionThree.order = 2;
    sectionThree.className = @"KBModelItem";
    sectionThree.items = @[
        MODEL(@"Drake - Worst Behavior", @"https://i.ytimg.com/vi/CccnAvfLPvE/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLBKduZRk6TRsKi8h4DE_cPajmtOcA", @"CccnAvfLPvE"),
        MODEL(@"Drake - Stars (Official Music Video) 2023", @"https://i.ytimg.com/vi/R4DZBZJsoEY/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLAKZUsBLjiB8Ook77VQSqatPhaQ2g", @"R4DZBZJsoEY"),
        MODEL(@"DJ Khaled ft. Drake - POPSTAR (Official Music Video - Starring Justin Bieber)", @"https://i.ytimg.com/vi/3CxtK7-XtE0/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLD9FC8VLEM86eZAY8awL1-3LgmM2g", @"3CxtK7-XtE0"),
        MODEL(@"Meek Mill - Going Bad feat. Drake (Official Video)", @"https://i.ytimg.com/vi/S1gp0m4B5p8/hqdefault.jpg?sqp=-oaymwEjCOADEI4CSFryq4qpAxUIARUAAAAAGAElAADIQj0AgKJDeAE=&rs=AOn4CLD33ZfTKyCvv6OWsoN_imf2kx3vnQ", @"S1gp0m4B5p8"),
        MODEL(@"Teenage Fever", @"https://i.ytimg.com/vi/e8HtwsnuTIw/hq720.jpg?sqp=-oaymwEXCNAFEJQDSFryq4qpAwkIARUAAIhCGAE=&rs=AOn4CLDMtNcOuNNwmb7rVQfQYpmpOeWDbA", @"e8HtwsnuTIw"),
    ];
    
    KBSection *sectionFour = [KBSection new];
    sectionFour.type = @"standard";
    sectionFour.sectionName = @"Third";
    sectionFour.size = @"320x240";
    sectionFour.infinite = false;
    sectionFour.autoScroll = false;
    sectionFour.order = 3;
    sectionFour.className = @"KBModelItem";
    sectionFour.items = @[
        MODEL(@"God's Plan", @"https://i.ytimg.com/vi/xpVfcZ0ZcFM/hqdefault.jpg", @"xpVfcZ0ZcFM"),
        MODEL(@"Rich Flex", @"https://i.ytimg.com/vi/I4DjHHVHWAE/hqdefault.jpg", @"I4DjHHVHWAE"),
        MODEL(@"Spin Bout U", @"https://i.ytimg.com/vi/T8nbNQpRwNo/hqdefault.jpg", @"T8nbNQpRwNo"),
        MODEL(@"MIA", @"https://i.ytimg.com/vi/NveQffpaOlU/hqdefault.jpg", @"NveQffpaOlU"),
        MODEL(@"Search & Rescue", @"https://i.ytimg.com/vi/tVthyPOWc-E/hqdefault.jpg", @"tVthyPOWc-E"),
    ];
    
    return @[section, sectionTwo, sectionThree, sectionFour];
}

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
    self.shelfViewController.useRoundedEdges = false;
    self.shelfViewController.placeholderImage = [[UIImage imageNamed:@"YTPlaceholder.png"] roundedBorderImage:20.0 borderColor:nil borderWidth:0];
    self.shelfViewController.itemSelectedBlock = ^(KBModelItem * _Nonnull item, BOOL isLongPress) {
        DLog(@"item selected block: %@ long: %d", item, isLongPress);
    };
    self.shelfViewController.sections = [self loadData];
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
