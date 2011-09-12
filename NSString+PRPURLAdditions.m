/***
 * Excerpted from "iOS Recipes",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/cdirec for more book information.
***/
//
//  NSString+PRPURLAdditions.m
//  MultipartHTTPPost
//
//  Created by Matt Drance on 9/24/10.
//  Copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import "NSString+PRPURLAdditions.h"

@implementation NSString (PRPURLAdditions) 

- (NSString *)prp_URLEncodedFormStringUsingEncoding:(NSStringEncoding)enc {
    NSString *escapedStringWithSpaces = 
    [self prp_percentEscapedStringWithEncoding:enc
                                   additionalCharacters:@"&=+"
                                      ignoredCharacters:nil];
    return escapedStringWithSpaces;
}

- (NSString *)prp_percentEscapedStringWithEncoding:(NSStringEncoding)enc
                              additionalCharacters:(NSString *)add
                                 ignoredCharacters:(NSString *)ignore {
    CFStringEncoding convertedEncoding = 
        CFStringConvertNSStringEncodingToEncoding(enc);
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                        kCFAllocatorDefault,
                                                        (CFStringRef)self,
                                                        (CFStringRef)ignore,
                                                        (CFStringRef)add,
                                                        convertedEncoding)
            autorelease];
}

@end
