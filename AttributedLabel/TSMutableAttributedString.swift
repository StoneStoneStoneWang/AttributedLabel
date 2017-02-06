//
//  TSMutableAttributedString.swift
//  ThreeStone
//
//  Created by 王磊 on 1/31/17.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    internal func setFont(font: UIFont) {
        
        setFont(font, range: NSMakeRange(0, length))
    }
    internal func setFont(font: UIFont ,range: NSRange) {
        
        removeAttribute(kCTFontAttributeName as String, range: range)
        
        let fontRef = CTFontCreateWithName(font.fontName, font.pointSize, nil)
        
        addAttribute(kCTFontAttributeName as String, value: fontRef, range: range)
    }
}
extension NSMutableAttributedString {
    
    internal func setTextColor(color: UIColor) {
        
        setTextColor(color, range: NSMakeRange(0, length))
    }
    internal func setTextColor(color: UIColor ,range: NSRange) {
        
        removeAttribute(kCTForegroundColorAttributeName as String, range: range)
        
        addAttribute(kCTForegroundColorAttributeName as String, value: color, range: range)
    }
}
extension NSMutableAttributedString {
    
    internal func setUnderlineStyle(style: CTUnderlineStyle ,modifier: CTUnderlineStyleModifiers) {
        
        setUnderlineStyle(style, modifier: modifier, range: NSMakeRange(0, length))
    }
    internal func setUnderlineStyle(style: CTUnderlineStyle ,modifier: CTUnderlineStyleModifiers ,range: NSRange) {
        
        removeAttribute(kCTUnderlineStyleAttributeName as String, range: range)
        
        addAttribute(kCTUnderlineStyleAttributeName as String, value: NSNumber(int: style.rawValue | modifier.rawValue), range: range)
    }
}

extension NSMutableAttributedString {
    
    internal func appendStrikeLine(range: NSRange) {
        
        addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.PatternSolid.rawValue | NSUnderlineStyle.StyleSingle.rawValue , range: range)
    }
}
