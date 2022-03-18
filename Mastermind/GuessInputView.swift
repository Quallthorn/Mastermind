//
//  GuessInputView.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-03-11.
//

import SwiftUI

struct GuessInputView: View {
    @ObservedObject var game : GameInfo
    @State var fullView = true
    @Binding var portrait : Bool
    @State var buttonDiameter : CGFloat = 0
    @State var colorGridHeight : CGFloat = 0
    
    var body: some View {
        VStack {
            //Displays current attempt number
            HStack{
                Text("Guess: \(game.guessNr)")
                    .font(.title)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                Spacer()
                
                if portrait {
                    Button(action: {
                        withAnimation {
                            fullView.toggle()
                        }
                    }) {
                        Image(systemName: "arrow.up")
                            .padding(.horizontal)
                            .font(.largeTitle)
                            .rotationEffect(Angle.degrees(fullView ? 180 : 0))
                    }
                    .foregroundColor(.white)
                }
            }
            
            //GuessInput
            HStack(spacing: 0) {
                Spacer()
                ForEach(game.curGuess) { code in
                    CurGuessButton(game: game, color: game.colorList[code.color].color, pos: code.pos)
                }
                Spacer()
            }
            
            line()
            
            if fullView {
                VStack {
                    
                    
                    if game.colorList.count > 8 {
                        GeometryReader { geo in
                            VStack(spacing: 4) {
                                ForEach (game.gridColorList) { row in
                                    HStack(spacing: 4) {
                                        Spacer()
                                        ForEach (row.row) { button in
                                            ColorPickButton(game: game, color: button.color, index: button.index, diameter: buttonDiameter)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .onChange(of: game.colorList) { _ in
                                buttonDiameter = geo.size.width/CGFloat((game.colorList.count)/game.gridColorList.count)-CGFloat(4*game.gridColorList.count)
                                colorGridHeight = buttonDiameter*(CGFloat(game.gridColorList.count))+CGFloat(4*game.gridColorList.count)
                            }
                            .onChange(of: geo.size.width) { _ in
                                buttonDiameter = geo.size.width/CGFloat((game.colorList.count)/game.gridColorList.count)-CGFloat(4*game.gridColorList.count)
                                colorGridHeight = buttonDiameter*(CGFloat(game.gridColorList.count))+CGFloat(4*game.gridColorList.count)
                            }
                            .onAppear(perform: {
                                buttonDiameter = geo.size.width/CGFloat((game.colorList.count)/game.gridColorList.count)-CGFloat(4*game.gridColorList.count)
                                colorGridHeight = buttonDiameter*(CGFloat(game.gridColorList.count))+CGFloat(4*game.gridColorList.count)
                            })
                        }
                        .frame(height: colorGridHeight)
                    } else {
                        GeometryReader { geo in
                                HStack(spacing: geo.size.width/(CGFloat(game.colorList.count*game.colorList.count-1))) {
                                    Spacer()
                                    ForEach (game.gridColorList) { row in
                                        ForEach (row.row) { button in
                                            ColorPickButton(game: game, color: button.color, index: button.index, diameter: geo.size.width/((CGFloat(game.colorList.count)+1)))
                                        }
                                    }
                                    Spacer()
                                }
                        
                            .onChange(of: geo.size.width) { _ in
                                buttonDiameter = geo.size.width/CGFloat((game.colorList.count))-4
                                colorGridHeight = buttonDiameter
                            }
                            .onAppear(perform: {
                                buttonDiameter = geo.size.width/CGFloat((game.colorList.count))-4
                                colorGridHeight = buttonDiameter
                            })
                        }
                        .frame(height: colorGridHeight)
                    }
                    
                    
                    
                    GeometryReader { geo in
                        HStack
                        {
                            //Backspace Button
                            Button(action: {
                                game.removeFromGuess()
                            }) {
                                Image(systemName: "arrow.left")
                                    .font(.largeTitle)
                                    .frame(height: geo.size.height/3)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .background(Color(red: 218/246, green: 58/256, blue: 46/256))
                            .clipShape(Capsule())
                            
                            //Guess Button
                            Button(action: {
                                if !game.curGuess.contains(where: { $0.color == 0 }) && game.gameActive {
                                    game.makeGuess()
                                    if !game.win {
                                        game.guessNr += 1
                                    }
                                }
                            }, label: {
                                Text("Guess")
                                    .font(.largeTitle)
                                    .frame(height: geo.size.height/3)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                            })
                                .foregroundColor(.white)
                                .background(Color(red: 218/246, green: 58/256, blue: 46/256))
                                .clipShape(Capsule())
                        }
                    }
                    .frame(height: 42)
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                .transition(.move(edge: .bottom))
            }
        }
    }
}

//Makes a line across the screen
struct screenLine: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .frame(height: 5)
            .ignoresSafeArea()
    }
}

//Diplay for color options
struct ColorPickButton: View {
    @StateObject var game: GameInfo
    let color: Color
    let index: Int
    let diameter : CGFloat
    
    var body: some View{
        Button(action: {
            game.addToGuess(index: index)
        }, label: {
            Circle()
                .foregroundColor(color)
                .frame(width: diameter, height: diameter)
        })
    }
}

//Diplay for current guess (it's a button because you can press it to change position)
struct CurGuessButton: View {
    @StateObject var game: GameInfo
    let color: Color
    let pos: Int
    
    var body: some View{
        Button(action: {
            game.curPos = pos
        }) {
            ZStack{
                if pos == game.curPos {
                    Circle()
                        .frame(height: CGFloat(100 - game.totalLength * 7))
                        .foregroundColor(game.highlight)
                } else {
                    Circle()
                        .frame(height: CGFloat(100 - game.totalLength * 7))
                        .foregroundColor(game.transparent)
                }
                Circle()
                    .frame(height: CGFloat(95 - game.totalLength * 7))
                    .foregroundColor(color)
            }
        }
    }
}
