//
//  WikiDataStore.h
//  Compass Tool
//
//  Created by Henry Chan on 7/29/15.
//  Copyright (c) 2015 Henry Chan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WikiDataStore : NSObject

//@property (nonatomic, strong) NSMutableArray *entries;

+ (instancetype)sharedDataStore;

@end
