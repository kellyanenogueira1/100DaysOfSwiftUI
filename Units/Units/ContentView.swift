//
//  ContentView.swift
//  Units
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 06/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputValue = 0.0
    @State private var inputValueUnit = UnitType.celsius
    @State private var outsideValueUnit = UnitType.celsius
    @FocusState private var isFocused: Bool
    
    private let units = [UnitType.celsius, UnitType.fahrenheit, UnitType.kelvin]
    
    private enum UnitType {
        static let celsius = "ºC"
        static let fahrenheit = "ºF"
        static let kelvin = "ºK"
    }
    
    private var convertedValue: String {
        let currentValue =  Measurement(value: inputValue, unit: extractUnitTemperature(inputValueUnit))
        let convertedValue = currentValue.converted(to: extractUnitTemperature(outsideValueUnit))
        return String(describing: convertedValue)
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    HStack {
                        TextField("Valor", value: $inputValue, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($isFocused)
                        
                        Picker("", selection: $inputValueUnit) {
                            ForEach(units, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                } header: {
                    Text("Insira um valor: ")
                }
                
                Section {
                    Picker("", selection: $outsideValueUnit) {
                        ForEach(units, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                } header: {
                    Text("Converter para: ")
                }
                
                Section {
                    Text(convertedValue)
                } header: {
                    Text("O valor convertido é: ")
                }
            }
            .navigationTitle("Units")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    
                    Button("Done") {
                        isFocused = false
                    }
                }
            }
        }
    }
    
    private func extractUnitTemperature(_ unit: String) -> UnitTemperature {
        switch unit {
        case UnitType.fahrenheit:
            return UnitTemperature.fahrenheit
        case UnitType.kelvin:
            return UnitTemperature.kelvin
        default:
            return UnitTemperature.celsius
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
