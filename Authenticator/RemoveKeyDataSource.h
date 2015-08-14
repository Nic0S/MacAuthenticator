//
//  RemoveKeyDataSource.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 5/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

@interface RemoveKeyDataSource : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, strong) NSMutableArray* names;

-(NSUInteger) numberOfRowsInTableView:(NSTableView*)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
@end
