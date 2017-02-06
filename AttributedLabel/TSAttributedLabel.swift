//
//  TSAttributedLabel.swift
//  ThreeStone
//
//  Created by 王磊 on 1/31/17.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit

import CoreFoundation

let kEllipsesCharacter = "\u{2026}"

let MinAsyncDetectLinkLength = 50

private var TS_attributed_label_parse_queue: dispatch_queue_t!

private var get_TS_attributed_label_parse_queue: dispatch_queue_t {
    if TS_attributed_label_parse_queue == nil {
        TS_attributed_label_parse_queue = dispatch_queue_create("threestone.parse_queue", nil)
    }
    return TS_attributed_label_parse_queue
}
@objc protocol TSCustomAttributedLabelDelegate: NSObjectProtocol {
    
    func customAttributedLabel(label: TSAttributedLabel ,linkData: AnyObject )
}
//Command failed due to signal: Segmentation fault: 11

class TSAttributedLabel: UIView {
    // MARK: 公开属性
    var font: UIFont? {
        willSet {
            guard let _ = newValue else {
                
                return
            }
            attributeSting?.setFont(newValue!)
            
            resetFont()
            
            for attachment in attachments {
                
                attachment.fontAscent = fontAscent
                
                attachment.fontDescent = fontDescent
                
            }
            resetTextFrame()
        }
    }
    var textColor: UIColor? {
        willSet {
            guard let _ = newValue else {
                
                return
            }
            attributeSting?.setTextColor(newValue!)
            
            resetTextFrame()
        }
    }
    
    // 字体颜色 默认颜色 黑色
    internal lazy var highlightedColor: UIColor = UIColor(red: 0xd7 / 255.0, green: 0xf2 / 255.0, blue: 0xff / 255.0, alpha: 1)// 点击高亮色
    
    internal lazy var linkColor: UIColor = UIColor.blueColor()
    //链接色
    internal lazy var underLindeForLink: Bool = true // 链接是否带下划线
    internal lazy var autoDetectLinks: Bool = true  // 自动检测连接
    internal lazy var numberOfLines: Int = 0 // 行数
    internal var textAlignment: CTTextAlignment? //文字排版样式
    
    internal lazy var lineBreakMode: CTLineBreakMode? = .ByWordWrapping //lineBreakMode
    // 行间距
    internal lazy var lineSpace: CGFloat = 0.0
    // 段间距
    internal lazy var paragraphSpacing: CGFloat = 0.0
    
    // 私有属性
    private var attributeSting: NSMutableAttributedString?
    
    private lazy var linkLocations: Array<TSAttributedLabelUrl> = []
    private lazy var attachments: Array<TSAttributedLabelAttachment> = []
    private lazy var textFrame: CTFrameRef? = nil
    private var fontAscent: CGFloat?
    private var fontDescent: CGFloat?
    private var fontHeight: CGFloat?
    private lazy var linkDetected: Bool = false
    private lazy var ignoreRedraw: Bool = false
    private var touchLink: TSAttributedLabelUrl?
    
    weak var delegate: TSCustomAttributedLabelDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var backgroundColor: UIColor? {
        willSet {
            guard let _ = newValue else {
                return
            }
            backgroundColor = UIColor.whiteColor()
        }
    }
    
    func commonInit() {
        attributeSting = NSMutableAttributedString()
        
        textFrame = nil
        
        font = UIFont.systemFontOfSize(15)
        
        textColor = UIColor.blackColor()
        
        resetFont()
    }
    
}
// 设置 添加 文本
extension TSAttributedLabel {
    func setText(text: String) {
        let attributeText = attributeString(text)
        setAttibuteText(attributeText)
    }
    func appendText(text: String) {
        let attributeText = attributeString(text)
        appendAttributeText(attributeText)
    }
}
// 属性 文本
extension TSAttributedLabel {
    func setAttibuteText(attributedText: NSAttributedString) {
        attributeSting = NSMutableAttributedString(attributedString: attributedText)
        cleanAll()
    }
    func appendAttributeText(attributedText: NSAttributedString) {
        attributeSting?.appendAttributedString(attributedText)
        resetTextFrame()
    }
}
// 图文
extension TSAttributedLabel {
    func appendImage(image: UIImage) {
        appendImage(image, maxSize: image.size)
    }
    func appendImage(image: UIImage , maxSize: CGSize) {
        appendImage(image, maxSize: maxSize, margin: UIEdgeInsetsZero)
        
    }
    func appendImage(image: UIImage , maxSize: CGSize , margin: UIEdgeInsets) {
        appendImage(image, maxSize: maxSize, margin: margin, alignment: .Bottom)
        
    }
    func appendImage(image: UIImage , maxSize: CGSize , margin: UIEdgeInsets , alignment: TSImageAlignment) {
        let attachment = TSAttributedLabelAttachment.attachment(image, margin: margin, alignment: alignment, maxSize: maxSize)
        appendAttachment(attachment)
    }
}
extension TSAttributedLabel {
    func appendView(view: UIView) {
        appendView(view, margin: UIEdgeInsetsZero)
    }
    func appendView(view: UIView , margin: UIEdgeInsets) {
        appendView(view, margin: margin, alignment: .Bottom)
    }
    func appendView(view: UIView , margin: UIEdgeInsets , alignment: TSImageAlignment) {
        let attachment = TSAttributedLabelAttachment.attachment(view, margin: margin, alignment: alignment, maxSize: .zero)
        
        appendAttachment(attachment)
    }
}
//添加自定义连接
extension TSAttributedLabel {
    func addCustomLink(linkData: AnyObject, forRange range: NSRange) {
        addCustomLink(linkData, forRange: range, linkColor: linkColor)
    }
    func addCustomLink(linkData: AnyObject , forRange range: NSRange , linkColor color: UIColor) {
        let url = TSAttributedLabelUrl.url(linkData, range: range, linkColor: color)
        linkLocations += [url]
        resetTextFrame()
    }
}
// MARK: 初始化
extension TSAttributedLabel {
    private func cleanAll() {
        ignoreRedraw = false
        linkDetected = false
        attachments.removeAll()
        linkLocations.removeAll()
        touchLink = nil
        for subView in subviews {
            subView.removeFromSuperview()
        }
        resetTextFrame()
    }
    private func resetTextFrame() {
        // 如果 不为空
        if let _ = textFrame {
            
            textFrame = nil
        }
        if NSThread.isMainThread() && !ignoreRedraw {
            setNeedsDisplay()
        }
    }
    
    private func resetFont() {
        if let _ = font {
            
            let fontRef = CTFontCreateWithName(font!.fontName, font!.pointSize, nil)
            
            fontAscent = CTFontGetAscent(fontRef)
            fontDescent = CTFontGetDescent(fontRef)
            fontHeight = CTFontGetSize(fontRef)
        }
    }
}



// drawRect
extension TSAttributedLabel {
    override func drawRect(rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        
        guard let ctx = context else  {
            return
        }
        
        CGContextSaveGState(ctx)
        
        let transform = transformForCoreText()
        
        CGContextConcatCTM(ctx ,transform)
        
        recomputeLinkIfNeed()
        
        let drawString = attributeStringDraw()
        if let _ = drawString {
            
            prepareTextFrame(drawString!, rect: rect)
            
            drawHighlightWithRect(rect)
            
            drawAttachment()
            
            drawText(drawString!, rect: rect, context: ctx)
            
        }
        
        CGContextRestoreGState(ctx)
        
    }
}

extension TSAttributedLabel {
    private func prepareTextFrame(string: NSAttributedString , rect: CGRect) {
        if nil == textFrame {
            let frameSetter = CTFramesetterCreateWithAttributedString(string)
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, rect)
            textFrame = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), path, nil)
        }
    }
    private func drawHighlightWithRect(rect: CGRect) {
        if let _ = touchLink {
            highlightedColor.setFill()
            
            let range = touchLink?.range
            
            let lines = CTFrameGetLines(textFrame!)
            
            let count = CFArrayGetCount(lines)
            
            var origins = [CGPoint](count:count, repeatedValue: CGPointZero)
            
            CTFrameGetLineOrigins(textFrame!, CFRangeMake(0, 0), &origins)
            
            let numberOfLines = numberOfDisplayedLines()
            
            let context = UIGraphicsGetCurrentContext()
            
            for i in 0..<numberOfLines  {
                
                let line = CFArrayGetValueAtIndex(lines, i)
                
                let stringRange = CTLineGetStringRange(unsafeBitCast(line, CTLine.self))
                
                let lineRange = NSRange(location: stringRange.location, length: stringRange.length)
                
                let intersectedRange = NSIntersectionRange(lineRange, range!)
                
                if intersectedRange.length == 0 {
                    continue
                }
                
                var highlightRect = rectForRange(intersectedRange, inLine: unsafeBitCast(line, CTLine.self), lineOrigin: origins[i])
                
                highlightRect = CGRectOffset(highlightRect, 0, -rect.origin.y)
                
                if !CGRectIsEmpty(highlightRect) {
                    let pi:CGFloat = CGFloat(M_PI)
                    let radius: CGFloat = 1.0
                    CGContextMoveToPoint(context, highlightRect.origin.x, highlightRect.origin.y + radius)
                    
                    CGContextAddLineToPoint(context, highlightRect.origin.x, highlightRect.origin.y + highlightRect.size.height - radius)
                    
                    CGContextAddArc(context, highlightRect.origin.x + radius, highlightRect.origin.y + highlightRect.size.height - radius,radius, pi, pi / 2.0, 1)
                    
                    CGContextAddLineToPoint(context, highlightRect.origin.x + highlightRect.size.width - radius,highlightRect.origin.y + highlightRect.size.height)
                    
                    CGContextAddArc(context, highlightRect.origin.x + highlightRect.size.width - radius,highlightRect.origin.y + highlightRect.size.height - radius, radius, pi / 2, 0, 1)
                    
                    CGContextAddLineToPoint(context, highlightRect.origin.x + highlightRect.size.width, highlightRect.origin.y + radius)
                    
                    CGContextAddArc(context, highlightRect.origin.x + highlightRect.size.width - radius, highlightRect.origin.y + radius,radius, 0.0, -pi / 2.0, 1)
                    
                    CGContextAddLineToPoint(context, highlightRect.origin.x + radius, highlightRect.origin.y)
                    
                    CGContextAddArc(context, highlightRect.origin.x + radius, highlightRect.origin.y + radius, radius,-pi / 2, pi, 1)
                    
                    CGContextFillPath(context);
                }
            }
        }
    }
    private func drawText(attributeString: NSAttributedString , rect: CGRect , context: CGContextRef) {
        if let _ = textFrame {
            
            if numberOfLines > 0 {
                let lines = CTFrameGetLines(textFrame!)
                
                let numberOflines = numberOfDisplayedLines()
                
                var origins = [CGPoint](count:CFArrayGetCount(lines), repeatedValue: CGPointZero)
                
                CTFrameGetLineOrigins(textFrame!, CFRangeMake(0, numberOfLines), &origins)
                
                for lineIndex in 0..<numberOflines  {
                    let lineOrigin = origins[lineIndex]
                    
                    CGContextSetTextPosition(context, lineOrigin.x, lineOrigin.y)
                    let line = CFArrayGetValueAtIndex(lines, lineIndex)
                    
                    var shouldDrawLine: Bool = true
                    
                    if (lineIndex == numberOflines) && (lineBreakMode == .ByTruncatingTail) {
                        let lastLineRange = CTLineGetStringRange(line as! CTLine)
                        
                        if (lastLineRange.location + lastLineRange.length < attributeString.length)
                        {
                            let truncationType: CTLineTruncationType = .End
                            
                            let truncationAttributePosition = lastLineRange.location + lastLineRange.length - 1;
                            let tokenAttributes = attributeString.attributesAtIndex(truncationAttributePosition, effectiveRange: nil)
                            
                            let tokenString = NSAttributedString(string: kEllipsesCharacter, attributes: tokenAttributes)
                            
                            let truncationToken = CTLineCreateWithAttributedString(tokenString);
                            
                            let truncationString: NSMutableAttributedString = attributeString.attributedSubstringFromRange(NSMakeRange(lastLineRange.location, lastLineRange.length)).mutableCopy() as! NSMutableAttributedString
                            
                            if (lastLineRange.length > 0) {
                                
                                truncationString.deleteCharactersInRange(NSMakeRange(lastLineRange.length - 1, 1))
                                
                            }
                            
                            truncationString.appendAttributedString(tokenString)
                            
                            let truncationLine: CTLineRef = CTLineCreateWithAttributedString(truncationString)
                            
                            let  truncatedLine: CTLineRef = CTLineCreateTruncatedLine(truncationLine, Double(rect.size.width), truncationType, truncationToken)!
                            
                            CTLineDraw(unsafeBitCast(truncatedLine, CTLine.self), context);
                            
                            shouldDrawLine = false;
                        }
                        if shouldDrawLine {
                            
                            CTLineDraw(unsafeBitCast(line, CTLine.self), context)
                            
                        }
                    }
                }
            }
            CTFrameDraw(textFrame!, context)
        }
    }
}


//属性文本
extension TSAttributedLabel {
    //辅助方法
    private func attributeString(text: String) -> NSMutableAttributedString {
        if !text.isEmpty {
            let string = NSMutableAttributedString(string: text)
            string.setFont(font!)
            string.setTextColor(textColor!)
            return string
        } else {
            return NSMutableAttributedString()
        }
    }
    // 行数
    private func numberOfDisplayedLines() -> Int {
        let lines = CTFrameGetLines(textFrame!)
        return numberOfLines > 0 ? min(CFArrayGetCount(lines), numberOfLines) :  CFArrayGetCount(lines)
    }
    private func attributeStringDraw() -> NSMutableAttributedString? {
        // 如果 属性字符串存在
        if let drawString = attributeSting {
            
            // 如果设置了.ByTruncatingTail(尾部省略) 那就 ByCharWrapping尽可能显示所有文字
            if lineBreakMode == .ByTruncatingTail {
                lineBreakMode = numberOfLines == 1 ? .ByCharWrapping : .ByWordWrapping
            }
            //行高
            var lineHeight: CGFloat = font!.lineHeight
            
            // 段落 设置
            let settings: [CTParagraphStyleSetting] = [
                CTParagraphStyleSetting(spec: .Alignment, valueSize: sizeof(UInt8), value: &textAlignment) ,
                CTParagraphStyleSetting(spec: .LineBreakMode, valueSize: sizeof(UInt8), value: &lineBreakMode),
                CTParagraphStyleSetting(spec: .MaximumLineSpacing, valueSize: sizeof(CGFloat), value: &lineSpace) ,
                CTParagraphStyleSetting(spec: .MaximumLineSpacing, valueSize: sizeof(CGFloat), value: &lineSpace) ,
                CTParagraphStyleSetting(spec: .ParagraphSpacing, valueSize: sizeof(CGFloat), value: &paragraphSpacing) ,
                CTParagraphStyleSetting(spec: .MinimumLineHeight, valueSize: sizeof(CGFloat), value: &lineHeight)
            ]
            // 创建段落格式
            let paragraphStyle = CTParagraphStyleCreate(settings, 6)
            
            drawString.addAttribute(kCTParagraphStyleAttributeName as String, value: paragraphStyle, range: NSMakeRange(0, drawString.length))
            for url in linkLocations {
                
                if (url.range?.location)! + (url.range?.length)! > (attributeSting?.length)! {
                    continue
                }
                
                let drawLinkColor = url.color ?? linkColor
                
                drawString.setTextColor(drawLinkColor, range: url.range!)
                
                drawString.setUnderlineStyle(underLindeForLink ? .Single : .None , modifier: .PatternSolid, range: url.range!)
                
            }
            return drawString
        }
        return nil
    }
    // url 辅助方法
    private func urlForPoint(point: CGPoint) -> TSAttributedLabelUrl? {
        let kVmargin: CGFloat = 5
        if !CGRectContainsPoint(CGRectInset(bounds, 0, -kVmargin), point) || textFrame == nil {
            return nil
        }
        
        let lines: CFArray = CTFrameGetLines(textFrame!)
        
        let count = CFArrayGetCount(lines)
        
        var origins = [CGPoint](count:count, repeatedValue: CGPointZero)
        
        CTFrameGetLineOrigins(textFrame!, CFRangeMake(0, 0), &origins)
        
        let transform = transformForCoreText()
        
        let verticalOffset: CGFloat = 0
        
        for i in 0..<count {
            let linePoint = origins[i]
            
            let line = CFArrayGetValueAtIndex(lines, i)
            
            let flippedRect = getLineBounds(unsafeBitCast(line, CTLineRef.self), point: linePoint)
            
            var rect = CGRectApplyAffineTransform(flippedRect, transform)
            
            rect = CGRectInset(rect, 0, -kVmargin)
            
            rect = CGRectOffset(rect, 0, verticalOffset)
            
            if CGRectContainsPoint(rect, point) {
                let relativePoint = CGPoint(x: point.x - CGRectGetMinX(rect), y: point.y - CGRectGetMinX(rect))
                let index = CTLineGetStringIndexForPosition(unsafeBitCast(line, CTLine.self), relativePoint)
                
                let url = linkAtIndex(index)
                
                if let _ = url {
                    
                    return url
                }
            }
        }
        return nil
    }
    
    private func linkAtIndex(index: Int) -> TSAttributedLabelUrl? {
        for url in linkLocations {
            if NSLocationInRange(index, url.range!) {
                return url
            }
        }
        return nil
    }
    private func linkDataForPoint(point: CGPoint) -> AnyObject? {
        let url = urlForPoint(point)
        return url?.lindData ?? nil
    }
    private func transformForCoreText() -> CGAffineTransform {
        return CGAffineTransformScale(CGAffineTransformMakeTranslation(0, bounds.size.height), 1.0, -1.0)
    }
    private func getLineBounds(line: CTLineRef , point: CGPoint) -> CGRect {
        
        var lineAscent: CGFloat = 0
        var lineDescent: CGFloat = 0
        var lineLeading: CGFloat = 0
        let width = CGFloat(CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading))
        
        let height = lineAscent + lineDescent
        
        return CGRect(x: point.x, y: point.y - lineDescent, width: width, height: height)
    }
    
    private func rectForRange(range: NSRange , inLine line: CTLineRef , lineOrigin: CGPoint) -> CGRect {
        var rectForRange: CGRect = CGRectZero
        
        let runs = CTLineGetGlyphRuns(line)
        
        let runCount: CFIndex = CFArrayGetCount(runs)
        
        for i in 0..<runCount {
            
            let run = CFArrayGetValueAtIndex(runs, i)
            
            let stringRunRange = CTRunGetStringRange(unsafeBitCast(run, CTRun.self))
            
            let lineRunRange = NSRange(location: stringRunRange.location, length: stringRunRange.length)
            
            let intersectdRunRange = NSIntersectionRange(lineRunRange, range)
            
            if intersectdRunRange.length == 0 {
                continue
            }
            
            var runAscent: CGFloat = 0
            var runDescent: CGFloat = 0
            var runLeading: CGFloat = 0
            
            let width = CGFloat(CTRunGetTypographicBounds(unsafeBitCast(run, CTRun.self),CFRangeMake(0, 0), &runAscent, &runDescent, &runLeading))
            
            let height = runAscent + runDescent
            
            let xOffSet = CTLineGetOffsetForStringIndex(line , CTRunGetStringRange(unsafeBitCast(run, CTRun.self)).location, nil)
            
            var linkRect = CGRect(x: lineOrigin.x + xOffSet - runLeading, y: lineOrigin.y - runDescent, width: width + runLeading, height: height)
            
            linkRect.origin.y = CGFloat(roundf(Float(linkRect.origin.y)))
            linkRect.origin.x = CGFloat(roundf(Float(linkRect.origin.x)))
            linkRect.size.width = CGFloat(roundf(Float(linkRect.size.width)))
            linkRect.size.height = CGFloat(roundf(Float(linkRect.size.height)))
            
            rectForRange = CGRectIsEmpty(rectForRange) ? linkRect : CGRectUnion(rectForRange, linkRect)
        }
        
        return rectForRange
    }
}

//添加图片
extension TSAttributedLabel {
    
    // 辅助方法 // TODO::......
    func appendAttachment( attachment: TSAttributedLabelAttachment) {
        attachment.fontAscent = fontAscent
        attachment.fontDescent = fontDescent
        var objectReplacementChar: unichar = 0xFFFC
        
        let objectReplacementString = NSString(characters: &objectReplacementChar, length: 1)
        //
        let attachText = NSMutableAttributedString(string: objectReplacementString as String)
        
        var callBack = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: deallocCallBack, getAscent: ascentCallBack, getDescent: descentCallBack, getWidth: widthCallback)
        
        //设置ctrun 代理
        
        let delegate: CTRunDelegate = CTRunDelegateCreate(&callBack, TSBridgeManager.getInstance.bridgeMutable(attachment))!
        
        attachText.setAttributes([kCTRunDelegateAttributeName as String: delegate], range: NSMakeRange(0, 1))
        
        attachments += [attachment]
        
        appendAttributeText(attachText)
    }
}
// 设置大小
extension TSAttributedLabel {
    private func drawAttachment() {
        
        if attachments.count == 0 {
            return
        }
        let context = UIGraphicsGetCurrentContext()
        
        if let _ = context {
            let lines = CTFrameGetLines(textFrame!)
            let lineCount = CFArrayGetCount(lines)
            var origins = [CGPoint](count:lineCount, repeatedValue: CGPointZero)
            CTFrameGetLineOrigins(textFrame!, CFRangeMake(0, 0), &origins)
            let numberOfLines = numberOfDisplayedLines()
            
            for i in 0..<numberOfLines {
                let line = CFArrayGetValueAtIndex(lines, i)
                
                let runs = CTLineGetGlyphRuns(unsafeBitCast(line, CTLine.self))
                
                let runCount: CFIndex = CFArrayGetCount(runs)
                
                let lineOrigin: CGPoint = origins[i]
                
                var lineAscent = CGFloat()
                var lineDescent = CGFloat()
                
                CTLineGetTypographicBounds(unsafeBitCast(line, CTLine.self), &lineAscent, &lineDescent, nil)
                
                let lineHeight: CGFloat = lineAscent + lineDescent
                
                let lineBottomY: CGFloat = lineOrigin.y - lineDescent
                
                for k in 0..<runCount {
                    
                    let run = CFArrayGetValueAtIndex(runs , k)
                    
                    let runAttributes = CTRunGetAttributes(unsafeBitCast(run, CTRun.self)) as NSDictionary
                    
                    let delegate = runAttributes[kCTRunDelegateAttributeName as String]
                    
                    if let _ = delegate {
                        let attibutedImage: TSAttributedLabelAttachment = unsafeBitCast(CTRunDelegateGetRefCon(delegate as! CTRunDelegate)
                            , TSAttributedLabelAttachment.self)
                        var ascent: CGFloat = 0
                        var descent: CGFloat = 0
                        let width: CGFloat = CGFloat(CTRunGetTypographicBounds(unsafeBitCast(run, CTRun.self), CFRangeMake(0, 0), &ascent, &descent, nil))
                        let imageBoxHeight = attibutedImage.boxSize().height
                        let XoffSet = CTLineGetOffsetForStringIndex(unsafeBitCast(line, CTLine.self), CTRunGetStringRange(unsafeBitCast(run, CTRun.self)).location, nil)
                        var imageBoxOriginY: CGFloat = 0
                        
                        switch attibutedImage.alginment! {
                        case .Top:
                            imageBoxOriginY = lineBottomY + lineHeight - imageBoxHeight
                            break
                        case .Center:
                            imageBoxOriginY = lineBottomY + (lineHeight - imageBoxHeight) / 2
                            break
                        case .Bottom:
                            imageBoxOriginY = lineBottomY
                            break
                        }
                        let rect: CGRect = CGRect(x: lineOrigin.x + XoffSet,y: imageBoxOriginY, width: width, height: imageBoxHeight)
                        var flippedMargins: UIEdgeInsets = attibutedImage.margin!
                        let top: CGFloat = flippedMargins.top
                        flippedMargins.top = flippedMargins.bottom
                        flippedMargins.bottom = top
                        let attachmentRect = UIEdgeInsetsInsetRect(rect, flippedMargins)
                        
                        if i == numberOfLines - 1 && k >= runCount - 2 && lineBreakMode == .ByTruncatingTail {
                            let attachmentWidth = CGRectGetWidth(attachmentRect)
                            let kMinEllipsesWidth = attachmentWidth
                            if CGRectGetWidth(bounds) - CGRectGetMinX(attachmentRect) - attachmentWidth <  kMinEllipsesWidth {
                                continue
                            }
                        }
                        let content = attibutedImage.content
                        if content is UIImage {
                            CGContextDrawImage(context, rect, (content as! UIImage).CGImage)
                        } else if content is UIView {
                            let view = content as? UIView
                            if let _ = view?.superview {
                                addSubview(view!)
                            }
                            let viewFrame = CGRect(x: attachmentRect.origin.x , y: bounds.size.height - attachmentRect.origin.y - attachmentRect.size.height, width: attachmentRect.size.width , height:  attachmentRect.size.height)
                            view?.frame = viewFrame
                        } else {
                            print("attachment content not supporetd \(content)")
                        }
                    }
                    
                }
                
            }
        }
    }
    override func sizeThatFits(size: CGSize) -> CGSize {
        let drawingString = attributeStringDraw()
        if drawingString!.length == 0 {
            return CGSizeZero
        }
        let attributedStringRef: CFAttributedStringRef = drawingString!
        let frameSetter = CTFramesetterCreateWithAttributedString(attributedStringRef)
        var range = CFRangeMake(0, 0)
        if numberOfLines > 0 {
            let path = CGPathCreateMutable()
            CGPathAddRect(path, nil, CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, nil)
            let lines = CTFrameGetLines(frame)
            if CFArrayGetCount(lines) > 0 {
                let lastVisibleLineIndex = min(numberOfLines, CFArrayGetCount(lines) - 1)
                let lastVisibleLine = CFArrayGetValueAtIndex(lines, lastVisibleLineIndex)
                let rangeToLayout = CTLineGetStringRange(lastVisibleLine as! CTLineRef)
                range = CFRangeMake(0, rangeToLayout.location + rangeToLayout.length)
            }
        }
        var fitCFRange = CFRangeMake(0, 0)
        let newSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, range, nil, size, &fitCFRange)
        if Double(UIDevice.currentDevice().systemVersion) >= 7.0 {
            if newSize.height < fontHeight! * 2 { // 单行
                
                return CGSize(width:CGFloat(ceilf(Float(newSize.width)) + 2), height: CGFloat(ceilf(Float(newSize.height)) + 4))
            }
            else {
                return CGSize(width: size.width, height: CGFloat(ceilf(Float(newSize.height)) + 4))
            }
        }else {
            return CGSize(width:CGFloat(ceilf(Float(newSize.width)) + 2), height: CGFloat(ceilf(Float(newSize.height)) + 2))
        }
    }
    override func intrinsicContentSize() -> CGSize {
        return sizeThatFits(CGSize(width: CGRectGetWidth(bounds), height: CGFloat.max))
    }
}
extension TSAttributedLabel {
    
    private func recomputeLinkIfNeed() {
        let kMinHttpLinkLength = 5
        if !(autoDetectLinks) || linkDetected {
            return
        }
        let text = attributeSting?.string
        let length = (text! as NSString).length
        if length <= kMinHttpLinkLength {
            return
        }
        let sync = length <= MinAsyncDetectLinkLength
        
        computeLink(text!, sync: sync)
    }
    private func computeLink(text: String , sync: Bool) {
        typealias TSLinkBlock = (Array<AnyObject>) -> Void
        
        let block: TSLinkBlock = {[weak self] array  in
            self!.linkDetected = true
            if array.count > 0 {
                for url in array {
                    self!.addAutoDetectedLink(url as! TSAttributedLabelUrl)
                    
                }
                self!.resetTextFrame()
            }
        }
        if sync {
            ignoreRedraw = true
            let links = TSAttributedLabelUrl.detectedText(text)
            block(links)
            ignoreRedraw = false
        } else {
            dispatch_sync(get_TS_attributed_label_parse_queue, {[weak self] () -> Void in
                let links = TSAttributedLabelUrl.detectedText(text)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let plainText = self!.attributeSting?.string
                    if plainText == text {
                        block(links)
                    }
                })
                })
        }
    }
    private func addAutoDetectedLink(url: TSAttributedLabelUrl) {
        let range = url.range
        for url in linkLocations {
            if NSIntersectionRange(range!, url.range!).length != 0 {
                return
            }
        }
        addCustomLink(url.lindData!, forRange: url.range!)
    }
}
// responder
extension TSAttributedLabel {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if touchLink == nil {
            for touch in touches {
                let point = touch.locationInView(self)
                touchLink = urlForPoint(point)
            }
        }
        if let _ = touchLink {
            setNeedsDisplay()
        } else {
            super.touchesBegan(touches, withEvent: event)
        }
    }
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesMoved(touches, withEvent: event)
        for touch in touches {
            let point = touch.locationInView(self)
            let touchLink = urlForPoint(point)
            if touchLink != self.touchLink {
                self.touchLink = touchLink
                setNeedsDisplay()
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        
        super.touchesCancelled(touches, withEvent: event)
        if let _ = touchLink {
            touchLink = nil
            setNeedsDisplay()
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch in touches {
            let point = touch.locationInView(self)
            
            if !onLabelClick(point) {
                super.touchesEnded(touches, withEvent: event)
            }
        }
        
        if let _ = touchLink {
            touchLink = nil
            setNeedsDisplay()
        }
    }
    private func onLabelClick(point: CGPoint) -> Bool {
        let linkData = linkDataForPoint(point)
        // TODO: ....
        if nil != linkData {
            if delegate != nil {
                delegate?.customAttributedLabel(self, linkData: linkData!)
            } else {
                var url: NSURL?
                if linkData is String {
                    url = NSURL(string: linkData as! String)
                }
                if linkData is NSURL {
                    url = linkData as? NSURL
                }
                if let _ = url {
                    UIApplication.sharedApplication().openURL(url!)
                }
            }
            return true
        }
        return false
    }
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let touchLink = urlForPoint(point)
        
        guard let _ = touchLink else {
            
            let subViews = self.subviews
            
            for view in subViews {
                let hitPoint = view.convertPoint(point, fromView: self)
                let hitTestView = view.hitTest(hitPoint, withEvent: event)
                if let _ = hitTestView {
                    return hitTestView
                }
            }
            return nil
        }
        return self
    }
}