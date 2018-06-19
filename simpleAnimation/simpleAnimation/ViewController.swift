//
//  ViewController.swift
//  simpleAnimation
//
//  Created by JeremyXue on 2018/6/14.
//  Copyright © 2018年 JeremyXue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var imageArray = [String]()
    
    var current = 0
    var end = 0
    var time = 0.0
    var finalNumber = 0
    
    @IBOutlet weak var maskView: UIView!
    
    @IBOutlet weak var playButton: UIButton! {
        didSet {
            playButton.layer.cornerRadius = playButton.frame.height / 2
            playButton.clipsToBounds = true
            playButton.layer.borderColor = UIColor.black.cgColor
            playButton.layer.borderWidth = 5
        }
    }
    @IBAction func play(_ sender: Any) {
        
        current = 0
        end = 100
        time = 0.0001
        finalNumber = 0
        randomImage(addView: maskView!)
        
        maskView?.layer.borderColor = UIColor.black.cgColor
        self.playButton.setTitle("Randoming", for: UIControlState.normal)
        self.playButton.backgroundColor = UIColor.red
        playButton.isEnabled = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for i in 1...11 {
            imageArray.append("月月\(i)")
        }
        self.playButton.backgroundColor = UIColor.green
        self.playButton.setTitle("Start!", for: UIControlState.normal)
        
        maskView.clipsToBounds = true
        maskView.backgroundColor = UIColor.black
        maskView.layer.borderWidth = 5
        maskView.layer.borderColor = UIColor.black.cgColor
        
        let backImage = UIImageView()
        backImage.image = UIImage(named: "抽獎")
        backImage.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        
        maskView?.addSubview(backImage)
        view.addSubview(maskView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createRandomImage(createQuantity:Int,endNumber:Int,addView:UIView) {
        let imageView = UIImageView()
        let randomNumber = Int(arc4random() % UInt32(imageArray.count - 1)) + 1
        imageView.image = UIImage(named: imageArray[randomNumber])
        imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.borderWidth = 5
        imageView.clipsToBounds = true
        finalNumber = randomNumber
        addView.addSubview(imageView)
        imageAnimation(imageView: imageView)
    }
    
    func imageAnimation(imageView:UIImageView) {
        imageView.center.x += imageView.frame.width
        UIView.animate(withDuration: time, animations: {
            imageView.center.x -= imageView.frame.width
        }) { (finish) in
            if self.current != self.end {
                UIView.animate(withDuration: self.time, animations: {
                    imageView.center.x -= imageView.frame.width
                }, completion: { (finish) in
                    imageView.removeFromSuperview()
                })
            } else {
                let effectView = UIView()
                
                effectView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
                effectView.backgroundColor = UIColor.white
                effectView.alpha = 0
                
                imageView.addSubview(effectView)
                
                UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
                    effectView.alpha = 1
                    self.maskView.layer.borderColor = UIColor.green.cgColor
                    self.maskView.layer.borderWidth = 5
                }, completion: { (finish) in
                    effectView.alpha = 0
                    effectView.removeFromSuperview()
                })
                
            }
        }
    }
    
    
    @objc func randomImage(addView:UIView) {
        Timer.scheduledTimer(withTimeInterval: time, repeats: false) { (timer) in
            self.current += 1
            self.time = self.time * 1.1
            
            if self.current == self.end {
                timer.invalidate()
                self.playButton.isEnabled = true
                self.playButton.backgroundColor = UIColor.green
                self.playButton.setTitle("Start!", for: UIControlState.normal)
                self.showCardInfo()
            } else {
                self.createRandomImage(createQuantity: self.current, endNumber: self.end, addView: addView)
                self.randomImage(addView: addView)
            }
        }
    }
    
    func showCardInfo() {
        
        let resultLabel = UILabel()
        resultLabel.frame = CGRect(x: 0, y: 0, width: 300, height: 40)
        resultLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y - 150)
        resultLabel.textColor = UIColor.white
        resultLabel.backgroundColor = UIColor.black
        resultLabel.alpha = 0
        resultLabel.text = "得到月月(\(self.finalNumber + 1))的照片"
        resultLabel.textAlignment = NSTextAlignment.center
        self.view.addSubview(resultLabel)
        
        UIView.animate(withDuration: 2, animations: {
            resultLabel.center.y -= 50
            resultLabel.alpha = 1
        }) { (finish) in
            UIView.animate(withDuration: 1, animations: {
                resultLabel.alpha = 0
            }, completion: { (finish) in
                resultLabel.removeFromSuperview()
            })
        }
    }
    
}

