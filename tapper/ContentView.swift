//
//  ContentView.swift
//  tapper
//
//  Created by Geoffrey Johnson on 1/1/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var header = "TAPPER!"
    @State var taps = 0
    @State private var timeRemaining = 20
    @State var gamePlaying = false
    @State private var isActive = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.purple
                    .ignoresSafeArea()
                VStack {
                    Spacer()
                    
                    // Header
                    if !gamePlaying {
                        ZStack {
                            Image(systemName: "bubble.middle.bottom.fill")
                                .resizable()
                                .symbolRenderingMode(.monochrome)
                                .foregroundStyle(.white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.45)
                                .shadow(color: .black, radius: 5, x: 0, y: 5)
                            Text(header)
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .multilineTextAlignment(.center)
                        }
                    }
                    
                    // display timer
                    if gamePlaying {
                        if (timeRemaining <= 5) {
                                Text("Time: \(timeRemaining)")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(Color.white)
                                            .opacity(0.75))
                        } else {
                            Text("Time: \(timeRemaining)")
                                .font(.title)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(Color.yellow)
                                        .opacity(0.75))
                        }
                    }
                    Spacer()
                    
                    // Score
                    Label("\(taps)", systemImage: "hand.tap.fill")
                        .foregroundColor(.white)
                        .font(.system(.largeTitle, design: .rounded))
                        .padding()
                        .border(.yellow, width: 7)
                        .cornerRadius(7)
                        .animation(.interpolatingSpring(stiffness: 50, damping: 1), value: 0.1)

                    Spacer()
                    
                    // Tap Button
                    if gamePlaying {
                        Button (action: {
                            taps += 1
                        },
                                label: {  Image(systemName: "hammer.circle")
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.yellow, .white)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.4)
                                .shadow(color: .black, radius: 5, x: 0, y: 5)
                        })
                            // prevent taps from counting when time runs out
                            .allowsHitTesting(timeRemaining > 0)
                    }
                    
                    //Play button to start game
                    if !gamePlaying {
                        Button(action: {
                            startGame()
                        },
                               label: { Image(systemName: "play.rectangle.fill")
                                .resizable()
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .yellow)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width * 0.3)
                        })
                    }
                    Spacer()
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
            // update timer while game being played and app is active
            .onReceive(timer) { time in
                guard self.isActive else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    endGame()
                }
            }
            // set to inactive when app moves to background
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {_ in self.isActive = false }
            // set to active when app moves to foreground
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                if gamePlaying {
                    self.isActive = true
                }
            }
        }
    }
    
    func startGame() {
        // reset time and taps
        taps = 0
        timeRemaining = 20
        // ∆ game state
        gamePlaying = true
        isActive = true
    }
    
    func endGame() {
        // retrieve existing saved high score and update if new score is higher
        let highScore = UserDefaults.standard.integer(forKey: "HighScore")
        if (taps > highScore) {
            UserDefaults.standard.set(taps, forKey: "HighScore")
            header = "New High\nScore!"
        } else {
            header = "TAPPER!"
        }
        // ∆ game state
        gamePlaying = false
        isActive = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
