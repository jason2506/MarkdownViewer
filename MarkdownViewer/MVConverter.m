/************************************************
 *  MVConverter.m
 *  MarkdownViewer
 *
 *  Copyright (c) 2012-2014, Chi-En Wu
 *  Distributed under The BSD 3-Clause License
 ************************************************/

#import "MVConverter.h"

@implementation MVConverter

#pragma mark Public Properties

@synthesize file = _file;

#pragma mark Converting Markdown to HTML

- (NSString *) preview
{
    NSString *content = [[NSString alloc] initWithContentsOfFile:[self file]
                                                        encoding:NSUTF8StringEncoding
                                                           error:nil];

    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *templatePath = [resourcePath stringByAppendingString:@"/template.html"];
    NSString *htmlTemplate = [[NSString alloc] initWithContentsOfFile:templatePath
                                                             encoding:NSUTF8StringEncoding
                                                                error:nil];

    NSString *parseResult = [self convertString:content];
    return [NSString stringWithFormat:htmlTemplate, resourcePath, parseResult];
    
}

- (NSString *) convertString:(NSString *)aString
{    
    NSData *data = [aString dataUsingEncoding:NSUTF8StringEncoding];

    Document *document = mkd_string(data.bytes, data.length, 0);
    mkd_compile(document, 0);

    char *html;
    int length = mkd_document(document, &html);

    NSString *result = [[NSString alloc] initWithBytes:html
                                                length:length
                                              encoding:NSUTF8StringEncoding];

    mkd_cleanup(document);

    return result;
}

@end
