//
//  Buttons.swift
//  GameTimer
//
//  Created by Chris Wright on 24/02/2015.
//  Copyright (c) 2015 BoruSoft. All rights reserved.
//

import UIKit
import Foundation


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@IBDesignable class MuteButton:UIButton
{

    var _muted = false
    var _debug = false

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.setTitle("", forState: UIControlState.Normal)
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    required init(coder decoder: NSCoder)
    {
        super.init(coder: decoder)
        self.setTitle("", forState: UIControlState.Normal)
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setMuted(newMuted:Bool)
    {
        if newMuted != _muted
        {
            _muted = newMuted
            self.setNeedsDisplay();
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setDebug(newDebug:Bool)
    {
        if newDebug != _debug
        {
            _debug = newDebug
            self.setNeedsDisplay();
        }
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func drawRect(rect: CGRect)
    {
        let startTime = NSDate.timeIntervalSinceReferenceDate()
        
        self.setTitle("", forState: UIControlState.Normal)

        
        //self.setTitle("", forState: UIControlState.Normal)

        super.drawRect(rect)
        
        //("\(self.bounds.size.width),\(self.bounds.size.height)" as NSString).drawAtPoint(self.bounds.origin, withAttributes: nil)
        

        let bounds = self.bounds
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        let size = min(bounds.width, bounds.height)
        
        
        // TODO: Try CoreGraphics instead...
        // http://www.thinkandbuild.it/building-a-custom-and-designabl-control-in-swift/


        // Debug - background rect
        //UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).set()
        //CGContextAddRect(UIGraphicsGetCurrentContext(), CGRect(x:center.x - size / 2, y:center.y - size / 2, width:size, height:size ) )
        //CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill)
        

        // Prepare for drawing
        let graphicsContext = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(graphicsContext, 2)
        CGContextSetLineCap(graphicsContext, kCGLineCapRound)
        
        if (_muted)
        {
            UIColor.lightGrayColor().set()
        }
        else
        {
            //UIColor.blackColor().set()
            UIColor.darkGrayColor().set()
        }

        
        // Rect
        CGContextAddRect(graphicsContext, CGRect(x:center.x - size * 0.35, y:center.y - size * 0.1, width:size * 0.3, height:size * 0.2 ) )
        //UIColor(red: 0.4, green: 0.3, blue: 0.3, alpha: 1.0).set()
        //CGContextSetLineWidth(graphicsContext, 3)
        //CGContextSetLineCap(graphicsContext, kCGLineCapButt)
        //CGContextDrawPath(graphicsContext, kCGPathFill)

        
        // Cone of speaker
        //UIColor(red:0.4, green:0.3, blue: 1, alpha: 1.0).set()
        CGContextMoveToPoint(graphicsContext, center.x - size/4, center.y)
        CGContextAddLineToPoint(graphicsContext, center.x, center.y - size/4)
        CGContextAddLineToPoint(graphicsContext, center.x, center.y + size/4)
        CGContextAddLineToPoint(graphicsContext, center.x - size/4, center.y)
        CGContextDrawPath(graphicsContext, kCGPathFill)


        // Build the circles
        let angle = CGFloat(M_PI / 180 * 45)

        CGContextAddArc(graphicsContext, CGFloat(self.frame.size.width / 2.0), CGFloat(self.frame.size.height / 2.0), size * 0.15, -angle, angle, 0)
        CGContextDrawPath(graphicsContext, kCGPathStroke)

        CGContextAddArc(graphicsContext, CGFloat(self.frame.size.width / 2.0), CGFloat(self.frame.size.height / 2.0), size * 0.25, -angle, angle, 0)
        CGContextDrawPath(graphicsContext, kCGPathStroke)

        CGContextAddArc(graphicsContext, CGFloat(self.frame.size.width / 2.0), CGFloat(self.frame.size.height / 2.0), size * 0.35, -angle, angle, 0)
        CGContextDrawPath(graphicsContext, kCGPathStroke)

        CGContextAddArc(graphicsContext, CGFloat(self.frame.size.width / 2.0), CGFloat(self.frame.size.height / 2.0), size * 0.45, -angle, angle, 0)
        CGContextDrawPath(graphicsContext, kCGPathStroke)
        
        
        // Muted - draw the X over it
        if (_muted)
        {
            UIColor.darkGrayColor().set()
            let xSize = size * 0.35;
            CGContextSetLineWidth(graphicsContext, 5)
            
            CGContextMoveToPoint(graphicsContext, center.x - xSize, center.y - xSize)
            CGContextAddLineToPoint(graphicsContext, center.x + xSize, center.y + xSize)
            CGContextDrawPath(graphicsContext, kCGPathStroke)

            CGContextMoveToPoint(graphicsContext, center.x + xSize, center.y - xSize)
            CGContextAddLineToPoint(graphicsContext, center.x - xSize, center.y + xSize)
            CGContextDrawPath(graphicsContext, kCGPathStroke)
        }


        // Debug - Draw the center
        if (_debug)
        {
            CGContextAddArc(graphicsContext, CGFloat(center.x), CGFloat(center.y), 2, 0, CGFloat(M_PI) * 2.0, 0)
            UIColor(red:1, green:0.25, blue:0.25, alpha:1.0).set()
            CGContextDrawPath(graphicsContext, kCGPathFill)
        }
        
        let timeTaken = NSDate.timeIntervalSinceReferenceDate() - startTime
        #if DEBUG
            println(__FUNCTION__ + " render time = \(timeTaken)" )
        #endif

    }
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@IBDesignable class RestartButton:UIButton
{
    
    var _string = "99:99"
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    required init(coder decoder: NSCoder)
    {
        super.init(coder: decoder)
        self.setTitle("", forState: UIControlState.Normal)
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setString(newString:String)
    {
        if newString != _string
        {
            _string = newString
            self.setNeedsDisplay();
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func drawRefreshAtPoint(center:CGPoint, radius:Double)
    {
        let graphicsContext = UIGraphicsGetCurrentContext()
        CGContextSetLineCap(graphicsContext, kCGLineCapRound)
        CGContextSetLineWidth(graphicsContext, 4)
        
        
        // Draw the arc
        UIColor.darkGrayColor().set()
        CGContextAddArc(graphicsContext, center.x, center.y, CGFloat(radius), CGFloat(M_PI / 180 * 22.5), CGFloat(M_PI / 180 * (360-22.5)), 0)
        let endOfArc = CGContextGetPathCurrentPoint(graphicsContext)  // Remember the end of the arc as it's lost once we draw
        CGContextDrawPath(graphicsContext, kCGPathStroke)
        
        
        // Triangle at end of arc
        CGContextSetLineWidth(graphicsContext, 1)
        CGContextMoveToPoint(graphicsContext,    endOfArc.x +  4,  endOfArc.y - 10)
        CGContextAddLineToPoint(graphicsContext, endOfArc.x +  3,  endOfArc.y + 4)
        CGContextAddLineToPoint(graphicsContext, endOfArc.x - 10,  endOfArc.y + 4)
        //UIColor.greenColor().set()
        CGContextDrawPath(graphicsContext, kCGPathFill)
        //CGContextDrawPath(graphicsContext, kCGPathStroke)
        
        
        // Debug - Mark the end of the arc (in red)
        //CGContextAddArc(graphicsContext, CGFloat(endOfArc.x), CGFloat(endOfArc.y), 2, 0, CGFloat(M_PI) * 2.0, 0)
        //UIColor(red:1, green:0.25, blue:0.25, alpha:1.0).set()
        //CGContextDrawPath(graphicsContext, kCGPathFill)
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)

        
        // Debug - draw bounds
        //("w=\(self.bounds.size.width)  h=\(self.bounds.size.height)" as NSString).drawAtPoint(self.bounds.origin, withAttributes: nil)


        let iconSize = min(bounds.width, bounds.height)
        

        // Prepare for drawing
        let graphicsContext = UIGraphicsGetCurrentContext()
        let radius = Double(iconSize * 0.2)
        
        
        let textAttributes =
        [
            NSFontAttributeName : UIFont.systemFontOfSize(24.0),
            NSForegroundColorAttributeName : UIColor.darkGrayColor()
        ]
        
        let textSize = _string.sizeWithAttributes(textAttributes)
        
        
        let textOrigin = CGPoint(x:bounds.midX - textSize.width/2, y:bounds.midY - textSize.height/2);
        

        // Debug - draw background rect for the text
        //UIColor.greenColor().set()
        //CGContextAddRect(UIGraphicsGetCurrentContext(), CGRect(x:textOrigin.x, y:textOrigin.y, width:textSize.width, height:textSize.height ) )
        //CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFill)

        
        //println(__FUNCTION__ + "textOrigin=\(textOrigin)")
        

        let stringNS:NSString = self._string as NSString
        stringNS.drawAtPoint(textOrigin, withAttributes: textAttributes)
        
        
        //CGContextSetTextPosition(graphicsContext, center.x + size/2 + 10, center.y /*+ textSize.height/2*/)
        //CTLineDraw(line, graphicsContext)
        //CGContextSetTextPosition(graphicsContext, center.x + size/2 + 80, center.y + textSize.height/2)
        //CTLineDraw(line, graphicsContext)
        
        //CGContextSetTextPosition(graphicsContext, center.x + size/2 + 160, center.y - textSize.height/2)
        //CTLineDraw(line, graphicsContext)
        
        
        var refreshIconPoint = CGPoint(x:bounds.midX - textSize.width/2 - iconSize/2 - 10, y:bounds.midY)
        if refreshIconPoint.x - CGFloat(radius*1.2) < self.bounds.minX
        {
            refreshIconPoint.x = self.bounds.minX + CGFloat(radius*1.75)
        }
        
        drawRefreshAtPoint(refreshIconPoint, radius:radius)
        //drawRefreshAtPoint(CGPoint(x:bounds.midX + textSize.width/2 + iconSize/2 + 10, y:bounds.midY), radius:radius)
        
        
        
        // Debug - mark the points where we draw
        //CGContextAddArc(graphicsContext, textOrigin.x, textOrigin.y, 2, 0, CGFloat(M_PI) * 2.0, 0)
        //CGContextAddArc(graphicsContext, center.x + size/2 + 10, center.y+textSize.height, 2, 0, CGFloat(M_PI) * 2.0, 0)
        //UIColor(red:1, green:0.25, blue:0.25, alpha:1.0).set()
        //CGContextDrawPath(graphicsContext, kCGPathFill)


  
        // Debug - Draw the center
        //CGContextAddArc(graphicsContext, CGFloat(center.x), CGFloat(center.y), 2, 0, CGFloat(M_PI) * 2.0, 0)
        //UIColor(red:1, green:0.25, blue:0.25, alpha:1.0).set()
        //CGContextDrawPath(graphicsContext, kCGPathFill)
    }
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@IBDesignable class MainButton:UIButton
{
    
    var _time = "XX:XX.X"
    var _status = "status"
    var _hint = "hint hint hint hint"
    var _debug = false
    var _displayHMS = false
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    required init(coder decoder: NSCoder)
    {
        super.init(coder: decoder)
        self.setTitle("", forState: UIControlState.Normal)
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setTime(newTime:String)
    {
        if newTime != _time
        {
            _time = newTime
            self.setNeedsDisplay();
        }
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setStatus(newStatus:String)
    {
        if newStatus != _status
        {
            _status = newStatus
            self.setNeedsDisplay();
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setHint(newHint:String)
    {
        if newHint != _hint
        {
            _hint = newHint
            self.setNeedsDisplay();
        }
    }
   
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setDisplayHMS(newDisplayHMS:Bool)
    {
        if newDisplayHMS != _displayHMS
        {
            _displayHMS = newDisplayHMS
            self.setNeedsDisplay();
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func setDebug(newDebug:Bool)
    {
        if newDebug != _debug
        {
            _debug = newDebug
            self.setNeedsDisplay();
        }
    }
    

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func drawRect(rect: CGRect)
    {
        super.drawRect(rect)

        // Debug - draw bounds
        if (_debug)
        {
            ("w=\(self.bounds.size.width)  h=\(self.bounds.size.height)" as NSString).drawAtPoint(self.bounds.origin, withAttributes: nil)
        }
    
        
        // Time
        var timeSizeText = min(self.bounds.width/8, self.bounds.height/4)
        
        var font = UIFont.systemFontOfSize(CGFloat(timeSizeText)); // Default
        
        
        //let fixedFontOptional = UIFont(name:"Courier New", size:CGFloat(timeSizeText)) // This returns an optional so can't add it to the disctionary
        let fixedFontOptional = UIFont(name:"Menlo-Regular", size:CGFloat(timeSizeText)) // This returns an optional so can't add it to the disctionary

        
        if let fixedFont = fixedFontOptional
        {
            font = fixedFont
            
        }
        
        let textAttributesTime =
        [
            NSFontAttributeName : font,
            NSForegroundColorAttributeName : UIColor.darkGrayColor()
        ]
        
        let textSizeTime = _time.sizeWithAttributes(textAttributesTime)
        
        
        let textOriginTime = CGPoint(x:bounds.midX - textSizeTime.width/2, y:bounds.midY - textSizeTime.height/2)
        
        let timeNS:NSString = self._time as NSString
        timeNS.drawAtPoint(textOriginTime, withAttributes: textAttributesTime)
        
        
        // Status
        var timeSizeStatus = timeSizeText / 2
        let textAttributesStatus =
        [
            NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(timeSizeStatus)),
            NSForegroundColorAttributeName : UIColor.darkGrayColor()
        ]
        
        let textSizeStatus = _status.sizeWithAttributes(textAttributesStatus)
        
        
        let textOriginStatus = CGPoint(x:bounds.midX - textSizeStatus.width/2, y:bounds.minY + bounds.height/4 - textSizeStatus.height/2)
            
        if (_displayHMS)
        {
            let HMS = "min sec"
            (HMS as NSString).drawAtPoint(CGPointMake(textOriginTime.x, textOriginTime.y - textSizeTime.height), withAttributes: textAttributesTime)
        }
        else
        {
            let statusNS:NSString = self._status as NSString
            statusNS.drawAtPoint(textOriginStatus, withAttributes: textAttributesStatus)
            
            // Background box for the status text
            if (_debug)
            {
                var textRect = CGRect(x:textOriginStatus.x, y:textOriginStatus.y, width:textSizeStatus.width, height:textSizeStatus.height)
                
                let graphicsContext = UIGraphicsGetCurrentContext()
                CGContextAddRect(graphicsContext, textRect)
                UIColor(red: 1, green: 0.7, blue: 0.7, alpha: 0.5).set()
                //CGContextSetLineWidth(graphicsContext, 3)
                //CGContextSetLineCap(graphicsContext, kCGLineCapButt)
                CGContextDrawPath(graphicsContext, kCGPathFill)
                
                statusNS.drawInRect(textRect, withAttributes: textAttributesStatus)
            }
        }
        
        
        var style = NSMutableParagraphStyle()
        
        //style.setAlignment(NSTextAlignment.Center)
        style.alignment = NSTextAlignment.Center
        
        let textAttributesStatus2 =
        [
            NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(timeSizeStatus)),
            NSParagraphStyleAttributeName : style,
            NSForegroundColorAttributeName : UIColor.darkGrayColor()
        ]
        
        
        // Hint
        var timeSizeHint = timeSizeStatus * 0.75
        
        let textAttributesHint =
        [
            NSFontAttributeName : UIFont.systemFontOfSize(CGFloat(timeSizeHint)),
            NSForegroundColorAttributeName : UIColor.darkGrayColor()
        ]
        
        let textSizeHint = _hint.sizeWithAttributes(textAttributesHint)
        
        
        let textOriginHint = CGPoint(x:bounds.midX - textSizeHint.width/2, y:bounds.maxY - bounds.height/8 - textSizeHint.height/2)
        
        let hintNS:NSString = self._hint as NSString
        hintNS.drawAtPoint(textOriginHint, withAttributes: textAttributesHint)
        
        //println(__FUNCTION__ + " drawing status=\(status) of size \(timeSizeStatus) at (\(textOriginStatus.x),\(textOriginStatus.y)")
    }
    
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@IBDesignable class SettingsButton:UIButton
{
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func pointAtAngle(centerX:CGFloat, centerY:CGFloat, radius:Double, angleInRadians:Double) -> CGPoint
    {
        let x = centerX + CGFloat(radius * cos(angleInRadians))
        let y = centerY + CGFloat(radius * sin(angleInRadians))
        return CGPoint(x:x, y:y)
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func layoutSubviews()
    {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func drawRect(rect: CGRect)
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        
        super.drawRect(rect)
        
        //("\(self.bounds.size.width),\(self.bounds.size.height)" as NSString).drawAtPoint(self.bounds.origin, withAttributes: nil)
        
        
        self.setTitle("", forState: UIControlState.Normal)
        
        let bounds = self.bounds
        let center = CGPoint(x:bounds.midX, y:bounds.midY)
        let size = min(bounds.width, bounds.height)
        
        
        let graphicsContext = UIGraphicsGetCurrentContext()
        //CGContextSetLineWidth(graphicsContext, 2)
        //CGContextSetLineCap(graphicsContext, kCGLineCapRound)

        
        UIColor.darkGrayColor().set()
        //UIColor.blackColor().set()

        //CGContextAddArc(graphicsContext, center.x, center.y, size * 0.4, 0, CGFloat(M_PI) * 2.0, 0)
        //CGContextDrawPath(graphicsContext, kCGPathStroke)
        

        //CGContextAddArc(graphicsContext, center.x, center.y, size * 0.22, 0, CGFloat(M_PI) * 2.0, 0)
        //UIColor .darkGrayColor().set()
        //CGContextDrawPath(graphicsContext, kCGPathStroke)

        
        let startPoint = pointAtAngle(center.x, centerY:center.y, radius:Double(size * 0.225), angleInRadians:Double(M_PI / 180.0 * (-11.5-11.5/2) ) )
        CGContextMoveToPoint(graphicsContext, startPoint.x, startPoint.y)

        for var angle = 0.0; angle<360.0; angle=angle+45
        {
            // Outer arc
            CGContextAddArc(graphicsContext, center.x, center.y, size * 0.3, CGFloat(M_PI / 180.0 * (angle-11.25)), CGFloat(M_PI / 180.0 * (angle+11.25) ), 0 )
            //let pointBetweenSpoke = pointAtAngle(center.x, centerY:center.y, radius:Double(size * 0.2), angleInRadians:Double(M_PI / 180.0 * (angle+22.5) ) )
            //CGContextAddLineToPoint(graphicsContext, pointBetweenSpoke.x, pointBetweenSpoke.y)
            
            
            // Line to inner
            let pointBetweenSpoke = pointAtAngle(center.x, centerY:center.y, radius:Double(size * 0.225), angleInRadians:Double(M_PI / 180.0 * (angle+11.25+11.25/2) ) )
            CGContextAddLineToPoint(graphicsContext, pointBetweenSpoke.x, pointBetweenSpoke.y)
            
            // Inner arc
            CGContextAddArc(graphicsContext, center.x, center.y, size * 0.225, CGFloat(M_PI / 180.0 * (angle+11.25)), CGFloat(M_PI / 180.0 * (angle+11.25+22.5-11.25/2) ), 0 )
        }
        
        
        // Hole
        CGContextAddArc(graphicsContext, center.x, center.y, size * 0.1, 0, CGFloat(M_PI) * 2.0, 1) // Note - this has to be drawn in the other direction as the outer path otherwise it will be filled
        
        
        //CGContextDrawPath(graphicsContext, kCGPathStroke)
        CGContextDrawPath(graphicsContext, kCGPathFill)


        // Debug - draw the middle
        //UIColor.redColor().set()
        //CGContextAddArc(graphicsContext, center.x, center.y, 2, 0, CGFloat(M_PI) * 2.0, 0)
        //CGContextDrawPath(graphicsContext, kCGPathFill)
    }

}

