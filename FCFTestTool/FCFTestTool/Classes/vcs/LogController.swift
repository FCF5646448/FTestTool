//
//  LogController.swift
//  FCFTestTool
//
//  Created by 冯才凡 on 2020/12/10.
//

import UIKit
import Masonry


class LogController: UIViewController {
    
    var btnActionBlock:((_ type: SwitchWindowStatus) -> Void)?
    var iconBtn: UIButton!
    var returnBtn: UIButton!
    
    
    var userInterface: Bool = false
    
    public var originRect: CGRect!
    public var log_consoleBtn = UIButton(type: .custom)
    public var log_returnBtn = UIButton(type: .custom)
    
    
    private let tab: UITabBarController =  UITabBarController()
    private lazy var apiVC =  APILogViewController()
    private lazy var infoVC = InfoLogViewController()
    private lazy var toolVC = ToolLogViewController()
    
    private var tabBatItemsDatas:[(title:String,imgName:String,selImgName:String)] = [("link","tab_link_unsel","tab_link_sel"),("info","tab_info_unsel","tab_info_sel"),("tool","tab_tool_unsel","tab_tool_sel")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configUI()
    }
    
    
    func configUI() {
        self.addChildViewController(self.tab)
        self.view.addSubview(self.tab.view)
        self.tab.view.mas_makeConstraints {
            $0?.edges.mas_equalTo()(self.view)
        }
        
        let bundlePatch = Bundle.init(for: self.classForCoder).resourcePath?.stringByAppendingPathComponent1(path: "/FCFTestTool.bundle")
        let resonce_bundle = Bundle(path: bundlePatch!)
        
        
        let vcs = [self.apiVC, self.infoVC, self.toolVC]
        var navs = [UINavigationController]()
        var i = 0
        for item in vcs {
            let barItem = factory(tabBatItemsDatas[i].title, tabBatItemsDatas[i].imgName, tabBatItemsDatas[i].selImgName)
            item.tabBarItem = barItem
            navs.append(UINavigationController(rootViewController: item))
            i += 1
        }
        
        self.tab.viewControllers = navs
        
        self.tab.view.addSubview(log_returnBtn)
        log_returnBtn.mas_makeConstraints {
            $0?.left.mas_equalTo()(self.view)?.offset()(0)
            $0?.top.mas_equalTo()(self.view)?.offset()(0)
            $0?.width.mas_equalTo()(44)
            $0?.height.mas_equalTo()(44)
        }
        
        log_returnBtn.setImage(UIImage(named: "close", in: resonce_bundle, compatibleWith: nil), for: .normal)
        log_returnBtn.addTarget(self, action: #selector(log_returnBtnAction), for: .touchUpInside)
        
        
        
        view.addSubview(log_consoleBtn)
        log_consoleBtn.frame = self.view.bounds
        log_consoleBtn.mas_makeConstraints {
            $0?.edges.mas_equalTo()(self.view)
        }
        
        log_consoleBtn.backgroundColor = .white
        log_consoleBtn.setImage(UIImage(named: "log_console", in: resonce_bundle, compatibleWith: nil) , for: .normal)
        log_consoleBtn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        log_consoleBtn.addTarget(self, action: #selector(log_consoleBtnAction), for: .touchUpInside)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(movePan(_:)))
        log_consoleBtn.addGestureRecognizer(pan)
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.setNeedsLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("xxxx")
    }
    

}

extension LogController {
    @objc func tabbarSeleteClick(_ index: Int) {
        self.tab.selectedIndex = index
        
    }
    
    @objc func log_consoleBtnAction() {
        btnActionBlock?(.max)
    }
    
    @objc func log_returnBtnAction() {
        btnActionBlock?(.min)
    }
    
    @objc func movePan(_ sender:UIPanGestureRecognizer){
        guard sender.view != nil else {
            return
        }
        sender.view!.superview?.bringSubview(toFront: sender.view!)
        
        let p = sender.translation(in: self.log_consoleBtn)
        if var origin = self.originRect {
            if origin.origin.x >= 0 || (origin.origin.x + origin.size.width) <= Log_ScreenWidth {
                origin.origin.x += p.x
            }
            if origin.origin.y >= 0 || (origin.origin.y + origin.size.height) <= Log_ScreenHeight {
                origin.origin.y += p.y
            }
            
            self.originRect = origin
        }
        
        sender.setTranslation(CGPoint.zero, in: UIApplication.shared.keyWindow)
        
        btnActionBlock?(.move)
        if sender.state == .changed {
            log_consoleBtn.isEnabled = false
        }else if sender.state == .ended {
            log_consoleBtn.isEnabled = true
            btnActionBlock?(.movend)
        }
    }
}


extension LogController {
    func factory(_ title:String,_ imgName:String,_ selImgName:String) -> UITabBarItem {
        let bundlePatch = Bundle.init(for: self.classForCoder).resourcePath?.stringByAppendingPathComponent1(path: "/FCFTestTool.bundle")
        let resonce_bundle = Bundle(path: bundlePatch!)
        let item = UITabBarItem(title: title, image: UIImage(named: imgName, in: resonce_bundle, compatibleWith: nil), selectedImage: UIImage(named: selImgName))
        
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.red], for: .selected)
        
        return item
    }
}
