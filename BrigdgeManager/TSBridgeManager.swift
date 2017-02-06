//
//  TSBrigdgeManager.swift
//  ThreeStone
//
//  Created by 王磊 on 1/29/17.
//  Copyright © 2017 ThreeStone. All rights reserved.
//

import UIKit

class TSBridgeManager: NSObject {
    
    static let getInstance: TSBridgeManager = TSBridgeManager()
    
    private override init() {
        super.init()
        
    }
    
}
extension TSBridgeManager {
    
    internal func bridgeMutable<T: AnyObject>(obj: T) -> UnsafeMutablePointer<Void> {
        
        return UnsafeMutablePointer<Void>(bridge(obj))
    }
    internal func bridge<T: AnyObject>(obj: T) -> UnsafePointer<Void> {
        return UnsafePointer(Unmanaged.passUnretained(obj).toOpaque())
    }
    //
    internal func bridgeMutable<T: AnyObject>(prt: UnsafeMutablePointer<Void>) -> T {
        
        return Unmanaged<T>.fromOpaque(COpaquePointer(prt)).takeUnretainedValue()
    }
    
    
    internal func bridge<T: AnyObject>(prt: UnsafePointer<Void>) -> T {
        return Unmanaged<T>.fromOpaque(COpaquePointer(prt)).takeUnretainedValue()
    }
}
