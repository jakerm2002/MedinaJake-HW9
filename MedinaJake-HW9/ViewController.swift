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

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.view.frame.height - self.view.safeAreaInsets.top)
        
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
            boxX = boxWidth * 4
            boxY = boxHeight * 10
            greenView.frame.origin.x = boxX
            greenView.frame.origin.y = boxY
        }
    }
    
    func moveBlock(direction: Int) {
//        while blockIsMoving {
            sleep(1)
            switch direction {
            case 0: //up
                boxY = boxY - boxHeight
                greenView.frame.origin.y = boxY
                break
            case 1: //down
                boxY = boxY + boxHeight
                greenView.frame.origin.y = boxY
                break
            case 2: //left
                break
            case 3: //right
                break
            default:
                break
            }
//        }
    }
    
    @IBAction func recognizeTapGesture(recognizer: UITapGestureRecognizer) {
        // tapping only works when the block is not moving.
        centerView()
        
        // move downward every 0.3 seconds
        
    }
    
    @IBAction func handleSwipeRight(recognizer: UISwipeGestureRecognizer) {
        print("swipe right")
        moveBlock(direction: 3)
    }
    
    @IBAction func handleSwipeLeft(recognizer: UISwipeGestureRecognizer) {
        print("swipe left")
        moveBlock(direction: 2)
    }
    
    @IBAction func handleSwipeUp(recognizer: UISwipeGestureRecognizer) {
        print("swipe up")
        moveBlock(direction: 0)
    }
    
    @IBAction func handleSwipeDown(recognizer: UISwipeGestureRecognizer) {
        print("swipe down")
        moveBlock(direction: 1)
    }
    
    
    


}

