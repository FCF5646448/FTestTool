//
//  APILogViewController.swift
//  FCFTestTool
//
//  Created by 冯才凡 on 2020/12/10.
//

import UIKit

class APILogViewController: UIViewController {

    var tb = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func configUI() {
        view.addSubview(tb)
        tb.mas_makeConstraints {
            $0?.edges.mas_equalTo()(self.view)
        }
    }
}
