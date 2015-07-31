//
//  WikiDataStore.m
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import "WikiDataStore.h"
#import "WikiAPIClient.h"

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
    
    
    
}

@end
