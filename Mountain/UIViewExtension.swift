//
//  UIViewExtension.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

extension UIView {
    @discardableResult
    open class func animate(withDuration duration: TimeInterval, delay: TimeInterval = 0, options: UIView.AnimationOptions = [], retain: Bool = true, animations: @escaping () -> Void = {}, situation: @escaping (ClimbingSituation) -> Void, completion: ((Bool) -> Void)? = nil) -> ClimbDownable? {
        let mountain = Mountain()
        
        UIView.animate(withDuration: duration, delay: delay, options: options, animations: {
            mountain.climb(retainSelf: retain).situation(situation)
            animations()
        }, completion: completion)
        
        return mountain
    }
    
    @discardableResult
    open class func animate(withDuration duration: TimeInterval, delay: TimeInterval = 0, usingSpringWithDamping dampingRatio: CGFloat, initialSpringVelocity velocity: CGFloat, options: UIView.AnimationOptions = [], retain: Bool = true, animations: @escaping () -> Void = {}, situation: @escaping (ClimbingSituation) -> Void, completion: ((Bool) -> Void)? = nil) -> ClimbDownable? {
        let mountain = Mountain()
        
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: velocity, options: options, animations: {
            mountain.climb(retainSelf: retain).situation(situation)
            animations()
        }, completion: completion)
        
        return mountain
    }
}
