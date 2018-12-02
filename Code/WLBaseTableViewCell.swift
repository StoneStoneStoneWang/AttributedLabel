//
//  WLBaseTableViewCell.swift
//  WLBaseTableViewDemo
//
//  Created by three stone 王 on 2018/11/25.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import TSToolKit_Swift
open class WLBaseTableViewCell: UITableViewCell {
    
    var indexPath: IndexPath!
    
    open var iconImageView: UIImageView = UIImageView().then {
        
        $0.contentMode = .scaleAspectFill
        
        $0.tag = 2001
    }
    
    open var titleLabel: UILabel = UILabel().then {
        
        $0.tag = 2002
        
        $0.font = UIFont.systemFont(ofSize: 15)
        
        $0.textAlignment = .left
        
        $0.textColor = WLHEXCOLOR(hexColor: "#3333333")
    }
    
    fileprivate final let bottomLine: UIImageView = UIImageView().then {
        
        $0.tag = 2003
    }
    
    open var lineType: WLBottomLineType = .lightgray {
        
        willSet {
            
            bottomLine.backgroundColor = WLHEXCOLOR(hexColor: newValue.rawValue)
        }
    }
    open var lineFrame: CGRect = .zero {
        
        willSet {
            
            bottomLine.frame = newValue
        }
    }
    
    open var lineImageName: String = "" {
        
        willSet {
            
            bottomLine.image = UIImage(named: newValue)
        }
    }
    
    open var titleFrame: CGRect = .zero {
        
        willSet {
            
            titleLabel.frame = newValue
        }
    }
    open var iconImageName: String = "" {
        
        willSet {
            
            iconImageView.image = UIImage(named: newValue)
        }
    }
    
    open var iconFrame: CGRect = .zero {
        
        willSet {
            
            iconImageView.frame = newValue
        }
    }
    
    public static func baseTableViewCell(_ lineType: WLBottomLineType ,_ reuseIdentifier: String) -> Self {
        
        return self.init(lineType,style: .default ,reuseIdentifier: reuseIdentifier)
    }
    
    required public convenience init(_ lineType: WLBottomLineType ,style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        self.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commitInit()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WLBaseTableViewCell {
    
    @objc open func commitInit() {
        
        selectionStyle = .none
        
        contentView.addSubview(iconImageView)
        
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(bottomLine)
        
        lineType = .lightgray
    }
}
extension WLBaseTableViewCell {
    
    @objc open func updateViewData(_ data: WLBaseTableBean) {
        
        
    }
}
extension WLBaseTableViewCell {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        lineFrame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
    }
}


extension WLBaseTableViewCell {
    
    public enum WLBottomLineType: String {
        
        case white = "#ffffff"
        
        case lightgray = "#eeeeee"
        
        case black = "#000000"
    }
}
