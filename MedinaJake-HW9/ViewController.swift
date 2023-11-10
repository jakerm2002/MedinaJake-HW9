//
//  ViewController.swift
//  MedinaJake-HW9
//
//  Created by Jake Medina on 11/9/23.
//

import UIKit

class ViewController: UIViewController {
    
    var screenWidth = 0.0
    var screenHeight = 0.0
    
    var boxWidth = 0.0
    var boxHeight = 0.0
    
    var screenOriginX = 0.0
    var screenOriginY = 0.0
    
    var boxX = 0.0
    var boxY = 0.0
    
    // what direction the block SHOULD be moving
    // after a swipe. used to discard moveBlock calls for
    // a direction the block should no longer be going
    var movementDirection: Int = 1
    
    var greenView = UIView()
    var queue: DispatchQueue!
    var blockIsMoving: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = DispatchQueue(label: "blockMoverQueue", qos: .userInteractive)
        
        // determine top and bottom safe area heights
        let window = UIApplication.shared.windows.first
        let topPadding = (window?.safeAreaInsets.top)!
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        
        screenOriginX = 0.0
        screenOriginY = topPadding
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height - topPadding - bottomPadding
        
        boxWidth = screenWidth / 9
        boxHeight = screenHeight / 19
        
        setupView()
        centerView()
    }
    
    // sets variables for green box and coordinates, and puts it in top left
    func setupView() {
        boxX = screenOriginX
        boxY = screenOriginY
        greenView = UIView(frame: CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight))
        greenView.backgroundColor = .green
        self.view.addSubview(greenView)
    }
    
    // puts the box in the center of the screen
    func centerView() {
        greenView.backgroundColor = .green
        boxX = screenOriginX + boxWidth * 4  // center column is the 5th column
        boxY = screenOriginY + boxHeight * 9 // center row is the 10th column
        greenView.frame.origin.x = boxX
        greenView.frame.origin.y = boxY
    }
    
    // to account for small differences between floating point coordinates
    func isWithinOneOf(_ num1: Double, _ num2: Double) -> Bool {
        let difference = abs(num1 - num2)
            return difference <= 1.0
    }
    
    func blockIsTouchingEdge() -> Bool {
        if isWithinOneOf(boxX, screenOriginX) ||
            isWithinOneOf(boxX, screenWidth - boxWidth) ||
            isWithinOneOf(boxY, screenOriginY) ||
            isWithinOneOf(boxY, screenOriginY + screenHeight - boxHeight)
        {
            return true
        }
        
        greenView.backgroundColor = .green
        return false
    }
    
    func moveBlock(direction: Int) {
        // check global movementDirection to ensure that calls to moveBlock
        // for an outdated direction will be cancelled
        while !blockIsTouchingEdge() && direction == movementDirection {
            self.blockIsMoving = true
            
            // calculate new coordinates
            switch direction {
                case 0: //up
                    boxY = boxY - boxHeight
                case 1: //down
                    boxY = boxY + boxHeight
                case 2: //left
                    boxX = boxX - boxWidth
                case 3: //right
                    boxX = boxX + boxWidth
                default:
                    break
            }
            
            // move the box
            DispatchQueue.main.async {
                self.greenView.frame.origin.x = self.boxX
                self.greenView.frame.origin.y = self.boxY
            }
            
            // set box color to red and allow user to tap to recenter
            if blockIsTouchingEdge() {
                DispatchQueue.main.async {
                    self.greenView.backgroundColor = .red
                    self.blockIsMoving = false
                }
            }
            
            usleep(300000) // tick
        }
    }
    
    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer) {
        if !blockIsMoving {
            let moveImmediately = !blockIsTouchingEdge()
            blockIsMoving = false
            centerView()
            movementDirection = 1
            
            // if the block is at the edge, when it recenters
            // allow it to stay at the centered position
            // for a little before moving
            if moveImmediately {
                queue.async {
                    print("tap gesture")
                    self.moveBlock(direction: 1)
                }
            } else {
                queue.async {
                    print("tap gesture")
                    usleep(300000)
                    self.moveBlock(direction: 1)
                }
            }
        }
    }
    
    @IBAction func handleSwipeRight(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 3
        queue.async {
            self.moveBlock(direction: 3)
        }
    }
    
    @IBAction func handleSwipeLeft(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 2
        queue.async {
            self.moveBlock(direction: 2)
        }
    }
    
    @IBAction func handleSwipeUp(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 0
        queue.async {
            self.moveBlock(direction: 0)
        }
    }
    
    @IBAction func handleSwipeDown(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 1
        queue.async {
            self.moveBlock(direction: 1)
        }
    }

}

