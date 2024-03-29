//
//  Knob.swift
//  nomadic-ambience
//
//  Created by Rob Broadwell on 1/11/18.
//  Copyright © 2018 Rob Broadwell. All rights reserved.
//

import UIKit

public class Knob: UIControl {
    private var backingValue: Float = 0.0
    
    /** Contains the receiver’s current value. */
    public var value: Float {
        get { return backingValue }
        set { setValue(newValue, animated: false) }
    }
    
    /** Sets the receiver’s current value, allowing you to animate the change visually. */
    public func setValue(_ value: Float, animated: Bool) {
        if(value != self.value) {
            // Save the value to the backing value
            // Make sure we limit it to the requested bounds
            self.backingValue = min(self.maximumValue, max(self.minimumValue, value))
            
            // Now let's update the knob with the correct angle
            let angleRange = endAngle - startAngle
            let valueRange = CGFloat(maximumValue - minimumValue)
            let angle = CGFloat(value - minimumValue) / valueRange * angleRange + startAngle
            knobRenderer.setPointerAngle(pointerAngle: angle, animated: animated)
        }
    }
    
    /** Contains the minimum value of the receiver. */
    public var minimumValue: Float = 0.0
    
    /** Contains the maximum value of the receiver. */
    public var maximumValue: Float = 1.0
    
    /** Contains a Boolean value indicating whether changes in the sliders value generate continuous update events. */
    public var continuous = true
    
    private let knobRenderer = KnobRenderer()
    
    /** Specifies the angle of the start of the knob control track. Defaults to -11π/8 */
    public var startAngle: CGFloat {
        get { return knobRenderer.startAngle }
        set { knobRenderer.startAngle = newValue }
    }
    
    /** Specifies the end angle of the knob control track. Defaults to 3π/8 */
    public var endAngle: CGFloat {
        get { return knobRenderer.endAngle }
        set { knobRenderer.endAngle = newValue }
    }
    
    /** Specifies the width in points of the knob control track. Defaults to 2.0 */
    public var lineWidth: CGFloat {
        get { return knobRenderer.lineWidth }
        set { knobRenderer.lineWidth = newValue }
    }
    
    /** Specifies the length in points of the pointer on the knob. Defaults to 6.0 */
    public var pointerLength: CGFloat {
        get { return knobRenderer.pointerLength }
        set { knobRenderer.pointerLength = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        createSublayers()
        self.addSubview(knobRenderer.knobImage)
        
        let gr = RotationGestureRecognizer(target: self, action: #selector(handleRotation(sender:)))
        self.addGestureRecognizer(gr)
    }
    
    public override func tintColorDidChange() {
        knobRenderer.strokeColor = tintColor
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSublayers() {
        knobRenderer.update(bounds: bounds)
        knobRenderer.strokeColor = tintColor
        knobRenderer.startAngle = -CGFloat(Double.pi * 11.0 / 8.0);
        knobRenderer.endAngle = CGFloat(Double.pi * 3.0 / 8.0);
        knobRenderer.pointerAngle = knobRenderer.startAngle;
        knobRenderer.lineWidth = 5.0
        knobRenderer.pointerLength = 6.0
        
        layer.addSublayer(knobRenderer.trackLayer)
        layer.addSublayer(knobRenderer.pointerLayer)
    }
    
    @objc func handleRotation(sender: AnyObject) {
        let gr = sender as! RotationGestureRecognizer
        
        // 1. Mid-point angle
        let midPointAngle = (2.0 * CGFloat(Double.pi) + self.startAngle - self.endAngle) / 2.0 + self.endAngle
        
        // 2. Ensure the angle is within a suitable range
        var boundedAngle = gr.rotation
        if boundedAngle > midPointAngle {
            boundedAngle -= 2.0 * CGFloat(Double.pi)
        } else if boundedAngle < (midPointAngle - 2.0 * CGFloat(Double.pi)) {
            boundedAngle += 2 * CGFloat(Double.pi)
        }
        
        // 3. Bound the angle to within the suitable range
        boundedAngle = min(self.endAngle, max(self.startAngle, boundedAngle))
        
        // 4. Convert the angle to a value
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let valueForAngle = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        
        // 5. Set the control to this value
        self.value = valueForAngle
        
        print("value: \(value)")
        
        // Notify of value change
        if continuous {
            sendActions(for: .valueChanged)
        } else {
            // Only send an update if the gesture has completed
            if (gr.state == UIGestureRecognizerState.ended) || (gr.state == UIGestureRecognizerState.cancelled) {
                sendActions(for: .valueChanged)
            }
        }
    }
}

private class KnobRenderer {
    var strokeColor: UIColor {
        get {
            return UIColor(cgColor: trackLayer.strokeColor!)
        }
        
        set(strokeColor) {
            trackLayer.strokeColor = strokeColor.cgColor
            pointerLayer.strokeColor = strokeColor.cgColor
        }
    }
    
    var lineWidth: CGFloat = 1.0 {
        didSet { update() }
    }
    
    let trackLayer = CAShapeLayer()
    
    let knobImage = UIImageView()
    
    var startAngle: CGFloat = 0.0 {
        didSet { update() }
    }
    
    var endAngle: CGFloat = 0.0 {
        didSet { update() }
    }
    
    let pointerLayer = CAShapeLayer()
    
    var backingPointerAngle: CGFloat = 0.0
    
    var pointerAngle: CGFloat {
        get { return backingPointerAngle }
        set { setPointerAngle(pointerAngle: newValue, animated: false) }
    }
    
    func setPointerAngle(pointerAngle: CGFloat, animated: Bool) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        pointerLayer.transform = CATransform3DMakeRotation(pointerAngle, 0.0, 0.0, 0.1)
        knobImage.transform = CGAffineTransform(rotationAngle: pointerAngle + CGFloat(Double.pi / 2))
        
        if animated {
            let midAngle = (max(pointerAngle, self.pointerAngle) - min(pointerAngle, self.pointerAngle) ) / 2.0 + min(pointerAngle, self.pointerAngle)
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            animation.duration = 0.25
            
            animation.values = [self.pointerAngle, midAngle, pointerAngle]
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pointerLayer.add(animation, forKey: nil)
        }
        
        CATransaction.commit()
        
        self.backingPointerAngle = pointerAngle
        updateTrackLayerPath()
    }
    
    var pointerLength: CGFloat = 0.0 {
        didSet { update() }
    }
    
    init() {
        trackLayer.fillColor = UIColor.clear.cgColor
        pointerLayer.fillColor = UIColor.clear.cgColor
        knobImage.image = #imageLiteral(resourceName: "knob")
    }
    
    func updateTrackLayerPath() {
        let arcCenter = CGPoint(x: trackLayer.bounds.width / 2.0, y: trackLayer.bounds.height / 2.0)
        let _ = max(pointerLength, trackLayer.lineWidth / 2.0) // "offset" now unused
        let radius = min(trackLayer.bounds.height, trackLayer.bounds.width) / 2.0 - 1; //was - offset
        trackLayer.path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: pointerAngle, clockwise: true).cgPath
    }
    
    func updatePointerLayerPath() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: pointerLayer.bounds.width - pointerLength - pointerLayer.lineWidth / 2.0, y: pointerLayer.bounds.height / 2.0))
        path.addLine(to: CGPoint(x: pointerLayer.bounds.width, y: pointerLayer.bounds.height / 2.0))
        pointerLayer.path = path.cgPath
    }
    
    func update() {
        trackLayer.lineWidth = lineWidth
        pointerLayer.lineWidth = lineWidth
        
        updateTrackLayerPath()
//        updatePointerLayerPath()
    }
    
    func update(bounds: CGRect) {
        let position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        
        trackLayer.bounds = bounds
        trackLayer.position = position
        
        pointerLayer.bounds = bounds
        pointerLayer.position = position
        
        knobImage.bounds = bounds
        knobImage.center = position
        
        update()
    }
}

import UIKit.UIGestureRecognizerSubclass

private class RotationGestureRecognizer: UIPanGestureRecognizer {
    var rotation: CGFloat = 0.0
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 10
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        updateRotationWithTouches(touches: touches)
        state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        updateRotationWithTouches(touches: touches)
        state = .changed
    }
    
    func updateRotationWithTouches(touches: Set<NSObject>) {
        if let touch = touches[touches.startIndex] as? UITouch {
            self.rotation = rotationForLocation(location: touch.location(in: self.view))
            print("rotation: \(rotation)")
        }
    }
    
    func rotationForLocation(location: CGPoint) -> CGFloat {
        let offset = CGPoint(x: location.x - view!.bounds.midX, y: location.y - view!.bounds.midY)
        return atan2(offset.y, offset.x)
    }
}
