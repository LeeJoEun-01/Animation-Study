//
//  StartViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/19.
//

import UIKit

import SnapKit

class StartViewController: UIViewController {

    // MARK: - 배경사진
    private let imageView: UIImageView = UIImageView(image: UIImage(named: "wallace_gromit"))

    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Game Start!", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = UIColor(red: 0.678, green: 0.615, blue: 0.66, alpha: 1)
        button.semanticContentAttribute = .forceLeftToRight
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 24
        button.addTarget(self, action: #selector(shakeEaseOut), for: .touchUpInside)

        return button
    }()

    @objc func shakeEaseOut() {
        startButton.transform = CGAffineTransform(translationX: 20, y: 0)
        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 0.1,
                       initialSpringVelocity: 2,
                       options: [.curveEaseOut]) {
            self.startButton.transform = .identity
        }
        self.present(Fighting2ViewController(), animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        imageView.contentMode = .scaleAspectFill

        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        self.view.addSubview(imageView)
        self.view.addSubview(startButton)
    }

    func setConstraints() {
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(180)
            $0.leading.equalToSuperview().inset(-220)
        }
        startButton.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(40)
            $0.height.equalTo(52)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
    }
}
