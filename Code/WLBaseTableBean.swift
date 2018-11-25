//
//  WLBaseTableBean.swift
//  WLBaseTableViewDemo
//
//  Created by three stone 王 on 2018/11/25.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit

open class WLBaseTableBean: NSObject {
    
    open var lineType: WLBaseTableViewCell.WLBottomLineType = .lightgray
    
    open var cellHeight: CGFloat = 0
    
    open var sectionHeaderHeight: CGFloat = 0
    
    open var sectionFooterHeight: CGFloat = 0
}
