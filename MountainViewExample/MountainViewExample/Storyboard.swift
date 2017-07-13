//
//  Storyboard.swift
//  MountainViewExample
//
//  Created by Kyohei Ito on 2017/01/04.
//  Copyright © 2017年 Kyohei Ito. All rights reserved.
//

import UIKit

private extension NSObjectProtocol {
    static var className: String {
        let className = NSStringFromClass(self)
        let range = className.range(of: ".")
        return className.substring(from: range!.upperBound)
    }
}

protocol Storyboard: NSObjectProtocol {
    associatedtype Instance
    static func makeFromStoryboard() -> Instance
    static var storyboard: UIStoryboard { get }
    static var storyboardName: String { get }
    static var identifier: String { get }
}

extension Storyboard {
    static var storyboardName: String {
        return className
    }
    
    static var identifier: String {
        return className
    }
    
    static var storyboard: UIStoryboard {
        return UIStoryboard(name: storyboardName, bundle: nil)
    }
    
    static func makeFromStoryboard() -> Self {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! Self
    }
}
