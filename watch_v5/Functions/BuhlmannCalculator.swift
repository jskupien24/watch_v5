//
//  BuhlmannCalculator.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/11/25.
//

import SwiftUI
import Foundation

//Tissue compartment data for ZHL-16C
struct Compartment {
    let halfTimeN2: Double    // Nitrogen halftime in minutes
    let halfTimeHe: Double    // Helium halftime in minutes
    let a: Double            // a parameter for nitrogen
    let b: Double            // b parameter for nitrogen
    
    //Gradient factors can be adjusted for conservatism
    static let defaultGfLow = 0.3
    static let defaultGfHigh = 0.8
}

class BuhlmannCalculator: ObservableObject {
    //ZHL-16C compartments (16 tissue compartments)
        private let compartments = [
            Compartment(halfTimeN2: 4.0, halfTimeHe: 1.51, a: 1.2599, b: 0.5050),
            Compartment(halfTimeN2: 8.0, halfTimeHe: 3.02, a: 1.0000, b: 0.6514),
            Compartment(halfTimeN2: 12.5, halfTimeHe: 4.72, a: 0.8618, b: 0.7222),
            Compartment(halfTimeN2: 18.5, halfTimeHe: 6.99, a: 0.7562, b: 0.7825),
            Compartment(halfTimeN2: 27.0, halfTimeHe: 10.21, a: 0.6667, b: 0.8126),
            Compartment(halfTimeN2: 38.3, halfTimeHe: 14.48, a: 0.5933, b: 0.8434),
            Compartment(halfTimeN2: 54.3, halfTimeHe: 20.53, a: 0.5282, b: 0.8693),
            Compartment(halfTimeN2: 77.0, halfTimeHe: 29.11, a: 0.4701, b: 0.8910),
            Compartment(halfTimeN2: 109.0, halfTimeHe: 41.20, a: 0.4187, b: 0.9092),
            Compartment(halfTimeN2: 146.0, halfTimeHe: 55.19, a: 0.3798, b: 0.9222),
            Compartment(halfTimeN2: 187.0, halfTimeHe: 70.69, a: 0.3497, b: 0.9319),
            Compartment(halfTimeN2: 239.0, halfTimeHe: 90.34, a: 0.3223, b: 0.9403),
            Compartment(halfTimeN2: 305.0, halfTimeHe: 115.29, a: 0.2971, b: 0.9477),
            Compartment(halfTimeN2: 390.0, halfTimeHe: 147.42, a: 0.2737, b: 0.9544),
            Compartment(halfTimeN2: 498.0, halfTimeHe: 188.24, a: 0.2523, b: 0.9602),
            Compartment(halfTimeN2: 635.0, halfTimeHe: 240.03, a: 0.2327, b: 0.9653)
        ]
        
        private var tissueLoadings: [[Double]] //[compartment][gas]
        private let gfLow: Double
        private let gfHigh: Double
        
        init(gfLow: Double = 0.4, gfHigh: Double = 0.9) {//changed from 0.3/0.8 to be less conservative with results
            self.gfLow = gfLow
            self.gfHigh = gfHigh
            self.tissueLoadings = Array(repeating: [0.79, 0.0], count: 16)
        }
        
        //Calculate no-decompression limit for a given depth
        func calculateNDL(depth: Double, gasMix: GasMix = GasMix()) -> Double {
            let absolutePressure = (depth / 10.0) + 1.0  //Convert depth to bar
            var maxTime = 0.0
            
            //Binary search for NDL
            var left = 0.0
            var right = 480.0  //increased from 60
            
//            while right - left > 1.0 {
//                let mid = (left + right) / 2
//                let wouldRequireDecoStop = calculateDecoStops(depth: depth,
//                                                            bottomTime: mid,
//                                                            gasMix: gasMix).count > 0
//                if wouldRequireDecoStop {
//                    right = mid
//                } else {
//                    left = mid
//                    maxTime = mid
//                }
//            }
            while right - left > 1.0 {
                    let mid = (left + right) / 2
                    let wouldRequireDecoStop = calculateDecoStops(depth: depth, bottomTime: mid).count > 0
                    if wouldRequireDecoStop {
                        right = mid
                    } else {
                        left = mid
                        maxTime = mid
                    }
                }
                
            return floor(maxTime)
        }
    
        private func calculateRequiredStopTime(currentLoadings: [[Double]],currentDepth: Double,nextDepth: Double,gasMix: GasMix) -> Double {
            let absolutePressure = (currentDepth / 10.0) + 1.0
            let nextPressure = (nextDepth / 10.0) + 1.0
            var requiredStopTime = 0.0
            
            // check for compartment that would exceed its M-value
            for i in 0..<compartments.count {
                let compartment = compartments[i]
                let currentN2 = currentLoadings[i][0]
                let currentHe = currentLoadings[i][1]
                
                //calc tolerated ambient pressure
                let a = compartment.a
                let b = compartment.b
                let mValue = (currentN2 + currentHe - a * nextPressure) / b
                
                if mValue > nextPressure {
                    //calc time needed to off-gas
                    let targetN2 = (nextPressure * b + a * nextPressure) * 0.9 // 90% of limit
                    let time = compartment.halfTimeN2 * log2((currentN2 - absolutePressure * gasMix.fN2) /
                                                           (targetN2 - absolutePressure * gasMix.fN2))
                    requiredStopTime = max(requiredStopTime, time)
                }
            }
            
            //round up to next minute
            return ceil(max(requiredStopTime, 0))
        }
        
        //Calculate tissue pressures after exposure
    func calculateTissuePressures(depth: Double, time: Double, gasMix: GasMix = GasMix()) -> [[Double]] {
        let absolutePressure = (depth / 33.0) + 1.0  // Changed from /10.0 to /33.0
        var newLoadings = tissueLoadings
        
        for i in 0..<compartments.count {
            let compartment = compartments[i]
            
            // Calculate for nitrogen
            let pN2 = absolutePressure * gasMix.fN2
            newLoadings[i][0] = tissueLoadings[i][0] +
                (pN2 - tissueLoadings[i][0]) *
                (1 - pow(2, -time / compartment.halfTimeN2))
            
            // Calculate for helium
            let pHe = absolutePressure * gasMix.fHe
            newLoadings[i][1] = tissueLoadings[i][1] +
                (pHe - tissueLoadings[i][1]) *
                (1 - pow(2, -time / compartment.halfTimeHe))
        }
            
        return newLoadings
    }
        
        //Calculate M-values
//        private func calculateMValue(compartment: Compartment, depth: Double) -> Double {
//            let absolutePressure = (depth / 10.0) + 1.0
////            return (absolutePressure / compartment.b) + compartment.          before GF adjustment on line 48
//            let gf = gfLow + ((gfHigh - gfLow) * (depth / 10.0))
//            return ((absolutePressure / compartment.b) + compartment.a) * gf
//        }
//    private func calculateMValue(compartment: Compartment, depth: Double) -> Double {
//        let absolutePressure = (depth / 33.0) + 1.0  // Changed from /10.0 to /33.0
//        return (absolutePressure / compartment.b) + compartment.a
////        let gf = gfLow + ((gfHigh - gfLow) * (depth / depth))
////        return ((absolutePressure / compartment.b) + compartment.a) * gf
//    }
    private func calculateMValue(compartment: Compartment, depth: Double) -> Double {
        let absolutePressure = (depth / 33.0) + 1.0  // Convert depth to ambient pressure in bar

        // Gradient factor scaling: interpolate GF between low (shallow) and high (deep)
        let gf = gfLow + ((gfHigh - gfLow) * (depth / 100.0))  // Assuming 100m as reference max depth

        return ((absolutePressure / compartment.b) + compartment.a) * gf
    }
        
    //Calculate decompression stops
    func calculateDecoStops(depth: Double, bottomTime: Double, gasMix: GasMix = GasMix()) -> [(depth: Double, time: Double)] {
        var stops: [(depth: Double, time: Double)] = []
        var currentLoadings = calculateTissuePressures(depth: depth, time: bottomTime, gasMix: gasMix)
        var currentDepth = depth
        
        while currentDepth > 0 {
            let nextDepth = max(currentDepth - 3, 0) // 3m stops
            let stopTime = calculateRequiredStopTime(currentLoadings: currentLoadings,
                                                   currentDepth: currentDepth,
                                                   nextDepth: nextDepth,
                                                     gasMix: gasMix)
            
            if stopTime > 0 {
                stops.append((currentDepth, stopTime))
                currentLoadings = calculateTissuePressures(depth: currentDepth,
                                                         time: stopTime,
                                                         gasMix: gasMix)
            }
            
            currentDepth = nextDepth
        }
        
        return stops
    }
        
    //Helper struct for gas mixture
    struct GasMix {
        let fO2: Double
        let fHe: Double
        let fN2: Double
        
        init(fO2: Double = 0.21, fHe: Double = 0.0) {
            self.fO2 = fO2
            self.fHe = fHe
            self.fN2 = 1.0 - fO2 - fHe
        }
    }
    
    //convenience method for basic recreational diving
    func calculateRecreationalLimits(depth: Double, time: Double, o2Percentage: Double = 21) -> DiveResults {
            let gasMix = GasMix(fO2: o2Percentage / 100, fHe: 0.0)  //explicitly set helium to 0
            let ndl = calculateNDL(depth: depth)  // use default gasMix
            let decoStops = calculateDecoStops(depth: depth, bottomTime: time)
            let mod = calculateMOD(fO2: o2Percentage / 100)
            
            return DiveResults(
                ndl: ndl,
                decoStops: decoStops,
                mod: mod,
                totalAscentTime: calculateTotalAscentTime(decoStops),
                isWithinLimits: time <= ndl
            )
        }
    
    //calculate Maximum Operating Depth for a given O2 percentage
    func calculateMOD(fO2: Double, maxPO2: Double = 1.4) -> Double {
        let modInMeters = ((maxPO2 / fO2) - 1.0) * 10
        return modInMeters * 3.28084  // Convert to feet before returning
    }
    
    private func calculateTotalAscentTime(_ stops: [(depth: Double, time: Double)]) -> Double {
        let ascentRate = 10.0 //meters per minute
        let maxDepth = stops.first?.depth ?? 0
            let directAscentTime = maxDepth / ascentRate //calc time based on depth and rate
            let totalStopTime = stops.reduce(0) { $0 + $1.time }
            return totalStopTime + directAscentTime
    }
}

//results structure for the dive calculations
struct DiveResults {
    let ndl: Double                              //no Decompression Limit in minutes
    let decoStops: [(depth: Double, time: Double)] //required deco stops
    let mod: Double                              //max operating depth
    let totalAscentTime: Double                    //total time needed for ascent
    let isWithinLimits: Bool                       //dive is within NDL?
}
