//
//  GridView.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit

class GridView: UIView {
    private func forEachLength(_ length: CGFloat, path: UIBezierPath, each: (CGFloat) -> CGRect) {
        let threshold: CGFloat = 30
        let length = length / 2
        let count = max(min(ceil(length / threshold), 5), 2)
        
        stride(from: 0, to: CGFloat(2), by: 1).forEach { section in
            stride(from: 1, to: count, by: 1).forEach { i in
                let rect = each(length / count * i + length * section)
                path.append(UIBezierPath(rect: rect))
            }
        }
    }
    
    func configureGrid() {
        let path = UIBezierPath(rect: bounds)
        forEachLength(bounds.width, path: path) { width in
            CGRect(x: width, y: 0, width: 1, height: bounds.height)
        }
        forEachLength(bounds.height, path: path) { height in
            CGRect(x: 0, y: height, width: bounds.width, height: 1)
        }
        
        let mask = CAShapeLayer()
        mask.fillRule = kCAFillRuleEvenOdd
        mask.path = path.cgPath
        layer.mask = mask
    }
}
