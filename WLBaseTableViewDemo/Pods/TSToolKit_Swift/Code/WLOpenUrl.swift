//
//  WLOpenUrl.swift
//  WLToolKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All righWL reserved.
//

import UIKit

// MARK: openUrl
open class WLOpenUrl: NSObject {
    
    public static func openUrl(urlString: String) -> Bool {
        
        if let url = URL(string: urlString) {
            
            return UIApplication.shared.openURL(url)
        }
        return false
    }
}

// MARK: openSetting
extension WLOpenUrl {
    
    public static func openSetting() -> Bool {
        
        let settingUrl = URL(string: UIApplication.openSettingsURLString)
        
        if let url = settingUrl, UIApplication.shared.canOpenURL(url) {
            
            return UIApplication.shared.openURL(url)
        }
        return false
    }
}
