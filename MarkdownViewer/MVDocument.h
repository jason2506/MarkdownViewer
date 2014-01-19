/************************************************
 *  MVDocument.h
 *  MarkdownViewer
 *
 *  Copyright (c) 2012-2014, Chi-En Wu
 *  Distributed under The BSD 3-Clause License
 ************************************************/

#import <Cocoa/Cocoa.h>
#import <Webkit/WebKit.h>

#import "MVConverter.h"

@interface MVDocument : NSDocument

@property (strong) IBOutlet WebView *webView;
@property (strong) MVConverter *converter;

@end
