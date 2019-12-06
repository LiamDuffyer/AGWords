import UIKit
public enum AABlurActionStyleSecond {
    case `default`, cancel, modern, modernCancel
}
public enum AABlurTopImageStyleSecond {
    case `default`, fullWidth
}
public enum AABlurAlertStyleSecond {
    case `default`, modern
}
open class AABlurAlertActionSecond: UIButton {
    fileprivate var handler: ((AABlurAlertActionSecond) -> Void)? = nil
    fileprivate var style: AABlurActionStyleSecond = AABlurActionStyleSecond.default
    fileprivate var parent: AABlurAlertControllerSecond? = nil
    var animation = true
    public init(title: String?, style: AABlurActionStyleSecond, handler: ((AABlurAlertActionSecond) -> Void)?) {
        super.init(frame: CGRect.zero)
        self.style = style
        self.handler = handler
        self.addTarget(self, action: #selector(buttonTapped), for: UIControl.Event.touchUpInside)
        self.setTitle(title, for: UIControl.State.normal)
        switch self.style {
        case .cancel:
            self.setTitleColor(UIColor(red:0.47, green:0.50, blue:0.55, alpha:1.00), for: UIControl.State.normal)
            self.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
            self.layer.borderColor = UIColor(red:0.74, green:0.77, blue:0.79, alpha:1.00).cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.1
        case .modernCancel:
            self.setTitleColor(UIColor(red:0.01, green:0.66, blue:0.96, alpha:1.0), for: UIControl.State.normal)
            self.backgroundColor = UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.00)
            self.titleLabel?.font = UIFont(name:"Panton", size: 15)
            self.layer.cornerRadius = 5
        case .modern:
            self.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.backgroundColor = Helper().returnColor(color: .blockColor)
            self.titleLabel?.font = UIFont(name:"Panton", size: 15)
            self.layer.cornerRadius = 5
        default:
            self.setTitleColor(UIColor.white, for: UIControl.State.normal)
            self.backgroundColor = UIColor(red:0.31, green:0.57, blue:0.87, alpha:1.00)
            self.layer.borderColor = UIColor(red:0.17, green:0.38, blue:0.64, alpha:1.00).cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.1
        }
        self.setTitleColor(self.titleColor(for: UIControl.State.normal)?.withAlphaComponent(0.5), for: UIControl.State.highlighted)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    @objc fileprivate func buttonTapped(_ sender: AABlurAlertActionSecond) {
        self.parent?.dismiss(animated: animation, completion: {
            self.handler?(sender)
        })
    }
}
open class AABlurAlertControllerSecond: UIViewController {
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    open var alertStyle: AABlurAlertStyleSecond = AABlurAlertStyleSecond.default
    open var blurEffectStyle: UIBlurEffect.Style = .light
    open var imageHeight: Float = 175
    open var topImageStyle: AABlurTopImageStyleSecond = AABlurTopImageStyleSecond.default
    open var alertViewWidth: Float?
    open var maxAlertViewWidth: CGFloat? = 450
    private var spacing: Int = 16
    private var titleSubtitleSpacing: Int = 16
    var widht1 = 44
    var widht2 = 0
    private var bottomSpacing: Int = 32
    fileprivate var backgroundImage : UIImageView = UIImageView()
    fileprivate var alertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        return view
    }()
    open var alertImage : UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    public let alertTitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 17)
        lbl.textColor = UIColor(red:0.20, green:0.22, blue:0.26, alpha:1.00)
        lbl.textAlignment = .center
        return lbl
    }()
    public let alertSubtitle : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 14)
        lbl.textColor = UIColor(red:0.51, green:0.54, blue:0.58, alpha:1.00)
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    let buttonsStackView : UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .fillEqually
        sv.spacing = 22
        return sv
    }()
    public init() {
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = .crossDissolve
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setup() {
        self.view.subviews.forEach{ $0.removeFromSuperview() }
        self.backgroundImage.subviews.forEach{ $0.removeFromSuperview() }
        self.view.frame = UIScreen.main.bounds
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        self.backgroundImage.frame = self.view.bounds
        self.backgroundImage.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.addSubview(backgroundImage)
        self.alertView.clipsToBounds = true
        switch self.alertStyle {
        case .modern:
            self.alertView.layer.cornerRadius = 13
            self.titleSubtitleSpacing = 32
            self.bottomSpacing = 24
        default:
            self.alertView.layer.cornerRadius = 5
            self.alertView.layer.shadowColor = UIColor.black.cgColor
            self.alertView.layer.shadowOffset = CGSize(width: 0, height: 15)
            self.alertView.layer.shadowRadius = 12
            self.alertView.layer.shadowOpacity = 0.22
        }
        self.view.addSubview(alertView)
        self.alertView.addSubview(alertImage)
        self.alertView.addSubview(alertTitle)
        self.alertView.addSubview(alertSubtitle)
        self.alertView.addSubview(buttonsStackView)
        if buttonsStackView.arrangedSubviews.count <= 0 {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnBackground))
            self.backgroundImage.isUserInteractionEnabled = true
            self.backgroundImage.addGestureRecognizer(tapGesture)
        }
        setupConstraints()
    }
    fileprivate func setupConstraints() {
        let viewsDict: [String: Any] = [
            "alertView": alertView,
            "alertImage": alertImage,
            "alertTitle": alertTitle,
            "alertSubtitle": alertSubtitle,
            "buttonsStackView": buttonsStackView
        ]
        let viewMetrics: [String: Any] = [
            "margin": spacing * 2,
            "spacing": spacing,
            "titleSubtitleSpacing": titleSubtitleSpacing,
            "bottomSpacing": bottomSpacing,
            "alertViewWidth": 450,
            "alertImageHeight": (alertImage.image != nil) ? imageHeight : 0,
            "alertTitleHeight": 22,
            "buttonsStackViewHeight": (buttonsStackView.arrangedSubviews.count > 0) ? widht1 : widht2
        ]
        if let alertViewWidth = alertViewWidth {
            self.view.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "H:[alertView(alertViewWidth)]", options: [],
                metrics: ["alertViewWidth":alertViewWidth], views: viewsDict))
        } else {
            let widthConstraints = NSLayoutConstraint(item: alertView,
                                                      attribute: NSLayoutConstraint.Attribute.width,
                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                      toItem: self.view,
                                                      attribute: NSLayoutConstraint.Attribute.width,
                                                      multiplier: 0.7, constant: 0)
            if let maxAlertViewWidth = maxAlertViewWidth {
                widthConstraints.priority = UILayoutPriority(rawValue: 999)
                self.view.addConstraint(NSLayoutConstraint(
                    item: alertView,
                    attribute: NSLayoutConstraint.Attribute.width,
                    relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
                    toItem: nil,
                    attribute: NSLayoutConstraint.Attribute.width,
                    multiplier: 1,
                    constant: maxAlertViewWidth))
            }
            self.view.addConstraint(widthConstraints)
        }
        let alertSubtitleVconstraint = (alertSubtitle.text != nil) ? "titleSubtitleSpacing-[alertSubtitle]-" : ""
        [NSLayoutConstraint(item: alertView, attribute: .centerX, relatedBy: .equal,
                            toItem: view, attribute: .centerX, multiplier: 1, constant: 0),
         NSLayoutConstraint(item: alertView, attribute: .centerY, relatedBy: .equal,
                            toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            ].forEach { self.view.addConstraint($0)}
        let imageStyleMargin = self.topImageStyle == .fullWidth ? "0" : "margin"
        [NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-\(imageStyleMargin)-[alertImage(alertImageHeight)]-spacing-[alertTitle(alertTitleHeight)]-\(alertSubtitleVconstraint)margin-[buttonsStackView(buttonsStackViewHeight)]-bottomSpacing-|",
            options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(imageStyleMargin)-[alertImage]-\(imageStyleMargin)-|",
            options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertTitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[alertSubtitle]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict),
         NSLayoutConstraint.constraints(withVisualFormat: "H:|-margin-[buttonsStackView]-margin-|",
                                        options: [], metrics: viewMetrics, views: viewsDict)
            ].forEach { NSLayoutConstraint.activate($0) }
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        backgroundImage.image = snapshot()
        let blurEffect = UIBlurEffect(style: blurEffectStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyEffectView.frame = backgroundImage.bounds
        vibrancyEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.contentView.addSubview(vibrancyEffectView)
        backgroundImage.addSubview(blurEffectView)
    }
    open func addAction(action: AABlurAlertActionSecond, animation: Bool = true) {
        action.parent = self
        action.animation = animation
        buttonsStackView.addArrangedSubview(action)
    }
    fileprivate func snapshot() -> UIImage? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, window.screen.scale)
        window.drawHierarchy(in: window.bounds, afterScreenUpdates: false)
        let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    @objc func tapOnBackground(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
