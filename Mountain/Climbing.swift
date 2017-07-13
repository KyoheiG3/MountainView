//
//  Climbing.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/04.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

public enum ClimbingSituation {
    case begin(info: Information)
    case on(progress: CGFloat, curve: CGFloat)
    case cancelled, finished
}

public protocol ClimbDownable {
    func climbDown()
}

public protocol Climbingable: ClimbDownable {
    @discardableResult
    func climb() -> Climber
}

public protocol ClimbFinishable {
    func finish(_ handler: @escaping (ClimbingSituation) -> Void)
}

public protocol Climber: ClimbFinishable {
    @discardableResult
    func situation(_ handler: @escaping (ClimbingSituation) -> Void) -> ClimbFinishable
    func filter(_ handler: @escaping (CGFloat, CGFloat) -> Bool) -> Self
    func map(_ handler: @escaping (CGFloat) -> CGFloat) -> Self
}
