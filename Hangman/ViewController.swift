//
//  ViewController.swift
//  Hangman
//
//  Created by Atin Agnihotri on 21/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    var wordLabel: UILabel!
    var triesLeftLabel: UILabel!
    var guessButton: UIButton!
    var currentWord = ""
    var correctGuesses = [String]()
    var triesLeft = 7 {
        didSet {
            triesLeftLabel.text = "Tries Left: \(triesLeft)"
            if triesLeft <= 0 {
                showErrorAlert(title: "Game Over", message: "Try again?")
                performSelector(inBackground: #selector(loadWords), with: nil)
            }
        }
    }

    override func loadView() {
        createSuperView()
        addWordLabel()
        addTriesLeftLabel()
        addGuessButton()
        addConstraints()
        print("Reached at the end of loadView")
    }
    
    func createSuperView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    func addWordLabel() {
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = "??????"
        wordLabel.font = UIFont.systemFont(ofSize: 26)
        wordLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(wordLabel)
    }
    
    func getWordLabelConstraints() -> [NSLayoutConstraint] {
        [
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ]
    }
    
    func addTriesLeftLabel() {
        triesLeftLabel = UILabel()
        triesLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        triesLeftLabel.text = "Tries Left: \(triesLeft)"
        triesLeftLabel.font = UIFont.systemFont(ofSize: 26)
        triesLeftLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(triesLeftLabel)
    }
    
    func getTriesLeftLabelConstraints() -> [NSLayoutConstraint] {
        [
            triesLeftLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            triesLeftLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            triesLeftLabel.topAnchor.constraint(equalTo: wordLabel.bottomAnchor)
        ]
    }
    
    func addGuessButton() {
        guessButton = UIButton(type: .system)
        guessButton.translatesAutoresizingMaskIntoConstraints = false
        guessButton.setTitle("GUESS", for: .normal)
        guessButton.titleLabel?.font = UIFont.systemFont(ofSize: 34)
        guessButton.addTarget(self, action: #selector(guessTapped), for: .touchUpInside)
        guessButton.titleLabel?.numberOfLines = 0
        guessButton.layer.borderColor = UIColor.lightGray.cgColor
        guessButton.layer.borderWidth = 5
        guessButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(guessButton)
    }
    
    func getGuessButtonConstraints() -> [NSLayoutConstraint] {
        [
            guessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guessButton.topAnchor.constraint(equalTo: triesLeftLabel.bottomAnchor),
            guessButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ]
    }
    
    @objc func guessTapped() {
        let ac = UIAlertController(title: "Venture a guess . . .", message: ". . . or the Hanged man gets it!", preferredStyle: .alert)
        ac.addTextField()
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        let ok = UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] action in
            guard let userAnswer = ac?.textFields?[0].text?.lowercased() else { return }
            guard userAnswer.count == 1 else {
                self?.showErrorAlert(title: "Invalid Input", message: "Please enter only one letter at a time!")
                return
            }
            self?.checkGuess(userAnswer)
        }
        ac.addAction(cancel)
        ac.addAction(ok)
        present(ac, animated: true)
    }
    
    func checkGuess(_ answer: String) {
        if currentWord.contains(answer) {
            userGaveRightAnswer(answer)
        } else {
            userGaveWrongAnswer()
        }
    }
    
    func userGaveRightAnswer(_ letter: String) {
        var newTitle = ""
        
        correctGuesses.append(letter)
        
        for letter in currentWord {
            let letterStr = String(letter)
            if correctGuesses.contains(letterStr) {
                newTitle += letterStr
            } else {
                newTitle += "?"
            }
        }
        
        newTitle = newTitle.uppercased()
        
        wordLabel.text = newTitle
        
        if !newTitle.contains("?") {
            showInfoAlert(title: "🍻 You won!", message: "The Hangman is safe for now. You wanna gamble his life again?")
        }
    }
    
    func userGaveWrongAnswer() {
        triesLeft -= 1
        showInfoAlert(title: "🚨 Wrong Guess", message: "The Hangman is one step closer to death")
    }
    
    func showAlert(title: String, message: String?, action: UIAlertAction) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(action)
        present(ac, animated: true)
    }
    
    func showInfoAlert(title: String, message: String?) {
        let ok = UIAlertAction(title: "OK", style: .default)
        showAlert(title: title, message: message, action: ok)
    }
    
    func showErrorAlert(title: String, message: String?) {
        showInfoAlert(title: "⚠️ \(title)", message: message)
    }
    
    @objc func showLoadError(message: String?) {
        showErrorAlert(title: "Loading Error", message: message)
    }
    
    func addConstraints() {
        var allConstraints: [NSLayoutConstraint]
        allConstraints = getWordLabelConstraints()
        allConstraints += getTriesLeftLabelConstraints()
        allConstraints += getGuessButtonConstraints()
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        performSelector(inBackground: #selector(loadWords), with: nil)
    }
    
    func showLoadErrorOnMainThread(message: String? = nil) {
        performSelector(onMainThread: #selector(showLoadError), with: message, waitUntilDone: false)
    }
    
    
    @objc func loadWords() {
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let words = try? String(contentsOf: url) {
                if let randomWord = words.components(separatedBy: "\n").randomElement() {
                    DispatchQueue.main.async { [weak self] in
                        self?.currentWord = randomWord.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                        self?.triesLeft = 7
                        print(self?.currentWord)
                    }
                } else {
                    showLoadErrorOnMainThread(message: "Could not load word from loaded data")
                }
            } else {
                showLoadErrorOnMainThread(message: "Could not parse  loaded data")
            }
        } else {
            showLoadErrorOnMainThread(message: "Could not load data")
        }
    }


}

