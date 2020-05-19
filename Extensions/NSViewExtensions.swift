//
//  NSViewExtensions.swift
//  AppLocker
//
//  Created by Roy Rao on 2020/2/24.
//  Copyright © 2020 RoyRao. All rights reserved.
//

import Cocoa

extension NSView {
    
    // Shake
    func shake(count: Float = 4, for duration: TimeInterval = 0.2, withTranslation translation: Float = 3) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        self.layer?.add(animation, forKey: "shake")
    }
    
}
