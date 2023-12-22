//
//  FinalViewController.swift
//  Animation-Study
//
//  Created by 이조은 on 12/19/23.
//

import UIKit
import SpriteKit
import GameplayKit

// GameScene은 SpriteKit의 SKScene 클래스를 상속받아 게임의 메인 화면을 구성
class GameScene: SKScene {

    // 배경 및 player 이미지 설정
    let background1 = SKSpriteNode(imageNamed: "pixel_bg")
    let background2 = SKSpriteNode(imageNamed: "pixel_bg")
    let player = SKSpriteNode(imageNamed: "clear_pin")
    var obstacles = [SKSpriteNode]()

    var startGameButton = SKLabelNode(fontNamed: "DungGeunMo")
    var isGameStarted = false
    let gameOverLabel = SKLabelNode(fontNamed: "DungGeunMo")

    // 게임 오버 상태를 체크하는 변수, false가 게임 실행 상태
    var isGameOver = false
    var scoreLabel = SKLabelNode(fontNamed: "DungGeunMo")
    var score = 0

    override func didMove(to view: SKView) {
        // 배경 이미지 크기 조정
        let aspectRatio = background1.size.width / background1.size.height
        background1.size.height = size.height
        background1.size.width = size.height * aspectRatio
        background2.size.height = size.height
        background2.size.width = size.height * aspectRatio

        // 배경 이미지 위치 설정
        background1.anchorPoint = CGPoint.zero
        background1.position = CGPoint(x: 0, y: 0)
        background2.anchorPoint = CGPoint.zero
        background2.position = CGPoint(x: background1.size.width, y: 0)

        // 배경 이미지 zPosition 설정
        background1.zPosition = -1
        background2.zPosition = -1

        // 배경 이미지 추가
        addChild(background1)
        addChild(background2)

        // 점수 설정
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: size.width * 0.15, y: size.height * 0.9)
        addChild(scoreLabel)

        // player 세팅
        let scale = 60 / player.size.width
        player.size = CGSize(width: 60, height: player.size.height * scale)
        player.position = CGPoint(x: size.width * 0.1, y: (size.height * 0.3)-25)
        addChild(player)

        startGameButton.text = "Game Start"
        startGameButton.fontSize = 30
        startGameButton.fontColor = .black
        startGameButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(startGameButton)

        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 65
        gameOverLabel.fontColor = .black
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY+20)
        addChild(gameOverLabel)

        gameOverLabel.isHidden = true
    }

    func addObstacle() {
        if isGameOver { return } // 게임 오버 상태일 때는 장애물을 추가 X

        let obstacle = SKSpriteNode(imageNamed: "dinosaur")
        let scale = 70 / obstacle.size.width
        obstacle.size = CGSize(width: 70, height: obstacle.size.height * scale)
        obstacle.position = CGPoint(x: size.width + obstacle.size.width/2, y: (size.height * 0.3)-32)
        addChild(obstacle)
        obstacles.append(obstacle)

        let moveLeft = SKAction.moveBy(x: -size.width - obstacle.size.width, y: 0, duration: 2.0)
        let moveReset = SKAction.removeFromParent()
        obstacle.run(SKAction.sequence([moveLeft, moveReset]), withKey: "moving")
    }

    func stopBackgroundMovement() {
        background1.removeAction(forKey: "moveBG")
        background2.removeAction(forKey: "moveBG")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)

        // 게임 시작 버튼을 눌렀을 때의 액션을 추가
        if startGameButton.contains(touchLocation) && !isGameStarted {
            startGame()
            startGameButton.isHidden = true
        } else if isGameOver {
            // 게임 오버 상태일 때는 플레이어가 점프 X
            return
        } else {
            // player 점프 액션
            let jumpUpAction = SKAction.moveBy(x: 0, y: 200, duration: 0.5)
            let jumpDownAction = SKAction.moveBy(x: 5, y: -200, duration: 0.4)
            let jumpSequence = SKAction.sequence([jumpUpAction, jumpDownAction])

            player.run(jumpSequence)
        }
    }

    func startGame() {
        isGameStarted = true
        isGameOver = false
        gameOverLabel.isHidden = true

        score = 0
        scoreLabel.text = "Score: 0"

        obstacles = [SKSpriteNode]()

        // 배경 이미지에 애니메이션 적용
        let moveLeft = SKAction.moveBy(x: -background1.size.width, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x: background1.size.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveBG = SKAction.repeatForever(moveLoop)

        // 배경 이미지에 애니메이션 적용
        background1.run(moveBG, withKey: "moveBG")
        background2.run(moveBG, withKey: "moveBG")

        //player position 초기화
        player.position = CGPoint(x: size.width * 0.1, y: (size.height * 0.3)-25)

        // 장애물 생성 시작
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addObstacle),
                SKAction.wait(forDuration: 2.0)
            ])
        ))
    }

    func gameOver() {
        isGameOver = true // 게임 오버 상태로 변경
        gameOverLabel.isHidden = false

        stopBackgroundMovement()

        // 게임 오버 시 장애물의 움직임을 멈춤
        for obstacle in obstacles {
            obstacle.removeAction(forKey: "moving")
        }

        startGameButton.text = "-Game Restart-"
        startGameButton.position = CGPoint(x: frame.midX, y: frame.midY-30)
        startGameButton.isHidden = false
        isGameStarted = false
    }

    override func update(_ currentTime: TimeInterval) {

        if isGameOver { return } // 게임 오버 상태일 때는 충돌 검사 X

        for (index, obstacle) in obstacles.enumerated().reversed() {
            if obstacle.frame.intersects(player.frame) { // 장애물과 충돌하면
                obstacles.remove(at: index)
                obstacle.removeFromParent()
                gameOver()
            } else if obstacle.position.x + obstacle.size.width/2 < player.position.x {
                obstacles.remove(at: index)
                obstacle.removeFromParent()
                score += 1
                scoreLabel.text = "Score: \(score)"
            }
        }
    }
}

class FinalViewController: UIViewController {

    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as? SKView {
            let scene = GameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
