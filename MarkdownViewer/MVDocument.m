/************************************************
 *  MVDocument.m
 *  MarkdownViewer
 *
 *  Copyright (c) 2012-2014, Chi-En Wu
 *  Distributed under The BSD 3-Clause License
 ************************************************/

#import "MVDocument.h"

@interface MVDocument ()

@property (strong) NSTimer *timer;
@property (strong) NSDate *lastUpdate;
@property (assign) NSPoint scrollPosition;

- (NSDate *)fileUpdateDate;
- (BOOL) isFileUpdated;
- (void) refresh;

- (NSScrollView *) scrollView;
- (void) saveScrollPosition;
- (void) restoreScrollPosition;

@end

@implementation MVDocument

#pragma mark Public Properties

@synthesize webView = _webView;
@synthesize converter = _converter;

#pragma mark Private Properties

@synthesize timer = _timer;
@synthesize lastUpdate = _lastUpdate;
@synthesize scrollPosition = _scrollPosition;

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
    [[self timer] invalidate];

    [super close];
}

- (void) windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    [self setLastUpdate:[NSDate distantPast]];
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:.5
                                                    target:self
                                                  selector:@selector(refresh)
                                                  userInfo:nil
                                                   repeats:YES]];
    [self refresh];
}

- (BOOL) readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError **)outError
{
    [[self converter] setFile:[url path]];
    return YES;
}

- (BOOL) writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
    NSData *source = [[[[self webView] mainFrame] dataSource] data];
    [source writeToFile:[absoluteURL path] atomically:YES];
    return YES;
}

- (BOOL) prepareSavePanel:(NSSavePanel *)savePanel
{
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"html"]];
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

#pragma mark Handling Load Finish

- (void) webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame
{
    [self restoreScrollPosition];
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
    BOOL isUpdated = [lastUpdate compare:[self lastUpdate]] == NSOrderedDescending;
    if (isUpdated)
        [self setLastUpdate:lastUpdate];

    return isUpdated;
}

#pragma mark Saving / Restoring Scroll Position

- (NSScrollView *) scrollView
{
    return [[[[[self webView] mainFrame] frameView] documentView] enclosingScrollView];
}

- (void) saveScrollPosition
{
    [self setScrollPosition:[[[self scrollView] contentView] bounds].origin];
}

- (void) restoreScrollPosition
{
    [[[self scrollView] documentView] scrollPoint:[self scrollPosition]];
}

#pragma mark Refreshing WebView

- (void) refresh
{
    if (![self isFileUpdated])
        return;

    [self saveScrollPosition];

    NSString *path = [[[self fileURL] path] stringByDeletingLastPathComponent];
    [[[self webView] mainFrame] loadHTMLString:[[self converter] preview]
                                       baseURL:[NSURL fileURLWithPath:path]];
}

@end
