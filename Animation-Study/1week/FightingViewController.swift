//
//  FightingViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/12.
//

import UIKit

import SnapKit

final class FightingViewController: UIViewController {

    // MARK: - 흔들리는 버튼
    let shakeButton1: UIButton = {
        let button = UIButton()
        button.setTitle("shake button 🌱", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 0.799, green: 0.919, blue: 0.726, alpha: 1)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(shakeEaseOut), for: .touchUpInside)

        return button
    }()

    @objc func shakeEaseOut() {
        shakeButton1.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 2,
                       options: [.curveEaseOut]) {
            self.shakeButton1.transform = .identity
        }
    }

    // MARK: - 토스트 버튼
    let toastButton2: UIButton = {
        let button = UIButton()
        button.setTitle("toast button 🍞", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 0.967, green: 0.896, blue: 0.715, alpha: 1)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(showToast), for: .touchUpInside)

        return button
    }()

    @objc func showToast() {
        let toastLabel: UILabel = {
            let label = UILabel(frame: CGRect(x: view.frame.size.width/2 - 150, y: view.frame.size.height-100, width: 300,  height : 42))
            label.text = "토스트 메시지 뽜밤~! 🧸"
            label.textColor = .white
            label.backgroundColor = UIColor(red: 0.606, green: 0.463, blue: 0.272, alpha: 1)
            label.textAlignment = .center
            label.font =  UIFont.systemFont(ofSize: 16)
            label.alpha = 1.0
            label.layer.cornerRadius = 8
            label.clipsToBounds = true

            return label
        }()

        view.addSubview(toastLabel)

        UIView.animate(withDuration: 3.0, animations: {
            toastLabel.alpha = 0.0
        }, completion: {
            (isBool) -> Void in
            self.dismiss (animated: true, completion: nil)
        })
    }

    // MARK: - 동그라미 버튼
    let circleButton3: UIButton = {
        let button = UIButton()
        button.setTitle("💖", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 1, green: 0.842, blue: 0.899, alpha: 1)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 30
        button.addTarget(self, action: #selector(showFlying), for: .touchUpInside)

        return button
    }()

    @objc func showFlying() {
        UIView.animateKeyframes(withDuration: 6.0, delay: 0)  {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/6) { [self] in
                circleButton3.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            }
            UIView.addKeyframe(withRelativeStartTime: 1/6, relativeDuration: 1/6) { [self] in
                circleButton3.transform = CGAffineTransform(rotationAngle: .pi)
            }
            UIView.addKeyframe(withRelativeStartTime: 2/6, relativeDuration: 1/6) { [self] in
                circleButton3.transform = CGAffineTransform(translationX: 200, y: 200)
            }
            UIView.addKeyframe(withRelativeStartTime: 3/6, relativeDuration: 1/6) { [self] in
                circleButton3.transform = CGAffineTransform(translationX: 0, y: 200)
            }
            UIView.addKeyframe(withRelativeStartTime: 4/6, relativeDuration: 1/6) { [self] in
                circleButton3.transform = CGAffineTransform(translationX: -200, y: 0)
            }
            UIView.addKeyframe(withRelativeStartTime: 5/6, relativeDuration: 1/6) { [self] in
                circleButton3.transform = CGAffineTransform(translationX: 0, y: 0)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        self.view.addSubview(shakeButton1)
        self.view.addSubview(toastButton2)
        self.view.addSubview(circleButton3)
    }

    func setConstraints() {
        shakeButton1.snp.makeConstraints {
            $0.top.equalToSuperview().inset(280)
            $0.height.equalTo(62)
            $0.width.equalTo(234)
            $0.centerX.equalToSuperview()
        }
        toastButton2.snp.makeConstraints {
            $0.top.equalTo(shakeButton1.snp.bottom).offset(40)
            $0.height.equalTo(62)
            $0.width.equalTo(234)
            $0.centerX.equalToSuperview()
        }
        circleButton3.snp.makeConstraints {
            $0.top.equalTo(toastButton2.snp.bottom).offset(56)
            $0.size.equalTo(60)
            $0.centerX.equalToSuperview()
        }
    }
}
