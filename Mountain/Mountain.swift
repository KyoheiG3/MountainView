//
//  Mountain.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/04.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit

public class Mountain: ClimbDownable {
    private class View: UIView, MountainLayerHaving {
        override class var layerClass: AnyClass {
            return MountainLayer.self
        }
        var mountainLayer: MountainLayer {
            return layer as! MountainLayer
        }
    }
    
    deinit {
        climbDown()
    }
    
    private let view = View()
    
    public init() {
        view.isHidden = true
    }
    
    public func climb(retainSelf: Bool = false) -> Climber {
        let layer = view.mountainLayer
        layer.prepareForClimbing(of: retainSelf ? self : nil)
        return view.climb()
    }
    
    public func climbDown() {
        view.climbDown()
    }
}
