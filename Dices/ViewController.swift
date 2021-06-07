import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var computerSumLabel: UILabel!
    @IBOutlet weak var computerWinnerImageView: UIImageView!
    @IBOutlet weak var playerSumLabel: UILabel!
    @IBOutlet weak var playerWinnerImageView: UIImageView!
    @IBOutlet var computerDiceImages: [UIImageView]!
    @IBOutlet var playerDiceImages: [UIImageView]!
    @IBOutlet weak var computerDiceCupTop: UIImageView!
    @IBOutlet weak var playerDiceCupTop: UIImageView!
    @IBOutlet weak var seeSwitch: UISwitch!
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    
    let diceData:[Dice] = [
        Dice(image: "one", number: 1),
        Dice(image: "two", number: 2),
        Dice(image: "three", number: 3),
        Dice(image: "four", number: 4),
        Dice(image: "five", number: 5),
        Dice(image: "six", number: 6)]
    
    var computerSum = 0
    var playerSum = 0
    
    let playerOfBackground = AVPlayer()
    let playerOfShakeDices = AVPlayer()
    
    //列舉分類會遇到的狀況
    enum GameType {
        case Init
        case Play
        case Open
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeBackgroundMusic()
        makeShakeMusic()
        updateStatus(type: .Init)
    }
    
    func makeBackgroundMusic() {
        let url = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)
        playerOfBackground.replaceCurrentItem(with: playerItem)
        playerOfBackground.play()
    }
    
    func makeShakeMusic() {
        let url = Bundle.main.url(forResource: "shakeDicesMusic", withExtension: "mp3")!
        let playerItem = AVPlayerItem(url: url)
        playerOfShakeDices.replaceCurrentItem(with: playerItem)
    }
    
    //模擬器搖晃骰子
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if playerDiceCupTop.isHidden == false , computerDiceCupTop.isHidden == false {
            if motion == .motionShake {
                randomDices()
                playerOfShakeDices.play()
            }
        }
    }
    
    func randomDices() {
        computerSum = 0
        playerSum = 0
        for computerDice in computerDiceImages {
            let randomNumber = Int.random(in: 0...5)
            computerDice.image = UIImage(named: diceData[randomNumber].image)
            computerSum += diceData[randomNumber].number
        }
        
        for playerDice in playerDiceImages {
            let randomNumber = Int.random(in: 0...5)
            playerDice.image = UIImage(named: diceData[randomNumber].image)
            playerSum += diceData[randomNumber].number
        }
    }
    
    @IBAction func replay(_ sender: UIButton) {
        updateStatus(type: .Init)
    }
    
    @IBAction func play(_ sender: UIButton) {
        updateStatus(type: .Play)
    }
    
    @IBAction func open(_ sender: UIButton) {
        updateStatus(type: .Open)
    }
    
    @IBAction func peek(_ sender: UISwitch) {
        if sender.isOn == true {
            playerDiceCupTop.alpha = 0.5
        }else{
            playerDiceCupTop.alpha = 1
        }
    }
    
    func updateStatus(type:GameType) {
        switch type {
        case .Init:
            computerSumLabel.text = "?"
            playerSumLabel.text = "?"
            computerDiceCupTop.isHidden = true
            playerDiceCupTop.isHidden = true
            playerOfBackground.play()
            computerSum = 0
            playerSum = 0
            playerWinnerImageView.isHidden = true
            computerWinnerImageView.isHidden = true
            seeSwitch.isOn = false
            openButton.isHidden = true
            replayButton.isHidden = true
            playButton.isHidden = false
            
        case .Play:
            randomDices()
            playerDiceCupTop.frame = CGRect(x: 13, y: 28, width: 225, height: 230)
            computerDiceCupTop.frame = CGRect(x: 13, y: 28, width: 225, height: 230)
            computerDiceCupTop.isHidden = false
            playerDiceCupTop.isHidden = false
            openButton.isHidden = false
            replayButton.isHidden = true
            
        case .Open:
            playButton.isHidden = true
            replayButton.isHidden = false
            openButton.isHidden = true
            playerOfBackground.pause()
            computerSumLabel.text = "\(computerSum)"
            playerSumLabel.text = "\(playerSum)"
            playerDiceCupTop.alpha = 1
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2, delay: 0, animations: {
                self.playerDiceCupTop.frame = CGRect(x: 13, y: -80, width: 225, height: 230)
                self.computerDiceCupTop.frame = CGRect(x: 13, y: -80, width: 225, height: 230)
            }, completion: nil)
            
            if playerSum > computerSum {
                playerWinnerImageView.isHidden = false
            }else if playerSum == computerSum {
                playerWinnerImageView.isHidden = false
                computerWinnerImageView.isHidden = false
                playerWinnerImageView.image = UIImage(named: "draw")
                computerWinnerImageView.image = UIImage(named: "draw")
            }else{
                computerWinnerImageView.isHidden = false
            }
        }
    }
}

