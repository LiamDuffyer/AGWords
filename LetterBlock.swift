import Foundation
import SpriteKit
class LetterBlock: SKSpriteNode{
    var labelLetter = SKLabelNode(fontNamed:"Panton")
    var isMoving = false
    var isColorise = false
    var index = 0
    var ref: LetterBlock? = nil
    var kek = false
    init(color: UIColor, size: CGSize!, letter: String!, position: CGPoint!, index: Int) {
        super.init(texture: nil, color: color, size: size)
        self.index = index
        self.position = position
        self.labelLetter.fontSize = size.height/1.5
        self.labelLetter.text = letter
        self.labelLetter.horizontalAlignmentMode = .center
        self.labelLetter.verticalAlignmentMode = .center
        self.labelLetter.fontColor = Helper.shared.returnColor(color: .labelFontColor)
        self.isUserInteractionEnabled = false
        self.addChild(labelLetter)
    }
    func colorize(){
        let colorize = SKAction.colorize(with: Helper.shared.returnColor(color: .emptyBlockColor), colorBlendFactor: 1, duration: 0.05)
        self.run(colorize)
    }
    func invertColorize(){
        let colorize = SKAction.colorize(with: Helper.shared.returnColor(color: .blockColor), colorBlendFactor: 1, duration: 0.05)
        self.run(colorize)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
