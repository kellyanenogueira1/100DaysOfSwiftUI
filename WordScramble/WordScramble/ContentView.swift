//
//  ContentView.swift
//  WordScramble
//
//  Created by Maria Kellyane da Silva Nogueira Sá on 14/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var useWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Enter your word", text: $newWord)
                        .autocapitalization(.none)
                }
                
                Section {
                    ForEach(useWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
                
                Section {
                    Text("\(score)")
                } header: {
                    Text("Score")
                }
            }
            .navigationTitle(rootWord)
            .toolbar {
                Button("Restart", action: startGame)
            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        
        guard isNotEqualRootWord(word: answer) else {
            wordError(title: "Word is equal", message: "You can't put the initial word")
            return
        }
        
        guard isGreaterThanThree(word: answer) else {
            wordError(title: "Word is shorter than three", message: "Put the greater word")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not recongnize", message: "You can't just make them up, you know!")
            return
        }
        
        withAnimation {
            useWords.insert(answer, at: 0)
        }
        
        changeScore(word: answer)
        newWord = ""
    }
    
    private func startGame() {
        clean()
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allwords = startWords.components(separatedBy: "\n")
                rootWord = allwords.randomElement() ?? "silkworm"
                return
            }
        }
        
        fatalError("Could not load start.txt from bundle.")
    }
    
    private func clean(){
        newWord = ""
        useWords = []
        score = 0
    }
    
    private func changeScore(word: String) {
        if word.count >= 5 {
            score+=2
        } else {
            score+=1
        }
    }
    
    private func isGreaterThanThree(word: String) -> Bool {
        word.count > 3
    }
    
    private func isNotEqualRootWord(word: String) -> Bool {
        !(word == rootWord)
    }
    
    private func isOriginal(word: String) -> Bool {
        !useWords.contains(word)
    }
    
    private func isPossible(word: String) -> Bool {
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    private func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    private func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
