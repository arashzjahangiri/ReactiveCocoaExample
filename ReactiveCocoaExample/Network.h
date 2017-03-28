//
//  Network.h
//  ReactiveCocoaExample
//
//  Created by Arash on 3/28/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface Network : NSObject
- (RACSignal *)fetchDate;
@end
