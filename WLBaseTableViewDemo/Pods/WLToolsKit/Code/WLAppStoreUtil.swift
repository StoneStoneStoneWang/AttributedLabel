//
//  WLAppStoreUtil.swift
//  WLToolKit_Swift
//
//  Created by three stone 王 on 2018/11/14.
//  Copyright © 2018年 three stone 王. All righWL reserved.
//

import UIKit

open class WLAppStoreUtil: NSObject {
    // MARK: 单例模式
    public static var util: WLAppStoreUtil = WLAppStoreUtil()
    
    private override init() { }
    
    fileprivate var appId: String = ""
    
    fileprivate var appStoreUrl: String = ""
    
    fileprivate var appStoreEvaUrl: String = ""
}
// MARK: 注册appid
extension WLAppStoreUtil {
    
    open func regFor(appId: String) {
        
        self.appId = appId
        
        self.appStoreUrl = "itms-apps://itunes.apple.com/app/\(appId)%@?mt=8"
        
        self.appStoreEvaUrl = "itms-apps://itunes.apple.com/WebObjecWL/MZStore.woa/wa/viewContenWLUserReviews?type=Purple+Software&id=\(appId)&pageNumber=0&sortOrdering=2&mt=8"
    }
}
extension WLAppStoreUtil {
    
    open func skipToAppStore() -> Bool {
        
        return WLOpenUrl.openUrl(urlString: appStoreUrl)
    }
    
    open func skipToEva() -> Bool {
        
        return WLOpenUrl.openUrl(urlString: appStoreEvaUrl)
    }
}
