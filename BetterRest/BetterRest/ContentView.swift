//
//  ContentView.swift
//  BetterRest
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 13/04/23.
//

import CoreML
import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var sleepTimeFeedback: String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        let prediction = makePrediction(Double(hour + minute))
        return prediction
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                } header: {
                    Text("When do you want to wake up?")
                }
                
                Section {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                } header: {
                    Text("Desired amount of sleep")
                }
                
                Section {
                    Picker(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", selection: $coffeeAmount) {
                        ForEach(0..<21) {
                            if $0 != 0 {
                                Text($0, format: .number)
                            }
                        }
                    }
                } header: {
                    Text("Daily coffee intake")
                }
                
                Section {
                    Text(sleepTimeFeedback)
                } header: {
                    Text("Your ideal bedtime is:")
                }
                
            }
            .navigationTitle("BetterRest")
            .alert("Error", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                 Text(sleepTimeFeedback)
            }
        }
    }
    
   
    func makePrediction(_ wakeInSeconds: Double) -> String {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let prediction = try model.prediction(
                wake: wakeInSeconds,
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            
            let sleepTime = wakeUp - prediction.actualSleep
            return sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            showingAlert = true
            return "Sorry, there was a problem calculating your bedtime"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
