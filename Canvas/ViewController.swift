//
//  ViewController.swift
//  Canvas
//
//  Created by Claudiu Andrei on 11/4/16.
//  Copyright © 2016 Claudiu Andrei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    @IBOutlet var parentView: UIView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    // Keept the tray origin
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    // Keep the new face
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let velocity = panGestureRecognizer.velocity(in: parentView)
        
        if panGestureRecognizer.state == .changed {
            let springVelocity = velocity.y / trayView.frame.height * 2
            if velocity.y < 0 {
                showTray(velocity: springVelocity)
            } else if velocity.y > 0 {
                hideTray(velocity: springVelocity)
            }
        }
    }
    
    @IBAction func onTrayTapGesture(_ sender: UITapGestureRecognizer) {
        let springVelocity = CGFloat(0.5)
        if trayView.center == trayCenterWhenClosed {
            showTray(velocity: springVelocity)
        } else if trayView.center == trayCenterWhenOpen {
            hideTray(velocity: springVelocity)
        }
    }
    
    @IBAction func onImagePanGesture(_ sender: UIPanGestureRecognizer) {
      
        // Look for the translation
        let translation = sender.translation(in: parentView)
      
        // Start
        if sender.state == .began {
            // Gesture recognizers know the view they are attached to
            let imageView = sender.view as! UIImageView
         
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
         
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
         
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
         
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
         
            // Load the point from the parent
            let point = sender.location(in: parentView)
         
            // Create the origin point
            newlyCreatedFaceOriginalCenter = point
         
        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(
               x: newlyCreatedFaceOriginalCenter.x + translation.x,
               y: newlyCreatedFaceOriginalCenter.y + translation.y
            )
        }
    }
    
    func showTray(velocity: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, animations: {
             self.trayView.center = self.trayCenterWhenOpen
        })
    }
    
    func hideTray(velocity: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, animations: {
            self.trayView.center = self.trayCenterWhenClosed
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trayCenterWhenOpen = CGPoint(x: 187.5, y: 542.0)
        trayCenterWhenClosed = CGPoint(x: 187.5, y: 742.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

