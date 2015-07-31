//
//  WikiViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiViewController.h"
//#import "WikiDataStore.h"
#import "WikiAPIClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@interface WikiViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) NSArray *articles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *articleExtractText;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *lastWikiUpdateLocation;

@end

@implementation WikiViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.articleTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.locationManager = [CLLocationManager new];
    
    self.locationManager.delegate = self;
    
    [self.locationManager startUpdatingLocation];

    
}

- (void) updateWikiArticles {
    
    [SVProgressHUD showWithStatus:@"Updating POI"];
    
//    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(40.7061682, -74.0136262);
    CLLocationCoordinate2D coordinates = self.lastWikiUpdateLocation.coordinate;
    [WikiAPIClient getArticlesAroundLocation:coordinates radius:400 completion:^(NSArray *wikiArticles) {
        
        self.articles = wikiArticles;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    }];
}

#pragma mark - Table View Protocol Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.articles.count;
    
}

- (MCSwipeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
    WikiArticle *currentArticle = self.articles[indexPath.row];
    
    cell.textLabel.text = currentArticle.title;
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm",currentArticle.distance];
    
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        NSLog(@"Did swipe \"Checkmark\" cell");
    }];
    
    return cell;
    
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WikiArticle *selectedArticle = self.articles[indexPath.row];
    
    self.articleTitleLabel.text = selectedArticle.title;
    
    if (!selectedArticle.extract) {
       
        [SVProgressHUD showWithStatus:@"Retrieving Extract"];
        
        [WikiAPIClient getArticleExtract:selectedArticle.pageID completion:^(NSString *extract) {
            
            selectedArticle.extract = extract;
            
            self.articleExtractText.text = extract;
            
            [SVProgressHUD dismiss];
            
        }];
        
    } else {
        
        self.articleExtractText.text = selectedArticle.extract;
        
    }
    
    
    
}

#pragma mark - CLLocation Protocol Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
   
    CLLocation *currentLocation = (CLLocation *)[locations firstObject];
    
    if (!self.lastWikiUpdateLocation) {
        
        self.lastWikiUpdateLocation = currentLocation;
        
        [self updateWikiArticles];
        
    } else {
        
        double distanceFromLastWikiUpdateLocation = [currentLocation distanceFromLocation:self.lastWikiUpdateLocation];
        
        [JDStatusBarNotification showWithStatus:[NSString stringWithFormat:@"%fm away from last wiki update location", distanceFromLastWikiUpdateLocation]];
        
        if (distanceFromLastWikiUpdateLocation > 400) { // every quarter mile?
            
            self.lastWikiUpdateLocation = currentLocation;
            
            [self updateWikiArticles];
            
        }

    }
    
}


@end
