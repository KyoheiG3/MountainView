//
//  Information.swift
//  Mountain
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

public struct Information {
    public static let `default` = Information(type: "CAAnimation", animation: CABasicAnimation())
    
    public let type: String
    public let delay: CFTimeInterval
    public let duration: CFTimeInterval
    public let reverse: Bool
    public let repeatCount: Float
    public let function: CAMediaTimingFunction?
    
    init(type: String, animation: CABasicAnimation) {
        self.type = type
        self.delay = animation.beginTime
        self.duration = animation.duration
        self.reverse = animation.autoreverses
        self.repeatCount = animation.repeatCount
        self.function = animation.timingFunction
    }
    
}
