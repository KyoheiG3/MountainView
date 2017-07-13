//
//  MountainLayerHaving.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

public protocol MountainLayerHaving: Climbingable {
    var mountainLayer: MountainLayer { get }
}

public extension MountainLayerHaving {
    @discardableResult
    public func climb() -> Climber {
        return mountainLayer.climb()
    }
    
    public func climbDown() {
        mountainLayer.climbDown()
    }
}
