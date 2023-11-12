//
//  ViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/08.
//

import UIKit

class ViewController: UIViewController {

    let testView : UIView = {
        let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        view.backgroundColor = .systemPink
        return view
    }()

    let testButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 150, y: 400, width: 200, height: 50))
        button.setTitle("짠!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.titleLabel?.textColor = .brown
        button.layer.backgroundColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(didMoveTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        transition()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        didMoveTap()
//    }

    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(testView)
        view.addSubview(testButton)
    }

    private func transition() {
        UIView.transition(with: testView, duration: 2.0, options: .transitionFlipFromTop, animations: nil)
    }

    @objc
    private func didMoveTap() {
        // 크기가 커지게
        UIView.animate(withDuration: 2.0) { [self] in
            testView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }

        // 제자리에서 돌기
        UIView.animate(withDuration: 2.0) { [self] in
            testView.transform = CGAffineTransform(rotationAngle: .pi)
        }

        // 대각선으로 내려가기
        UIView.animate(withDuration: 2.0) { [self] in
            testView.transform = CGAffineTransform(translationX: 200, y: 200)
        }

        // => 다 합치면 크게 돌면서 ... 암튼 신기

        // MARK:- Animate Combine

        // MARK:- Animate 순차처리 -1
    }
}
