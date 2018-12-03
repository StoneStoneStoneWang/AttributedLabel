//
//  DateUtil.swift
//  TSToolKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation

extension Date {
    
    public static func getTimeStamp_S() -> String {
        
        return "\(Int8(Date().timeIntervalSince1970))"
    }
    
    public static func getTimeStamp_MS() -> String {
        
        return "\(UInt64(Date().timeIntervalSince1970 * 1000))"
    }
}
