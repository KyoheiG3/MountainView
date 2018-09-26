//
//  CurveView.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit

class CurveView: UIView {
    override class var layerClass: AnyClass {
        return CAShapeLayer.self
    }
    
    var shapeLayer: CAShapeLayer {
        return layer as! CAShapeLayer
    }
    
    var lineColor = UIColor.black.withAlphaComponent(0.5)
    var lineWidth: CGFloat = 2
    var lineCap = CAShapeLayerLineCap.round
    
    private var lastPoint: CGPoint?
    private let curvePath = UIBezierPath()
    
    func configureCurve() {
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = lineCap
        
        lastPoint = nil
        curvePath.removeAllPoints()
        curvePath.move(to: CGPoint(x: -frame.minX, y: frame.maxY))
    }
    
    func reset() {
        if let lastPoint = lastPoint {
            curvePath.addLine(to: lastPoint)
            shapeLayer.path = curvePath.cgPath
        }
        
        lastPoint = nil
        curvePath.removeAllPoints()
        curvePath.move(to: CGPoint(x: -frame.minX, y: frame.maxY))
    }
    
    func move(to oritin: CGPoint) {
        let point = oritin - frame.origin
        let nextPoint: CGPoint
        
        if let lastPoint = lastPoint {
            nextPoint = ave(point, lastPoint)
            curvePath.addQuadCurve(to: nextPoint, controlPoint: lastPoint)
        } else {
            nextPoint = ave(curvePath.currentPoint, point)
            curvePath.addLine(to: nextPoint)
        }
        
        curvePath.move(to: nextPoint)
        shapeLayer.path = curvePath.cgPath
        
        lastPoint = point
    }
}

private extension CGPoint {
    static func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

private func ave(_ lhs: CGPoint, _ rhs: CGPoint) -> CGPoint {
    return CGPoint(x: (lhs.x + rhs.x) / 2, y: (lhs.y + rhs.y) / 2)
}
