//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 07/04/23.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct ContentView: View {
    
    @State private var showingFeedback = false
    @State private var wasFinished = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var answerSelected = ""
    @State private var isAnimate = false
    
    var body: some View {

        ZStack() {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack()  {
                        Text("Tap the flag of")
                            .foregroundColor(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            answerSelected = countries[number]
                        } label: {
                            FlagImage(imageName: countries[number]) // Animation - Day 34
                                .rotation3DEffect(
                                    .degrees(answerSelected == countries[number] ? 360 : 0),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .opacity(
                                    answerSelected != countries[number] && isAnimate ? 0.25 : 1
                                )
                                .scaleEffect(answerSelected != countries[number] && isAnimate ? 0.8 : 1)
                                .animation(.default.delay(0.5), value: 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        
        .alert(scoreTitle, isPresented: $showingFeedback) {
            Button("Continue", action: askQuestion)
        } message: {
             Text("That's flag of \(answerSelected)")
        }
        
        .alert(scoreTitle, isPresented: $wasFinished) {
            Button("Restart", action: reset)
        } message: {
             Text("Your score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        isAnimate = true // Animation - Day 34
        if number == correctAnswer {
            scoreTitle = "Correct"
            score+=1
        } else {
            scoreTitle = "Wrong"
        }
        checkScore()
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isAnimate = false // Animation - Day 34
    }
    
    func checkScore() {
        if score == 8 {
            showingFeedback = false
        } else {
            showingFeedback = true
        }
        wasFinished = !showingFeedback
    }
    
    func reset() {
        score = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
