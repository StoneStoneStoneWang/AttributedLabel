//
//  WLBaseRefreshTableView.swift
//  WLBaseTableViewDemo
//
//  Created by three stone 王 on 2018/11/25.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import MJRefresh
open class WLBaseRefreshTableView: WLBaseTableView {
    
    
    
}
extension WLBaseRefreshTableView {
    
    @objc open override func commitInit() {
        
    }
}
extension WLBaseRefreshTableView {
    
    @objc open func setMJNormalHeader(_ refreshingBlock: @escaping () -> ()) {
        
        if let mj_header = mj_header {
            
            mj_header.refreshingBlock! = {
                
                refreshingBlock()
            }
        } else {
            
            mj_header = MJRefreshNormalHeader(refreshingBlock: {
                
                refreshingBlock()
            })
            
            mj_header.setValue(true, forKey: "lastUpdatedTimeLabel.hidden")
            
            mj_header.setValue(true, forKey: "stateLabel.hidden")
        }
    }
    
    @objc open func mj_headerEndRefreshing(_ state: MJRefreshState) {
        
        mj_header.state = state
        
        mj_header.endRefreshing()
    }
    
    @objc open func setMJNormalFooter(_ refreshingBlock: @escaping () -> ()) {
        
        if let mj_footer = mj_footer {
            
            mj_footer.refreshingBlock! = {
                
                refreshingBlock()
            }
        } else {
            
            mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: {
                
                refreshingBlock()
            })
            
            mj_footer.setValue(true, forKey: "stateLabel.hidden")
            
            mj_footer.isHidden = true
        }
    }
    
    @objc open func mj_footerEndRefreshing(_ state: MJRefreshState) {
        
        mj_footer.state = state
        
        mj_footer.endRefreshing()
    }
}
