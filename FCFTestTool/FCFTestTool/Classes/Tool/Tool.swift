//
//  Tool.swift
//  FCFTestTool
//
//  Created by 冯才凡 on 2020/12/12.
//

import Foundation

extension String {
    func stringByAppendingPathComponent1(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
}


