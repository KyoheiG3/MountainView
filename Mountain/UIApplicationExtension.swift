//
//  UIApplicationExtension.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/04.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

extension UIApplication {
    class var visibleViewController: UIViewController? {
        var presentedViewController = UIApplication.shared.delegate?.window??.rootViewController
        while let presentedVC = presentedViewController?.presentedViewController {
            presentedViewController = presentedVC
        }
        
        if let navigationController = presentedViewController as? UINavigationController {
            return navigationController.visibleViewController ?? presentedViewController
        } else {
            return presentedViewController
        }
    }
}
