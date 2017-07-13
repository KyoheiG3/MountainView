//
//  MountainView.swift
//  MountainView
//
//  Created by Kyohei Ito on 2016/12/05.
//  Copyright © 2016年 Kyohei Ito. All rights reserved.
//

import UIKit
import Mountain

public class MountainView: UIView, MountainLayerHaving, MountainLayerDelegate {
    private let curveView = CurveView()
    private let crossView = CrossView()
    private let gridView = GridView()
    private let informationView = InformationView()
    public var mountainLayer: MountainLayer {
        return layer as! MountainLayer
    }

    var viewColor: UIColor = .black
    var curveLineCap: String {
        get { return curveView.lineCap }
        set { curveView.lineCap = newValue }
    }
    var curveWidth: CGFloat {
        get { return curveView.lineWidth }
        set { curveView.lineWidth = newValue }
    }
    var curveColor: UIColor {
        get { return curveView.lineColor }
        set { curveView.lineColor = newValue }
    }
    
    override public class var layerClass: AnyClass {
        return MountainLayer.self
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        resizeSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
        resizeSubviews()
    }
    
    public func resizeSubviews() {
        informationView.frame = bounds
        informationView.font = UIFont.systemFont(ofSize: max((bounds.width + bounds.height) / 30, 8))
        informationView.configureLabel()
        informationView.setInformation(.default)
        informationView.setProgress(0)
        
        gridView.frame = bounds
        gridView.configureGrid()
        
        crossView.frame = bounds
        crossView.configureGrid()
        
        curveView.frame = CGRect(x: -frame.width / 2, y: -frame.height / 2, width: frame.width * 2, height: frame.height * 2)
        curveView.configureCurve()
    }
    
    func configureView() {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        
        gridView.backgroundColor = viewColor.withAlphaComponent(0.2)
        addSubview(gridView)
        
        crossView.crossColor = viewColor.withAlphaComponent(0.5)
        addSubview(crossView)
        
        addSubview(curveView)
        
        informationView.textAlignment = .right
        informationView.textColor = viewColor.withAlphaComponent(0.5)
        addSubview(informationView)
    }
    
    public func climbingSituationDidChange(_ layer: MountainLayer, situation: ClimbingSituation) {
        switch situation {
        case .begin(let info):
            informationView.setInformation(info)
            informationView.setProgress(0)
        case .on(let progress, let curve):
            let point = CGPoint(x: frame.width * progress, y: frame.height - frame.height * curve)
            curveView.move(to: point)
            informationView.setProgress(progress)
        case .cancelled, .finished:
            curveView.reset()
        }
    }
    
}
