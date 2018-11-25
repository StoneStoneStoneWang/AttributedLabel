//
//  MXThenAction.swift
//  ChekuCafe
//
//  Created by 王磊 on 7/25/16.
//  Copyright © 2016 ChekuCafe. All rights reserved.
//

//

import Foundation
import UIKit

// MARK: - Types

/// Same as true
public let YES = true

/// Same as false
public let NO = false

public typealias void_block_t = @convention(block) () -> Void

// MARK: - ThenAction
public protocol MXThenAction {}

extension NSObject: MXThenAction {}

extension MXThenAction where Self: AnyObject {
    
    /**
     Then Action after allocation and initializing
     
     Usage:
     let aView = UIView().then {
     $0.backgroundColor = UIColor.redColor()
     $0.translatesAutoresizingMaskIntoConstraints = false
     }
     
     - parameter closure: closure
     
     - returns: value itself
     */
    public func then(closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }
}

extension MXThenAction where Self: Any {
    
    /**
     Then Action after allocation and initializing
     
     Usage:
     let aView = UIView().then {
     $0.backgroundColor = UIColor.redColor()
     $0.translatesAutoresizingMaskIntoConstraints = false
     }
     
     - parameter closure: closure
     
     - returns: value itself
     */
    public func then(closure: (inout Self) -> Void) -> Self {
        var cp = self
        closure(&cp)
        return cp
    }
}
