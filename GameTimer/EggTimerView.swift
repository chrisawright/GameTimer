//
//  Control.swift
//  test-designable
//
//  Created by Chris Wright on 06/03/2015.
//  Copyright (c) 2015 borusoft. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class EggTimerView: UIView
{
    override func drawRect(rect: CGRect)
    {
        //("Hello" as NSString).drawAtPoint(CGPoint(x:10, y:10), withAttributes: nil);
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        CGContextSaveGState(graphicsContext)
        
        
        var size:CGFloat
        
        // Aspect ratio is 2h:1w
        if (bounds.size.width*2 > bounds.size.height)
        {
            size = bounds.size.height
        }
        else
        {
            size = bounds.size.width * 2
        }
        

        //UIColor.purpleColor().set(); UIBezierPath(rect:CGRect(x:bounds.midX - size/2, y:bounds.midY - size/2, width:size, height:size)).stroke()
        
        
        let radius = size / 12
        
        
        let bottomRightOrigin = CGPoint(x:bounds.midX + size/4 - radius, y:bounds.midY + size/2 - radius)
        let bottomLeftOrigin =  CGPoint(x:bounds.midX - size/4 + radius, y:bounds.midY + size/2 - radius)
        let topRightOrigin =    CGPoint(x:bounds.midX + size/4 - radius, y:bounds.midY - size/2 + radius)
        let topLeftOrigin =     CGPoint(x:bounds.midX - size/4 + radius, y:bounds.midY - size/2 + radius)
        
        let rightOrigin =       CGPoint(x:bounds.midX + radius + radius*4, y:bounds.midY)
        let leftOrigin =        CGPoint(x:bounds.midX - radius - radius*4, y:bounds.midY)
        
        
        
        var path = UIBezierPath()
        
        
        path.addArcWithCenter(rightOrigin,       radius:radius*4, startAngle:CGFloat(M_PI / 180 * (180+22.5)), endAngle:CGFloat(M_PI / 180 * (180-22.5)), clockwise:false) // Right
        
        path.addArcWithCenter(bottomRightOrigin, radius:radius,   startAngle:CGFloat(M_PI / 180 * (-45+22.5)),         endAngle:CGFloat(M_PI / 180 * 90), clockwise:true)          // Bottom right
        
        path.addArcWithCenter(bottomLeftOrigin,  radius:radius,   startAngle:CGFloat(M_PI / 180 * 90),         endAngle:CGFloat(M_PI / 180 * (180+45-22.5)), clockwise:true)  // Bottom left
        path.addArcWithCenter(leftOrigin,        radius:radius*4, startAngle:CGFloat(M_PI / 180 * 22.5),       endAngle:CGFloat(M_PI / 180 * -22.5), clockwise:false) // Left
        path.addArcWithCenter(topLeftOrigin,     radius:radius,   startAngle:CGFloat(M_PI / 180 * (180-22.5)), endAngle:CGFloat(M_PI / 180 * 270), clockwise:true)       // Top left
        path.addArcWithCenter(topRightOrigin,    radius:radius,   startAngle:CGFloat(M_PI / 180 * 270),        endAngle:CGFloat(M_PI / 180 * 22.5), clockwise:true)      // Top right
        path.closePath()
        
        
        // Gradient of eggtimer
        let locations = [ CGFloat(0.0),  CGFloat(1.0) ]
        let colors = [UIColor.greenColor().CGColor,UIColor.redColor().CGColor]
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let gradient  = CGGradientCreateWithColors(colorspace, colors, locations)
        let startPoint  = CGPointMake(bounds.midX, bounds.midY - size/2)
        let endPoint = CGPointMake(bounds.midX, bounds.midY + size/2)
        
        
        path.addClip()
        CGContextDrawLinearGradient(graphicsContext, gradient,startPoint, endPoint, 0)
        
        
        // Path of eggtimer
        UIColor.blackColor().set()
        path.lineWidth = size / 50
        path.stroke()
        
        CGContextRestoreGState(graphicsContext)  // Need this otherwise the view is still clipped (for the gradient fill)
        
        
        //for thePoint in [bottomRightOrigin, bottomLeftOrigin, topRightOrigin, topLeftOrigin, rightOrigin, leftOrigin]
        //{
        //    var path = UIBezierPath()
        //    path.addArcWithCenter(thePoint, radius:3, startAngle:0, endAngle:300, clockwise: true)
        //    UIColor.blueColor().set()
        //    path.stroke()
        //}
        

        //for thePoint in [startPoint, endPoint]
        //{
        //   var path = UIBezierPath()
        //    path.addArcWithCenter(thePoint, radius:3, startAngle:0, endAngle:300, clockwise: true)
        //    UIColor.greenColor().set()
        //    path.stroke()
        //}

        
        //for thePoint in [bottomRightOrigin, bottomLeftOrigin, topRightOrigin, topLeftOrigin]
        //{
        //    UIBezierPath(arcCenter:thePoint, radius:radius, startAngle: 0, endAngle:CGFloat(M_PI)*2, clockwise: true).stroke()
        //}

        
        //for thePoint in [rightOrigin, leftOrigin]
        //{
        //    UIBezierPath(arcCenter:thePoint, radius:radius*2, startAngle: 0, endAngle:CGFloat(M_PI)*2, clockwise: true).stroke()
        //}
        

    }
}