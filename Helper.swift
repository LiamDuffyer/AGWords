import Foundation
import SpriteKit
var needShowAD: ADenum = .start
enum ADenum {
    case start
    case startAgain
    case exit
}
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone 
    case pad 
}
func getCef()->CGFloat{
    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    switch (deviceIdiom) {
    case .pad:
        return 5
    case .phone:
        return 4
    default:
        return 5
    }
}
func getCefY()->CGFloat{
    let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
    switch (deviceIdiom) {
    case .pad:
        return 1.3
    case .phone:
        return 1
    default:
        return 5
    }
}
public class Helper{
    struct sizes {
        let blockLetter = Int(UIScreen.main.bounds.width/getCef())
    }
    func returnSize(color: sizeEnum)->Int{
        switch color {
        case .blockLetter:
            return sizes().blockLetter
        }
    }
    enum sizeEnum: Int {
        case blockLetter = 1
    }
    static let shared = Helper()
    enum colorEnum: Int {
        case backgroundColor = 0
        case blockColor = 1
        case labelFontColor = 2
        case progressBarColor = 3
        case emptyBlockColor = 4
    }
    struct colorStruct {
        let backgroundColor = UIColor(red:0.28, green:0.32, blue:0.40, alpha:1.0)
        let blockColor = UIColor(red:21/255.0, green:170/255.0, blue:254/255.0, alpha:1.0)
        let emptyBlockColor = UIColor(red:0.14, green:0.16, blue:0.20, alpha:1.0) 
        let labelFontColor = UIColor.white
        let progressBarColor = UIColor(red:0.03, green:0.85, blue:0.84, alpha:1.0) 
    }
    struct buttonColor {
        let questionButtonColor = UIColor(red:0.12, green:0.67, blue:0.54, alpha:1.0)
        let pauseButtonColor  = UIColor(red:0.89, green:0.24, blue:0.34, alpha:1.0)
    }
    func returnButtonColor(key: gameButtonColor)->UIColor{
        switch key {
        case .pause:
            return buttonColor().pauseButtonColor
        case .question:
            return buttonColor().questionButtonColor
        }
    }
    enum gameButtonColor: Int {
        case question = 0
        case pause = 1
    }
    func returnColor(color: colorEnum)->UIColor{
        switch color {
        case .backgroundColor:
            return colorStruct().backgroundColor
        case .blockColor:
            return colorStruct().blockColor
        case .labelFontColor:
            return colorStruct().labelFontColor
        case .progressBarColor:
            return colorStruct().progressBarColor
        case .emptyBlockColor:
            return colorStruct().emptyBlockColor
        }
    }
}
