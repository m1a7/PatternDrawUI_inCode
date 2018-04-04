//
//  TestModel.m
//  PatternDrawUI_inCode
//
//  Created by Uber on 04/04/2018.
//  Copyright © 2018 uber. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (TestModel*)mockup
{
    TestModel* myObject = [[TestModel alloc] init];
    if (myObject) {
        myObject.textMainLbl = @"Hello World bhsbdkfjhskd s gsh h  s fsdf sdjf jksjdhf js jsdhf js jshdfkjh skhdfks  jsdfkjshdfkjhs skdjfhs sdfh";
        
        myObject.rectWidthInPerFromSuperViewInPortrain  = 50.f;
        myObject.rectHeightInPerFromSuperViewInPortrain = 50.f;

        myObject.rectWidthInPerFromSuperViewInLandscape  = 80.f;
        myObject.rectHeightInPerFromSuperViewInLandscape = 80.f;
    } else {
        // error recovery...
    }
    return myObject;
}
@end

