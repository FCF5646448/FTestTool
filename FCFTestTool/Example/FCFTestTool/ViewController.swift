//
//  ViewController.swift
//  FCFTestTool
//
//  Created by FCF5646448 on 12/09/2020.
//  Copyright (c) 2020 FCF5646448. All rights reserved.
//

import UIKit
import FCFTestTool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FLogLevel.minShow()
    }

}

