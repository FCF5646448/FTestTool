//
//  TestToolSwitchWindow.swift
//  FCFTestTool
//
//  Created by 冯才凡 on 2020/12/10.
//

import Foundation
import UIKit


enum SwitchWindowStatus {
    case min
    case max
    case move
    case movend
}

public let FLogLevel = TestToolSwitchWindow.share

let Log_ScreenWidth:CGFloat      = UIScreen.main.bounds.size.width
let Log_ScreenHeight:CGFloat     = UIScreen.main.bounds.size.height
let Log_ScreenSize:CGSize        = UIScreen.main.bounds.size
var Log_keyWindowSize:CGSize {
    guard let wd = UIApplication.shared.delegate?.window else {
        return CGSize(width: 375, height: 812)
    }
    return wd!.frame.size
}

@objc public class TestToolSwitchWindow: UIView {
    var minRect: CGRect!
    var maxRect: CGRect!
    
    lazy var vc: LogController = {
        let vc = LogController()
        return vc
    }()
    
    var currentType: SwitchWindowStatus = .min {
        didSet{
            switch self.currentType {
            case .min:
                break
            case .max:
                break
            case .move:
                break
            case .movend:
                break
            }
        }
    }
    
    
    static let share = TestToolSwitchWindow()
    private init() {
        super.init(frame: CGRect(origin: CGPoint(x: Log_keyWindowSize.width - 60, y: Log_keyWindowSize.height-40-64), size: CGSize(width: 50, height: 50)))
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configUI() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.maxRect = CGRect(x: 0, y: Log_keyWindowSize.height*1.0/3.0, width: Log_keyWindowSize.width, height: Log_keyWindowSize.height*2.0/3.0)
        self.minRect = CGRect(x: Log_keyWindowSize.width - 60, y: Log_keyWindowSize.height-40-64, width: 50, height: 50)
        self.vc.originRect = minRect
        
        self.addSubview(self.vc.view)
        
        self.vc.btnActionBlock = {[weak self] (status) in
            switch status {
            case .min:
                self?.minShow()
            case .max:
                self?.maxShow()
            case .move:
                self?.move()
            case .movend:
                self?.movend()
            }
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.vc.view.frame = self.bounds
    }
    
}

extension TestToolSwitchWindow {
    @objc public func minShow() {
        guard let wd = UIApplication.shared.delegate?.window as? UIWindow else { //
            return
        }
        wd.addSubview(self)
        wd.bringSubview(toFront: self)
        self.frame = self.minRect
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.vc.log_consoleBtn.isHidden = false
        
        self.setNeedsLayout()
        self.isHidden = false
    }
    
    @objc public func maxShow() {
        guard let wd = UIApplication.shared.delegate?.window else {
            return
        }
        wd!.addSubview(self)
        wd!.bringSubview(toFront: self)
        self.frame = self.maxRect
        self.layer.cornerRadius = 0
        self.layer.masksToBounds = true
        
        self.vc.log_consoleBtn.isHidden = true
        self.setNeedsLayout()
        
        self.isHidden = false
        
    }
    
    @objc public func move() {
        self.minRect = self.vc.originRect
        self.frame = self.minRect
        self.setNeedsLayout()
    }
    
    @objc public func movend() {
        guard var rect = self.minRect else {
            return
        }
        if rect.origin.x < Log_ScreenWidth/2.0 {
            rect.origin.x = 5
        }
        
        if rect.origin.x >= Log_ScreenWidth/2.0 {
            rect.origin.x = (Log_ScreenWidth - 5 - 50)
        }
        
        if rect.origin.y < 64 {
            rect.origin.y = 64
        }
        
        if rect.origin.y > Log_ScreenHeight - 50 - 49 {
            rect.origin.y = Log_ScreenHeight - 50 - 49
        }
        
        UIView.animate(withDuration: 0.24) {
            self.minRect = rect
            self.frame = self.minRect
            self.vc.originRect = self.minRect
            self.setNeedsLayout()
        }
        
    }
    
}


extension TestToolSwitchWindow {
    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let gesView = super.hitTest(point, with: event)
        
        print(gesView?.classForCoder as Any)
        
        return gesView
    }
}
