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
    var submitButton: UIButton!
    var triesLeft = 7 {
        didSet {
            triesLeftLabel.text = "Tries Left: \(triesLeft)"
            if triesLeft <= 0 {
                showErrorAlert(title: "Game Over", message: nil)
            }
        }
    }

    override func loadView() {
        createSuperView()
        addWordLabel()
        addTriesLeftLabel()
        addSubmitButton()
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
    
    func addSubmitButton() {
        submitButton = UIButton(type: .system)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 34)
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.layer.borderColor = UIColor.lightGray.cgColor
        submitButton.layer.borderWidth = 1
        view.addSubview(submitButton)
    }
    
    func getSubmitConstraints() -> [NSLayoutConstraint] {
        [
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(equalTo: triesLeftLabel.bottomAnchor),
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ]
    }
    
    @objc func submitTapped() {
        print("TBD")
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
    
    func addConstraints() {
        var allConstraints: [NSLayoutConstraint]
        allConstraints = getWordLabelConstraints()
        allConstraints += getTriesLeftLabelConstraints()
        allConstraints += getSubmitConstraints()
        
        NSLayoutConstraint.activate(allConstraints)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        performSelector(inBackground: #selector(loadWords), with: nil)
    }
    
    
    @objc func loadWords() {
        if let url = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
        }
    }


}

