//
//  ColorSelection.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-03-16.
//

import SwiftUI

struct ColorSelection: View {
    @ObservedObject var game: GameInfo
    @Binding var showColors: Bool
    @Binding var changedColor: Bool
    @State var colorGridHeight : CGFloat = 0
    @State var colorsAmount = 8
    
    var body: some View {
        VStack(spacing: 0) {
            
            ChooseColorsDropDown(showColors: $showColors)
                .foregroundColor(.white)
                .background(Color(red: 218/256, green: 58/256, blue: 46/256))
                .cornerRadius(15, corners: [.topLeft, .topRight])
                .padding(.horizontal)
            
                VStack {
                    GeometryReader { geo in
                        VStack(spacing: 0) {
                            Spacer(minLength: geo.size.height/31)
                            ForEach (game.gridBooleanList) { row in
                                HStack(spacing: 0) {
                                    Spacer(minLength: geo.size.width/17)
                                    ForEach (row.row) { button in
                                        ColorBooleanView(buttonValues: button, diameter: geo.size.width*3/17, selected: button.active, colorsAmount: $colorsAmount, changedColor: $changedColor)
                                        Spacer(minLength: geo.size.width/17)
                                    }
                                }
                                Spacer(minLength: geo.size.height/31)
                            }
                            
                        }
                        .onChange(of: geo.size.width) { _ in
                            colorGridHeight = geo.size.width*6/4
                        }
                    }
                    .frame(height: colorGridHeight)
                }
                .foregroundColor(.white)
                .background(Color(red: 80/256, green: 80/256, blue: 80/256))
                .padding(.horizontal)
                .scaleEffect(y: showColors ? 1 : 0, anchor: .top)
            
            Rectangle()
                .foregroundColor(Color(red: 218/256, green: 58/256, blue: 46/256))
                .cornerRadius(15, corners: [.bottomLeft, .bottomRight])
                .padding(.horizontal)
                .frame(height: 50)
                .offset(y: showColors ? 0 : -colorGridHeight)
        }
    }
}

struct ColorBooleanView: View {
    var buttonValues: ColorBoolean
    let diameter: CGFloat
    
    @State var selected: Bool
    @Binding var colorsAmount: Int
    @Binding var changedColor: Bool
    
    var body: some View {
        Button(action: {
            if colorsAmount > 4 || !buttonValues.active {
                buttonValues.active.toggle()
                selected = buttonValues.active
                colorsAmount += selected ? 1 : -1
                changedColor = true
            }
        }, label: {
            ZStack {
                Circle()
                    .foregroundColor(buttonValues.color)
                    .frame(width: diameter, height: diameter)

                Image(systemName: selected ? "circle" : "nosign")
                    .resizable()
                    .frame(width: diameter, height: diameter)
                    .foregroundColor(selected ? .white : .black)
            }
        })
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
