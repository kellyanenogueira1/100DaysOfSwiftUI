//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 11/04/23.
//

import SwiftUI

struct OptionView: View {
    var option: String
    
    var body: some View {
        Text(option)
            .font(.largeTitle)
            .padding(20)
            .background(Color(red: 218/255, green: 0/255, blue: 16/255))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 6)
    }
}

struct ContentView: View {
    @State private var options = [Option.rock, Option.paper, Option.scissors].shuffled()
    @State private var gameOptionIndex = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var gameOption = ""
    @State private var correctAnswer = ""
    @State private var score = 0
    @State private var showFeedback = false
    
    private let buttons = [Option.rock, Option.paper, Option.scissors]
    
    private enum Option {
        static let rock = "👊🏻"
        static let paper = "🖐🏻"
        static let scissors = "✌🏻"
    }
    
    var body: some View {
        ZStack() {
            LinearGradient(
                colors: [Color.white,
                         Color(red: 255/255, green: 243/255, blue: 224/255),
                         Color(red: 251/255, green: 208/255, blue: 123/255)],
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
            
            VStack {
                Text("♥️ \(score)")
                    .font(.title.weight(.semibold))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                VStack {
                    Text("Treine seu cérebro")
                        .font(.system(size: 38).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 4)
                    // Verificar se é melhor deixar
                    Text("Pedra, Papel ou Tesoura")
                        .font(.system(size: 24).weight(.medium))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                }.padding(.vertical, 24)
                
                Spacer()
                
                VStack {
                    Text(options[gameOptionIndex])
                        .font(.system(size: 76))
                        .padding(48)
                        .background(Color(red: 251/255, green: 208/255, blue: 123/255))
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                }
                .padding(48)
                
                Spacer()
                
                Text((shouldWin ? "Qual é a opção que perde?" : "Qual é a opção que ganha?"))
                    .font(.system(size: 24).weight(.medium))
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    ForEach(0..<3) { index in
                        Button {
                            buttonTapped(index)
                        } label: {
                            OptionView(option: buttons[index])
                        }
                    }
                }
                
                Spacer()
                
                .alert("Parabéns!", isPresented: $showFeedback) {
                    Button("Jogar de novo", action: reset)
                } message: {
                     Text("Você finalizou o jogo.")
                }
            }
            .padding(24)
        }
    }
    
    private func buttonTapped(_ index: Int) {
        shouldWin.toggle()
        options.shuffle()
        shouldWin ? checkAnswerIfTrue() : checkAnswerIfFalse()
        gameOption = options[gameOptionIndex]
        isCorrect(buttons[index])
    }
    
    private func isCorrect(_ optionSelected: String) {
        if optionSelected == correctAnswer {
            score += 1
        } else {
            score -= 1
        }
        wasFinished()
    }
    
    private func wasFinished() {
        if score == 10 {
            showFeedback = true
        } else {
            showFeedback = false
        }
    }
    
    private func reset() {
        score = 0
        shouldWin.toggle()
        options.shuffle()
    }
    
    private func checkAnswerIfTrue() {
        switch gameOption {
        case Option.rock:
            correctAnswer = Option.paper
        case Option.paper:
            correctAnswer = Option.scissors
        case Option.scissors:
            correctAnswer =  Option.rock
        default: break
        }
    }
    
    private func checkAnswerIfFalse() {
        switch gameOption {
        case Option.rock:
            correctAnswer = Option.scissors
        case Option.paper:
            correctAnswer = Option.rock
        case Option.scissors:
            correctAnswer =  Option.paper
        default: break
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
