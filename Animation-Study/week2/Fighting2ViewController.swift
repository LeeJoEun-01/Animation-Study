//
//  Fighting2ViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/19.
//

import UIKit

import SnapKit

final class Fighting2ViewController: UIViewController {
    var score: Int = 0
    var timer: Timer? = nil

    private lazy var gromit = UIImageView(image: UIImage(named: "gromit"))
    private let rabbit1 = UIImageView(image: UIImage(named: "rabbit1"))
    private let rabbit2 = UIImageView(image: UIImage(named: "rabbit2"))
    private let rabbit3 = UIImageView(image: UIImage(named: "rabbit3"))
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Catch the rabbit! (ᐡ｡•༝•｡ᐡ)"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .darkGray
        label.numberOfLines = 2

        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setHierarchy()
        setConstraints()
        target()
        startTimer()
    }

    // MARK: - 레이아웃 설정
    func setHierarchy() {
        self.view.addSubview(gromit)
        self.view.addSubview(titleLabel)
        self.view.addSubview(rabbit1)
        self.view.addSubview(rabbit2)
        self.view.addSubview(rabbit3)
    }

    func setConstraints() {
        gromit.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(120)
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(40)
        }
        rabbit1.snp.makeConstraints {
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(75)
        }
        rabbit2.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.width.height.equalTo(75)
        }
        rabbit3.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
            $0.width.height.equalTo(75)
        }

        rabbit1.contentMode = .scaleAspectFit
        rabbit2.contentMode = .scaleAspectFit
        rabbit3.contentMode = .scaleAspectFit
    }

    // MARK: - 게임 함수 설정
    private func target() {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(viewPan(_:)))
        gromit.addGestureRecognizer(gesture)
        gromit.isUserInteractionEnabled = true
    }

    //Pan 제스처 함수
    @objc
    private func viewPan(_ sender: UIPanGestureRecognizer) {
        let transition = sender.translation(in: gromit)
        let changedX = gromit.center.x + transition.x
        let changedY = gromit.center.y + transition.y

        self.gromit.center = .init(x: changedX,
                                    y: changedY)
        sender.setTranslation(.zero, in: self.gromit)
    }

    private func startTimer() {
        guard timer == nil else { return }
        self.timer = Timer.scheduledTimer(timeInterval: 0.5,
                                          target: self,
                                          selector: #selector(self.moveRabbit),
                                          userInfo: nil,
                                          repeats: true)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // 토끼가 움직이는 함수
    @objc
    private func moveRabbit() {
        var rabbit1Y = self.rabbit1.frame.origin.y
        rabbit1Y -= 10
        self.rabbit1.frame = .init(origin: .init(x: self.rabbit1.frame.origin.x,
                                                     y: rabbit1Y),
                                       size: self.rabbit1.frame.size)

        var rabbit2X = self.rabbit2.frame.origin.x
        rabbit2X += 10
        self.rabbit2.frame = .init(origin: .init(x: rabbit2X,
                                                      y: self.rabbit2.frame.origin.y),
                                        size: self.rabbit2.frame.size)

        var rabbit3X = self.rabbit3.frame.origin.x
        rabbit3X -= 10
        self.rabbit3.frame = .init(origin: .init(x: rabbit3X,
                                                       y: self.rabbit3.frame.origin.y),
                                         size: self.rabbit3.frame.size)
        self.calculatePositionReached()
    }

    // 토끼랑 그로밋이 만났는지 측정해서 게임 점수와 시작, 끝 정해주는 함수
    private func calculatePositionReached() {
        if self.gromit.frame.minX <= self.rabbit1.frame.minX &&
            self.gromit.frame.maxX >= self.rabbit1.frame.maxX &&
            self.gromit.frame.minY <= self.rabbit1.frame.minY &&
            self.gromit.frame.maxY >= self.rabbit1.frame.maxY
        {
            self.rabbit1.isHidden = true
            self.score += 10
        }

        if self.gromit.frame.minX <= self.rabbit2.frame.minX &&
            self.gromit.frame.maxX >= self.rabbit2.frame.maxX &&
            self.gromit.frame.minY <= self.rabbit2.frame.minY &&
            self.gromit.frame.maxY >= self.rabbit2.frame.maxY
        {
            self.rabbit2.isHidden = true
            self.score += 10
        }

        if self.gromit.frame.minX <= self.rabbit3.frame.minX &&
            self.gromit.frame.maxX >= self.rabbit3.frame.maxX &&
            self.gromit.frame.minY <= self.rabbit3.frame.minY &&
            self.gromit.frame.maxY >= self.rabbit3.frame.maxY
        {
            self.rabbit3.isHidden = true
            self.score += 10
        }

        // 게임 성공(the end) 조건
        if (score == 30) {
            self.stopTimer()
            self.titleLabel.text = "Success!!"

            UIView.animateKeyframes(withDuration: 2.0, delay: 0)  {
                UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2.0) { [self] in
                    gromit.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                }
            }
        }
    }

}
