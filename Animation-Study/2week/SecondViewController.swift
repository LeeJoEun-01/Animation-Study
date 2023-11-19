//
//  SecondViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 2023/11/15.
//

import UIKit

class SecondViewController: UIViewController {

    var testView : UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.frame = CGRect(x: 100, y: 300, width: 200, height: 200)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.view.addSubview(testView)

        target()
    }

    private func target() {

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTap))
        tapGesture.numberOfTapsRequired = 3
        testView.addGestureRecognizer(tapGesture)

        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(viewPinch))
        testView.addGestureRecognizer(pinchGesture)

        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(viewRotation))
        testView.addGestureRecognizer(rotationGesture)

        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipe))
        rightGesture.direction = .right

        let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipe))
        leftGesture.direction = .left

        self.view.addGestureRecognizer(rightGesture)
        self.view.addGestureRecognizer(leftGesture)

        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(viewPress))
        pressGesture.minimumPressDuration = 3
        pressGesture.numberOfTouchesRequired = 2
        testView.addGestureRecognizer(pressGesture)

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(viewPan))
        testView.addGestureRecognizer(panGesture)
    }

    @objc
    func viewTap(_ gesture: UITapGestureRecognizer) {
        print("🍎")
        UIView.animate(withDuration: 1.0, animations: { [self] in
            testView.frame.origin.x += 50
        }, completion: { _ in
            UIView.animate(withDuration: 1.0, animations: { [self] in
                testView.frame.origin.x -= 50
            })
        })
    }

    @objc
    func viewPinch(gesture: UIPinchGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        gesture.scale = 1
        // option 키: 손가락 두개를 사용하는 효과!
    }

    @objc
    func viewRotation(gesture: UIRotationGestureRecognizer) {
        guard let view = gesture.view else { return }
        view.transform = view.transform.rotated(by: gesture.rotation)
        gesture.rotation = 0
    }

    @objc
    func viewSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .right {
            self.view.backgroundColor = .brown
        } else if gesture.direction == .left {
            self.view.backgroundColor = .white
        }
    }

    @objc
    func viewPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            print("Start\n")
        case .changed:
            print("Change\n")
        case .ended:
            print("End\n")
        case .possible:
            print("Possibe")
        case .cancelled:
            print("Cancel")
        case .failed:
            print("Fail")
        @unknown default:
            print("옼😳")
        }
    }

    @objc func viewPan(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        if let viewToMove = gesture.view {
            viewToMove.center = CGPoint(x: viewToMove.center.x + translation.x, y: viewToMove.center.y + translation.y)
        }

        gesture.setTranslation(.zero, in: view)
    }
}
