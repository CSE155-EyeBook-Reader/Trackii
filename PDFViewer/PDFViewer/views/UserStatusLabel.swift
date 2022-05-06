//
//  UserStatusLabel.swift
//  SeeSoSample
//
//  Created by david on 2021/05/25.
//  Copyright © 2021 VisaulCamp. All rights reserved.
//

import UIKit
import SeeSo

class UserStatusLabel : UIView {
  let attensionLabel : UILabel = UILabel()
  let blinkLabel : UILabel = UILabel()
  let drowsinessLabel : UILabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  func aticveSubView(){
    initLabels()
    attensionLabel.text = "attension : None"
    blinkLabel.text = "blink : None"
    drowsinessLabel.text = "drowsiness : None"
  }


  func initLabels(){
    self.addSubview(attensionLabel)
    self.addSubview(blinkLabel)
    self.addSubview(drowsinessLabel)
    attensionLabel.translatesAutoresizingMaskIntoConstraints = false
    let attentionConstraints : [NSLayoutConstraint] =  [attensionLabel.widthAnchor.constraint(equalTo: self.widthAnchor), attensionLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33), attensionLabel.topAnchor.constraint(equalTo: self.topAnchor), attensionLabel.leftAnchor.constraint(equalTo: self.leftAnchor)]

    blinkLabel.translatesAutoresizingMaskIntoConstraints = false
    let blinkConstraints : [NSLayoutConstraint] =  [blinkLabel.widthAnchor.constraint(equalTo: self.widthAnchor), blinkLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33), blinkLabel.topAnchor.constraint(equalTo: self.attensionLabel.bottomAnchor), blinkLabel.leftAnchor.constraint(equalTo: self.leftAnchor)]

    drowsinessLabel.translatesAutoresizingMaskIntoConstraints = false
    let drowsinessConstraints : [NSLayoutConstraint] =  [drowsinessLabel.widthAnchor.constraint(equalTo: self.widthAnchor), drowsinessLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.33), drowsinessLabel.topAnchor.constraint(equalTo: self.blinkLabel.bottomAnchor), drowsinessLabel.leftAnchor.constraint(equalTo: self.leftAnchor)]
    for subConstraints in [attentionConstraints, blinkConstraints, drowsinessConstraints]{
      for constraint in subConstraints {
        constraint.isActive = true
      }
    }
  }

  func setLableText(attensionText : String? = nil, blinkText : String? = nil, drowsinessText : String? = nil) {
    if let attension = attensionText {
      DispatchQueue.main.async {
        self.attensionLabel.text = "attension : \(attension)"
      }
    }

    if let blink = blinkText {
      DispatchQueue.main.async {
        self.blinkLabel.text = "blink : \(blink)"
      }

    }

    if let drowsiness = drowsinessText {
      DispatchQueue.main.async {
        self.drowsinessLabel.text = "drowsiness : \(drowsiness)"
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension UserStatusLabel : UserStatusDelegate {
  func onAttension(timestampBegin: Int, timestampEnd: Int, score: Double) {
    self.setLableText(attensionText: String(Double(round(1000 * score)/1000)))
    print("\(#function) \(timestampBegin) ~ \(timestampEnd) : \(score)")
  }

}
