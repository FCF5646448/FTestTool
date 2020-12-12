//
//  LogPrint.swift
//  FCFTestTool
//
//  Created by 冯才凡 on 2020/12/12.
//

import Foundation

@objc public protocol FlogPrintProtocol {
    @objc optional func setFlogPrintTool_on_off() -> Bool
}

class FLogPrint: NSObject {
    private var logArr = [String]()
    private var openPrint: Bool {
        return self.delegate?.setFlogPrintTool_on_off?() ?? false
    }
    // 自定义并发队列
    private let concurrentQueue = DispatchQueue(label: "com.btclass.logprint", attributes: .concurrent)
    
    @objc public weak var delegate: FlogPrintProtocol?
    @objc public var logDidChanged: (()->Void)?
    
    static let share = FLogPrint()
    
    private override init() {
        super.init()
    }
    
    /*
     loglevel:
     BuglyLogLevelError   = 1,
     BuglyLogLevelWarn    = 2,
     BuglyLogLevelInfo    = 3,
     BuglyLogLevelDebug   = 4,
     
     */
    public func recordLog<T>(_ message: T,_ loglevel: Int, file: String = #file, method: String = #function, line: Int = #line) {
        
        if openPrint == false {
            return
        }
        
        if loglevel < 3 {
            writeInfo("\(message)", file:file, method: method, line: line)
        }else{
            write("\(message)")
        }
    }
    
    private func write(_ message: String) {
        self.concurrentQueue.async(flags: .barrier) {
            self.logArr.insert("\(message)\n", at: 0)
            DispatchQueue.main.async {
                // 发送通知
            }
        }
    }
    
    private func writeInfo(_ message: String, file: String = #file, method: String = #function, line: Int = #line) {
        self.concurrentQueue.async(flags: .barrier) {
            self.logArr.insert("\(message)\n loc:\(file);\(method);\(line)\n", at: 0)
            DispatchQueue.main.async {
                // 发送通知
                self.logDidChanged?()
            }
        }
    }
    
    public func readLgArr() -> [String] {
        var logsCopy: [String]!
        self.concurrentQueue.sync {
            logsCopy = self.logArr
        }
        return logsCopy
    }
    
    
    public func clear() {
        self.concurrentQueue.async(flags: .barrier) {
            self.logArr.removeAll()
        }
    }
    
}
