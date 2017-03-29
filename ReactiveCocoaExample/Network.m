    //
    //  Network.m
    //  ReactiveCocoaExample
    //
    //  Created by Arash on 3/28/17.
    //  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
    //

#import "Network.h"
#import "Model.h"
@interface Network()
@property (strong, nonatomic) Model*model;
@end

@implementation Network
    
- (RACSignal *)fetchDate{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL* url = [NSURL URLWithString:[self getBaseUrl]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        NSURLSessionDataTask *dataTask = [urlSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                           if (!error) {
                                                               NSError* err;
                                                               NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                                    options:kNilOptions
                                                                                                                      error:&err];
                                                               
                                                               NSString *dateString = [[json objectForKey:@"data"]objectForKey:@"date"];
                                                               if (err) {
                                                                   NSLog(@"Unable to decode json, %@", err.localizedDescription);
                                                                   [subscriber sendError:error];
                                                               }
                                                               
                                                               [subscriber sendNext:dateString];
                                                               [subscriber sendCompleted];
                                                           } else {
                                                               [subscriber sendError:error];
                                                           }
                                                           
                                                       }];
        [dataTask resume];
        return nil;
    }];
}
    
- (NSString *)getBaseUrl{
    return @"http://localhost:3000/getCurrentDate";
}
@end
