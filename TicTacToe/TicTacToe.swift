//
//  TicTacToe.swift
//  TicTacToe
//
//

import Foundation
import UIKit

class TicTacToeModel {

    private let possibleCombinations = [[[1,1,1],[0,0,0],[0,0,0]],[[0,0,0],[1,1,1],[0,0,0]],[[0,0,0],[0,0,0],[1,1,1]],[[1,0,0],[1,0,0], [1,0,0]],[[0,1,0],[0,1,0], [0,1,0]],[[0,0,1],[0,0,1], [0,0,1]],[[1,0,0],[0,1,0], [0,0,1]],[[0,0,1],[0,1,0], [1,0,0]],]
    

    public var board = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)
    
    
    
    public var xScore = 0
    public var yScore = 0
    
    public func resetGame() {
        board = [[Int]](repeating: [Int](repeating: 0, count: 3), count: 3)
    }



    public func checkStatus(needToAddScore: Bool) -> GameCurrentState {
        if checkCondition(value: 1) {
            if needToAddScore{
                self.xScore += 1
            }
            return .X_Win
        } else if checkCondition(value: 2) {
            if needToAddScore{
                self.yScore += 1
            }
            return .O_Win
        } else {
            var xCount = 0, oCount = 0, dotCount = 0
            for i in 0..<3 {
                for j in 0..<3 {
                    switch board[i][j] {
                    case 1:
                        xCount += 1
                    case 2:
                        oCount += 1
                    default:
                        dotCount += 1
                    }
                }
            }

            if dotCount == 0 {
                return .matchDraw
            } else if xCount > oCount {
                return .player_B_Turn
            } else {
                return .player_A_Turn
            }
        }
    }

    private func checkCondition(value: Int) -> Bool {
        var counter = 0
        for wBoard in possibleCombinations {
            counter = 0
            for count in 0..<3 {
                for section in 0..<3 {
                    if wBoard[count][section] == 1 {
                        if board[count][section] == value {
                            counter += 1
                        }
                    }
                }
            }
            if (counter == 3) {
                return true
            }
        }
        return false
    }

}


