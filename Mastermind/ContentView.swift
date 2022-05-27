//
//  ContentView.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-02-24.
//

import SwiftUI

struct ContentView: View {
	@StateObject var game : GameInfo
	@State private var quotes = [String]()
	
	var body: some View {
		ZStack {
			Color(red: 50/256, green: 50/256, blue: 50/256)
				.ignoresSafeArea()
			
			if game.portrait {
				VStack(spacing: 0) {
					AllPreviousGuessesView(game: game)
					makeLine(horizontal: true, units: 5)
						.padding(.bottom)
					GuessInputView(game: game, portrait: $game.portrait)
				}
			} else {
				HStack(spacing: 0) {
					AllPreviousGuessesView(game: game)
					makeLine(horizontal: false, units: 5)
					GuessInputView(game: game, portrait: $game.portrait)
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
			if UIDevice.current.orientation.isPortrait {
				game.portrait = true
			} else if UIDevice.current.orientation.isLandscape {
				game.portrait = false
			}
		}
		.sheet(isPresented: $game.win, onDismiss: {game.gameActive = false}) {
			WinSheet(length: game.totalLength, colors: game.colorList.count-1, guesses: game.guessNr, quote: quotes[Int.random(in: 0..<quotes.count)])
		}
		.task {
			do {
				let url = URL(string: "https://hws.dev/quotes.txt")!

				for try await quote in url.lines {
					quotes.append(quote)
				}
				print(quotes)
			} catch {
				quotes.append("Error, no quotes for you")
				print("Error, no quotes for you")
			}
		}
	}
}

//Makes a line across the screen
struct makeLine: View {
	let horizontal : Bool
	let units: CGFloat
	
	var body: some View {
		if horizontal {
			Rectangle()
				.foregroundColor(.gray)
				.frame(height: units)
				.ignoresSafeArea()
		} else {
			Rectangle()
				.foregroundColor(.gray)
				.frame(width: units)
				.ignoresSafeArea()
		}
	}
}
	
struct WinSheet : View {
	let length : Int
	let colors : Int
	let guesses : Int
	let quote : String
	
	var body: some View {
		ZStack{
			Color(red: 70/256, green: 70/256, blue: 70/256)
				.ignoresSafeArea()
			VStack{
				Text(quote)
					.foregroundColor(.white)
					.font(.title)
					.fontWeight(.bold)
					.padding()
				
				Text("You Won!")
					.foregroundColor(.white)
					.font(.title)
					.fontWeight(.bold)
					.padding()
				
				Text("Guesses: \(guesses)\n\nLength: \(length)\nColors: \(colors)")
					.foregroundColor(.red)
					.font(.title)
					.padding()
			}
		}
	}
}

