//
//  StartMenu.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-03-03.
//

import SwiftUI

struct StartMenu: View {
    @StateObject var game = GameInfo()
    @State var guessTemplate = [0,0]
    var start = "Start"
    var resume = "Resume"
    @State var playGameLabel: String
    @State var sliderValue: Float = 4
    @State var showColors: Bool = false
    @State var changedColor: Bool = true
    
    init() {
        UITableView.appearance().backgroundColor = UIColor(red: 0/256, green: 0/256, blue: 0/256, alpha: 0)
        playGameLabel = start
    }
    
    var body: some View {
        NavigationView {
            ZStack{
                Color(red: 50/256, green: 50/256, blue: 50/256)
                    .ignoresSafeArea()
                
                VStack{
                    ScrollView {
                        Rectangle()
                            .frame(height: 120)
                            .foregroundColor(game.transparent)
                            .onChange(of: changedColor) { _ in
                                if changedColor {
                                    playGameLabel = start
                                }
                            }
                        
                        HStack{
                            //Reset Button
                            Button(action: {
                                game.setColors()
                                game.resetGame(length: Int(sliderValue))
                                playGameLabel = start
                            }, label: {
                                Text("Reset")
                                    .font(.largeTitle)
                                    .frame(height: 12)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                            })
                            .foregroundColor(.white)
                            .background(Color(red: 218/246, green: 58/256, blue: 46/256))
                            .clipShape(Capsule())
                            
                            //Start Game Button
                            NavigationLink(destination: ContentView(game: game).onAppear {
                                if Int(sliderValue) != game.totalLength || changedColor {
                                    game.setColors()
                                    game.setLength(length: Int(sliderValue))
                                    game.gameActive = true
                                    showColors = false
                                    changedColor = false
                                }
                                playGameLabel = resume
                                game.portrait = !UIDevice.current.orientation.isLandscape
                            }) {
                                Text(playGameLabel)
                                    .font(.largeTitle)
                                    .frame(height: 12)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .background(Color(red: 218/256, green: 58/256, blue: 46/256))
                            .clipShape(Capsule())
                        }
                        .padding(.horizontal)
                        
                        VStack {
                            HStack {
                                Text("Length: \(Int(sliderValue))")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                Spacer()
                            }
                            HStack{
                                Slider(value: $sliderValue, in: 3...Float(game.maxLength), step: 1) { _ in
                                    game.setColors()
                                    game.setLength(length: Int(sliderValue))
                                    playGameLabel = start
                                }
                                .padding(.horizontal)
                                .accentColor(.white)
                            }
                            .padding(.horizontal)
                            .padding(.bottom)
                        }
                        .foregroundColor(.white)
                        .background(Color(red: 218/256, green: 58/256, blue: 46/256))
                        .cornerRadius(15)
                        .padding(.horizontal)
                        .frame(height: 100)
                        
                        ColorSelection(game: game, showColors: $showColors, changedColor: $changedColor)
                            .padding(.bottom)
                    }
                }
            }
        }
    }
}
