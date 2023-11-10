//
//  ViewController.swift
//  MedinaJake-HW9
//
//  Created by Jake Medina on 11/9/23.
//

import UIKit

class ViewController: UIViewController {
    
//    let boxWidth = self.view.bounds.width / 9
//    let boxHeight = self.view.bounds.height / 19
//    let boxX = 0.0
//    let boxY = 0.0
//    var greenView = UIView(frame: CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight))
    var screenWidth = 0.0
    var screenHeight = 0.0
    var boxWidth = 0.0
    var boxHeight = 0.0
    var screenOriginX = 0.0
    var screenOriginY = 0.0
    
    var boxX = 0.0
    var boxY = 0.0
    
    var blockIsMoving: Bool = false
    
    var greenView = UIView()
    
    var queue: DispatchQueue!
    
    var movementDirection: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.height - self.view.safeAreaInsets.top)
    
        queue = DispatchQueue(label: "blockMoverQueue", qos: .userInteractive)
        
        let window = UIApplication.shared.windows.first
        let topPadding = (window?.safeAreaInsets.top)!
        let bottomPadding = (window?.safeAreaInsets.bottom)!
        
        screenOriginX = 0.0
        screenOriginY = topPadding
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height - topPadding - bottomPadding
        
        boxWidth = screenWidth / 9
        boxHeight = screenHeight / 19
        
        
//        var bottomView = UIView(frame: CGRect(x: 0, y: screenOriginY+screenHeight-boxHeight, width: screenWidth, height: boxHeight))
//        bottomView.backgroundColor = .red
//        view.addSubview(bottomView)
        
        setupView()
        
        centerView()
    }
    
    // initializes green box and puts it in top left
    private func setupView() {
        
        boxX = screenOriginX
        boxY = screenOriginY
        
        greenView = UIView(frame: CGRect(x: boxX, y: boxY, width: boxWidth, height: boxHeight))
        greenView.backgroundColor = .green
        
        self.view.addSubview(greenView)
    }
    
    // puts the box in the center of the screen
    private func centerView() {
        // center column is the 5th column
        // center row is the 10th column
        if !blockIsMoving {
            greenView.backgroundColor = .green
            boxX = screenOriginX + boxWidth * 4
            boxY = screenOriginY + boxHeight * 9
            greenView.frame.origin.x = boxX
            greenView.frame.origin.y = boxY
        }
    }
    
    func isWithinOneOf(_ num1: Double, _ num2: Double) -> Bool {
        let difference = abs(num1 - num2)
            return difference <= 1.0
    }
    
    func blockIsTouchingEdge() -> Bool {
        
//        if greenView.frame.origin.x == screenOriginX ||
//            greenView.frame.origin.x == screenWidth - boxWidth ||
//            greenView.frame.origin.y == screenOriginY ||
//            greenView.frame.origin.y == screenOriginY + screenHeight - boxHeight
        print("boxY \(boxY)")
        print("calculation \(screenOriginY+screenHeight-boxHeight)")
        if isWithinOneOf(boxX, screenOriginX) ||
            isWithinOneOf(boxX, screenWidth - boxWidth) ||
            isWithinOneOf(boxY, screenOriginY) ||
            isWithinOneOf(boxY, screenOriginY + screenHeight - boxHeight)
        {
            print("blockIsTouchingEdge true")
            return true
        }
        
//        if greenView.frame.origin.x == screenOriginX {
//            return true
//        }
//        
//        if greenView.frame.origin.x == screenWidth - boxWidth {
//            return true
//        }
//        
//        if greenView.frame.origin.y == screenOriginY {
//            return true
//        }
//        
//        if greenView.frame.origin.y == screenOriginY + screenHeight - boxHeight {
//            return true
//        }
        
        greenView.backgroundColor = .green
        print("blockIsTouchingEdge false")
        return false
    }
    
    func moveBlock(direction: Int) {
        while !blockIsTouchingEdge() && direction == movementDirection {
            self.blockIsMoving = true
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
            DispatchQueue.main.async {
                self.greenView.frame.origin.x = self.boxX
                self.greenView.frame.origin.y = self.boxY
            }
            if blockIsTouchingEdge() {
                DispatchQueue.main.async {
                    self.greenView.backgroundColor = .red
                    self.blockIsMoving = false
                }
            }
            usleep(300000)
        }
    }
    
    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer) {
        // tapping only works when the block is not moving.
        centerView()
        
        // move downward every 0.3 seconds
        
    }
    
    @IBAction func handleSwipeRight(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 3
        queue.async {
            print("swipe right")
            self.moveBlock(direction: 3)
        }
    }
    
    @IBAction func handleSwipeLeft(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 2
        queue.async {
            print("swipe left")
            self.moveBlock(direction: 2)
        }
    }
    
    @IBAction func handleSwipeUp(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 0
        queue.async {
            print("swipe up")
            self.moveBlock(direction: 0)
        }
    }
    
    @IBAction func handleSwipeDown(recognizer: UISwipeGestureRecognizer) {
        movementDirection = 1
        queue.async {
            print("swipe down")
            self.moveBlock(direction: 1)
        }
    }
    
    
    


}

