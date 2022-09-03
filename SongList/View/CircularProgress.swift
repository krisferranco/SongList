//
//  CircularProgress.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/2/22.
//

import UIKit

class CircularProgress: UIView {

    fileprivate var progressLayer = CAShapeLayer()
    fileprivate var tracklayer = CAShapeLayer()
    
    var currentProgress: Float = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    var progressColor:UIColor = UIColor.red {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }
    
    var trackColor:UIColor = UIColor.white {
        didSet {
            tracklayer.strokeColor = trackColor.cgColor
        }
    }
    
    fileprivate func createCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.size.width/2.0
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
        radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * Double.pi),
        endAngle: CGFloat(1.5 * Double.pi), clockwise: true)
        
        tracklayer.path = circlePath.cgPath
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = trackColor.cgColor
        tracklayer.lineWidth = 3.0;
        tracklayer.strokeEnd = 1.0
        layer.addSublayer(tracklayer)
        
        progressLayer.path = circlePath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = 4.0;
        progressLayer.strokeEnd = 0.0
        layer.addSublayer(progressLayer)
        
    }
    
    func setProgressWithAnimation(value: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 0.1
        // Animate from 0 (no circle) to 1 (full circle)
        animation.fromValue = currentProgress
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "animateCircle")
        
        currentProgress = value
    }

}
