//
//  WLBaseRefreshTableView.swift
//  WLBaseTableViewDemo
//
//  Created by three stone 王 on 2018/11/25.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import UIKit
import MJRefresh
import RxCocoa
import RxSwift

public extension Reactive where Base: MJRefreshComponent {
    
    var refreshing: ControlEvent<Void> {
        let source: Observable<Void> = Observable.create {
            [weak control = self.base] observer  in
            if let control = control {
                control.refreshingBlock = {
                    observer.on(.next(()))
                }
            }
            return Disposables.create()
        }
        return ControlEvent(events: source)
    }
    
    //停止刷新
    var endRefreshing: Binder<Bool> {
        return Binder(base) { refresh, isEnd in
            if isEnd {
                refresh.endRefreshing()
            }
        }
    }
}

open class WLBaseRefreshTableView: WLBaseTableView {
    
    
    
}
extension WLBaseRefreshTableView {
    
    @objc open override func commitInit() {
        super.commitInit()
        
        let mj_header = MJRefreshNormalHeader()
        
        self.mj_header = mj_header
        
        mj_header.lastUpdatedTimeLabel.isHidden = true
        
        //初始化数据
        let mj_footer = MJRefreshBackNormalFooter()
    
        self.mj_footer = mj_footer
    }
}

