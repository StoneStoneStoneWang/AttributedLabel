//
//  WLSectionModel.swift
//  WLBaseTableViewDemo
//
//  Created by three stone 王 on 2018/12/18.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

public struct WLSectionModel<Section, ItemType> {
    public var model: Section
    public var items: [Item]
    
    public init(model: Section, items: [Item]) {
        self.model = model
        self.items = items
    }
}

extension WLSectionModel
: SectionModelType {
    public typealias Identity = Section
    public typealias Item = ItemType
    
    public var identity: Section {
        return model
    }
}

extension WLSectionModel
: CustomStringConvertible {
    
    public var description: String {
        return "\(self.model) > \(items)"
    }
}

extension WLSectionModel {
    public init(original: WLSectionModel<Section, Item>, items: [Item]) {
        self.model = original.model
        self.items = items
    }
}
