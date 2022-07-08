//
//  ViewController.swift
//  Project2
//
//  Created by Gitko Denis on 21.06.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var questionsAsked = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(shareTapped))
//        Get defaults
        
        let defaults = UserDefaults.standard
        let previousScore = defaults.object(forKey: "maxScore") as? Int ?? 0
        print(previousScore)

        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion()
        // Do any additional setup after loading the view.
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()) || score: \(score)"
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        var message: String
        questionsAsked += 1
        
        if(questionsAsked == 5 && sender.tag == correctAnswer) {
            title = "Congratulations"
            score += 1
        }
        else if(questionsAsked == 5 && sender.tag != correctAnswer) {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
        else if(sender.tag == correctAnswer) {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            score -= 1
        }
                
        
        if questionsAsked == 5 {
            message = "Your FINAL score is \(score)"
            
//            Save the new score in userDefaults
            let defaults = UserDefaults.standard
            if let previousScore = defaults.object(forKey: "maxScore") as? Int {
                if score > previousScore {
                    title = "New high score!"
                    defaults.set(score, forKey: "maxScore")
                }
            } else {
                defaults.set(score, forKey: "maxScore")
            }
//            Saving in userDefault finished
            
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
        } else {
            message = "Your score is \(score)."
        }
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)

            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        
    }
    @objc func shareTapped() {
        let vc = UIActivityViewController(activityItems: ["Your score is \(score)"], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

}

