//
//  ContentView.swift
//  tapper
//
//  Created by Geoffrey Johnson on 1/1/22.
//

import SwiftUI


struct ContentView: View {
    @State var taps: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.purple
                    .ignoresSafeArea()
            VStack {
                
                Spacer()
                Label("\(taps)", systemImage: "hand.tap.fill")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                    .border(.yellow, width: 7)
                    .cornerRadius(7)
                Spacer()
                Button (action: {
                    taps += 1                }, label:
                {  Image(systemName: "hammer.circle")
                        .resizable()
                        .symbolRenderingMode(.palette)
                        .foregroundStyle(.yellow, .white)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.4)
                        .shadow(color: .black, radius: 5, x: 0, y: 5)

                })
                Spacer()
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
