//
//  MVDocument.m
//
//  Copyright (c) 2012 Chi-En Wu, All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  * Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  * Neither the name of the organization nor the
//  names of its contributors may be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "MVDocument.h"

@interface MVDocument ()

@property (strong) NSTimer *timer;
@property (strong) NSDate *lastUpdate;

- (NSDate *)fileUpdateDate;
- (BOOL) isFileUpdated;
- (void) refresh;

@end

@implementation MVDocument

#pragma mark Public Properties

@synthesize webView = _webView;
@synthesize converter = _converter;

#pragma mark Private Properties

@synthesize timer = _timer;
@synthesize lastUpdate = _lastUpdate;

#pragma mark Initializing

- (id) init
{
    self = [super init];
    if (self)
    {
        _converter = [MVConverter new];
    }

    return self;
}

#pragma mark Override Methods

- (NSString *) windowNibName
{
    return @"MVDocument";
}

- (void) close
{
    [_timer invalidate];
    _timer = nil;

    [super close];
}

- (void) windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    _lastUpdate = [NSDate distantPast];
    _timer = [NSTimer scheduledTimerWithTimeInterval:.5
                                              target:self
                                            selector:@selector(refresh)
                                            userInfo:nil
                                             repeats:YES];
    [self refresh];
}

- (BOOL) readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
    [_converter setFile:[url path]];
    return YES;
}

#pragma mark Handling Navigation

- (void) webView:(WebView *)sender decidePolicyForNavigationAction:(NSDictionary *)actionInformation
    request:(NSURLRequest *)request frame:(WebFrame *)frame
    decisionListener:(id <WebPolicyDecisionListener>)listener
{
    if ([[request URL] host])
        [[NSWorkspace sharedWorkspace] openURL:[request URL]];
    else
        [listener use];
}

#pragma mark Tracking File Update Date

- (NSDate *)fileUpdateDate
{
    NSDictionary *fileInfo = [[NSFileManager new] attributesOfItemAtPath:[[self fileURL] path]
                                                                   error:nil];
    return [fileInfo valueForKey:NSFileModificationDate];
}

- (BOOL) isFileUpdated
{
    NSDate *lastUpdate = [self fileUpdateDate];
    BOOL isUpdated = [lastUpdate compare:_lastUpdate] == NSOrderedDescending;
    if (isUpdated)
        _lastUpdate = lastUpdate;

    return isUpdated;
}

#pragma mark Refreshing WebView

- (void) refresh
{
    if (![self isFileUpdated])
        return;

    NSString *path = [[[self fileURL] path] stringByDeletingLastPathComponent];
    [[_webView mainFrame] loadHTMLString:[_converter preview]
                                 baseURL:[NSURL fileURLWithPath:path]];
}

@end
