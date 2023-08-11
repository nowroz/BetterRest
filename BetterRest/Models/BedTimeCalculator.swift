//
//  BedTimeCalculator.swift
//  BetterRest
//
//  Created by Nowroz Islam on 11/8/23.
//

import CoreML
import Foundation

@Observable class BedTimeCalculator {
    var wakeUpTime: Date
    var sleepAmount: Double
    var coffeeAmount: Int
    
    init() {
        var components = DateComponents()
        components.hour = 7
        
        self.wakeUpTime = Calendar.current.date(from: components) ?? Date.now
        self.sleepAmount = 8
        self.coffeeAmount = 1
    }
}

extension BedTimeCalculator {
    var bedtime: Date {
        let config = MLModelConfiguration()
        guard let model = try? SleepTimeEstimator(configuration: config) else {
            fatalError("Failed to initialize the ML model.")
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
        guard let hour = components.hour, let minute = components.minute else {
            fatalError("Failed to retrieve hour and/or minute.")
        }
        
        let hoursInSeconds = Double(hour) * 60 * 60
        let minutesInSeconds = Double(minute) * 60
        
        guard let prediction = try? model.prediction(wake: hoursInSeconds + minutesInSeconds, estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)) else {
            fatalError("Failed to predict.")
        }
        
        let sleepTimeInSeconds = prediction.actualSleep
        
        return wakeUpTime - sleepTimeInSeconds
    }
}
