//
//  WikiViewController.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiViewController.h"
//#import "WikiDataStore.h"
#import "WikiAPI.h"

@interface WikiViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *articles;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *articleTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *articleExtractText;

@end

@implementation WikiViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.articleTitleLabel.adjustsFontSizeToFitWidth = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [WikiAPI getArticlesAroundLocation:CLLocationCoordinate2DMake(40.7061682, -74.0136262) completion:^(NSArray *wikiArticles) {
        
        self.articles = wikiArticles;
    
        [self.tableView reloadData];
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.articles.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ArticleCell" forIndexPath:indexPath];
    
    WikiArticle *currentArticle = self.articles[indexPath.row];
    
    cell.textLabel.text = currentArticle.title;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WikiArticle *selectedArticle = self.articles[indexPath.row];
    
    [WikiAPI getArticleExtract:selectedArticle.pageID completion:^(NSString *extract) {

        self.articleTitleLabel.text = selectedArticle.title;
        self.articleExtractText.text = extract;
        
    }];
    
}

@end
