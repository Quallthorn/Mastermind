//
//  PreviousGuessesView.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-03-11.
//

import Foundation
import SwiftUI

struct AllPreviousGuessesView : View {
    @ObservedObject var game: GameInfo
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                VStack {
                    List(game.allGuesses) { guess in
                        HStack(spacing: 4) {
                            //Guess Colors
                            ForEach (guess.code) { code in
                                PrevGuessView(game: game, color: game.colorList[code.color].color)
                            }
                            //Hints
                            VStack(spacing: 2) {
                                //Row 1
                                HStack(spacing: 2) {
                                    ForEach (guess.hintCodeR1) { hint in
                                        HintView(game: game, color: game.hintColorList[hint.color])
                                    }
                                }
                                //Row 2
                                HStack(spacing: 2) {
                                    ForEach (guess.hintCodeR2) { hint in
                                        HintView(game: game, color: game.hintColorList[hint.color])
                                    }
                                    if (game.totalLength % 2 != 0) {
                                        HintView(game: game, color: game.transparent)
                                    }
                                }
                            }
                        }
                        .listRowBackground(game.bgBlack)
                        .id(guess.index)
                    }
                    .onChange(of: game.allGuesses) { _ in
                        withAnimation(.spring()) {
                            proxy.scrollTo(game.allGuesses.count - 1)
                        }
                    }
                }
            }
        }
    }
}

//Display for previous guess
struct PrevGuessView: View {
    @ObservedObject var game: GameInfo
    let color : Color
    
    var body: some View{
        Circle()
            .frame(height: CGFloat(100 - game.totalLength * 6))
            .foregroundColor(color)
    }
}

//Display for hints (red, white or grey(hole))
struct HintView: View {
    @ObservedObject var game: GameInfo
    let color : Color
    
    var body: some View{
        ZStack {
            Rectangle()
                .aspectRatio(contentMode: .fit)
                .frame(width: CGFloat(28 - game.totalLength * 2))
                .foregroundColor(game.transparent)
            
            if color == game.hole {
                Circle()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(25 - game.totalLength * 2))
                    .foregroundColor(color)
            }
            else {
                Circle()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: CGFloat(28 - game.totalLength * 2))
                    .foregroundColor(color)
            }
        }
    }
}
