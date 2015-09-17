//
//  UHNBLETypes.h
//  Pods
//
//  Created by Nathaniel Hamming on 2015-02-19.
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

///----------------------------------
/// @name Short Float Type Definition
///----------------------------------
/**
 Defines a short float, which is commonly used in BLE services
 
 @warning Will be moved to the UHNBLEController pod
 */
typedef struct shortFloat {
    char exponent : 4;
    short mantissa : 12;
} shortFloat;

///------------------------------
/// @name Common Field Definitions
///------------------------------
/**
 All possible glucose fluid types with their assigned value
 */
typedef NS_ENUM (uint8_t, GlucoseFluidTypeOption) {
    /** Fluid Type indicating that the glucose measurement was taken from capillary whole blood */
    GlucoseFluidTypeWholeBloodCapillary = 1,
    /** Fluid Type indicating that the glucose measurement was taken from capillary plasma */
    GlucoseFluidTypePlasmaCapillary,
    /** Fluid Type indicating that the glucose measurement was taken from venous whole blood */
    GlucoseFluidTypeWholeBloodVenous,
    /** Fluid Type indicating that the glucose measurement was taken from venous plasma */
    GlucoseFluidTypePlasmaVenous,
    /** Fluid Type indicating that the glucose measurement was taken from arterial whole blood */
    GlucoseFluidTypeWholeBloodArterial,
    /** Fluid Type indicating that the glucose measurement was taken from arterial plasma */
    GlucoseFluidTypePlasmaArterial,
    /** Fluid Type indicating that the glucose measurement was taken from undetermined whole blood */
    GlucoseFluidTypeWholeBloodUndetermined,
    /** Fluid Type indicating that the glucose measurement was taken from undetermined plasma */
    GlucoseFluidTypePlasmaUndetermined,
    /** Fluid Type indicating that the glucose measurement was taken from interstitial fluid */
    GlucoseFluidTypeISF,
    /** Fluid Type indicating that the glucose measurement was taken from control solution */
    GlucoseFluidTypeControlSolution,
};

/**
 All possible glucose sample locations with their assigned value
 */
typedef NS_ENUM (uint8_t, GlucoseSampleLocationOption) {
    /** Sample location indicating that the glucose measurement was taken from the finger */
    GlucoseSampleLocationFinger                = 1,
    /** Sample location indicating that the glucose measurement was taken from an alternative site */
    GlucoseSampleLocationAlternativeSiteTest   = 2,
    /** Sample location indicating that the glucose measurement was taken from the earlobe */
    GlucoseSampleLocationEarlobe               = 3,
    /** Sample location indicating that the glucose measurement was taken with control solution */
    GlucoseSampleLocationControlSolution       = 4,
    /** Sample location indicating that the glucose measurement was taken from subcutaneous tissue */
    GlucoseSampleLocationSubcutaneousTissue    = 5,
    /** Sample location indicating that the location is not available */
    GlucoseSampleLocationNotAvailable          = 15,
};

/**
 Glucose concentration unit types
 */
typedef NS_ENUM (NSUInteger, GlucoseMeasurementGlucoseConcentrationUnits)
{
    GlucoseMeasurementGlucoseConcentrationUnitsKgPerL               = 0,
    GlucoseMeasurementGlucoseConcentrationUnitsMolPerL,
    GlucoseMeasurementGlucoseConcentrationUnitsMgPerDL,
    GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL,
};

