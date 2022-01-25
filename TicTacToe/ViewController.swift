//
//  ViewController.swift
//  TicTacToe
//
//

import UIKit



class ViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet weak var scoreXlbl: UILabel!
    @IBOutlet weak var scoreOLbl: UILabel!
    
    var ticModel = TicTacToeModel()
    var databaseRef = CoreDatabase()
    var lastSenderTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateGameState()
        self.resetGameWithUI()
        self.addSwipeGesture()
        self.becomeFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.fetchAndShowShowScore()
    }
    
    //MARK: fetch data from coredata
    func fetchAndShowShowScore(){
        self.databaseRef.loadSaveData { (isXturn, xScore, oScore,resumeData) in
            self.lblStatus.text = isXturn ? GameCurrentState.player_A_Turn.rawValue : GameCurrentState.player_B_Turn.rawValue
            self.scoreXlbl.text = "X-Score : \(xScore)"
            self.scoreOLbl.text = "O-Score : \(oScore)"
            self.ticModel.xScore = xScore
            self.ticModel.yScore = oScore
            self.checkAndResumeGame(data: resumeData)
        }
    }
    
    
    //MARK: check and set resume data
    func checkAndResumeGame(data: [[String: Any]]){
        if data.count == 0{
            return
        }
        for i in 1...9 {
            let btn = self.view.viewWithTag(i) as! UIButton
            for boardDataDict in data{
                let tag = boardDataDict[AppConstants.resumeTag_Key] as? Int ?? 0
                let isSelected = boardDataDict[AppConstants.resumeIsSelected_Key] as? Bool ?? false
                let isXImage = boardDataDict[AppConstants.resumeIsXImage_Key] as? Bool ?? false
                let boardData = boardDataDict[AppConstants.resumeTotalBoard_Key] as? [[Int]] ?? [[]]
                if boardData.first?.count ?? 0 > 0{
                    self.ticModel.board = boardData
                }
                if btn.tag == tag{
                    if isSelected{
                        btn.setImage(isXImage ? GameImages.x_image : GameImages.o_image, for: .normal)
                    }
                }
            }
        }
    }
    
    //MARK: add swipe gesture
    func addSwipeGesture(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down:
                self.resetGameWithUI()
            default:
                break
            }
        }
    }
    
    //MARK: Button actions
    @IBAction func buttonTapped(sender: UIButton) {
        
        if ticModel.checkStatus(needToAddScore: false) == .O_Win || ticModel.checkStatus(needToAddScore: false) == .X_Win || ticModel.checkStatus(needToAddScore: false) == .matchDraw{
            return
        }
        
        if sender.currentImage != GameImages.blank_image{
            return
        }
      
        let btnTag = sender.tag
        var btnImage = UIImage()
        var btnValue: Int
        var isNextXTurn = false
        switch ticModel.checkStatus(needToAddScore: true) {
        case .player_A_Turn:
            btnImage = GameImages.x_image!
            btnValue = 1
            isNextXTurn = false
        case .player_B_Turn:
            btnImage = GameImages.o_image!
            btnValue = 2
            isNextXTurn = true

        default:
            btnImage = GameImages.blank_image!
            btnValue = 0
        }
        ticModel.board[(btnTag-1)/3][(btnTag-1)%3] = btnValue
        sender.setImage(btnImage, for: .normal)
        self.lblStatus.text = ticModel.checkStatus(needToAddScore: true).rawValue
        self.scoreXlbl.text = "X-Score : \(ticModel.xScore)"
        self.scoreOLbl.text = "O-Score : \(ticModel.yScore)"
        
        self.lastSenderTag = btnTag
        self.checkAndSaveData(isNextXTurn: isNextXTurn)
        
    }
    
    
    func checkAndSaveData(isNextXTurn : Bool){
        var dataDict : [[String: Any]] = [[:]]
        for i in 1...9 {
            let btn = self.view.viewWithTag(i) as! UIButton
            dataDict.append([AppConstants.resumeTag_Key:i,AppConstants.resumeIsSelected_Key:btn.currentImage != GameImages.blank_image ? true : false,AppConstants.resumeIsXImage_Key:btn.currentImage == GameImages.x_image ? true : false,AppConstants.resumeTotalBoard_Key:ticModel.board])
        }
        self.databaseRef.saveDataInCoreData(isXturn: isNextXTurn, oScore: ticModel.yScore, xScore: ticModel.xScore,boardData: dataDict)
    }

    @IBAction func btnResetTapped(sender: UIButton) {
        self.resetGameWithUI()
    }
    
    //MARK: check current status
    func updateGameState() {
        self.lblStatus.text = ticModel.checkStatus(needToAddScore: false).rawValue
    }

    //MARK: reset game with UI/Logic
    func resetGameWithUI(){
        ticModel.resetGame()
        for i in 1...9 {
            let btn = self.view.viewWithTag(i) as! UIButton
            btn.setImage(GameImages.blank_image, for: .normal)
        }
        updateGameState()

    }
    
    
    //MARK: over ride responder add shake detection
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake{
            if lastSenderTag != 0{
                ticModel.board[(lastSenderTag-1)/3][(lastSenderTag-1)%3] = 0
                self.updateGameState()
                let btn = self.view.viewWithTag(lastSenderTag) as! UIButton
                btn.setImage(GameImages.blank_image, for: .normal)
            }
        }
    }
}

