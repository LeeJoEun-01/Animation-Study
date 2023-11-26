//
//  ThridViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/22.
//

import UIKit

class CoreAnimationViewController: UIViewController {

    override func loadView() {
        super.loadView()
        let view = CoreAnimationView(frame: UIScreen.main.bounds)
        view.setAnimateBackGround()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }
}

class CoreAnimationView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        override func draw(_ rect: CGRect) {
            self.backgroundColor = .white
        }

    func setAnimateBackGround() {
        let animation = CABasicAnimation(keyPath: "backgroundColor")
        animation.duration = 4
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = UIColor.blue.cgColor
        animation.isRemovedOnCompletion = false
        self.layer.add(animation, forKey: "backgroundAni")
    }
}
