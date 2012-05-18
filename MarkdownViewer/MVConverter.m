//
//  MVConverter.m
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

#import "MVConverter.h"

static int WRITE_UNIT = 64;
static int MAX_NESTING_LEVEL = 16;

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

    struct sd_callbacks callbacks;
    struct html_renderopt options;

    sdhtml_renderer(&callbacks, &options, 0);
    struct sd_markdown *markdown = sd_markdown_new(0, MAX_NESTING_LEVEL, &callbacks, &options);

    struct buf *outputBuffer = bufnew(WRITE_UNIT);
    sd_markdown_render(outputBuffer, data.bytes, data.length, markdown);

    NSString *result = [[NSString alloc] initWithBytes:outputBuffer->data
                                                length:outputBuffer->size
                                              encoding:NSUTF8StringEncoding];

    bufrelease(outputBuffer);
    sd_markdown_free(markdown);

    return result;
}

@end
