//
//  TestViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/19.
//

import UIKit

class TestViewController: UIViewController {
    var score: Int = 0
    var timer: Timer? = nil
    var isPause: Bool = true

    private lazy var kurommi = UIImageView(image: UIImage(named: "kuromi"))
    private let topToast = UIImageView(image: UIImage(named: "toast"))
    private let bottomToast = UIImageView(image: UIImage(named: "toast"))
    private let leadingToast = UIImageView(image: UIImage(named: "toast"))
    private let trailingToast = UIImageView(image: UIImage(named: "toast"))
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Hi"
        label.font = UIFont(name: "Korail-Round-Gothic-Light", size: 20)
        label.textColor = .brown
        label.numberOfLines = 2

        return label
    }()


    //저는 viewDidLoad startTimer 를 바로 시작하지 않고 longPress 제스처를 추가했어요
    //꾹 눌렀다가 땠을 때 startTimer 가 시작될 수 있게 .ended 에다가 startTimer()를 시작했답니다!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        setLayout()
        setToast()
//        startTimer()
        target()
    }

    private func target() {
        //LongPress 제스처 추가
        let press = UILongPressGestureRecognizer(target: self, action: #selector(viewPress))
        press.minimumPressDuration = 3.0
        kurommi.addGestureRecognizer(press)

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(viewPan(_:)))
        kurommi.addGestureRecognizer(gesture)
        kurommi.isUserInteractionEnabled = true
    }

    //Pan 제스처 함수
    @objc
    private func viewPan(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: kurommi)
        let changedX = kurommi.center.x + transition.x
        let changedY = kurommi.center.y + transition.y

        self.kurommi.center = .init(x: changedX,
                                    y: changedY)
        sender.setTranslation(.zero, in: self.kurommi)
    }

    //longPress 제스처 함수
    @objc
    private func viewPress(gesture : UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            startTimer()
        }
    }

    //시간 측정
    private func startTimer() {
        guard timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                          target: self,
                                          selector: #selector(self.moveToast),
                                          userInfo: nil,
                                          repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func setLayout() {
        self.view.addSubview(kurommi)
        self.view.addSubview(scoreLabel)
        kurommi.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        scoreLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
    }

    private func setToast() {
        self.view.addSubview(topToast)
        self.view.addSubview(bottomToast)
        self.view.addSubview(leadingToast)
        self.view.addSubview(trailingToast)

        topToast.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        leadingToast.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        trailingToast.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        bottomToast.snp.makeConstraints {
            $0.bottom.centerX.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }

    //startTimer 가 시작되면 실행되는 함수(토스트가 움직이는 함수)
    @objc
    private func moveToast() {
        var topToastY = self.topToast.frame.origin.y
        topToastY += 10
        self.topToast.frame = .init(origin: .init(x: self.topToast.frame.origin.x,
                                                  y: topToastY),
                                    size: self.topToast.frame.size)

        var bottomToastY = self.bottomToast.frame.origin.y
        bottomToastY -= 10
        self.bottomToast.frame = .init(origin: .init(x: self.bottomToast.frame.origin.x,
                                                     y: bottomToastY),
                                       size: self.bottomToast.frame.size)

        var leftToastX = self.leadingToast.frame.origin.x
        leftToastX += 10
        self.leadingToast.frame = .init(origin: .init(x: leftToastX,
                                                      y: self.leadingToast.frame.origin.y),
                                        size: self.leadingToast.frame.size)

        var rightToastX = self.trailingToast.frame.origin.x
        rightToastX -= 10
        self.trailingToast.frame = .init(origin: .init(x: rightToastX,
                                                       y: self.trailingToast.frame.origin.y),
                                         size: self.trailingToast.frame.size)
        self.calculatePositionReached()
    }

    //토스트랑 쿠로미랑 만났는지 측정해서 게임 점수와 시작,끝 정해주는 함수
    private func calculatePositionReached() {
        if self.kurommi.frame.minX <= self.topToast.frame.minX &&
            self.kurommi.frame.maxX >= self.topToast.frame.maxX &&
            self.kurommi.frame.minY <= self.topToast.frame.minY &&
            self.kurommi.frame.maxY >= self.topToast.frame.maxY
        {
            self.scoreLabel.text = "ByeBye\nScore:\(self.score)"
            self.stopTimer()
        } else {
            self.score += 10
        }

        if self.kurommi.frame.minX <= self.leadingToast.frame.minX &&
            self.kurommi.frame.maxX >= self.leadingToast.frame.maxX &&
            self.kurommi.frame.minY <= self.leadingToast.frame.minY &&
            self.kurommi.frame.maxY >= self.leadingToast.frame.maxY
        {
            self.scoreLabel.text = "ByeBye\nScore:\(self.score)"
            self.stopTimer()
        } else {
            self.score += 10
        }

        if self.kurommi.frame.minX <= self.trailingToast.frame.minX &&
            self.kurommi.frame.maxX >= self.trailingToast.frame.maxX &&
            self.kurommi.frame.minY <= self.trailingToast.frame.minY &&
            self.kurommi.frame.maxY >= self.trailingToast.frame.maxY
        {
            self.scoreLabel.text = "ByeBye\nScore:\(self.score)"
            self.stopTimer()
        } else {
            self.score += 10
        }

        if self.kurommi.frame.minX <= self.bottomToast.frame.minX &&
            self.kurommi.frame.maxX >= self.bottomToast.frame.maxX &&
            self.kurommi.frame.minY <= self.bottomToast.frame.minY &&
            self.kurommi.frame.maxY >= self.bottomToast.frame.maxY
        {
            self.scoreLabel.text = "ByeBye\nScore:\(self.score)"
            self.stopTimer()
        } else {
            self.score += 10
        }
    }
}
