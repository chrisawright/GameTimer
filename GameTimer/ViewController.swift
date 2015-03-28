//
//  ViewController.swift
//  GameTimer
//
//  Created by Chris Wright on 18/02/2015.
//  Copyright (c) 2015 BoruSoft. All rights reserved.
//

import UIKit
import AVFoundation


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class ViewController: UIViewController
{
    
    let pinchRec = UIPinchGestureRecognizer()
    let panRec = UIPanGestureRecognizer()
    
    
    @IBOutlet var mainButton: MainButton!
    @IBOutlet var restartButton: RestartButton!
    @IBOutlet var muteButton: MuteButton!
    @IBOutlet var settingsArea: UIButton!
    
    
    var stopTime = NSDate.timeIntervalSinceReferenceDate() // TODO: Change
    var timeRemaining = 0.0 // For use when paused only, otherwise stopTime should be accurate
    
    var timer = NSTimer()
    var announcements = [0.0: "Time's Up"]
    
    var targetTime = 0.0
    
    let synth = AVSpeechSynthesizer()
    
    var muted = true
    
    var defaultMainColour:UIColor?
    
    var initialPanPos:CGPoint?
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad()
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        super.viewDidLoad()

        
        pinchRec.addTarget(self, action:"pinchTime:")
        view.addGestureRecognizer(pinchRec)
        
        panRec.addTarget(self, action:"panTime:")
        view.addGestureRecognizer(panRec)

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"stop" , name:"com.borusoft.gametimer.sleep", object: nil)
        
        
        targetTime = NSUserDefaults.standardUserDefaults().doubleForKey("targetTime")
        if targetTime==0
        {
            targetTime = 10.0
        }
        
        
        mainButton.setStatus("Ready")
        mainButton.setHint("Tap to start or pinch to adjust time")

        mainButton.setTime(timeToString(targetTime) )
        restartButton.setString(timeToString(targetTime ) )
        defaultMainColour = mainButton.backgroundColor
        
        
        muted = NSUserDefaults.standardUserDefaults().boolForKey("muted")
        muteButton.setMuted(muted);
        
        #if DEBUG
            println (__FUNCTION__ + " muted=\(muted)")
        #endif
    }


    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func didReceiveMemoryWarning()
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func start(timeLeft:Double)
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        let aSelector : Selector = "update"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.10, target: self, selector: aSelector, userInfo: nil, repeats: true)
        
        stopTime = NSDate.timeIntervalSinceReferenceDate() + timeLeft

        
        mainButton.backgroundColor = UIColor.greenColor();
        
        announce("go");
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func restart()
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        // Clear any current timer
        if timer.valid
        {
            timer.invalidate()
        }
        
        
        // Remove and re-add any announcements

        
        announcements.removeAll(keepCapacity: false)

        
        if targetTime>=300.0
        {
            announcements[300.0] = "five minutes";
        }
        
        if targetTime>=240.0
        {
            announcements[240.0] = "four minutes";
        }

        if targetTime>=180.0
        {
            announcements[180.0] = "three minutes";
        }

        if targetTime>=120.0
        {
            announcements[120.0] = "two minutes";
        }

        if targetTime>=60.0
        {
            announcements[60.0] = "one minute";
        }
        
        if targetTime>=30.0
        {
            announcements[30.0] = "thirty seconds";
        }

        if targetTime>=20.0
        {
            announcements[20.0] = "twenty seconds";
        }

        if targetTime>=10.0
        {
            announcements[10.0] = "ten seconds";
        }
    
        if targetTime >= 5.0
        {
            announcements[5.0] = "five"
        }
        
        if targetTime >= 4.0
        {
            announcements[4.0] = "four"
        }
        
        if targetTime >= 3.0
        {
            announcements[3.0] = "three"
        }
        
        if targetTime >= 2.0
        {
            announcements[2.0] = "two"
        }
        
        if targetTime >= 1.0
        {
            announcements[1.0] = "one"
        }
        
        announcements[0.0] = "Time's Up"
        
        
        start(targetTime);

        
        // Flash the main and restart buttons to give some feedback
        #if DEBUG
            println("flashing")
        #endif
        
        let origColourMain = self.mainButton.backgroundColor
        self.mainButton.backgroundColor = UIColor.brownColor()
        
        let origColourRestart = self.restartButton.backgroundColor
        let orifColourSettings = self.settingsArea.backgroundColor
        
        self.restartButton.backgroundColor = UIColor.brownColor()
        self.settingsArea.backgroundColor = UIColor.brownColor()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(),
        {
            #if DEBUG
                println("flashed")
            #endif
            self.mainButton.backgroundColor = origColourMain
            self.restartButton.backgroundColor = origColourRestart
            self.settingsArea.backgroundColor = orifColourSettings
        })
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func resume()
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        start(timeRemaining)
        timeRemaining = -1 // No longer using this so ensure it's zero
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func pause()
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        timeRemaining = stopTime - NSDate.timeIntervalSinceReferenceDate()
        stop()
        
        if timeRemaining < 0
        {
            timeRemaining = 0;
        }
        
        mainButton.setStatus("Paused")
        mainButton.setHint("Tap to resume or pinch to adjust time")
        mainButton.setTime(self.timeToString(timeRemaining+1) )
        
        announce("paused");
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func stop()
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate)
        timer.invalidate()
        mainButton.backgroundColor = defaultMainColour
        
        
        mainButton.setStatus("Ready")
        mainButton.setDisplayHMS(false)
        mainButton.setTime(timeToString(targetTime) )
        mainButton.setHint("Tap to start or pinch to adjust time")

    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func announce(announcementString:String)
    {
        #if DEBUG
            println (__FUNCTION__ + "  announcementString=" + announcementString)
        #endif
        
        
        //for voice in AVSpeechSynthesisVoice.speechVoices()
        //{
        //    println("  voice=\(voice)")
        //}
        
        
        if (!muted)
        {
            self.synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate);
            
            let outOfTime = AVSpeechUtterance(string:announcementString)
            outOfTime.pitchMultiplier = 1
            outOfTime.postUtteranceDelay = 0.0
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))
            {
                self.synth.pauseSpeakingAtBoundary(AVSpeechBoundary.Word)
                self.synth.speakUtterance(outOfTime)
            }
        }
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func doAnnouncements()
    {
        var timeLeft = stopTime -  NSDate.timeIntervalSinceReferenceDate()
        
        var timesToAnnounce = [Double]()
        
        
        for (announcementTime, announcementString) in announcements
        {
            //println("\(announcementTime): \(announcementString)")
            
            if (timeLeft<announcementTime)
            {
                #if DEBUG
                    println(__FUNCTION__ + " adding \(announcementTime)")
                #endif
                timesToAnnounce.append(announcementTime)
            }
        }
        
        
        if timesToAnnounce.count > 0
        {
            #if DEBUG
                println(__FUNCTION__ + "timesToAnnounce=" + timesToAnnounce.description)
            #endif
        }
        
        
        for announcementTime in timesToAnnounce
        {
            if let thisOne = announcements[announcementTime]
            {
                announce(thisOne);
                announcements.removeValueForKey(announcementTime);
            }
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func timeToString(time:Double) -> String
    {
        assert(time>=0);
        
        let minutes = UInt8(time / 60.0)
        let seconds = UInt8(time % 60.0)
        //let tenths  = UInt8((time % 1) * 10)
        //let result = String.localizedStringWithFormat("%02d:%02d.%1d", minutes, seconds, tenths)
        let result = String.localizedStringWithFormat(" %02d:%02d ", minutes, seconds)
        //println("result = \(result)")
        return result
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func update()
    {
        var timeLeft = stopTime -  NSDate.timeIntervalSinceReferenceDate()
        
        if (timeLeft>0)
        {
            mainButton.setStatus("Running")
            mainButton.setHint("Tap to pause")
            mainButton.setTime(self.timeToString(timeLeft+1) )
            doAnnouncements();
        }
        else
        {
            timeLeft = 0 // prevent -ve time left
            
            doAnnouncements()
            stop()
            
            mainButton.setTime("Time's up")
            mainButton.setHint("Tap to start or pinch to adjust time")
            mainButton.backgroundColor = UIColor.redColor()
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func pauseTapped(sender: UIButton)
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        
        if !timer.valid
        {
            if timeRemaining > 0
            {
                resume()
            }
            else
            {
                restart()
            }
        }
        else
        {
            pause()
        }

    
        //let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        //tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        //self.presentViewController(tapAlert, animated: true, completion: nil)
        
        
        //self.timerLabel.text = "clicked!"
        
        
        //update()
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func roundTargetTime(time:Double) -> Double
    {
        if (time<1)
        {
            return 1.0
        }
        else if (time<11)
        {
            return Double(Int(time))
        }
        else if (time < 60)
        {
            return Double(Int(time/5)*5)
        }
        else if (time<300)
        {
            return Double(Int(time/30)*30)
        }
        else
        {
            return Double(Int(time/60)*60)
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Calculate the new time for the pan - exponential - following the granularity we limit it to
    func adjustTimeForPan(targetTime:Double, pixelsMoved:Double) ->Double
    {
        let moves = Int(pixelsMoved / 20);
        var newTargetTime = targetTime;


        if (moves>0)
        {
            for _ in 1...moves
            {
                if (newTargetTime<11)
                {
                    newTargetTime = newTargetTime + 1
                }
                else if (newTargetTime < 60)
                {
                    newTargetTime = newTargetTime + 5
                }
                else if (newTargetTime < 300)
                {
                    newTargetTime = newTargetTime + 30
                }
                else
                {
                    newTargetTime = newTargetTime + 60
                }
            }
        }
        else if moves<0
        {
            for _ in moves...0
            {
                if (newTargetTime<11)
                {
                    newTargetTime = newTargetTime - 1
                }
                else if (newTargetTime < 60)
                {
                    newTargetTime = newTargetTime - 5
                }
                else if (newTargetTime < 300)
                {
                    newTargetTime = newTargetTime - 30
                }
                else
                {
                    newTargetTime = newTargetTime - 60
                }
            }
            
            if newTargetTime < 1
            {
                newTargetTime = 1
            }
        }
        
          return newTargetTime
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func pinchTime(sender: UIButton)
    {
        if timer.valid
        {
            // Counting down so ignore this
            return
        }
        else
        {
            timeRemaining = 0.0 // In case we're paused
        }
        
        #if DEBUG
            switch pinchRec.state
            {
                case UIGestureRecognizerState.Possible:  println (__FUNCTION__ + "Possible  scale=\(pinchRec.scale)" )
                case UIGestureRecognizerState.Began:     println (__FUNCTION__ + "Began     scale=\(pinchRec.scale)" )
                case UIGestureRecognizerState.Changed:   println (__FUNCTION__ + "Changed   scale=\(pinchRec.scale)" )
                case UIGestureRecognizerState.Ended:     println (__FUNCTION__ + "Ended     scale=\(pinchRec.scale)" )
                case UIGestureRecognizerState.Cancelled: println (__FUNCTION__ + "Cancelled scale=\(pinchRec.scale)" )
                case UIGestureRecognizerState.Failed:    println (__FUNCTION__ + "Failed    scale=\(pinchRec.scale)" )
                default: assert(false); println (__FUNCTION__ + "???? scale=\(pinchRec.scale)" )
            }
        #endif
        
        
        if pinchRec.state==UIGestureRecognizerState.Changed
        {
            var targetTimeNew = roundTargetTime(targetTime * Double(pinchRec.scale))
            //mainButton.setStatus("New Time")
            mainButton.setDisplayHMS(true)
            mainButton.setHint("")
            mainButton.setTime(timeToString(targetTimeNew) )
            restartButton.setString(timeToString(targetTimeNew) )
        }
        else  if pinchRec.state==UIGestureRecognizerState.Ended
        {
            targetTime = roundTargetTime(targetTime * Double(pinchRec.scale))
            mainButton.setStatus("Ready")
            mainButton.setDisplayHMS(false)
            mainButton.setHint("Tap to start or pinch to adjust time")
            mainButton.setTime(timeToString(targetTime) )
            restartButton.setString(String.localizedStringWithFormat("%@", timeToString(targetTime) ) );

            
            NSUserDefaults.standardUserDefaults().setDouble(targetTime, forKey: "targetTime")
            #if DEBUG
                println("targetTime=\(targetTime)")
            #endif
        }
        
        mainButton.backgroundColor = defaultMainColour
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    func panTime(sender: UIButton)
    {
        if timer.valid
        {
            // Counting down so ignore this
            return
        }
        else
        {
            timeRemaining = 0.0 // In case we're paused
        }
        
        #if DEBUG
            switch panRec.state
            {
            case UIGestureRecognizerState.Possible:  println (__FUNCTION__ + "Possible  translationInView=\(panRec.translationInView)" )
            case UIGestureRecognizerState.Began:     println (__FUNCTION__ + "Began     translationInView=\(panRec.translationInView)" )
            case UIGestureRecognizerState.Changed:   println (__FUNCTION__ + "Changed   translationInView=\(panRec.translationInView)" )
            case UIGestureRecognizerState.Ended:     println (__FUNCTION__ + "Ended     translationInView=\(panRec.translationInView)" )
            case UIGestureRecognizerState.Cancelled: println (__FUNCTION__ + "Cancelled translationInView=\(panRec.translationInView)" )
            case UIGestureRecognizerState.Failed:    println (__FUNCTION__ + "Failed    translationInView=\(panRec.translationInView)" )
            default: assert(false); println (__FUNCTION__ + "???? translationInView=\(panRec.translationInView)" )
            }
        #endif

        
        if panRec.state==UIGestureRecognizerState.Began
        {
            initialPanPos = panRec.translationInView(view)
        }
        else if panRec.state==UIGestureRecognizerState.Changed || panRec.state==UIGestureRecognizerState.Ended
        {
            let newPanPos = panRec.translationInView(view)
            
            if let initialPanPosActual = initialPanPos
            {
                var pixelsMoved = Double(initialPanPosActual.y - newPanPos.y)
                // TODO - this needs to be exponential - follwing the granularity we limit it to
                let targetTimeAdjustForPan = adjustTimeForPan(targetTime, pixelsMoved:pixelsMoved)
                
                var targetTimeNew = roundTargetTime(targetTimeAdjustForPan)
                //mainButton.setStatus("New Time")
                mainButton.setDisplayHMS(true)
                mainButton.setHint("")
                mainButton.setTime(timeToString(targetTimeNew) )
                restartButton.setString(timeToString(targetTimeNew) )
                
                
                //("\(pixelsMoved)" as NSString).drawAtPoint(mainButton.bounds.origin, withAttributes: nil)
                //mainButton.setHint("pixelsMoved=\(pixelsMoved)")

            
                if panRec.state==UIGestureRecognizerState.Ended
                {
                    targetTime = targetTimeNew
                    
                    mainButton.setStatus("Ready")
                    mainButton.setDisplayHMS(false)
                    mainButton.setHint("Tap to start or pinch to adjust time")
                    
                    NSUserDefaults.standardUserDefaults().setDouble(targetTime, forKey: "targetTime")
                    #if DEBUG
                        println("targetTime=\(targetTime)")
                    #endif
                }
            }
            else
            {
                assert(false) // No initialPanPos
            }
        }
        
        mainButton.backgroundColor = defaultMainColour
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func restartClicked(sender: UIButton)
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        restart();
    }

    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func muteClicked(sender: UIButton)
    {
        #if DEBUG
            println (__FUNCTION__)
        #endif
        
        muted = !muted;
        
        if (muted)
        {
            self.synth.stopSpeakingAtBoundary(AVSpeechBoundary.Immediate);
        }
        
        #if DEBUG
            println (__FUNCTION__ + " muted=\(muted)")
        #endif
        
        muteButton.setMuted(muted);
        NSUserDefaults.standardUserDefaults().setBool(muted, forKey: "muted")
    }
    
}