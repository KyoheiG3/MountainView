//
//  MountainLayer.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/11/30.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit

private protocol Easing {
    var progress: CGFloat { get }
    var curve: CGFloat { get }
}

public protocol MountainLayerDelegate: CALayerDelegate {
    func climbingSituationDidChange(_ layer: MountainLayer, situation: ClimbingSituation)
}

public extension MountainLayerDelegate {
    func climbingSituationDidChange(_ layer: MountainLayer, situation: ClimbingSituation) {
        // Do nothing
    }
}

public class MountainLayer: CALayer, Easing {
    fileprivate struct Ease: Easing {
        let curve: CGFloat
        let progress: CGFloat
    }
    
    private static let progressKey = "progress"
    private static let curveKey = "curve"
    fileprivate struct Distance {
        let progressKey = MountainLayer.progressKey
        let curveKey = MountainLayer.curveKey
        let from = Ease(curve: 0, progress: 0)
        let to = Ease(curve: 1, progress: 1)
    }
    
    override public class func needsDisplay(forKey key: String) -> Bool {
        if key == progressKey || key == curveKey {
            return true
        }
        return super.needsDisplay(forKey: key)
    }
    
    fileprivate let distance = Distance()

    fileprivate var information: Information?
    fileprivate var capturedMountain: Mountain?
    fileprivate var situationHandler: ((ClimbingSituation) -> Void)? {
        willSet {
            if let info = information, let handler = newValue {
                handler(.begin(info: info))
            }
        }
    }
    fileprivate var filterHandler: ((CGFloat, CGFloat) -> Bool)?
    fileprivate var mapHandler: ((CGFloat) -> CGFloat)?
    fileprivate var finishHandler: ((ClimbingSituation) -> Void)?
    
    fileprivate var isClimbing = false
    fileprivate var isClimbingFinish: Bool {
        if isClimbing, let layer = presentation() {
            return layer.progress == distance.to.progress
        } else {
            return false
        }
    }
    fileprivate var isProgressing: Bool {
        return isClimbing == true && isClimbingFinish == false
    }
    
    fileprivate weak var workingSuperlayer: CALayer?
    fileprivate weak var animationDelegate: CAAnimationDelegate?
    fileprivate var mountainDelegate: MountainLayerDelegate? {
        return delegate as? MountainLayerDelegate
    }
    
    @NSManaged fileprivate var progress: CGFloat
    @NSManaged fileprivate var curve: CGFloat
    
    func prepareForClimbing(of mountain: Mountain? = nil) {
        capturedMountain = mountain
        if superlayer == nil, let view = UIApplication.visibleViewController?.view {
            view.layer.addSublayer(self)
            workingSuperlayer = view.layer
        }
    }
    
    fileprivate func setCurrentEase(_ ease: Easing) {
        if delegate != nil {
            curve = ease.curve
            progress = ease.progress
        }
    }
    
    fileprivate func resetForClimbing() {
        setCurrentEase(distance.from)
        removeSituationHandler()
        
        if workingSuperlayer != nil {
            removeFromSuperlayer()
        }
    }
    
    private func removeSituationHandler() {
        information = nil
        situationHandler = nil
        filterHandler = nil
        mapHandler = nil
        finishHandler = nil
        capturedMountain = nil
    }
}

// MARK: Situation operation
extension MountainLayer {
    fileprivate func changeClimbingSituation(_ situation: ClimbingSituation) {
        switch situation {
        case .begin:
            break
        case .on:
            situationHandler?(situation)
        case .cancelled, .finished:
            finishHandler?(situation)
        }
        
        mountainDelegate?.climbingSituationDidChange(self, situation: situation)
    }
    
    fileprivate func filterSituation(progress: CGFloat, curve: CGFloat) -> Bool {
        return filterHandler?(progress, curve) != false
    }
    
    fileprivate func mapSituation(_ curve: CGFloat) -> CGFloat {
        return mapHandler?(curve) ?? curve
    }
}

// MARK: Layer life cycle
extension MountainLayer {
    override public func removeFromSuperlayer() {
        setCurrentEase(distance.from)
        
        super.removeFromSuperlayer()
        workingSuperlayer = nil
        resetForClimbing()
    }
    
    override public func display() {
        super.display()
        
        guard isClimbing else {
            return setCurrentEase(distance.from)
        }
        
        if let easing: Easing = presentation(), easing.progress > 0 && filterSituation(progress: easing.progress, curve: easing.curve) != false {
            changeClimbingSituation(.on(progress: easing.progress, curve: mapSituation(easing.curve)))
        }
    }
    
    override public func action(forKey event: String) -> CAAction? {
        if event == distance.progressKey || event == distance.curveKey {
            if event == distance.progressKey {
                isClimbing = false
            }
            
            if let action = super.action(forKey: "opacity") {
                if event == distance.curveKey, let action = action as? CABasicAnimation {
                    let info = Information(type: "\(type(of: action))", animation: action)
                    information = info
                    changeClimbingSituation(.begin(info: info))
                    
                    action.keyPath = event
                    action.fromValue = distance.from.curve
                    action.toValue = distance.to.curve
                    return action
                } else if event == distance.progressKey, let action = action as? CAAnimation {
                    isClimbing = true
                    
                    let anim = CABasicAnimation()
                    anim.fromValue = distance.from.progress
                    anim.toValue = distance.to.progress
                    anim.beginTime = CACurrentMediaTime() + action.beginTime
                    anim.duration = action.duration
                    anim.speed = action.speed
                    anim.timeOffset = action.timeOffset
                    anim.repeatCount = action.repeatCount
                    anim.repeatDuration = action.repeatDuration
                    anim.autoreverses = action.autoreverses
                    anim.fillMode = action.fillMode
                    anim.timingFunction = CAMediaTimingFunction(name: .linear)
                    
                    animationDelegate = action.delegate
                    anim.delegate = self
                    return anim
                }
            }
        }
        
        return super.action(forKey: event)
    }
}

// MARK: Climbingable
extension MountainLayer: Climbingable {
    public func climb() -> Climber {
        if isProgressing {
            UIView.performWithoutAnimation {
                setCurrentEase(distance.from)
            }
        }
        
        setCurrentEase(distance.to)
        return self
    }
    
    public func climbDown() {
        removeAnimation(forKey: distance.progressKey)
        removeAnimation(forKey: distance.curveKey)
    }
}

// MARK: Climber
extension MountainLayer: Climber {
    @discardableResult
    public func situation(_ handler: @escaping (ClimbingSituation) -> Void) -> ClimbFinishable {
        situationHandler = handler
        return self
    }
    
    public func filter(_ handler: @escaping (CGFloat, CGFloat) -> Bool) -> Self {
        filterHandler = handler
        return self
    }
    
    public func map(_ handler: @escaping (CGFloat) -> CGFloat) -> Self {
        mapHandler = handler
        return self
    }
    
    public func finish(_ handler: @escaping (ClimbingSituation) -> Void) {
        finishHandler = handler
    }
}

// MARK: CAAnimationDelegate
extension MountainLayer: CAAnimationDelegate {
    public func animationDidStart(_ anim: CAAnimation) {
        animationDelegate?.animationDidStart?(anim)
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            changeClimbingSituation(.finished)
        } else {
            changeClimbingSituation(.cancelled)
        }
        
        if isClimbingFinish {
            resetForClimbing()
        }
        
        animationDelegate?.animationDidStop?(anim, finished: flag)
    }
}
