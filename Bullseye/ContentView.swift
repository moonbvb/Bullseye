//
//  ContentView.swift
//  Bullseye
//
//  Created by Denis Suspicin on 17.07.2020.
//  Copyright © 2020 DenisSuspicin. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    // Properties
    // ==========
    
    //Colors
    let midnightBlue = Color(red: 0.0,
                             green: 0.2,
                             blue: 0.4)
    
    // User interface views
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    var sliderValueRounded: Int {
        Int(sliderValue.rounded())
    }
    var sliderTargetDifference: Int {
        abs(sliderValueRounded - target)
    }
    
    //Game stats
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var round = 1
    
    
    // User interface content and layouts
    var body: some View {
        NavigationView{
            VStack {
                Spacer().navigationBarTitle("🎯 Bullseye 🎯")
                
                // Target row
                HStack {
                    Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
                    Text("\(target)").modifier(ValueStyle())
                }
                
                Spacer()
                
                // Slider row
                HStack {
                    Text("1").modifier(LabelStyle())
                    Slider(value: $sliderValue, in: 0...100)
                        .accentColor(.green)
                        .animation(.easeOut)
                    Text("100").modifier(LabelStyle())
                }
                
                Spacer()
                
                // Button row
                Button(action: {
                    self.alertIsVisible = true
                }) {
                    Text("Hit me!").modifier(ButtonLargeTextStyle())
                }
                .background(Image("Button")
                .modifier(Shadow())
                )
                    .alert(isPresented: $alertIsVisible) {
                        Alert(title: Text(alertTitle()),
                              message: Text(scoringMessage()),
                              dismissButton: .default(Text("Awesome!")) {
                                self.startNewRound()
                            }
                        )
                }
                
                Spacer()
                
                // Score row
                HStack {
                    Button(action: {
                        self.startNewGame()
                    }) {
                        HStack {
                            Image("StartOverIcon")
                            Text("Start over").modifier(ButtonSmallTextStyle())
                        }
                        
                    }
                    .background(Image("Button"))
                    .modifier(Shadow())
                    Spacer()
                    Text("Score:").modifier(LabelStyle())
                    Text("\(score)").modifier(ValueStyle())
                    Spacer()
                    Text("Round:").modifier(LabelStyle())
                    Text("\(round)").modifier(ValueStyle())
                    Spacer()
                    NavigationLink(destination: AboutView()) {
                        HStack {
                            Image("InfoIcon")
                            Text("Info").modifier(ButtonSmallTextStyle())
                        }
                    }
                    .background(Image("Button"))
                    .modifier(Shadow())
                }
                .padding(.bottom, 20)
                .accentColor(midnightBlue)
            }
            .onAppear() {
                self.startNewGame()
            }
            .background(Image("Background"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Methods
    // =======
    func pointsForCurrentRound() -> Int {
        let maximumScore = 100
        
        let points: Int
        switch sliderTargetDifference {
        case 0:
            points = 200
        case 1:
            points = 150
        default:
            points = maximumScore - sliderTargetDifference
        }
        return points
    }
    
    func scoringMessage() -> String {
        return "The slider`s value is \(sliderValueRounded).\n" +
            "The target value is \(target).\n" +
        "You scored \(pointsForCurrentRound()) points this round."
    }
    
    func alertTitle() -> String {
        var title: String
        switch sliderTargetDifference {
        case 0:
            title = "Perfect!"
        case 1...4:
            title = "You almost had it!"
        case 5...10:
            title = "Not bad."
        default:
            title = "Are you even trying?"
        }
        return title
    }
    
    func startNewRound() {
        resetSliderAndTarget()
        score += pointsForCurrentRound()
        round += 1
    }
    
    func startNewGame() {
        resetSliderAndTarget()
        score = 0
        round = 1
    }
    
    func resetSliderAndTarget() {
        target = Int.random(in: 0...100)
        sliderValue = Double.random(in: 0...100)
    }
    
}

//View modifiers
//==============
struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(.white)
            .modifier(Shadow())
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 24))
            .foregroundColor(.yellow)
            .modifier(Shadow())
    }
}

struct Shadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black, radius: 5, x: 2, y: 2)
    }
}

struct ButtonLargeTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 18))
            .foregroundColor(.black)
    }
}

struct ButtonSmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Arial Rounded MT Bold", size: 12))
            .foregroundColor(.black)
        
    }
}
// Preview
// =======

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
