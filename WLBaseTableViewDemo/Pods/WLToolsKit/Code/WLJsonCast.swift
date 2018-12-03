//
//  WLJsonCast.swift
//  TSToolKit_Swift
//
//  Created by three stone 王 on 2018/11/30.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation

open class WLJsonCast {
    
    // 必须是遵守了序列化的对象
    public static func cast<T>(argu: T) -> String {
        
        do {
            
            let jsonData = try JSONSerialization.data(withJSONObject: argu, options: .prettyPrinted)
            
            return String(data: jsonData, encoding: String.Encoding.utf8)!
            
        } catch {
            
            return ""
        }
    }
    
    public static func cast(argu: String) -> AnyObject! {
        
        do {
            return try JSONSerialization.jsonObject(with: argu.data(using: String.Encoding.utf8)!, options: JSONSerialization.ReadingOptions.mutableLeaves) as AnyObject
            
        } catch {
            
            return nil
        }
    }
}
