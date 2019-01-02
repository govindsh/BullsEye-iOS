//
//  EasyGameController.swift
//  BullsEye
//
//  Created by Srikkanth Govindaraajan on 12/29/18.
//  Copyright © 2018 Srikkanth Govindaraajan. All rights reserved.
//

import Foundation
import UIKit

class EasyGameController: UIViewController {
    
    // class variables
    var currentValue: Int = 0
    var targetValue: Int = 0
    var score = 0
    var round = 0
    var lives = 0
    var bullsEye = 0
    var highestScore = 0
    var scoresTables: [String:Int] = [:]
    var savedHighestScore = UserDefaults.init()

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var hatTrickLabel: UILabel!
    @IBOutlet weak var highestScoreLabel: UILabel!
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()

        savedHighestScore.set(savedHighestScore.integer(forKey: "highScore"), forKey: "highScore")
        let thumbImage = #imageLiteral(resourceName: "SliderThumb-Normal")
        slider.setThumbImage(thumbImage, for: .normal)

        let thumbImageHighlighted = #imageLiteral(resourceName: "SliderThumb-Highlighted")
        slider.setThumbImage(thumbImageHighlighted, for: .highlighted)

        let insets = UIEdgeInsets(top:0, left:14,bottom:0,right:14)

        let trackLeftImage = #imageLiteral(resourceName: "the-button-859349_960_720")
        let _ = trackLeftImage.resizableImage(withCapInsets: insets)
        slider.setMinimumTrackImage(trackLeftImage, for: .normal)

        let trackRightImage = #imageLiteral(resourceName: "SliderTrackRight")
        let _ = trackRightImage.resizableImage(withCapInsets: insets)
        slider.setMaximumTrackImage(trackRightImage, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func startOver() {
        // Reset Game
        resetGame()
    }

    @IBAction func showSliderValue(_ sender: Any) {
        let roundedValue = slider.value.rounded()
        currentValue = Int(roundedValue)

    }

    @IBAction func showAlert() {
        let difference = abs(targetValue - currentValue)
        var points = 0
        if (difference <= 5) {
            points = Int(slider.maximumValue) - difference
        }
        var bonusPointsMessage = ""
        var hatTrickMessage = ""
        var finalMessage = ""
        let message = "You scored: \(points) points"

        var title : String = ""

        // Based on difference, decide points & message to be displayed
        // Increase points when range is lesser than or equal to 5
        if difference == 0 {
            points += 100
            title = "Perfecto!!"
            bullsEye += 1
            bonusPointsMessage = "\nBull's Eye!! 100 bonus points"
        } else if (difference == 1) {
            points += 50
            title = "Very very close!!"
            bonusPointsMessage = "\n50 bonus points"
            bullsEye = 0
        } else if difference <= 5 {
            title = "Almost there!"
            bullsEye = 0
        } else {
            lives -= 1
            if (lives == 0) {
                title = "Game over! Try again"
            } else {
                title = "Better luck next time!\nLives remaining \(lives)"
                bullsEye = 0
            }
        }

        // Calculate score
        score = score + points
        scoreLabel.text = String(score)
        livesLabel.text = String(lives)

        //  Update dict with current score
        scoresTables["currentScore"] = score

        if (checkForHatTrick()) {
            lives += 1
            hatTrickLabel.text = String(bullsEye / 3)
            hatTrickMessage = "\nAwesome! you scored hat trick, you get an extra life."
        }

        if (bonusPointsMessage != "") {
            finalMessage = message + bonusPointsMessage + "\nTotal score = " + String(score) + hatTrickMessage
        } else {
            finalMessage = message + "\nTotal score = " + String(score) + hatTrickMessage
        }

        if title.contains("Game over") {

            if (self.score > self.highestScore) {
                self.highestScore = self.score
                savedHighestScore.set(self.highestScore, forKey: "highScore")
                self.resetGame()
            } else {
                startNewRound()
            }
        }

        // Display alert message

        let alertButton = UIAlertController(title: title, message: finalMessage, preferredStyle: .actionSheet)
        let actionForAlertButton = UIAlertAction(title: "Ok!", style: .default, handler: {
            action in
            if (title.contains("Game over")) {
                let _ = self.scoresTables["highestScore"] ?? 0
                if (self.score > self.highestScore) {
                    self.highestScore = self.score
                    self.savedHighestScore.set(self.highestScore, forKey: "highScore")
                }
                self.resetGame()
            } else {
                self.startNewRound()
            }
        })

        alertButton.addAction(actionForAlertButton)

        present(alertButton, animated: true, completion: nil)

    }

    func checkForHatTrick() -> Bool {
        if (bullsEye / 3 > 0) {
            return true
        }
        return false
    }


    // Helper methods
    func startNewRound() {
        // Start new round - Increase round count and get new slider value
        let maxValue = Int(slider.maximumValue)
        targetValue = Int.random(in: 1...maxValue)
        currentValue = 50
        round += 1
        slider.value = Float(currentValue)
        label.text = String(targetValue)
        roundLabel.text = String(round)
    }

    func resetGame() {
        // Reset to defaults for the game to start again
        let roundedValue = slider.value.rounded()
        round = 0
        score = 0
        lives = 3
        bullsEye = 0
        currentValue = Int(roundedValue)
        scoreLabel.text = String(0)
        roundLabel.text = String(0)
        livesLabel.text = String(lives)
        hatTrickLabel.text = String(bullsEye)
        highestScoreLabel.text = savedHighestScore.string(forKey: "highScore")
        scoresTables["highestScore"] = highestScore
        startNewRound()
    }
}
