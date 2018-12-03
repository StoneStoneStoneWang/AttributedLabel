//
//  WLCommon.swift
//  WLToolKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All righWL reserved.
//

import Foundation
import UIKit


// MARK: Screen 相关

public let WL_SCREEN_BOUNDS: CGRect = UIScreen.main.bounds

public let WL_SCREEN_SIZE: CGSize = UIScreen.main.bounds.size

public let WL_SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width

public let WL_SCREEN_HEIGHT: CGFloat = UIScreen.main.bounds.height

public var KISIPHONEX: Bool = __CGSizeEqualToSize(CGSize(width: 375.0, height: 812.0), WL_SCREEN_SIZE) || __CGSizeEqualToSize(CGSize(width: 812.0, height: 375.0), WL_SCREEN_SIZE)

public let WL_STATUSBAR_HEIGHT: CGFloat = KISIPHONEX ? 44 : 20

public let WL_TABBAR_HEIGHT: CGFloat = KISIPHONEX ? 34 + 49 : 49


// MARK: printLog
public func printLog<T>(message: T,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line)
{
    
    debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message): \(Date.getTimeStamp_MS())")
}

// MARK: 获取手机信息
/***********************************
 **     设备名
 ***********************************/
public let DeviceName: String = UIDevice.current.name
/***********************************
 **   操作系统
 ***********************************/
public let DeviceOS: String = UIDevice.current.systemName
/***********************************
 **  设备id
 ***********************************/
public let DeviceVersion: String = UIDevice.current.systemVersion
/***********************************
 **  设备id
 ***********************************/
public let DeviceId: String = UIDevice.current.identifierForVendor!.uuidString
/***********************************
 **  设备机型
 ***********************************/
public let DeviceModel: String = String.correspondVersion()

extension String {
    
    fileprivate static func correspondVersion() -> String {
        let name = UnsafeMutablePointer<utsname>.allocate(capacity: 1)
        uname(name)
        let machine = withUnsafePointer(to: &name.pointee.machine, { (ptr) -> String? in
            
            let int8Ptr = ptr.withMemoryRebound(to: Int8.self, capacity: 1, {
                
                return $0
            })
            return String(cString : int8Ptr)
        })
        
        _ = withUnsafePointer(to: &name.pointee.nodename, { (ptr) -> String? in
            
            let int8Ptr = ptr.withMemoryRebound(to: Int8.self, capacity: 1, {
                
                return $0
            })
            return String(cString : int8Ptr)
        })
        
        name.deallocate()
        
        if let deviceString = machine {
            switch deviceString {
            //iPhone
            case "iPhone1,1":                return "iPhone 1G"
            case "iPhone1,2":                return "iPhone 3G"
            case "iPhone2,1":                return "iPhone 3GS"
            case "iPhone3,1", "iPhone3,2":   return "iPhone 4"
            case "iPhone4,1":                return "iPhone 4S"
            case "iPhone5,1", "iPhone5,2":   return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":   return "iPhone 5C"
            case "iPhone6,1", "iPhone6,2":   return "iPhone 5S"
            case "iPhone7,1":                return "iPhone 6 Plus"
            case "iPhone7,2":                return "iPhone 6"
            case "iPhone8,1":                return "iPhone 6s"
            case "iPhone8,2":                return "iPhone 6s Plus"
            case "iPhone8,4":                return "iPhone SE"
            case "iPhone9,3":                return "iPhone 7"
            case "iPhone9,1":                return "iPhone 7"
            case "iPhone9,2":                return "iPhone 7 Plus"
            case "iPhone9,4":                return "iPhone 7 Plus"
            // iPad
            case "iPad1,1":                  return "iPad"
            case "iPad2,1":                  return "iPad2"
            case "iPad2,2":                  return "iPad2"
            case "iPad2,3":                  return "iPad2"
            case "iPad2,4":                  return "iPad2"
            case "iPad3,1":                  return "iPad (3rd generation)"
            case "iPad3,2":                  return "iPad (3rd generation)"
            case "iPad3,3":                  return "iPad (3rd generation)"
            case "iPad3,4":                  return "iPad (4th generation)"
            case "iPad3,5":                  return "iPad (4th generation)"
            case "iPad3,6":                  return "iPad (4th generation)"
            case "iPad4,1":                  return "iPad Air"
            case "iPad4,2":                  return "iPad Air"
            case "iPad4,3":                  return "iPad Air"
            case "iPad5,3":                  return "iPad Air 2"
            case "iPad5,4":                  return "iPad Air 2"
            case "iPad6,7":                  return "iPad Pro (12.9-inch)"
            case "iPad6,8":                  return "iPad Pro (12.9-inch)"
                
            case "iPad6,3":                  return "iPad Pro (9.7-inch)"
            case "iPad6,4":                  return "iPad Pro (12.9-inch)"
            case "iPad6,11":                  return "iPad (5th generation)"
            // 模拟器
            case "x86_64":                  return "Simulator"
            default:
                return "Simulator"
            }
        } else {
            return "Unknown"
        }
    }
}
/***********************************
 **  像素
 ***********************************/
public let DeviceResolution: String = NSCoder.string(for: CGSize(width: UIScreen.main.bounds.width * UIScreen.main.scale,height: UIScreen.main.bounds.height * UIScreen.main.scale))

