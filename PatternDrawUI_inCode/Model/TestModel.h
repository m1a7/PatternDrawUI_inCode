//
//  TestModel.h
//  PatternDrawUI_inCode
//
//  Created by Uber on 04/04/2018.
//  Copyright © 2018 uber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, strong) NSString* textMainLbl;

@property (nonatomic, assign) float rectWidthInPerFromSuperViewInPortrain;
@property (nonatomic, assign) float rectHeightInPerFromSuperViewInPortrain;

@property (nonatomic, assign) float rectWidthInPerFromSuperViewInLandscape;
@property (nonatomic, assign) float rectHeightInPerFromSuperViewInLandscape;

+ (TestModel*)mockup;

@end
