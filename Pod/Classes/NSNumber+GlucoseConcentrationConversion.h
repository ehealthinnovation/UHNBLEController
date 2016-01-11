//
//  NSNumber+GlucoseConcentrationConversion.h
//  UHNBGMController
//
//  Created by Adrian de Almeida on 2015-03-31.
//  Copyright (c) 2015 University Health Network.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import "UHNBLETypes.h"

/**
 `NSDictionary+GlucoseConcentrationConversion` includes helper methods to converts a glucose concentration values
 */
@interface NSNumber (GlucoseConcentrationConversion)

/**
 Converts a glucose value from one unit to another.  Available units can be found in `UHNBLETypes.h` and include kg / L, mol / L, mg / dL and mmol / L.

 
 @param fromUnits   The units to convert the glucose value from
 @param toUnits     The units to convert the glucose value to
 
 @returns The glucose value for the requested units as a `NSNumber`
 
 */
- (NSNumber *) convertGlucoseConcentrationFromUnits:(GlucoseMeasurementGlucoseConcentrationUnits) fromUnits toUnits:(GlucoseMeasurementGlucoseConcentrationUnits) toUnits;

@end
