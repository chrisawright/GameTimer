//
//  ViewController.swift
//  ButtonTest
//
//  Created by Chris Wright on 26/02/2015.
//  Copyright (c) 2015 BoruSoft. All rights reserved.
//

import UIKit


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ViewController: UIViewController
{
    //@IBOutlet var button:MainButton!
    //@IBOutlet var button:RestartButton!
    @IBOutlet var button:UIButton!
    
    let panRec = UIPanGestureRecognizer()
    
    var initialSizeTapPos:CGPoint!
    var initialPanPos:CGPoint!
    var buttonFrame:CGRect!
    

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let mainButton = button as? MainButton
        {
            mainButton.setStatus("Ready")
            mainButton.setHint("Tap to start or pinch to adjust time")
            mainButton.setTime("99:99:99")
        }
        else if let muteButton = button as? MuteButton
        {
            // Nothing to set
        }
        else if let settingsButton = button as? SettingsButton
        {
            // Nothing to set
        }
        else
        {
            assert(false)  // Need to code for this type
        }
        
        panRec.addTarget(self, action:"pan:")
        view.addGestureRecognizer(panRec)
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func pan(sender: UIButton)
    {
        
        //switch panRec.state
        //{
        //    case UIGestureRecognizerState.Possible:  println (__FUNCTION__ + "Possible " )
        //    case UIGestureRecognizerState.Began:     println (__FUNCTION__ + "Began     translationInView=\(panRec.translationInView)" )
        //    case UIGestureRecognizerState.Changed:   println (__FUNCTION__ + "Changed   translationInView=\(panRec.translationInView)" )
        //    case UIGestureRecognizerState.Ended:     println (__FUNCTION__ + "Ended     translationInView=\(panRec.translationInView)" )
        //    case UIGestureRecognizerState.Cancelled: println (__FUNCTION__ + "Cancelled translationInView=\(panRec.translationInView)" )
        //    default: assert(false);                  println (__FUNCTION__ + "???       translationInView=\(panRec.translationInView)" )
        //}


        if panRec.state==UIGestureRecognizerState.Began
        {
            if (panRec.locationInView(view).x < button.frame.midX)
            {
                // Start of move
                initialPanPos = panRec.translationInView(view)
                assert(initialSizeTapPos == nil)
                //button.backgroundColor = UIColor.purpleColor()
            }
            else
            {
                // Start of size
                initialSizeTapPos = panRec.translationInView(view)
                assert(initialPanPos == nil)
                //button.backgroundColor = UIColor.redColor()
            }

            buttonFrame = button.frame
        }
        else if panRec.state==UIGestureRecognizerState.Changed
        {
            let newPos = panRec.translationInView(view)
            
            
            if (initialPanPos != nil)
            {
                assert (initialSizeTapPos==nil)
                
                // Move
                var newFrame = CGRectMake(buttonFrame.origin.x + newPos.x - initialPanPos.x, buttonFrame.origin.y + newPos.y - initialPanPos.y, buttonFrame.size.width, buttonFrame.size.height)
                
                //println (__FUNCTION__ + " newFrame=\(newFrame)" )
                button.frame = newFrame
            }
            else if (initialSizeTapPos != nil)
            {
                assert (initialPanPos==nil)
                
                // Size
                var newFrame = CGRectMake(buttonFrame.origin.x, buttonFrame.origin.y, buttonFrame.size.width  + newPos.x - initialSizeTapPos.x, buttonFrame.size.height + newPos.y - initialSizeTapPos.y)
                
                
                //println (__FUNCTION__ + " newFrame=\(newFrame)" )
                button.frame = newFrame
            }
            else
            {
                // Didn't start the action on a control so ignore
            }
        }
        else  if panRec.state==UIGestureRecognizerState.Ended
        {
            initialSizeTapPos = nil
            initialPanPos = nil
        }
    }

}

