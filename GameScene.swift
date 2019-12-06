import SpriteKit
import GameplayKit
import UIKit
import Flurry_iOS_SDK
import Hero
class GameScene: SKScene {
    var letters = ["S","C","O","O","T"]
    var arrayWords: [String] = []
    var allLetter: [LetterBlock] = []
    var allEmptyBlock: [LetterBlock] = []
    var answer = ""
    var copyNodeArray: [LetterBlock] = []
    var viewController: GameViewController
    var scoreLabel = SKLabelNode(fontNamed:"Panton")
    var isFirstTime = true
    init(size:CGSize, scaleMode:SKSceneScaleMode, viewController: GameViewController) {
        self.viewController = viewController
        super.init(size:size)
        self.scaleMode = scaleMode
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {
        initBackground()
        getWords()
        getRandomWord()
        createBlocks()
        createEmptyBlock()
        changePosition()
    }
    func runTimer(){
        self.runTimerAction()
    }
    func showAD(){
        if !isFirstTime {
                switch needShowAD {
                case .startAgain:
                    self.scoreLabel.text = "0"
                    self.progress = 1.0
                    self.nextWord()
                    self.runTimerAction()
                case .start:
                    self.runTimerAction()
                case .exit:
                    self.viewController.performSegue(withIdentifier: "toMainMenu", sender: nil)
                }
        } else {
            isFirstTime = false
            switch needShowAD {
            case .startAgain:
                self.scoreLabel.text = "0"
                self.progress = 1.0
                self.nextWord()
                self.runTimerAction()
            case .start:
                self.runTimerAction()
            case .exit:
                self.viewController.performSegue(withIdentifier: "toMainMenu", sender: nil)
            }
        }
    }
    func finishGame() {
        self.removeAction(forKey: "countdown")
        let vc = AABlurAlertControllerSecond()
        vc.buttonsStackView.axis = .vertical
        vc.widht1 = 100
        vc.widht2 = 100
        self.nextWord()
        progress = 1.0
        if let local = Locale.current.languageCode {
            if local == "ru" {
                vc.addAction(action: AABlurAlertActionSecond(title: "Начать!", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Start")
                    self.runTimerAction()
                    needShowAD = .start
                    self.showAD()
                })
                vc.addAction(action: AABlurAlertActionSecond(title: "Главное меню", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Exit")
                    needShowAD = .exit
                    self.showAD()
                })
                vc.alertSubtitle.text = "Рекорд: " + String(setScore())
            } else {
                vc.addAction(action: AABlurAlertActionSecond(title: "Start!", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Start")
                    self.runTimerAction()
                    needShowAD = .start
                    self.showAD()
                })
                vc.addAction(action: AABlurAlertActionSecond(title: "Main Menu", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Exit")
                    needShowAD = .exit
                    self.showAD()
                })
                vc.alertSubtitle.text = "Best score: " + String(setScore())
            }
        } else {
            vc.addAction(action: AABlurAlertActionSecond(title: "Start!", style: AABlurActionStyleSecond.modern) { _ in
                Flurry.logEvent("Start")
                needShowAD = .start
                self.showAD()
            })
            vc.addAction(action: AABlurAlertActionSecond(title: "Main Menu", style: AABlurActionStyleSecond.modern) { _ in
                Flurry.logEvent("Exit")
                needShowAD = .exit
                self.showAD()
            })
            vc.alertSubtitle.text = "Best score: " + String(setScore())
        }
        vc.blurEffectStyle = .light
        vc.alertImage.layer.masksToBounds = true
        vc.alertTitle.text = "🔥🔥🔥"
        self.scoreLabel.text = "0"
        self.viewController.present(vc, animated: true, completion: nil)
    }
    func cancelButton(){
        self.removeAction(forKey: "countdown")
        let vc = AABlurAlertControllerSecond()
        vc.buttonsStackView.axis = .vertical
        vc.widht1 = 150
        vc.widht2 = 150
        if let local = Locale.current.languageCode {
            if local == "ru" {
                vc.addAction(action: AABlurAlertActionSecond(title: "Продолжить", style: AABlurActionStyleSecond.modern) { _ in
                    self.runTimerAction()
                })
                vc.addAction(action: AABlurAlertActionSecond(title: "Заново", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Start again")
                    needShowAD = .startAgain
                    self.showAD()
                })
                vc.addAction(action: AABlurAlertActionSecond(title: "Главное меню", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Exit")
                    needShowAD = .exit
                    self.showAD()
                })
                vc.alertTitle.text = "Пауза"
            } else {
                vc.addAction(action: AABlurAlertActionSecond(title: "Сontinue", style: AABlurActionStyleSecond.modern) { _ in
                    self.runTimerAction()
                })
                vc.addAction(action: AABlurAlertActionSecond(title: "Start again", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Start again")
                    needShowAD = .startAgain
                    self.showAD()
                })
                vc.addAction(action: AABlurAlertActionSecond(title: "Main Menu", style: AABlurActionStyleSecond.modern) { _ in
                    Flurry.logEvent("Exit")
                    needShowAD = .exit
                    self.showAD()
                })
                vc.alertTitle.text = "Pause"
            }
        } else {
            vc.addAction(action: AABlurAlertActionSecond(title: "Сontinue!", style: AABlurActionStyleSecond.modern) { _ in
                self.runTimerAction()
            })
            vc.addAction(action: AABlurAlertActionSecond(title: "Start again!", style: AABlurActionStyleSecond.modern) { _ in
                Flurry.logEvent("Start again")
                needShowAD = .startAgain
                self.showAD()
            })
            vc.alertTitle.text = "Pause"
        }
        vc.blurEffectStyle = .light
        vc.alertImage.layer.masksToBounds = true
        self.viewController.present(vc, animated: true, completion: nil)
    }
    func pauseViewController(){
        let vc = AABlurAlertControllerSecond()
        self.removeAction(forKey: "countdown")
        if let local = Locale.current.languageCode {
            if local == "ru" {
                vc.addAction(action: AABlurAlertActionSecond(title: "Продолжить", style: AABlurActionStyleSecond.modern) { _ in
                    self.runTimerAction()
                })
            } else {
                vc.addAction(action: AABlurAlertActionSecond(title: "Сontinue!", style: AABlurActionStyleSecond.modern) { _ in
                    self.runTimerAction()
                })
            }
        } else {
            vc.addAction(action: AABlurAlertActionSecond(title: "Сontinue!", style: AABlurActionStyleSecond.modern) { _ in
                self.runTimerAction()
            })
        }
        vc.blurEffectStyle = .light
        vc.alertImage.layer.masksToBounds = true
        if let local = Locale.current.languageCode {
            if local == "ru" {
                vc.alertTitle.text = "Собирай слова!"
                vc.alertSubtitle.text = "У тебя 100 секунд. Собирай слова! Нажми на букву и она автоматически переместится в пустую ячейку. Чтобы удалить букву, нажми на нее еще раз."
            } else {
                vc.alertTitle.text = "Collect words!"
                vc.alertSubtitle.text = "You have 100 seconds. Collect words. Tap on the letter and it will automatically move to a empty cell. To remove letter, tap on it again."
            }
        } else {
            vc.alertTitle.text = "Collect words!"
            vc.alertSubtitle.text = "You have 100 seconds. Collect words. Tap on the letter and it will automatically move to a empty cell. To remove letter, tap on it again."
        }
        self.viewController.present(vc, animated: true, completion: nil)
    }
    var questionButton: ButtonClass?
    var pauseButton: ButtonClass?
    func initScoreLabel(){
        print("initScoreLabel")
        scoreLabel.text = String(0)
        scoreLabel.color = UIColor.white
        scoreLabel.fontSize = CGFloat(Double(UIScreen.main.bounds.width/10))
        scoreLabel.position = CGPoint(x: 0, y: UIScreen.main.bounds.height/2-UIScreen.main.bounds.width/10-UIScreen.main.bounds.width/25 - topPadding)
        self.addChild(scoreLabel)
    }
    func addPoints(){
        scoreLabel.text = String(Int(scoreLabel.text!)! + answer.count)
    }
    var progress = 1.0
    var energyProgressBar: SKProgressBar? = nil
    func runTimerAction(){
        let wait = SKAction.wait(forDuration: 1) 
        let block = SKAction.run({
            [unowned self] in
            if self.progress > 0.02{
                self.progress = self.progress-0.01
                self.energyProgressBar!.setProgress(CGFloat(self.progress))
            } else {
                self.energyProgressBar!.setProgress(0)
                self.finishGame()
                self.removeAction(forKey: "countdown")
            }
        })
        let sequence = SKAction.sequence([wait,block])
        run(SKAction.repeatForever(sequence), withKey: "countdown")
    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    func setScore()->Int{
        Flurry.logEvent("Finish", withParameters: ["Score ": Int(self.scoreLabel.text!)!]);
        var bestScore = 0
        if isKeyPresentInUserDefaults(key: "score") {
            if UserDefaults.standard.integer(forKey: "score") > Int(self.scoreLabel.text!)! {
                bestScore = UserDefaults.standard.integer(forKey: "score")
            } else {
                UserDefaults.standard.set(Int(self.scoreLabel.text!), forKey: "score")
                bestScore = Int(self.scoreLabel.text!)!
            }
        } else {
            UserDefaults.standard.set(Int(self.scoreLabel.text!), forKey: "score")
            bestScore = Int(self.scoreLabel.text!)!
        }
        return bestScore
    }
    func initProgressBar(){
        energyProgressBar = SKProgressBar.init(baseColor: Helper().returnColor(color: .emptyBlockColor),
                                                   coverColor: Helper().returnColor(color: .progressBarColor),
                                                   size: CGSize(width: Int(UIScreen.main.bounds.width - UIScreen.main.bounds.width/4), height: Int(UIScreen.main.bounds.width)/10))
        energyProgressBar!.position.y = -(UIScreen.main.bounds.height/2-UIScreen.main.bounds.width/10 - topPadding)
        addChild(energyProgressBar!)
        runTimerAction()
    }
    func changePosition(){
        pauseButton = ButtonClass(circleOfRadius: UIScreen.main.bounds.width/15,
                                  letter: "X",
                                  gameScene: self,
                                  position: CGPoint(x: (UIScreen.main.bounds.width/2-UIScreen.main.bounds.width/10), y: UIScreen.main.bounds.height/2-UIScreen.main.bounds.width/10))
        questionButton = ButtonClass(circleOfRadius: UIScreen.main.bounds.width/15,
                                     letter: "?",
                                     gameScene: self,
                                     position: CGPoint(x: (-UIScreen.main.bounds.width/2+UIScreen.main.bounds.width/10), y: UIScreen.main.bounds.height/2-UIScreen.main.bounds.width/10))
        if let btn = pauseButton {
            btn.position.y = (btn.position.y - topPadding)
            self.addChild(btn)
        }
        if let btn = questionButton {
            btn.position.y = (btn.position.y - topPadding)
            self.addChild(btn)
        }
        initScoreLabel()
        initProgressBar()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let positionInScene = touch.location(in: self.scene!)
            let touchedNode = self.atPoint(positionInScene)
            if let touchedNode = touchedNode as? LetterBlock {
                if let text = touchedNode.labelLetter.text {
                    if text != "" && !touchedNode.kek {
                        moveBlock(touchedNode: touchedNode)
                    }
                }
            } else if let touchedNode = touchedNode.parent as? LetterBlock {
                if let text = touchedNode.labelLetter.text {
                    if text != "" && !touchedNode.kek {
                        moveBlock(touchedNode: touchedNode)
                    }
                }
            }
        }
    }
    func moveBlock(touchedNode: LetterBlock){
        if touchedNode.isColorise {
            for node in copyNodeArray {
                if node.index == touchedNode.index {
                    copyNodeArray.firstIndex(of: node).map { copyNodeArray.remove(at: $0) }
                    touchedNode.ref!.isMoving = false
                    touchedNode.ref!.labelLetter.text! = ""
                    touchedNode.isMoving = true
                    node.isMoving = true
                    let move = SKAction.move(to: touchedNode.position, duration: 0.3)
                    let scale = SKAction.scale(to: touchedNode.size, duration: 0.3)
                    move.timingMode = .easeIn
                    scale.timingMode = .easeIn
                    let sequence = SKAction.sequence([scale, move])
                    node.run(sequence, completion: {
                        let colorize = SKAction.colorize(with: Helper.shared.returnColor(color: .blockColor), colorBlendFactor: 1, duration: 0.05)
                        touchedNode.run(colorize, completion: {
                            node.removeAllActions()
                            node.removeAllChildren()
                            node.removeFromParent()
                            touchedNode.isColorise = false
                            touchedNode.isMoving = false
                            node.isMoving = false
                            node.kek = false
                        })
                    })
                }
            }
        } else {
            if !touchedNode.isMoving {
                for node in allEmptyBlock {
                    if node.isMoving == false {
                        node.labelLetter.isHidden = true
                        node.labelLetter.text = touchedNode.labelLetter.text!
                        node.isMoving = true
                        touchedNode.isMoving = true
                        touchedNode.colorize()
                        touchedNode.ref = node
                        let copyNode = LetterBlock(color: Helper.shared.returnColor(color: .blockColor),
                                                   size: touchedNode.size,
                                                   letter: touchedNode.labelLetter.text!,
                                                   position: touchedNode.position,
                                                   index: touchedNode.index)
                        copyNode.isMoving = true
                        self.addChild(copyNode)
                        copyNodeArray.append(copyNode)
                        let move = SKAction.move(to: node.position, duration: 0.3)
                        let scale = SKAction.scale(to: node.size, duration: 0.3)
                        move.timingMode = .easeIn
                        scale.timingMode = .easeIn
                        let sequence = SKAction.sequence([move, scale])
                        copyNode.run(sequence, completion: {
                            self.checkWord()
                            touchedNode.isColorise = true
                            touchedNode.isMoving = false
                            copyNode.isMoving = false
                            copyNode.kek = true
                        })
                        break
                    }
                }
            }
        }
    }
    func checkWord(){
        var word = ""
        var flag = false
        for node in allEmptyBlock {
            word = word + node.labelLetter.text!
        }
        if word == answer {
            Flurry.logEvent("Good answer", withParameters: ["Word ": word]);
            animateTitleLabel(color: UIColor(red:0.12, green:0.67, blue:0.54, alpha:1.0), wait: 0.0)
            addPoints()
            nextWord()
        } else if word.count == answer.count {
            for element in arrayWords {
                if word == element {
                    flag = true
                }
            }
            if flag {
                Flurry.logEvent("Good answer, but different", withParameters: ["Word ": word]);
                animateTitleLabel(color: UIColor(red:0.12, green:0.67, blue:0.54, alpha:1.0), wait: 0.0)
                addPoints()
                nextWord()
            } else {
                Flurry.logEvent("Bad answer", withParameters: ["Word ": word]);
                animateTitleLabel(color: UIColor(red:0.97, green:0.22, blue:0.35, alpha:1.0), wait: 0.2)
            }
        }
    }
    func animateTitleLabel(color: UIColor, wait: Double){
        let animation1 = SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.2)
        animation1.timingMode = .easeOut
        let animation2 = SKAction.colorize(with: Helper().returnColor(color: .backgroundColor), colorBlendFactor: 0.0, duration: 0.2)
        animation2.timingMode = .easeIn
        background.run(.sequence([
            animation1,
            .wait(forDuration: wait),
            animation2
            ]))
    }
    func nextWord(){
        for node in allLetter {
            node.removeAllActions()
            node.removeAllChildren()
            node.removeFromParent()
        }
        for node in allEmptyBlock {
            node.removeAllActions()
            node.removeAllChildren()
            node.removeFromParent()
        }
        for node in copyNodeArray {
            node.removeAllActions()
            node.removeAllChildren()
            node.removeFromParent()
        }
        allLetter.removeAll()
        allEmptyBlock.removeAll()
        copyNodeArray.removeAll()
        getRandomWord()
        createBlocks()
        createEmptyBlock()
    }
    func getRandomWord(){
        answer = arrayWords.randomElement()!
        print(answer)
        letters = answer.map { String($0)}.shuffled()
    }
    func createEmptyBlock(){
        let blockSize = Int(UIScreen.main.bounds.width)/10
        var sizePlus = 0
        if letters.count % 2 == 0 {
            sizePlus = blockSize*((letters.count+2)/2)-blockSize/2
        } else {
            sizePlus = blockSize*((letters.count+2)/2)
        }
        for i in 1...letters.count{
            let block = LetterBlock(color: Helper.shared.returnColor(color: .emptyBlockColor),
                                    size: CGSize(width: blockSize-blockSize/10, height: blockSize-blockSize/10),
                                    letter: "",
                                    position: CGPoint(x: blockSize*i-sizePlus, y:Int(UIScreen.main.bounds.width/(2*getCefY()))),
                                    index: -1)
            self.addChild(block)
            allLetter.append(block)
            allEmptyBlock.append(block)
        }
    }
    func getWords(){
        arrayWords.removeAll()
        var fileName = "eng"
        if let local = Locale.current.languageCode {
            if local == "ru" {
                fileName = "rus"
            } else {
                fileName = "eng"
            }
        } else {
            fileName = "eng"
        }
        do {
            if let path = Bundle.main.path(forResource: fileName, ofType: "txt"){
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                arrayWords = data.components(separatedBy: "\n")
            }
        } catch let err as NSError {
            print(err)
        }
    }
    func createBlocks(){
        let blockSize = Helper().returnSize(color: .blockLetter)
        let offset = Int(Double(blockSize)/5.5)
        var line = 0
        var count = letters.count
        while count >= 3 {
            var arg = 0
            for i in count-2...count {
                let block = LetterBlock(color: Helper.shared.returnColor(color: .blockColor),
                                        size: CGSize(width: blockSize, height: blockSize),
                                        letter: letters[i-1],
                                        position: CGPoint(x: (arg*(blockSize+offset))-(blockSize+offset), y:offset*4+(line*(-blockSize-offset))),
                                        index: i-1)
                self.addChild(block)
                allLetter.append(block)
                arg = arg + 1
            }
            line = line + 1
            count = count - 3
        }
        switch count {
        case 1:
            let block = LetterBlock(color: Helper.shared.returnColor(color: .blockColor),
                                    size: CGSize(width: blockSize, height: blockSize),
                                    letter: letters[0],
                                    position: CGPoint(x: 0, y:offset*4+(line*(-blockSize-offset))),
                                    index: 0)
            self.addChild(block)
            allLetter.append(block)
        case 2:
            let block = LetterBlock(color: Helper.shared.returnColor(color: .blockColor),
                                    size: CGSize(width: blockSize, height: blockSize),
                                    letter: letters[0],
                                    position: CGPoint(x: -(blockSize/2+offset/2), y:offset*4+(line*(-blockSize-offset))),
                                    index: 0)
            self.addChild(block)
            allLetter.append(block)
            let block2 = LetterBlock(color: Helper.shared.returnColor(color: .blockColor),
                                    size: CGSize(width: blockSize, height: blockSize),
                                    letter: letters[1],
                                    position: CGPoint(x: (blockSize/2+offset/2), y:offset*4+(line*(-blockSize-offset))),
                                    index: 1)
            self.addChild(block2)
            allLetter.append(block2)
        case 0:
            print(":)")
        default:
            print(":)")
        }
    }
    let background = SKSpriteNode.init(texture: nil)
    func initBackground(){
        background.position = CGPoint(x: 0, y: 0)
        background.color = Helper.shared.returnColor(color: .backgroundColor)
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.zPosition = -1
        background.name = "background"
        self.addChild(background)
    }
}
