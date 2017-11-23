//
//  ViewController.swift
//  UserMoveButton
//
//  Created by Lawrence F MacFadyen on 2017-11-23.
//  Copyright © 2017 Lawrence F MacFadyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var sliderX: UISlider!
    @IBOutlet weak var sliderY: UISlider!
    @IBOutlet weak var buttonGo: RoundButton!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var buttonYOffset: NSLayoutConstraint!
    @IBOutlet weak var buttonXOffset: NSLayoutConstraint!
    
    //MARK: Constant key values for UserDefaults
    let buttonOffsetKeyX = "offsetX"
    let buttonOffsetKeyY = "offsetY"
    
    //MARK: IBActions
    @IBAction func sliderValueChangedX(_ sender: UISlider) {
        let currentValue = CGFloat(sender.value)
        buttonXOffset.constant = currentValue
    }
    
    @IBAction func sliderValueChangedY(_ sender: UISlider) {
        let currentValue = CGFloat(sender.value)
        buttonYOffset.constant = -currentValue
    }
    
    //MARK: ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sliderX.addTarget(self, action: #selector(onSliderXValChanged(slider:event:)), for: .valueChanged)
        sliderY.addTarget(self, action: #selector(onSliderYValChanged(slider:event:)), for: .valueChanged)
        
        // Let's user long gesture and double tap for the button
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress))
        buttonGo.addGestureRecognizer(longGesture)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.doubleTapped))
        doubleTap.numberOfTapsRequired = 2
        buttonGo.addGestureRecognizer(doubleTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // We want light text for the dark status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        setupSliderY()
        setupSliderX()
    }
    
    //MARK: Gestures and handling
    @objc func doubleTapped() {
        userSaidGo()
    }
    
    @objc func longPress() {
        userSaidGo()
    }
    
    func userSaidGo()
    {
        let alertController = UIAlertController(title: "Go", message: "You said Go!", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction) in }
        
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: Slider setup and handling
    func setupSliderX()
    {
        let viewBounds = viewButton.bounds.width
        let boundsSpace = viewBounds/2
        let buttonRadius = buttonGo.bounds.width/2
        let sliderRange = boundsSpace-buttonRadius
        let sliderMin = -sliderRange
        let sliderMax = sliderRange
        
        sliderX.minimumValue = Float(sliderMin)
        sliderX.maximumValue = Float(sliderMax)
        
        // set value user saved or to 0 for first run
        if let offsetX = UserDefaults.standard.object(forKey: buttonOffsetKeyX) as? CGFloat {
            sliderX.value = Float(offsetX)
            buttonXOffset.constant = offsetX
            
        } else {
            sliderX.value = Float(0.0)
            buttonXOffset.constant = 0.0
        }
        
    }
    
    func setupSliderY()
    {
        let viewBounds = viewButton.bounds.height
        let boundsSpace = viewBounds/2
        let buttonRadius = buttonGo.bounds.height/2
        let sliderRange = boundsSpace-buttonRadius
        let sliderMin = -sliderRange
        let sliderMax = sliderRange
        
        sliderY.minimumValue = Float(sliderMin)
        sliderY.maximumValue = Float(sliderMax)
        
        // set value user saved or to 0 for first run
        if let offsetY = UserDefaults.standard.object(forKey: buttonOffsetKeyY) as? CGFloat {
            sliderY.value = Float(offsetY)
            // make it -offsetY since minus means lower, and we store - value for slider min (= bottom so higher value)
            buttonYOffset.constant = -offsetY
            
        } else {
            sliderY.value = Float(0.0)
            buttonYOffset.constant = 0.0
        }
    }
    
    @objc func onSliderXValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            // handle drag moved
            case .ended:
                let currentValue = CGFloat(slider.value)
                // save value to NSUserDefaults
                UserDefaults.standard.set(currentValue, forKey: buttonOffsetKeyX)
                print("Updated slider value X in Defaults")
            default:
                break
            }
        }
    }
    
    @objc func onSliderYValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            // handle drag moved
            case .ended:
                let currentValue = CGFloat(slider.value)
                // save value to NSUserDefaults
                UserDefaults.standard.set(currentValue, forKey: buttonOffsetKeyY)
                print("Updated slider Y value in Defaults")
            default:
                break
            }
        }
    }
}

