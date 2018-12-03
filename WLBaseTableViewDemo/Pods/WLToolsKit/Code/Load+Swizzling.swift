//
//  Load+ Swizzling.swift
//  TSToolKit_Swift
//
//  Created by three stone 王 on 2018/11/16.
//  Copyright © 2018年 three stone 王. All rights reserved.
//

import Foundation
import UIKit
// MARK: 参考 http://www.qingpingshan.com/m/view.php?aid=395346
public protocol SelfAware: class {
    
    static func awake()
}

fileprivate class NothingToSeeHere {
    
    static func harmlessFunction() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate()
    }
}

extension UIApplication {
    
    private static let runOnce: Void = {
        
        NothingToSeeHere.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
// MARK: 例子
//extension UIViewController: SelfAware {
//    public static func awake() {
//
//        UIViewController.classInit()
//    }
//
//    private static func classInit() {
//
//        viewDidLoad_swizzleMethod
//
//        viewWillAppear_swizzleMethod
//    }
//
//    @objc open func __ts_swizzled_viewWillAppear(_ animated: Bool) {
//        __ts_swizzled_viewWillAppear(animated)
//
//
//    }
//
//    @objc open func __ts_swizzled_viewDidLoad() {
//        __ts_swizzled_viewDidLoad()
//
//    }
//
//    private static let viewWillAppear_swizzleMethod: Void = {
//        let originalSelector = #selector(viewWillAppear(_:))
//        let swizzledSelector = #selector(__ts_swizzled_viewWillAppear(_:))
//        swizzlingForClass(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
//    }()
//
//    private static let viewDidLoad_swizzleMethod: Void = {
//        let originalSelector = #selector(viewDidLoad)
//        let swizzledSelector = #selector(__ts_swizzled_viewDidLoad)
//        swizzlingForClass(UIViewController.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
//    }()
//
//    private static func swizzlingForClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) {
//        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
//        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
//
//        guard (originalMethod != nil && swizzledMethod != nil) else {
//            return
//        }
//
//        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) {
//            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
//        } else {
//            method_exchangeImplementations(originalMethod!, swizzledMethod!)
//        }
//    }
//}
