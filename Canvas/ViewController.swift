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
    @IBOutlet weak var trayArrowView: UIImageView!
    
    // Keept the tray origin
    var trayCenterWhenOpen: CGPoint!
    var trayCenterWhenClosed: CGPoint!
    
    // Keep the new face
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        
        // Absolute (x,y) coordinates in parent view (parentView should be
        // the parent view of the tray)
        let velocity = sender.velocity(in: parentView)
        
        if sender.state == .changed {
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
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: 2)
            
            // The didPan: method will be defined in Step 3 below.
            // let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onNewImagePanGesture(sender:)))
            
            // The didPan: method will be defined in Step 3 below.
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onNewImagePinchGesture(sender:)))
            let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(onNewImageRotateGesture(sender:)))
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onNewImageTapGesture(sender:)))
            
            // Make sure we double tap
            tapGestureRecognizer.numberOfTapsRequired = 2
            
            // Delegate the use of the gesture recognizer
            pinchGestureRecognizer.delegate = self
            rotateGestureRecognizer.delegate = self
            tapGestureRecognizer.delegate = self
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(rotateGestureRecognizer)
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
         
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
            self.trayArrowView.transform = CGAffineTransform(rotationAngle: CGFloat(0))

        })
    }
    
    func hideTray(velocity: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, animations: {
            self.trayView.center = self.trayCenterWhenClosed
            self.trayArrowView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
        })
    }
    
    func onNewImagePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            sender.view?.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            print("Gesture is changing")
        } else if sender.state == .ended {
            sender.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func onNewImagePinchGesture(sender: UIPinchGestureRecognizer) {
        let scale = sender.scale
        sender.scale = 1
        sender.view!.transform = sender.view!.transform.scaledBy(x: scale, y: scale)
    }
    
    func onNewImageRotateGesture(sender: UIRotationGestureRecognizer) {
        sender.view!.transform = sender.view!.transform.rotated(by: sender.rotation)
        sender.rotation = 0
    }
    
    func onNewImageTapGesture(sender: UIRotationGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let trayDownOffset = CGFloat(200)
        trayCenterWhenOpen = trayView.center
        trayCenterWhenClosed = CGPoint(x: trayCenterWhenOpen.x, y: trayCenterWhenOpen.y + trayDownOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

