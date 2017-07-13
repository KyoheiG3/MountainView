//
//  InformationView.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit
import Mountain

class InformationView: UIView {
    private let functionLabel = UILabel()
    private let parameterLabel = UILabel()
    private let progressLabel = UILabel()
    
    var font = UIFont.systemFont(ofSize: 8) {
        didSet {
            functionLabel.font = font
            parameterLabel.font = font
            progressLabel.font = font
        }
    }
    var textAlignment = NSTextAlignment.right {
        didSet {
            functionLabel.textAlignment = textAlignment
            parameterLabel.textAlignment = textAlignment
            progressLabel.textAlignment = textAlignment
        }
    }
    var textColor = UIColor.black.withAlphaComponent(0.5) {
        didSet {
            functionLabel.textColor = textColor
            parameterLabel.textColor = textColor
            progressLabel.textColor = textColor
        }
    }
    
    func configureLabel() {
        addSubview(functionLabel)
        addSubview(parameterLabel)
        addSubview(progressLabel)
    }
    
    func setProgress(_ progress: CGFloat) {
        progressLabel.text = "\(Int(progress * 100))%"
        
        UIView.performWithoutAnimation {
            progressLabel.sizeToFit()
            progressLabel.frame.origin = CGPoint(x: bounds.width - progressLabel.bounds.width - 2, y: bounds.height - progressLabel.bounds.height - parameterLabel.bounds.height - functionLabel.bounds.height)
        }
    }
    
    func setInformation(_ info: Information) {
        functionLabel.text = info.type
        parameterLabel.text = "dur:\(info.duration) del:\(info.delay)"
        
        UIView.performWithoutAnimation {
            parameterLabel.sizeToFit()
            functionLabel.sizeToFit()
            
            parameterLabel.frame.origin = CGPoint(x: bounds.width - parameterLabel.bounds.width - 2, y: bounds.height - parameterLabel.bounds.height - functionLabel.bounds.height)
            functionLabel.frame.origin = CGPoint(x: bounds.width - functionLabel.bounds.width - 2, y: bounds.height - functionLabel.bounds.height)
        }
    }
}
