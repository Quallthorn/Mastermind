//
//  GuessInfo.swift
//  Mastermind
//
//  Created by Oscar Karlsson on 2022-02-25.
//

import Foundation
import SwiftUI

class GameInfo : ObservableObject {
    @Published var curGuess : [GuessID] = [GuessID(color: 0, pos: 0), GuessID(color: 0, pos: 1)]
    @Published var allGuesses : [SavedGuess] = []
    @Published var curPos = 0
    @Published var guessNr = 1
    @Published var win = false
    @Published var gameActive = true
    @Published var portrait = true
    @Published var maxLength = 10
    
    var answer : [Int] = []
    var tempAnswer : [Int] = []
    var tempGuess : [Int] = []
    var totalLength : Int = 2
    var halfLength : Int = 1
    let numberOfColors : Int = 11
    let halfNoC : Int = 6
    var rights = 0
    var almosts = 0
    
    var colorBooleanList = [ColorBoolean]()
    var gridBooleanList = [GridColorBoolean]()
    var colorList = [IDdColor]()
    var gridColorList = [GridIDdColor]()
    var allColorsList: [Color]
    var hintColorList: [Color]
    
    let bgWhite = Color(red: 180/256, green: 180/256, blue: 180/256)
    let bgBlack = Color(red: 30/256, green: 30/256, blue: 30/256)
    let grey = Color(red: 50/256, green: 50/256, blue: 50/256)
    
    //total: 24
    let red = Color(red: 240/256, green: 0/256, blue: 0/256)
    let orange = Color(red: 255/256, green: 100/256, blue: 0/256)
    let yellow = Color(red: 243/256, green: 227/256, blue: 4/256)
    let green = Color(red: 0/256, green: 200/256, blue: 0/256)
    
    let teal = Color(red: 0/256, green: 200/256, blue: 200/256)
    let blue = Color(red: 0/256, green: 0/256, blue: 250/256)
    let purple = Color(red: 135/256, green: 0/256, blue: 255/256)
    let magenta = Color(red: 240/256, green: 0/256, blue: 240/256)
    
    let maroon = Color(red: 125/256, green: 0/256, blue: 1/256)
    let darkOrange = Color(red: 127/256, green: 50/256, blue: 0/256)
    let olive = Color(red: 128/256, green: 129/256, blue: 38/256)
    let forest = Color(red: 1/256, green: 125/256, blue: 0/256)
    
    let cyan = Color(red: 56/256, green: 126/256, blue: 127/256)
    let navy = Color(red: 1/256, green: 0/256, blue: 125/256)
    let violet = Color(red: 67/256, green: 0/256, blue: 127/256)
    let fuchsia = Color(red: 120/256, green: 0/256, blue: 120/256)
    
    let pink = Color(red: 237/256, green: 128/256, blue: 167/256)
    let lavender = Color(red: 222/256, green: 190/256, blue: 251/256)
    let lime = Color(red: 204/256, green: 253/256, blue: 80/256)
    let mint = Color(red: 186/256, green: 253/256, blue: 198/256)
    
    let beige = Color(red: 250/256, green: 218/256, blue: 179/256)
    let brown = Color(red: 111/256, green: 77/256, blue: 47/256)
    let black = Color(red: 0/256, green: 0/256, blue: 0/256)
    let white = Color(red: 240/256, green: 240/256, blue: 240/256)

    
    //let sky = Color(red: 146/256, green: 233/256, blue: 233/256)

    
    let highlight = Color(red: 0.5, green: 0.5, blue: 0.6, opacity: 0.8)
    let hole = Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.8)
    let transparent = Color(red: 0, green: 0, blue: 0, opacity: 0)
    
    init() {
        allColorsList = [bgWhite, red, orange, yellow, green, teal, blue, purple, magenta, maroon, darkOrange, olive, forest, cyan, navy, violet, fuchsia, pink, lavender, lime, mint, beige, brown, black, white]
        hintColorList = [white, red, hole]
        
        for i in 0..<allColorsList.count {
            
            if i < 9 {
                colorBooleanList.append(ColorBoolean(index: i, color: allColorsList[i], active: true))
            } else {
                colorBooleanList.append(ColorBoolean(index: i, color: allColorsList[i], active: false))
            }
        }
        
        for i in 0..<6 {
            gridBooleanList.append(GridColorBoolean(row: [colorBooleanList[1+(i)*4], colorBooleanList[2+(i)*4], colorBooleanList[3+(i)*4], colorBooleanList[4+(i)*4]]))
        }
        
        colorList.append(IDdColor(color: bgWhite, index: 0))
    }
    
    func setColors() {
        colorList = []
        colorList.append(IDdColor(color: bgWhite, index: 0))
        var index = 1
        for i in 1..<colorBooleanList.count {
            if colorBooleanList[i].active {
                colorList.append(IDdColor(color: colorBooleanList[i].color, index: index))
                index += 1
            }
        }
        var colorRow1 = [IDdColor]()
        var colorRow2 = [IDdColor]()
        var colorRow3 = [IDdColor]()
        if colorList.count > 17 {
            for i in 1...colorList.count/3 {
                colorRow1.append(colorList[i])
            }
            for i in colorList.count/3+1..<colorList.count/3*2+1 {
                colorRow2.append(colorList[i])
            }
            for i in colorList.count/3*2+1..<colorList.count {
                colorRow3.append(colorList[i])
            }
        } else {
            for i in 1...colorList.count/2 {
                colorRow1.append(colorList[i])
            }
            for i in colorList.count/2+1..<colorList.count {
                colorRow2.append(colorList[i])
            }
        }
        gridColorList = []
        gridColorList.append(GridIDdColor(row: colorRow1))
        gridColorList.append(GridIDdColor(row: colorRow2))
        if colorRow3.count > 0 {
            gridColorList.append(GridIDdColor(row: colorRow3))
        }
    }
    
    func setLength(length: Int) {
        totalLength = length
        halfLength = Int(round(Double(totalLength)/2))
        
        curGuess = []
        answer = []
        allGuesses = []
        curPos = 0
        guessNr = 1
        
        for i in 0..<totalLength {
            curGuess.append(GuessID(color: 0, pos: i))
            answer.append(Int.random(in: 1..<colorList.count))
        }
    }
    
    func resetGame(length: Int) {
        win = false
        gameActive = true
        resetGuess()
        setLength(length: length)
    }
    
    func addToGuess(index: Int) {
        curGuess[curPos].color = index
        updatePos(right: true)    }
    
    func removeFromGuess() {
        curGuess[curPos].color = 0
        updatePos(right: false)
    }
    
    func updatePos(right: Bool) {
        if right && curPos < totalLength - 1 {
            curPos += 1
        }
        else if !right && curPos > 0 {
            curPos -= 1
        }
        else {
            curPos = curPos
        }
    }
    
    func makeGuess(){
        print("Answer:\(answer)")
        checkRight()
        checkAlmost()
        checkWin()
        makeGuessClass()
        resetGuess()
    }
    
    func checkRight(){
        tempAnswer = answer
        tempGuess = []
        for i in 0..<totalLength {
            tempGuess.append(curGuess[i].color)
        }
        for i in 0..<totalLength{
            if tempGuess[i] == tempAnswer[i]{
                rights += 1
                tempAnswer[i] = -1
                tempGuess[i] = -2
            }
        }
    }
    
    func checkAlmost(){
        for i in 0..<totalLength{
            for j in 0..<totalLength{
                if tempGuess[i] == tempAnswer[j]{
                    almosts += 1
                    tempAnswer[j] = -1
                    break
                }
            }
        }
    }
    
    func checkWin(){
        if rights == totalLength{
            win = true
        }
    }
    
    func makeGuessClass() {
        var code : [GuessID] = []
        var hintCheck : [Int] = []
        var hintsR1 : [GuessID] = []
        var hintsR2 : [GuessID] = []
                    
        for i in 0..<totalLength {
            code.append(GuessID(color: curGuess[i].color, pos: curGuess[i].pos))
        }
        
        for _ in 0..<rights {
            hintCheck.append(1)
        }
        
        for _ in 0..<almosts {
            hintCheck.append(0)
        }

        for _ in rights+almosts..<totalLength {
            hintCheck.append(2)
        }
        
        for i in 0..<halfLength {
            hintsR1.append(GuessID(color: hintCheck[i], pos: i))
        }
        for i in halfLength..<totalLength {
            hintsR2.append(GuessID(color: hintCheck[i], pos: i))
        }
        
        allGuesses.append(SavedGuess(index: guessNr - 1, code: code, hintCodeR1: hintsR1, hintCodeR2: hintsR2))
    }
    
    func resetGuess(){
        for i in 0..<totalLength {
            curGuess[i].color = 0
        }
        curPos = 0
        rights = 0
        almosts = 0
    }
    
    //
    func makeHintRow(start: Int, stop: Int, @Binding row: [GuessID], IDCheck: [Int]){
        for i in start..<stop {
            row.append(GuessID(color: IDCheck[i], pos: 0))
        }
    }
}

struct line: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray)
            .frame(height: 5)
            .ignoresSafeArea()
    }
}

class GuessID : Identifiable {
    let id = UUID()
    var color: Int
    let pos: Int
    
    init(color: Int, pos: Int) {
        self.color = color
        self.pos = pos
    }
}

class SavedGuess : Identifiable, Equatable {
    let id = UUID()
    let index: Int
    let code: [GuessID]
    let hintCodeR1: [GuessID]
    let hintCodeR2: [GuessID]
    
    init(index: Int, code: [GuessID], hintCodeR1: [GuessID], hintCodeR2: [GuessID]) {
        self.index = index
        self.code = code
        self.hintCodeR1 = hintCodeR1
        self.hintCodeR2 = hintCodeR2
    }
    
    static func ==(lhs: SavedGuess, rhs: SavedGuess) -> Bool {
        return lhs.index == rhs.index
    }
}

class IDdColor : ObservableObject, Identifiable, Equatable {
    let id = UUID()
    let color : Color
    let index : Int
    
    init(color: Color, index: Int) {
        self.color = color
        self.index = index
    }
    
    static func ==(lhs: IDdColor, rhs: IDdColor) -> Bool {
        return lhs.index == rhs.index
    }
}

class GridIDdColor : ObservableObject, Identifiable {
    let id = UUID()
    let row : [IDdColor]
    
    init(row: [IDdColor]) {
        self.row = row
    }
}

class ColorBoolean :  ObservableObject, Identifiable {
    let id = UUID()
    let index: Int
    let color: Color
    var active: Bool
    
    init(index: Int, color: Color, active: Bool) {
        self.index = index
        self.color = color
        self.active = active
    }
}

class GridColorBoolean :  ObservableObject, Identifiable {
    let id = UUID()
    var row: [ColorBoolean]
    
    init(row: [ColorBoolean]) {
        self.row = row
    }
}
