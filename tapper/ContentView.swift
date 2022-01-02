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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var gamePlaying = false
    @State private var isActive = false

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
                            .frame(width: geometry.size.width * 0.4)
                            .shadow(color: .black, radius: 5, x: 0, y: 5)
                        Text(header)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                    }
                }
                
                // display timer
                if gamePlaying {
                    Text("Time: \(timeRemaining)")
                        .font(.title)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(
                                Capsule()
                                    .fill(Color.yellow)
                                    .opacity(0.75))
                }

                
                Spacer()
                
                // Score
                Label("\(taps)", systemImage: "hand.tap.fill")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                    .border(.yellow, width: 7)
                    .cornerRadius(7)
                
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
            .allowsHitTesting(timeRemaining > 0)
            }
            // update timer while game being played and app is active
                .onReceive(timer) { time in
                    guard self.isActive else { return }
                    if self.timeRemaining > 0 {
                        self.timeRemaining -= 1
                    } else {
                        gamePlaying = false
                        isActive = false
                    }
                }
            // set to inactive when app moves to background
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) {_ in self.isActive = false }
            // set to active when app moves to foreground
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    if gamePlaying {
                        self.isActive = true
                    }  }
        }
    }
    
    func startGame() {
        taps = 0
        timeRemaining = 20
        gamePlaying = true
        isActive = true
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
