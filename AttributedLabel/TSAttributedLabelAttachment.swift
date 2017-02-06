//
//  TSAttributedLabelAttachment.swift
//  ThreeStone
//
//  Created by 王磊 on 1/31/17.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit

enum TSImageAlignment: Int {
    case Top
    case Center
    case Bottom
}

class TSAttributedLabelAttachment: NSObject {
    
    var content: AnyObject?
    
    var margin: UIEdgeInsets?
    
    var alginment: TSImageAlignment?
    
    var fontAscent: CGFloat?
    
    var fontDescent: CGFloat?
    
    var maxSize: CGSize?
    
}
extension TSAttributedLabelAttachment {
    
    static func attachment(content: AnyObject , margin: UIEdgeInsets , alignment: TSImageAlignment , maxSize: CGSize) -> TSAttributedLabelAttachment {
        
        let attachment = TSAttributedLabelAttachment()
        
        attachment.content = content
        
        attachment.margin = margin
        
        attachment.alginment = alignment
        
        attachment.maxSize = maxSize
        
        return attachment
    }
    
    internal func boxSize() -> CGSize {
        var contentSize = attachmentSize()
        
        if maxSize?.width > 0 && maxSize?.height > 0 && contentSize.width > 0 && contentSize.height > 0 {
            contentSize = calculateContentSize()
        }
        return CGSize(width: contentSize.width + (margin?.left)! + (margin?.right)!, height: contentSize.height + (margin?.top)! + (margin?.bottom)!)
    }
}
// 计算size
extension TSAttributedLabelAttachment {
    
    private func calculateContentSize() -> CGSize {
        let attachmentForSize: CGSize = attachmentSize()
        
        let width = attachmentForSize.width
        
        let height = attachmentForSize.height
        
        let newWidth = maxSize?.width
        
        let newHeight = maxSize?.height
        
        if width <= newWidth && height <= newHeight {
            
            return attachmentForSize
        }
        return (width / height > newWidth! / newHeight!) ? CGSize(width: newWidth!, height: newWidth! * height / width) : CGSize(width: newHeight! * width / height, height: newHeight!)
    }
    
    private func attachmentSize() -> CGSize {
        
        var size: CGSize = CGSizeZero
        
        if content is UIImage {
            size = (content as! UIImage).size
        }
        if content is UIView {
            
            size = (content as! UIView).size
            
        }
        return size
    }
}

public func deallocCallBack(ref: UnsafeMutablePointer<Void>) {
    
}
public func widthCallback(ref: UnsafeMutablePointer<Void>) -> CGFloat {
    
    let image: TSAttributedLabelAttachment = unsafeBitCast(ref, TSAttributedLabelAttachment.self)
    return image.boxSize().width
}
public func ascentCallBack(ref: UnsafeMutablePointer<Void>) -> CGFloat {
    let image: TSAttributedLabelAttachment = unsafeBitCast(ref, TSAttributedLabelAttachment.self)
    
    var ascent: CGFloat = 0
    
    let height: CGFloat = image.boxSize().height
    
    switch image.alginment! {
    case .Top:
        ascent = height - image.fontAscent!
        break
    case .Center:
        let fontAscent: CGFloat = image.fontAscent!
        
        let fontDescent: CGFloat = image.fontDescent!
        
        let basiLine = (fontAscent + fontDescent) / 2 - fontDescent
        
        ascent = height / 2 + basiLine
        break
    case .Bottom:
        
        ascent = height - image.fontDescent!
        
        break
    }
    
    return ascent
}

public func descentCallBack(ref: UnsafeMutablePointer<Void>) -> CGFloat {
    let image: TSAttributedLabelAttachment = unsafeBitCast(ref, TSAttributedLabelAttachment.self)
    
    var descent: CGFloat = 0
    
    let height: CGFloat = image.boxSize().height
    
    switch image.alginment! {
    case .Top:
        descent = height - image.fontAscent!
        break
    case .Center:
        let fontAscent: CGFloat = image.fontAscent!
        
        let fontDescent: CGFloat = image.fontDescent!
        
        let basiLine = (fontAscent + fontDescent) / 2 - fontDescent
        
        descent = height / 2 - basiLine
        break
    case .Bottom:
        
        descent = image.fontAscent!
        
        break
    }
    
    return descent
}



