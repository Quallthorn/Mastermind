//
//  ChooseColorsDropDown.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-03-16.
//

import SwiftUI

struct ChooseColorsDropDown: View {
    @Binding var showColors: Bool
    
    var body: some View {
        HStack {
            Text("Colors:")
                .font(.title)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    showColors.toggle()
                }
            }) {
                Image(systemName: "arrow.up")
                    .padding(.horizontal)
                    .font(.largeTitle)
                    .rotationEffect(Angle.degrees(showColors ? 180 : 0))
            }
            .foregroundColor(.white)
            .frame(height: 50)
        }
    }
}
