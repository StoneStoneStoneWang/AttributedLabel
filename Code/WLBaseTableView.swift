//
//  WLBaseTableView.swift
//  WLBaseTableViewDemo
//
//  Created by three stone 王 on 2018/11/25.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit

open class WLBaseTableView: UITableView {
    
    public static func baseTableView() -> Self {
        
        return self.init(frame: .zero,style: .plain)
    }
    
    public static func baseTableView(frame: CGRect) -> Self {
        
        return self.init(frame: frame,style: .plain)
    }
    
    public static func baseTableView(frame: CGRect, style: UITableView.Style) -> Self {
        
        return self.init(frame: frame,style: style)
    }
    
    public required override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        commitInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WLBaseTableView {
    
    @objc open func commitInit() {
        
        showsVerticalScrollIndicator = false
        
        showsHorizontalScrollIndicator = false
    }
}

