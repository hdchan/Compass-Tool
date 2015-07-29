//
//  WikiDataStore.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiDataStore.h"
#import "WikiAPI.h"

@implementation WikiDataStore

+ (instancetype)sharedDataStore {
    static WikiDataStore *_sharedDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDataStore = [WikiDataStore new];
    });
    
    return _sharedDataStore;
}

- (void) getEntriesWithBlock:(void(^)(NSArray *wikiArticles))completion {
    
    [WikiAPI getArticlesAroundLocation:CLLocationCoordinate2DMake(40.7061682, -74.0136262) completion:^(NSArray *wikiArticles) {
        
        NSLog(@"%@",wikiArticles);
        
    }];
    
}

@end
