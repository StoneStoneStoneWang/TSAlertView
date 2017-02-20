//
//  TSCustomAlertView.swift
//  ThreeStone
//
//  Created by 王磊 on 17/2/15.
//  Copyright © 2017年 ThreeStone. All rights reserved.
//

import UIKit
// 之后想做 有重力特效的 alert 所以这里加了

enum TSAlertShowMode: Int {
    case Alert
    case XLineRotate
}

enum TSAlertDismissAction: Int {
    case DarkShadow
    case Cancel
    case Confirm
}

private let Alert_DarkShadow_Show_Animated_Duration: NSTimeInterval = 0.3

private let Alert_DarkShadow_Dismiss_Animated_Duration: NSTimeInterval = 0.2

private let WhiteColor: UIColor = UIColor.whiteColor()

private let ClearColor: UIColor = UIColor.clearColor()

private let Alert_Dismiss_Animated_Duration: NSTimeInterval = 0.2

private let TSScreen_Width: CGFloat = CGRectGetWidth(UIScreen.mainScreen().bounds)

private let TSScreen_Height: CGFloat = CGRectGetHeight(UIScreen.mainScreen().bounds)

private func RGBColor(r: CGFloat,g: CGFloat ,b: CGFloat) -> UIColor {
    return UIColor(red: r / 255.0,green: g / 255.0,blue: b / 255.0,alpha: 1)
}

typealias TSAlertDismissHandler = (action: TSAlertDismissAction) -> ()

class TSCustomAlertView: UIView {
    
    required init(title: String) {
        super.init(frame: CGRectZero)
        
        self.title = title
        
        commitInitSubviews()
    }
    
    private var title: String?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal var showMode: TSAlertShowMode = .Alert
    
    internal var margin: CGFloat = 30
    
    private var contentView: UIView = UIView.getInstance()
    
    private var darkShadow: UIView = UIView.getInstance()
    
    internal var darkShadowAlpha: CGFloat = 0.3
    
    private var cancelItem: UIButton = UIButton(type: .Custom)
    
    private var confirmItem: UIButton = UIButton(type: .Custom)
    
    private var dismissHandler: TSAlertDismissHandler?
    
    private var customView: UIView?
    
    private var middleLine: UIView = UIView()
    
    private var topLine: UIView = UIView()
    
    private var bottomLine: UIView = UIView()
    
    private var titleLabel: UILabel = UILabel().then {
        
        $0.textAlignment = .Center
        
        $0.font = UIFont.systemFontOfSize(15)
        
        $0.textAlignment = .Center
    }
    
    private var titleColor: UIColor? {
        willSet {
            
            guard let _ = newValue else {
                
                return
            }
            
            titleLabel.textColor = newValue
        }
    }
    
    private var imageView: UIImageView = UIImageView()
    
    func commitInitSubviews() {
        titleColor = UIColor.blueColor()
        
        contentView.layer.cornerRadius = 5
        
        contentView.backgroundColor = WhiteColor
        
        titleLabel.text = title
        
        backgroundColor = ClearColor
        
        addSubview(darkShadow)
        
        addSubview(contentView)
        
        cancelItem.setTitle("取消", forState: .Normal)
        
        cancelItem.setTitle("取消", forState: .Highlighted)
        
        cancelItem.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        confirmItem.setTitle("确定", forState: .Normal)
        
        confirmItem.setTitle("确定", forState: .Highlighted)
        
        confirmItem.setTitleColor(UIColor.blueColor(), forState: .Normal)
        
        confirmItem.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        cancelItem.titleLabel?.font = UIFont.systemFontOfSize(15)
        
        middleLine.backgroundColor = UIColor.lightGrayColor()
        
        contentView.addSubview(middleLine)
        
        contentView.addSubview(cancelItem)
        
        contentView.addSubview(confirmItem)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(topLine)
        
        contentView.addSubview(bottomLine)
        
        topLine.backgroundColor = UIColor.lightGrayColor()
        
        bottomLine.backgroundColor = UIColor.lightGrayColor()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapTriggered))
        
        darkShadow.addGestureRecognizer(tap)
        
        darkShadow.layer.backgroundColor = RGBColor(30, g: 30, b: 30).CGColor
        
        confirmItem.addTarget(self, action: #selector(confirm), forControlEvents: .TouchUpInside)
        
        cancelItem.addTarget(self, action: #selector(cancle), forControlEvents: .TouchUpInside)
    }
}

extension TSCustomAlertView {
    internal func addCustomContentView(view: UIView) {
        
        customView = view
        
    }
}
extension TSCustomAlertView {
    
    internal func show(dismissHandler: TSAlertDismissHandler) {
        
        self.dismissHandler = dismissHandler
        
        let window = UIApplication.sharedApplication().keyWindow
        
        window?.addSubview(self)
        
        frame = UIScreen.mainScreen().bounds
        
        darkShadow.frame = bounds
        
        let contentView_Width: CGFloat = TS_Screen_Width - 2 * margin
        
        titleLabel.frame = CGRectMake(0, 0, contentView_Width, 40)
        
        contentView.frame = CGRectMake(margin,0 , contentView_Width, 40 + 40)
        
        contentView.center = CGPointMake(TS_Screen_Width / 2, TS_Screen_Height / 2)
        
        cancelItem.frame = CGRectMake(0, 40, contentView_Width / 2, 40)
        
        confirmItem.frame = CGRectMake(contentView_Width / 2, 40, contentView_Width / 2, 40)
        
        middleLine.frame = CGRectMake(contentView_Width / 2 - 0.25, 40, 0.5, 40)
        
        topLine.frame = CGRectMake(0, 40, contentView_Width, 0.5)
        
        bottomLine.frame = CGRectMake(0, 40, contentView_Width, 0.5)
        
        switch showMode {
        case .Alert:
            
            darkShadowShow()
            
            alertShow()
            
            break
        case .XLineRotate:
            
            darkShadow.alpha = 0
            
            XLineRotate()
            
            contentView.layer.borderColor = UIColor.lightGrayColor().CGColor
            
            contentView.layer.borderWidth = 0.5
            
            performSelector(#selector(delay), withObject: nil, afterDelay: 0.3)
            
            break
        default:
            
            break
        }
    }
    
    func delay() {
        
        darkShadowShow()
    }
    
    internal func dismiss() {
        
        UIView.animateWithDuration(Alert_DarkShadow_Dismiss_Animated_Duration, animations: {[weak self] in
            
            self!.darkShadow.alpha = 0
            
        }) {[weak self] (isFinished) in
            
            self!.hidden = true
            
            self!.removeFromSuperview()
        }
    }
}
// MARK: darkShadowShow animation
extension TSCustomAlertView {
    
    @objc private func darkShadowShow() {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.duration = Alert_DarkShadow_Show_Animated_Duration
        
        animation.removedOnCompletion = true
        
        animation.fillMode = kCAFillModeForwards
        
        animation.fromValue = 0
        
        animation.toValue = darkShadowAlpha
        
        animation.repeatCount = 1
        
        darkShadow.layer.addAnimation(animation, forKey: nil)
        
        darkShadow.alpha = darkShadowAlpha
    }
}
// MARK: action
extension TSCustomAlertView {
    @objc private func tapTriggered() {
        
        dismissHandler!(action: .DarkShadow)
        
        dismiss()
    }
    
    @objc private func confirm() {
        
        dismissHandler!(action: .Confirm)
        
        dismiss()
    }
    @objc private func cancle() {
        
        dismissHandler!(action: .Cancel)
        
        dismiss()
    }
}
// MARK: alert Animation
extension TSCustomAlertView {
    
    @objc private func alertShow() {
        
        let animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = 0.5
        
        animation.delegate = self
        
        animation.removedOnCompletion = true
        
        animation.fillMode = kCAFillModeForwards
        
        let values = NSMutableArray()
        
        values.addObject(NSValue(CATransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)))
        
        values.addObject(NSValue(CATransform3D: CATransform3DMakeScale(1.01, 1.01, 1.0)))
        
        values.addObject(NSValue(CATransform3D: CATransform3DMakeScale(0.99, 0.99, 0.99)))
        
        values.addObject(NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        
        animation.values = values as [AnyObject]
        
        animation.keyTimes = [0.0,0.5,0.75,1]
        
        animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        
        contentView.layer.addAnimation(animation, forKey: nil)
    }
}
extension TSCustomAlertView {
    
    @objc private func XLineRotate() {
        
        contentView.layer.anchorPoint = CGPointMake(0.5, 1)
        
        let animation = CABasicAnimation(keyPath: "transform.rotation.x")
        
        animation.duration = 0.3
        
        animation.fromValue = M_PI / 2
        
        animation.toValue = 0
        
        animation.repeatCount = 1
        
        contentView.layer.addAnimation(animation, forKey: nil)
    }
}

extension TSCustomAlertView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
    }
}
