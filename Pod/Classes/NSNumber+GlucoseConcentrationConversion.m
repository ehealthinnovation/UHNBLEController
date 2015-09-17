//
//  NSNumber+GlucoseConcentrationConversion.h
//  UHNBGMController
//
//  Created by Adrian de Almeida on 2015-03-31.
//  Copyright (c) 2015 University Health Network.
//

#import "NSNumber+GlucoseConcentrationConversion.h"

@implementation NSNumber (GlucoseConcentrationConversion)

- (NSNumber *) convertGlucoseConcentrationFromUnits:(GlucoseMeasurementGlucoseConcentrationUnits) fromUnits toUnits:(GlucoseMeasurementGlucoseConcentrationUnits) toUnits;
{
    NSNumber *newValue = nil;

    switch (fromUnits)
    {
        case GlucoseMeasurementGlucoseConcentrationUnitsKgPerL:
        {
            NSNumber *mgPerDLValue = [self convertFromKgPerLToMgPerDL];
            
            switch (toUnits)
            {
                case GlucoseMeasurementGlucoseConcentrationUnitsKgPerL:
                default:
                {
                    newValue = self;
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMolPerL:
                {
                    NSNumber *mmolPerLValue = [mgPerDLValue convertFromMgPerDLToMMolPerL];
                    newValue = [mmolPerLValue convertFromMmolPerLToMolPerL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMgPerDL:
                {
                    newValue = mgPerDLValue;
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL:
                {
                    newValue = [mgPerDLValue convertFromMgPerDLToMMolPerL];
                    break;
                }
            }
            break;
        }
        case GlucoseMeasurementGlucoseConcentrationUnitsMolPerL:
        {
            NSNumber *mmolPerLValue = [self convertFromMolPerLToMmolPerL];
            
            switch (toUnits)
            {
                case GlucoseMeasurementGlucoseConcentrationUnitsKgPerL:
                default:
                {
                    NSNumber *mgPerDLValue = [mmolPerLValue convertFromMmolPerLToMgPerDL];
                    newValue = [mgPerDLValue convertFromMgPerDLToKgPerL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMolPerL:
                {
                    newValue = self;
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMgPerDL:
                {
                    newValue = [mmolPerLValue convertFromMmolPerLToMgPerDL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL:
                {
                    newValue = mmolPerLValue;
                    break;
                }
            }
            break;
        }
        case GlucoseMeasurementGlucoseConcentrationUnitsMgPerDL:
        {
            switch (toUnits)
            {
                case GlucoseMeasurementGlucoseConcentrationUnitsKgPerL:
                default:
                {
                    newValue = [self convertFromMgPerDLToKgPerL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMolPerL:
                {
                    NSNumber *mmolPerLValue = [self convertFromMgPerDLToMMolPerL];
                    newValue = [mmolPerLValue convertFromMmolPerLToMolPerL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMgPerDL:
                {
                    newValue = self;
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL:
                {
                    newValue = [self convertFromMgPerDLToMMolPerL];;
                    break;
                }
            }
            break;
        }
        case GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL:
        {
            switch (toUnits)
            {
                case GlucoseMeasurementGlucoseConcentrationUnitsKgPerL:
                default:
                {
                    NSNumber *mgPerDLValue = [self convertFromMmolPerLToMgPerDL];
                    newValue = [mgPerDLValue convertFromMgPerDLToKgPerL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMolPerL:
                {
                    newValue = [self convertFromMmolPerLToMolPerL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMgPerDL:
                {
                    newValue = [self convertFromMmolPerLToMgPerDL];
                    break;
                }
                case GlucoseMeasurementGlucoseConcentrationUnitsMmolPerL:
                {
                    newValue = self;
                    break;
                }
            }
            break;
        }
    }
    
    return newValue;
}

- (NSNumber *) convertFromKgPerLToMgPerDL;
{
    return [NSNumber numberWithFloat:([self floatValue] * 100000.0)];
}

- (NSNumber *) convertFromMolPerLToMmolPerL;
{
    return [NSNumber numberWithFloat:([self floatValue] * 1000.0)];
}

- (NSNumber *) convertFromMgPerDLToKgPerL;
{
    return [NSNumber numberWithFloat:([self floatValue] / 100000.0)];
}

- (NSNumber *) convertFromMmolPerLToMolPerL;
{
    return [NSNumber numberWithFloat:([self floatValue] / 1000.0)];
}

- (NSNumber *) convertFromMgPerDLToMMolPerL;
{
    return [NSNumber numberWithFloat:([self floatValue] / 18.02)];
}

- (NSNumber *) convertFromMmolPerLToMgPerDL;
{
    return [NSNumber numberWithFloat:([self floatValue] * 18.02)];
}

@end
