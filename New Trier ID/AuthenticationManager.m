//
//  AuthenticationManager.m
//  New Trier ID
//
//  Created by Jack Serrino on 11/2/13.
//  Copyright (c) 2013 Jack Serrino. All rights reserved.
//

#import "AuthenticationManager.h"
#import "curl.h"

@implementation AuthenticationManager

- (NSString *) getBarcodeFromID:(NSString *)idNumber
{
    int year = [[idNumber substringToIndex:4] intValue];
    NSDate *date = [[NSDate date] dateByAddingTimeInterval:(NSTimeInterval) (60*60*24*183)];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:NSYearCalendarUnit fromDate:date];
    int year2 = (int) [components year];
    [_prefs setInteger:year2 forKey:@"schoolYear"];
    int prefix = 100*(2-((year-year2)/2));
    return [NSString stringWithFormat:@"%d%@1",prefix,idNumber];
}

- (void) finish:(BOOL)authenticated withErrorOrNil:(NSString *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_callback finishedAuthentication:authenticated withErrorOrNil:error];
    });
}

struct url_data {
    size_t size;
    char* data;
};

- (NSData *) dataFromStruct:(struct url_data *)data
{
    return [NSData dataWithBytesNoCopy:data->data length:data->size freeWhenDone:YES];
}

size_t write_data(void *ptr, size_t size, size_t nmemb, struct url_data *data) {
    size_t index = data->size;
    size_t n = (size * nmemb);
    char* tmp;
    
    data->size += (size * nmemb);

    tmp = realloc(data->data, data->size);
    
    if(tmp) {
        data->data = tmp;
    } else {
        if(data->data) {
            free(data->data);
        }
        fprintf(stderr, "Failed to allocate memory.\n");
        exit(1);
    }
    
    memcpy((data->data + index), ptr, n);
    
    return size * nmemb;
}

- (struct url_data) prepareStruct
{
    struct url_data data;
    data.size = 0;
    data.data = malloc(4096);
    return data;
}

- (NSString*)generateRandomString:(int)num {
    NSMutableString* string = [NSMutableString stringWithCapacity:num];
    for (int i = 0; i < num; i++) {
        [string appendFormat:@"%C", (unichar)('a' + arc4random_uniform(25))];
    }
    return string;
}

- (void) authenticateUser:(NSString *)user withPassword:(NSString *)password delegate:(id<AuthenticationReceiver>)delegate
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *cookieFile = [documentsDirectory stringByAppendingPathComponent:[self generateRandomString:16]];
    _prefs = [NSUserDefaults standardUserDefaults];
    _callback = delegate;
    
    CURL *handle = curl_easy_init();
    if (!handle)
    {
        [self finish:NO withErrorOrNil:@"Error connecting to server"];
        return;
    }
    struct url_data req0 = [self prepareStruct];
    struct url_data req1 = [self prepareStruct];
    struct url_data req2 = [self prepareStruct];
    struct url_data req3 = [self prepareStruct];
    struct url_data req4 = [self prepareStruct];
    struct url_data req5 = [self prepareStruct];
    
    const char * barcodeURL = [[NSString stringWithFormat:@"http://barcodes4.me/barcode/c39/%@.png?width=400&height=90&IsTextDrawn=1&IsBorderDrawn=1", [self getBarcodeFromID:user]] UTF8String];
    curl_easy_setopt(handle, CURLOPT_URL, barcodeURL);
    curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, write_data);
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, &req0);
    curl_easy_perform(handle);
    NSData *barcodeImageData = [self dataFromStruct:&req0];
    [_prefs setObject:barcodeImageData forKey:@"barcodeImage"];
    
    
    curl_easy_setopt(handle, CURLOPT_URL, "https://onlinefiles.nths.net");
    curl_easy_setopt(handle, CURLOPT_COOKIEJAR, [cookieFile UTF8String]);
    curl_easy_setopt(handle, CURLOPT_COOKIEFILE, [cookieFile UTF8String]);
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, &req1);
    curl_easy_perform(handle);
    free(req1.data);
    
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, &req2);
    curl_easy_setopt(handle, CURLOPT_URL, "https://onlinefiles.nths.net/admin/");
    curl_easy_perform(handle);
    free(req2.data);
    
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, &req3);
    curl_easy_setopt(handle, CURLOPT_USERNAME, [user UTF8String]);
    curl_easy_setopt(handle, CURLOPT_PASSWORD, [password UTF8String]);
    curl_easy_perform(handle);
    NSString *authorized = [[NSString alloc] initWithData:[self dataFromStruct:&req3] encoding:NSASCIIStringEncoding];
    if (!([authorized rangeOfString:@"not authorized"].location == NSNotFound))
    {
        [self finish:NO withErrorOrNil:nil];
        return;
    }
    
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, &req4);
    curl_easy_setopt(handle, CURLOPT_URL, "https://onlinefiles.nths.net/admin/default.asp?txtInitial=0&amp;");
    curl_easy_perform(handle);
    NSString *nameFinder = [[NSString alloc] initWithData:[self dataFromStruct:&req4] encoding:NSASCIIStringEncoding];
    NSRange i = [nameFinder rangeOfString:@"vtxtFromName=\""];
    NSRange j = [nameFinder rangeOfString:@"\"" options:NSLiteralSearch range:NSMakeRange(i.location+i.length+2, 1000)];
    NSString *name = [nameFinder substringWithRange:NSMakeRange(i.location+i.length, j.location-(i.location+i.length))];
    [_prefs setObject:name forKey:@"fullName"];
    
    curl_easy_setopt(handle, CURLOPT_WRITEDATA, &req5);
    const char * imageURL = [[NSString stringWithFormat:@"https://onlinefiles.nths.net/admin/in-openpicture.asp?FileUserID=%@",user] UTF8String];
    curl_easy_setopt(handle, CURLOPT_URL, imageURL);
    curl_easy_perform(handle);
    NSData *pictureImageData = [self dataFromStruct:&req5];
    
    [_prefs setObject:pictureImageData forKey:@"pictureImage"];
    [_prefs setObject:user forKey:@"idNumber"];
    [_prefs synchronize];
    
    [self finish:YES withErrorOrNil:nil];
    remove([cookieFile UTF8String]);
    
    curl_easy_cleanup(handle);
    return;
}


@end
