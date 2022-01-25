//
//  Constants.swift
//  TicTacToe
//
//

import Foundation
import UIKit


public enum GameCurrentState : String {
    case player_A_Turn = "Now X turn"
    case player_B_Turn = "Now O turn"
    case X_Win = "X wins"
    case O_Win = "O wins"
    case matchDraw = "Game Draw"
}


struct GameImages {
    static let x_image = UIImage(named: "Cross")
    static let o_image = UIImage(named: "Circle")
    static let blank_image = UIImage(named: "blank")
}

struct AppConstants {
    static let coreDataEntityName = "TicTac"
    static let xTurn_Key = "isXTurn"
    static let oScore_Key = "oScore"
    static let xScore_Key = "xScore"
    static let boardData_Key = "boardData"

    static let resumeIsSelected_Key = "isSelected"
    static let resumeTag_Key = "tag"
    static let resumeIsXImage_Key = "isXimage"
    static let resumeTotalBoard_Key = "totalBoard"

}

