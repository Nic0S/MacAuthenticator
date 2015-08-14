//
//  RemoveKeyDataSource.m
//  Authenticator
//
//  Created by Nico Schlumprecht on 5/26/15.
//  Copyright (c) 2015 nicos. All rights reserved.
//

#import "RemoveKeyDataSource.h"

@implementation RemoveKeyDataSource


-(NSUInteger) numberOfRowsInTableView:(NSTableView*)aTableView{
    NSLog(@"%lu", (unsigned long)_names.count);

    return _names.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex{
    return _names[rowIndex];
}


- (NSView *)tableView:(NSTableView *)tableView
   viewForTableColumn:(NSTableColumn *)tableColumn
                  row:(NSInteger)row {
    
    // Get an existing cell with the MyView identifier if it exists
    NSTextField *result = [tableView makeViewWithIdentifier:@"MyView" owner:self];
    
    // There is no existing cell to reuse so create a new one
    //if (result == nil) {
        
        // Create the new NSTextField with a frame of the {0,0} with the width of the table.
        // Note that the height of the frame is not really relevant, because the row height will modify the height.
        result = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 24, 204)];
        
        // The identifier of the NSTextField instance is set to MyView.
        // This allows the cell to be reused.
        result.identifier = @"MyView";
    
    [result setStringValue:_names[row]];
    //}
    
    // result is now guaranteed to be valid, either as a reused cell
    // or as a new cell, so set the stringValue of the cell to the
    // nameArray value at row
    result.stringValue = [self.names objectAtIndex:row];
    
    // Return the result
    return result;
    
}

@end
