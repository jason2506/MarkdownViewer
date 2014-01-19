/************************************************
 *  MVConverter.h
 *  MarkdownViewer
 *
 *  Copyright (c) 2012-2014, Chi-En Wu
 *  Distributed under The BSD 3-Clause License
 ************************************************/

#import <Foundation/Foundation.h>

#import "markdown.h"

@interface MVConverter : NSObject

@property (strong) NSString *file;

- (NSString *) preview;
- (NSString *) convertString:(NSString *)aString;

@end
