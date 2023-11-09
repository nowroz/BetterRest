//
//  ContentView.swift
//  BetterRest
//
//  Created by Nowroz Islam on 11/8/23.
//

import SwiftUI

struct ContentView: View {
    @Bindable var calculator: BedTimeCalculator = .init()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("When do you want to wake up?") {
                    DatePicker("Time", selection: $calculator.wakeUpTime, displayedComponents: [.hourAndMinute])
                }
                
                Section("Desired amount of sleep?") {
                    Stepper("\(calculator.sleepAmount.formatted()) hours", value: $calculator.sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section("Daily coffee intake?") {
                    Stepper("^[\(calculator.coffeeAmount) cup](inflect: true)", value: $calculator.coffeeAmount, in: 1...20)
                        .foregroundStyle(calculator.coffeeAmount > 4 ? .red : .primary)
                }
                
                Section("Estimated Bedtime") {
                    Text(calculator.bedtime.formatted(date: .omitted, time: .shortened))
                        .frame(maxWidth: .infinity)
                        .font(.title.weight(.heavy))
                        .foregroundStyle(.secondary)
                }
            }
            .navigationTitle("BetterRest")
        }
    }
}

#Preview {
    ContentView()
}
