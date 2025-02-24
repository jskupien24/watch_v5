//
//  BuhlmannCalculator.swift
//  watch_v5
//
//  Created by Jack Skupien on 2/11/25.
//

import SwiftUI
import Foundation

// Gas mixture definition
struct GasMix {
    let fO2: Double  // fraction of oxygen
    let fHe: Double  // fraction of helium
    let fN2: Double  // fraction of nitrogen
    
    init(fO2: Double = 0.21, fHe: Double = 0.0) {
        self.fO2 = fO2
        self.fHe = fHe
        self.fN2 = 1.0 - fO2 - fHe  // nitrogen makes up the remainder
    }
}
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
    // ZHL-16C compartments remain the same as they're already in metric
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
    
    private var tissueLoadings: [[Double]]
    private let gfLow: Double
    private let gfHigh: Double
    
    init(gfLow: Double = 0.4, gfHigh: Double = 0.9) {
        self.gfLow = gfLow
        self.gfHigh = gfHigh
        self.tissueLoadings = Array(repeating: [0.79, 0.0], count: 16)
    }
    
    func calculateNDL(depth: Double, gasMix: GasMix = GasMix()) -> Double {
        // Depth is now in meters, pressure in bar
        let absolutePressure = (depth / 10.0) + 1.0
        var maxTime = 0.0
        
        // Binary search for NDL
        var left = 0.0
        var right = 200.0  // Max NDL time in minutes
        
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
    
    func calculateTissuePressures(depth: Double, time: Double, gasMix: GasMix = GasMix()) -> [[Double]] {
        // Depth in meters, pressure in bar
        let absolutePressure = (depth / 10.0) + 1.0
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
    
    private func calculateMValue(compartment: Compartment, depth: Double) -> Double {
        // Depth in meters, pressure in bar
        let absolutePressure = (depth / 10.0) + 1.0
        let gf = gfLow + ((gfHigh - gfLow) * (depth / 100.0))
        return ((absolutePressure / compartment.b) + compartment.a) * gf
    }
    
    func calculateDecoStops(depth: Double, bottomTime: Double, gasMix: GasMix = GasMix()) -> [(depth: Double, time: Double)] {
        var stops: [(depth: Double, time: Double)] = []
        var currentLoadings = calculateTissuePressures(depth: depth, time: bottomTime, gasMix: gasMix)
        var currentDepth = depth
        
        while currentDepth > 0 {
            let nextDepth = max(currentDepth - 3, 0) // 3m stops
            let stopTime = calculateRequiredStopTime(
                currentLoadings: currentLoadings,
                currentDepth: currentDepth,
                nextDepth: nextDepth,
                gasMix: gasMix
            )
            
            if stopTime > 0 {
                stops.append((currentDepth, stopTime))
                currentLoadings = calculateTissuePressures(
                    depth: currentDepth,
                    time: stopTime,
                    gasMix: gasMix
                )
            }
            
            currentDepth = nextDepth
        }
        
        return stops
    }
    
    private func calculateRequiredStopTime(currentLoadings: [[Double]], currentDepth: Double, nextDepth: Double, gasMix: GasMix) -> Double {
        // All depths in meters, pressures in bar
        let absolutePressure = (currentDepth / 10.0) + 1.0
        let nextPressure = (nextDepth / 10.0) + 1.0
        var requiredStopTime = 0.0
        
        for i in 0..<compartments.count {
            let compartment = compartments[i]
            let currentN2 = currentLoadings[i][0]
            let currentHe = currentLoadings[i][1]
            
            let a = compartment.a
            let b = compartment.b
            let mValue = (currentN2 + currentHe - a * nextPressure) / b
            
            if mValue > nextPressure {
                let targetN2 = (nextPressure * b + a * nextPressure) * 0.9
                let time = compartment.halfTimeN2 * log2(
                    (currentN2 - absolutePressure * gasMix.fN2) /
                    (targetN2 - absolutePressure * gasMix.fN2)
                )
                requiredStopTime = max(requiredStopTime, time)
            }
        }
        
        return ceil(max(requiredStopTime, 0))
    }
    
    func calculateMOD(fO2: Double, maxPO2: Double = 1.4) -> Double {
        // Calculate MOD in meters
        return (((maxPO2 / fO2) - 1.0) * 10)*3.280839895 //converts to feet
    }
    
    func calculateRecreationalLimits(depth: Double, time: Double, o2Percentage: Double = 21) -> DiveResults {
        // Input depth should be in meters
        let gasMix = GasMix(fO2: o2Percentage / 100, fHe: 0.0)
        let ndl = getTestNDL(depth: depth)
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
    
    private func calculateTotalAscentTime(_ stops: [(depth: Double, time: Double)]) -> Double {
        let ascentRate = 10.0 // meters per minute
        let maxDepth = stops.first?.depth ?? 0
        let directAscentTime = maxDepth / ascentRate
        let totalStopTime = stops.reduce(0) { $0 + $1.time }
        return totalStopTime + directAscentTime
    }
}

struct DiveResults {
    let ndl: Double                              // No Decompression Limit in minutes
    let decoStops: [(depth: Double, time: Double)] // Required deco stops (depths in meters)
    let mod: Double                              // Max operating depth in meters
    let totalAscentTime: Double                  // Total time needed for ascent
    let isWithinLimits: Bool                    // Whether dive is within NDL
}

private func getTestNDL(depth: Double) -> Double {
    // Standard recreational dive table values
    let depthFt = depth * 3.28084
    switch depthFt {
    case 0..<35: return 205
    case 35..<40: return 140
    case 40..<50: return 100
    case 50..<60: return 70
    case 60..<70: return 50
    case 70..<80: return 40
    case 80..<90: return 30
    case 90..<100: return 25
    case 100..<110: return 20
    case 110..<120: return 15
    case 120..<130: return 12
    case 130..<140: return 10
    default: return 5
    }
}
