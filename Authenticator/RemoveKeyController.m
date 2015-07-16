//
//  RemoveKeyController.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 5/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "RemoveKeyController.h"

@interface RemoveKeyController ()

@end



@implementation RemoveKeyController

int selectedRow = -1;
-(instancetype)init{
    if(self = [super init]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNames:) name:@"Names" object:nil];
        _names = [NSArray new];
    }
    return self;
}

- (void)awakeFromNib {
    [nameTable setHeaderView:nil];
    [nameTable setDataSource:self];
    [nameTable setDelegate:self];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}


-(IBAction)removeKeyButtonPressed:(id)sender{
    if(selectedRow != -1){
        NSDictionary *userInfo = @{ @"name" : _names[selectedRow]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KeyRemovedNotification" object:nil userInfo:userInfo];
    }
}

-(void)setNames:(NSNotification*)notification{
    _names = notification.userInfo.allKeys;
    [nameTable reloadData];
}

- (NSUInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    
    // how many rows do we have here?
    return self.names.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    // populate each row of our table view with data
    // display a different value depending on each column (as identified in XIB)
    
   NSLog(@"%@", self.names[row]);
    return [NSString stringWithString:self.names[row]];
    
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    // Get an existing cell with the MyView identifier if it exists
    NSTableCellView *result = nil; //[tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    // There is no existing cell to reuse so create a new one
    if (result == nil) {
    
        // Create the new NSTextField with a frame of the {0,0} with the width of the table.
        // Note that the height of the frame is not really relevant, because the row height will modify the height.
        result = [[NSTableCellView alloc] initWithFrame:NSMakeRect(0, 0, nameTable.bounds.size.height, [nameTable rowHeight])];
    
        // The identifier of the NSTextField instance is set to MyView.
        // This allows the cell to be reused.
        result.identifier = @"MyView";
    }
    NSTextField *cellTF = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, result.bounds.size.height)];
    [result addSubview:cellTF];
    result.textField = cellTF;
    [cellTF setBordered:NO];
    [cellTF setEditable:NO];
    [cellTF setDrawsBackground:NO];
    result.textField.stringValue = [self.names objectAtIndex:row];
    
    
    // Return the result
    return result;
    
}


- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    
    NSTableView *tableView = notification.object;
    NSLog(@"User has selected row %ld", (long)tableView.selectedRow);
    selectedRow = (int)tableView.selectedRow;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 20;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
