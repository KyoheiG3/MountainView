//
//  CrossView.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit

class CrossView: UIView {
    private let crossPath = UIBezierPath()
    var crossColor: UIColor = .black
    
    override func draw(_ rect: CGRect) {
        crossColor.withAlphaComponent(0.5).setStroke()
        crossPath.stroke()
    }
    
    func configureGrid() {
        backgroundColor = .clear
        
        crossPath.removeAllPoints()
        crossPath.move(to: CGPoint(x: bounds.width / 2, y: 0))
        crossPath.addLine(to: CGPoint(x: bounds.width / 2, y: bounds.maxY))
        crossPath.move(to: CGPoint(x: 0, y: bounds.height / 2))
        crossPath.addLine(to: CGPoint(x: bounds.maxX, y: bounds.height / 2))
    }
}
