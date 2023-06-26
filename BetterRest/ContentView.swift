//
//  ContentView.swift
//  BetterRest
//
//  Created by Nowroz Islam on 4/6/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    private var bedTime: Date {
        calculateSleep()
    }
    
    private static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("Please pick a time", selection: $wakeUp, displayedComponents: [.hourAndMinute])
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section {
                    Stepper(sleepAmount.formatted(), value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    Picker("Pick the number of coffee cups", selection: $coffeeAmount) {
                        ForEach(1..<21) { num in
                            Text("^[\(num) cup](inflect: true)")
                                .tag(num)
                        }
                    }
                    .labelsHidden()
                    .frame(maxWidth: .infinity, alignment: .trailing)
                } header: {
                    Text("Daily coffee intake")
                }
                
                Section {
                    Text(bedTime.formatted(date: .omitted, time: .shortened))
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                } header: {
                    Text("Bedtime")
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateSleep() -> Date {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let output = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTimeDifference = output.actualSleep
            let sleepTime = wakeUp - sleepTimeDifference
            
            return sleepTime
        } catch {
            fatalError("Failed to predict bedtime.")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
