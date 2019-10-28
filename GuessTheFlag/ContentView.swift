//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Conner Shannon on 10/13/19.
//  Copyright © 2019 Conner Shannon. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var message = ""
    @State private var xDegrees = 0.0
    @State private var opacity = 1.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 2)
                    }
                    .rotation3DEffect(.degrees(number == self.correctAnswer ? self.xDegrees : 0), axis: (x: 1, y: 0, z: 0))
                    .opacity(number != self.correctAnswer ? self.opacity : 1)
                }
                
                Text("Score: \(score)")
                Spacer()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text(message), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                    })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            self.opacity = 0.2
        }
        
        if (number == correctAnswer) {
            withAnimation {
                self.xDegrees += 360
            }
            scoreTitle = "Correct"
            score += 1
            message = "Your score is now \(score)."
        } else {
            scoreTitle = "Wrong answer"
            message = "That's the flag of \(countries[number]). Your score is \(score)."
        }
        showingScore = true
    }
    
    func askQuestion() {
        withAnimation {
            self.opacity = 1.0
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
