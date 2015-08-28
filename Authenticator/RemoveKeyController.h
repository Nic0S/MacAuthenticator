//
//  RemoveKeyController.h
//  Authenticator
//
//  Created by Nico Schlumprecht on 5/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AppKit/AppKit.h>

@interface RemoveKeyController : NSObject <NSTableViewDataSource, NSTableViewDelegate>{
    
@private
    IBOutlet NSTableView *nameTable;
}

@property (nonatomic, strong) NSArray *names;

-(instancetype)init;

-(IBAction)removeKeyButtonPressed:(id)sender;

-(NSUInteger) numberOfRowsInTableView:(NSTableView*)aTableView;

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row;

@end
