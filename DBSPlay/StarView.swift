//
//  StarView.swift
//  DBSPlay
//
//  Created by DevilStiffer on 31/01/20.
//  Copyright © 2020 DBS. All rights reserved.
//

import UIKit

class StarsView: UIView {

    @IBInspectable var rating: Double = 5.0 {
        didSet {
            setNeedsLayout()
        }
    }

    func starPath(size: CGFloat, full: Bool) -> UIBezierPath {
        let fullPoints = [CGPoint(x: 0.5, y: 0.03), CGPoint(x: 0.61, y: 0.38), CGPoint(x: 0.99, y: 0.38), CGPoint(x: 0.68, y: 0.61), CGPoint(x: 0.8, y: 0.97), CGPoint(x: 0.5, y: 0.75), CGPoint(x: 0.2, y: 0.97), CGPoint(x: 0.32, y: 0.61), CGPoint(x: 0.01, y: 0.38), CGPoint(x: 0.39, y: 0.38)].map({ CGPoint(x: $0.x * size, y: $0.y * size) })
        let halfPoints = [CGPoint(x: 0.5, y: 0.03), CGPoint(x: 0.5, y: 0.75), CGPoint(x: 0.2, y: 0.97), CGPoint(x: 0.32, y: 0.61), CGPoint(x: 0.01, y: 0.38), CGPoint(x: 0.39, y: 0.38)].map({ CGPoint(x: $0.x * size, y: $0.y * size) })
        let points = full ? fullPoints : halfPoints
        let starPath = UIBezierPath()
        starPath.move(to: points.last!)
        for point in points {
            starPath.addLine(to: point)
        }
        return starPath
    }

    func starLayer(full: Bool) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = starPath(size: bounds.size.height, full: full).cgPath
        shapeLayer.fillColor = tintColor.cgColor
        return shapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let sublayers = layer.sublayers
        for sublayer in sublayers ?? [] {
            sublayer.removeFromSuperlayer()
        }
        for i in 1...5 {
            if rating >= Double(i) - 0.5 {
                let star = starLayer(full: rating >= Double(i))
                star.transform = CATransform3DMakeTranslation(bounds.size.height * CGFloat(i - 1), 0, 0)
                layer.addSublayer(star)
            }
        }
    }
}
