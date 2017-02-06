//
//  TSAttributedLabelUrl.swift
//  ThreeStone
//
//  Created by 王磊 on 1/31/17.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit
let urlPattern = "((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((:[0-9]+)?)((?:\\/[\\+~%\\/\\.\\w\\-]*)?\\??(?:[\\-\\+=&;%@\\.\\w]*)#?(?:[\\.\\!\\/\\\\\\w]*))?)"
var customDetectBlock: TSCustomDetectedLinkBlock?
class TSAttributedLabelUrl: NSObject {
    var lindData: AnyObject?
    var range: NSRange?
    var color: UIColor?
}
extension TSAttributedLabelUrl {
    
    static func url(linkData: AnyObject ,range: NSRange , linkColor: UIColor?)
        -> TSAttributedLabelUrl {
            
            let url = TSAttributedLabelUrl()
            
            url.lindData = linkData
            
            url.range = range
            
            url.color = linkColor
            
            return url
    }
}
extension TSAttributedLabelUrl {
    // 检测文本中 自定义查找接口 或者 url 接口
    class func detectedText(plainText: String) -> Array<TSAttributedLabelUrl> {
        if (customDetectBlock != nil) {
            return customDetectBlock!(text: plainText)
        } else {
            
            var links: Array<TSAttributedLabelUrl> = []
            let urlRegex = try! NSRegularExpression(pattern: urlPattern, options: .CaseInsensitive)
            urlRegex.enumerateMatchesInString(plainText, options: .ReportCompletion, range: NSMakeRange(0, (plainText as NSString).length), usingBlock: { (result, _, _) -> Void in
                
                guard let _ = result else {
                    
                    return
                }
                
                let range = result!.range
                
                let text = (plainText as NSString).substringWithRange(range)
                
                let link = TSAttributedLabelUrl.url(text, range: range, linkColor: nil)
                
                links += [link]
                
            })
            return links
        }
    }
}

extension TSAttributedLabelUrl {
    
    class func setCustomDetectMethod(block: TSCustomDetectedLinkBlock)  {
        customDetectBlock = block
    }
}
typealias TSCustomDetectedLinkBlock = (text: String) -> Array<TSAttributedLabelUrl>

