//
//  CheckmarkView.swift
//
//  Created by Roy Rao on 2020/3/20.
//  Copyright © 2020 RoyRao. All rights reserved.
//
//  Edited version of WVCheckMark for macOS
//  Reference: https://github.com/wvabrinskas/WVCheckMark

import Cocoa

public class CheckmarkView: NSView {
    private var lineWidth: CGFloat = 4
    private var lineColor: CGColor = NSColor.green.cgColor
    private var loadingLineColor: CGColor = NSColor.darkGray.cgColor
    private var duration: CGFloat = 0.6
    private var damping: CGFloat = 10
    private var originalRect: CGRect!
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        originalRect = frameRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var isFlipped: Bool {
        return true
    }
    
}

extension CheckmarkView {
    
    // MARK: - Private methods
    private func springAnimation() -> CASpringAnimation {
        // checkmark animation
        let spring = CASpringAnimation.init(keyPath: "lineWidth")
        spring.damping = damping
        spring.toValue = lineWidth
        spring.duration = spring.settlingDuration
        spring.repeatCount = 0
        spring.fillMode = .both
        spring.isRemovedOnCompletion = false
        return spring
    }
    
    private func createX(rect: CGRect) {
        createCircle(rect: rect)
        
        let plusShapeLeft = CAShapeLayer.init()
        plusShapeLeft.position = .init(x: 0, y: 0)
        plusShapeLeft.lineWidth = 0
        plusShapeLeft.strokeColor = lineColor
        let pathLeft = CGMutablePath.init()
        pathLeft.move(to: .init(x: rect.midX - 10, y: rect.midY - 10))
        pathLeft.addLine(to: .init(x: rect.midX + 10, y: rect.midY + 10))
        plusShapeLeft.path = pathLeft
        plusShapeLeft.add(springAnimation(), forKey: nil)
        
        let plusShapeRight = CAShapeLayer.init()
        plusShapeRight.position = .init(x: 0, y: 0)
        plusShapeRight.lineWidth = 0
        plusShapeRight.strokeColor = lineColor
        let pathRight = CGMutablePath.init()
        pathRight.move(to: .init(x: rect.midX + 10, y: rect.midY - 10))
        pathRight.addLine(to: .init(x: rect.midX - 10, y: rect.midY + 10))
        plusShapeRight.path = pathRight
        plusShapeRight.add(springAnimation(), forKey: nil)
        
        self.layer?.addSublayer(plusShapeLeft)
        self.layer?.addSublayer(plusShapeRight)
    }
    
    private func createCheckmark(rect: CGRect) {
        createCircle(rect: originalRect)
        
        let checkShape = CAShapeLayer.init()
        //  origin
//        checkShape.position = .init(x: rect.midX + (rect.size.width * 0.25), y: rect.midY - (rect.size.height * 0.15))
        checkShape.position = .init(x: rect.midX + (rect.size.width * 0.25), y: rect.height / 4)
        checkShape.path = NSBezierPath.init(rect: .init(x: 0, y: 0, width: rect.size.width / 2, height: rect.size.height / 2)).cgPath
        checkShape.lineWidth = 0
        checkShape.fillColor = .clear
        checkShape.strokeColor = lineColor
        checkShape.strokeStart = 0
        checkShape.strokeEnd = 0.36
        checkShape.setAffineTransform(.init(rotationAngle: 2.4))
        checkShape.add(springAnimation(), forKey: nil)
        
        self.layer?.addSublayer(checkShape)
    }
    
    private func createStroke(rect: CGRect) {
        let rectShape = CAShapeLayer.init()
        rectShape.bounds = bounds
        rectShape.position = .init(x: rect.midX, y: rect.midY)
        rectShape.cornerRadius = bounds.width / 2
        rectShape.path = NSBezierPath.init(ovalIn: rect).cgPath
        rectShape.lineWidth = lineWidth
        rectShape.strokeColor = loadingLineColor
        rectShape.fillColor = .clear
        rectShape.strokeStart = 0
        rectShape.strokeEnd = 0
        
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 1.0
        start.beginTime = CFTimeInterval(duration / 2.0)
        start.speed = 2.0
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1.0
        
        let group = CAAnimationGroup()
        group.animations = [end,start]
        group.duration = CFTimeInterval(duration)
        group.autoreverses = false
        group.repeatCount = .infinity
        group.timingFunction = nil
        group.fillMode = .both
        group.isRemovedOnCompletion = false
        rectShape.add(group, forKey: nil)
        
        //add shapes to layer
        self.layer?.addSublayer(rectShape)
    }
    
    private func createCircle(rect: CGRect) {
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds
        rectShape.position = CGPoint(x: rect.midX, y: rect.midY)
        rectShape.cornerRadius = bounds.width / 2
        rectShape.path = NSBezierPath.init(rect: rect).cgPath
        rectShape.lineWidth = lineWidth
        rectShape.strokeColor = lineColor
        rectShape.fillColor = .clear
        rectShape.strokeStart = 0
        rectShape.strokeEnd = 0
        
        let easeOut = CAMediaTimingFunction(name: .easeOut)
        
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 0
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1.0
        
        let group = CAAnimationGroup()
        group.animations = [end,start]
        group.duration = CFTimeInterval(duration)
        group.autoreverses = false
        group.repeatCount = 0
        group.timingFunction = easeOut
        group.fillMode = .both
        group.isRemovedOnCompletion = false
        rectShape.add(group, forKey: nil)
        
        //add shapes to layer
        self.layer?.addSublayer(rectShape)
    }
    
    // MARK: - Open methods
    open func set(color: CGColor, width: CGFloat, damping: CGFloat, duration: CGFloat) {
        setColor(color: color)
        setLineWidth(width: width)
        setDamping(damp: damping)
        setDuration(duration: duration)
    }
    
    open func setColor(color: CGColor) {
        lineColor = color
    }
     
    open func setLineWidth(width: CGFloat) {
        lineWidth = width
    }
    
    open func setLoadingLineColor(color: CGColor) {
        loadingLineColor = color
    }
    
    open func setDuration(duration: CGFloat) {
        self.duration = duration
    }
    
    open func setDamping(damp: CGFloat) {
        damping = damp
    }
    
    open func startCheckmark(completion: (() -> Void)? = nil) {
        clear()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        createCheckmark(rect: originalRect)
        CATransaction.commit()
    }
    
    open func startX(completion: (() -> Void)? = nil) {
        clear()
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        createX(rect: originalRect)
        CATransaction.commit()
    }
    
    open func startLoading() {
        clear()
        createStroke(rect: originalRect)
    }
    
    open func clear() {
        if let sublayers = self.layer?.sublayers {
            for sublayer in sublayers {
                if sublayer is CAShapeLayer {
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
    
}
