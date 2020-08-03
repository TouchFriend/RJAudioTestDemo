//
//  RJPerson.m
//  RJAudioTestDemo
//
//  Created by TouchWorld on 2020/7/28.
//  Copyright © 2020 RJSoft. All rights reserved.
//

#import "RJPerson.h"

@interface RJPerson () {
    float _weight;
}

@end

@implementation RJPerson

- (instancetype)init {
    self = [super init];
    if (self) {
//        self.name = @"cxz";
//        self->_name = @"ddd";
        _name = @"ccc";
//        _age = 13;
//        self->_age = 15;
    }
    return self;
}

@end
