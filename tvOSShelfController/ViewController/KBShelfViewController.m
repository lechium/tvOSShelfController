//
//  KBFeaturedViewController.m
//  tvOSGridTest
//
//  Created by Kevin Bradley on 2/28/17.
//  Copyright © 2017 nito, LLC. All rights reserved.
//

#import "KBShelfViewController.h"
#import "KBTableViewCell.h"
#import "KBDataItemCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Additions.h"
#import <objc/runtime.h>
#import "AppDelegate.h"
#import "KBModelItem.h"
#import "ViewController.h"

@interface KBShelfViewController () {
    UILongPressGestureRecognizer *longPress;
    BOOL _firstAppearance;
    NSArray <KBSection *> *sections_;
}
@property (nonatomic, assign) CGFloat lastScrollViewOffsetX;
@property (nonatomic, assign) CGFloat lastScrollViewOffsetY;
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) NSTimer *bannerTimer;
@property (readwrite, assign) NSInteger selectedSection;
@property (nonatomic, strong) NSCache *cellCache;
@property ScrollDirection scrollDirection;
@property NSDate *randomDate;
@end

@implementation KBShelfViewController

-(void)loadView {
    [super loadView];
    self.randomDate = [NSDate date];
    self.contentOffsetDictionary = [NSMutableDictionary dictionary];
    self.cellCache = [NSCache new];
}

- (void)viewDidLoad {
    _firstAppearance =  false;
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.translatesAutoresizingMaskIntoConstraints = FALSE;
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView autoPinEdgesToSuperviewEdges];
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.top = -10;
    self.tableView.insetsContentViewsToSafeArea = false;
    self.tableView.insetsLayoutMarginsFromSafeArea = false;
    self.tableView.contentInset = edgeInsets;
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypePlayPause]];
    [self.view addGestureRecognizer:longPress];
    self.tabBarObservedScrollView = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_firstAppearance) {
        _firstAppearance = true;
    }
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    self.tableView.maskView = nil;
    self.navigationController.view.backgroundColor = nil;
    self.tabBarController.view.backgroundColor = nil;
}

- (void)updateAutoScroll {
    if (self.sections.count > 0){
        if ([self autoScrollSections].count > 0){
            [self startAutoscrollBanners];
        }
    }
}

- (void)startAutoscrollBanners {
    self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:12 target:self selector:@selector(showNextBanner) userInfo:nil repeats:YES];
}

- (void)stopAutoscrollBanners {
    [self.bannerTimer invalidate];
    self.bannerTimer = nil;
}

- (NSArray <KBSection *> *)sections {
    return sections_;
}

- (void)setSections:(NSArray<KBSection *> *)sections {
    sections_ = sections;
    [self handleSectionsUpdated];
}

- (void)handleSectionsUpdated {
    [self createTableViewCells];
    [self updateAutoScroll];
}

- (void)showNextBanner {
    if (self.selectedSection == 0) return;
    if (self.sections.count == 0) { return; }
    [[self autoScrollSections] enumerateObjectsUsingBlock:^(KBSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [self.sections indexOfObject:obj];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:index];
        KBSection *featuredSection = self.sections[index];
        KBTableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
        UICollectionView *cv = cell.collectionView;
        
        NSIndexPath *indexPathForCell = [self centeredIndexPathForCollectionView:cv];
        //DLog(@"featuredSection.packages.count: %lu indexPathForCell.row: %lu ", featuredSection.items.count, indexPathForCell.row);
        if (featuredSection.items.count == indexPathForCell.row+1){
            //DLog(@"nope");
            [cell goToOne];
            return;
        }
        
        if (self.selectedSection != index) {
            ip = [NSIndexPath indexPathForRow:indexPathForCell.row+1 inSection:0];
            
            [CATransaction begin];
            [CATransaction setAnimationDuration:8];
            [cv scrollToItemAtIndexPath:ip
                       atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                               animated:YES];
            [CATransaction commit];
        }
    }];
}

-(void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        DLog(@"LONG PRESS MOFO");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.count;
}

- (NSArray *)arrayForSection:(NSInteger)section {
    KBSection *currentSection = self.sections[section];
    return currentSection.items;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSArray <KBSection *> *)infiniteSections {
    return [self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"infinite == true"]];
}

- (NSArray <KBSection *> *)autoScrollSections {
    return [self.sections filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"autoScroll == true"]];
}

- (void)createTableViewCells {
    [self showHUD];
    [_cellCache removeAllObjects];
    [self.sections enumerateObjectsUsingBlock:^(KBSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:idx];
        KBTableViewCell *cell = [self createCellAtIndexPath:ip];
        [_cellCache setObject:cell forKey:@(idx)];
    }];
    [self dismissHUD];
    [self.tableView reloadData];
    [self handleInfiniteSections];
}

- (void)handleInfiniteSections {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[self infiniteSections] enumerateObjectsUsingBlock:^(KBSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = [self.sections indexOfObject:obj];
            KBTableViewCell *cell = [self.cellCache objectForKey:@(index)];
            [cell goToOne];
        }];
    });
}

- (KBTableViewCell *)createCellAtIndexPath:(NSIndexPath *)indexPath {
    KBSection *section = self.sections[indexPath.section];
    static NSString *CellIdentifier = @"CellIdentifier";
    KBTableViewCell *cell = (KBTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell){
        cell = [[KBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.section = section;
    [cell setCollectionViewDataSourceDelegate:self section:indexPath.section];
    return cell;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KBTableViewCell *cell = [self.cellCache objectForKey:@(indexPath.section)];
    if (!cell) {
        cell = [self createCellAtIndexPath:indexPath];
        [_cellCache setObject:cell forKey:@(indexPath.section)];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(KBTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //CGFloat horizontalOffset = [self.contentOffsetDictionary[[@(index) stringValue]] floatValue];
    //[cell.collectionView setContentOffset:CGPointMake(horizontalOffset, 0)];
}

#pragma mark - UITableViewDelegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KBSection *section = self.sections[indexPath.section];
    if (section.sectionType == KBSectionTypeBanner){
        return section.imageHeight;
    } else {
        return section.imageHeight + 100; //need extra space for the labels and whatnot
    }
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger realSection = [collectionView section];
    //get our detail array based on collectionView
    KBSection *currentSection = self.sections[realSection];
    if (currentSection.infinite) return INFINITE_CELL_COUNT;
    NSArray *detailsArray = [self arrayForSection:realSection];
    //DLog(@"details for section titled: %@ count: %lu index: %lu section2: %lu", self.sections[realSection].sectionName, detailsArray.count, realSection, section);
    return detailsArray.count;
}

- (KBModelItem *)collectionView:(UICollectionView *)collectionView itemAtRow:(NSInteger)row {
    NSInteger realSection = [collectionView section];
    NSArray *detailsArray = [self arrayForSection:realSection];
    NSInteger index = row;
    KBSection *featuredSection = self.sections[realSection];
    if (featuredSection.infinite) {
        index = index % detailsArray.count;
    }
    return detailsArray[index];
}

//an item was selected!

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemSelectedBlock) {
        KBModelItem *item = [self collectionView:collectionView itemAtRow:indexPath.row];
        self.itemSelectedBlock(item);
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    KBDataItemCollectionViewCell *ourCell = (KBDataItemCollectionViewCell*)cell;
    NSInteger realSection = [collectionView section];
    KBSection *section = self.sections[realSection];
    if (section.sectionType == KBSectionTypeBanner) {
        ourCell.label.text = @"";
        ourCell.imageHeightConstraint.constant = section.imageHeight - 50;
    } else {
        ourCell.imageHeightConstraint.constant = section.imageHeight - 50;
    }
}


- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator{
    
    //DLog(@"nfv: %@", context.nextFocusedView);
    UICollectionView *sv = (UICollectionView*)context.nextFocusedView.superview;
    if ([sv respondsToSelector:@selector(section)]){
        //DLog(@"selected section: %lu", sv.indexPath.section);
        BOOL sectionChanged = (self.selectedSection != sv.section);
        if (sectionChanged) {
            DLog(@"changed from section: %lu to %lu", self.selectedSection, sv.section);
        }
        self.selectedSection = sv.section;
    } else {
        self.selectedSection = 0;
    }
}

- (NSIndexPath *)indexPathForPreferredFocusedViewInCollectionView:(UICollectionView *)collectionView {
    NSIndexPath *visibleIndexPath = [self centeredIndexPathForCollectionView:collectionView];
    return visibleIndexPath;
}


- (NSIndexPath *)centeredIndexPathForCollectionView:(UICollectionView *)collectionView {
    
    CGRect visibleRect = (CGRect){.origin = collectionView.contentOffset, .size = collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [collectionView indexPathForItemAtPoint:visiblePoint];
    return visibleIndexPath;
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    
}

- (void)collectionView:(UICollectionView *)collectionView prefetchItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths {
    /*
     NSInteger realSection = [(UICollectionView *)collectionView section];
     NSArray *detailsArray = [self arrayForSection:realSection];
     FeaturedSection *featuredSection = self.sections[realSection];
     */
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KBDataItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellIdentifier forIndexPath:indexPath];
    
    NSInteger realSection = [collectionView section];
    KBSection *featuredSection = self.sections[realSection];
    KBModelItem *currentItem = [self collectionView:collectionView itemAtRow:indexPath.row];
    cell.label.text = currentItem.title;
    if (featuredSection.sectionType == SectionTypeBanner) {
        cell.bannerLabel.text = currentItem.title;
        cell.bannerDescription.text = currentItem.details;
        NSString *banner = [currentItem.banner stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:banner] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    } else {
        cell.bannerLabel.text = @"";
        cell.bannerDescription.text = @"";
        NSString *icon = [currentItem.imagePath stringByReplacingOccurrencesOfString:@"http://" withString:@"https://"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:icon] placeholderImage:self.placeholderImage options:SDWebImageAllowInvalidSSLCertificates];
    }
    
    return cell;
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillSnapNavigationBar:(UIScrollView *)scrollView {
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    UICollectionView *collectionView = (UICollectionView *)scrollView;
    if (collectionView.section == 0){
        return;
    }
    CGFloat horizontalOffset = scrollView.contentOffset.x;
    NSInteger index = collectionView.section;
    //DLog(@"indexPath: %@", collectionView.indexPath);
    self.contentOffsetDictionary[[@(index) stringValue]] = @(horizontalOffset);
}

@end
