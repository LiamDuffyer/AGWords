import UIKit
import SpriteKit
import GameplayKit
var topPadding: CGFloat = 0.0
class GameViewController: UIViewController {
    var sceneTest: GameScene? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        loadScene()
    }
    func loadScene(){
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size, scaleMode:SKSceneScaleMode.aspectFill, viewController: self)
            sceneTest = scene
            scene.size = view.bounds.size
            scene.scaleMode = SKSceneScaleMode.aspectFill
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            view.presentScene(scene)
        }
    }
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
