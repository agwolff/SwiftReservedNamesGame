//
//  ReservedWordsViewController.swift
//  SwiftReservedWords
//
//  Created by Allan Wolff on 03/03/20.
//  Copyright © 2020 Allan Wolff. All rights reserved.
//

import UIKit

enum GameStatus {
    case victory
    case defeat
}

// MARK: Properties and View Lifecycle
class ReservedWordsViewController: UIViewController {
    var textField = UITextField()
    var checkButton = UIButton()
    var timerLabel = UILabel()
    var scoreLabel = UILabel()
    var tableView = UITableView()
    let kCellIdentifier = "ReservedWordTableViewCell"
    
    var timer: Timer?
    var totalTimeInSeconds = 300
    
    var viewModel = ReservedWordsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        startTimer()
    }
}

// MARK: UI Implementation
extension ReservedWordsViewController {
    func setupUI() {
        self.title = "Swift Reserved Words"
        view.backgroundColor = .white
        
        // Best layout implementation here would be using AutoLayout programatically (NSLayoutConstraints via a util such as UIView extension method to anchor the views in relation to other views, but since this would be outside the scope of this activity, I have opted for using frames0
        setupScoreLabel()
        setupTimerLabel()
        setupTextField()
        setupCheckButton()
        setupAndPopulateTableView()
    }
    
    func setupScoreLabel() {
        scoreLabel = UILabel(frame: CGRect(x: 20, y: 60, width: (UIScreen.main.bounds.width / 2 - 20), height: 30))
        scoreLabel.font = scoreLabel.font.withSize(24)
        view.addSubview(scoreLabel)
    }
    
    func setupTimerLabel() {
        timerLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2), y: 60, width: (UIScreen.main.bounds.width / 2 - 20), height: 30))
        timerLabel.textAlignment = .right
        timerLabel.font = scoreLabel.font.withSize(24)
        timerLabel.text = "Time: \(self.timeFormatted(self.totalTimeInSeconds))"
        view.addSubview(timerLabel)
    }
    
    func setupTextField() {
        textField = UITextField(frame: CGRect(x: 20, y: 110, width: UIScreen.main.bounds.width - 40, height: 50))
        textField.autocapitalizationType = .none
        textField.placeholder = "Type the reserved word here"
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.delegate = self
        view.addSubview(textField)
    }
    
    func setupCheckButton() {
        checkButton = UIButton(frame: CGRect(x: 20, y: 170, width: UIScreen.main.bounds.width - 40, height: 60))
        checkButton.backgroundColor = .black
        checkButton.layer.cornerRadius = 8
        checkButton.layer.borderWidth = 2.0
        checkButton.layer.borderColor = UIColor.gray.cgColor
        checkButton.setTitle("Check", for: .normal)
        checkButton.addTarget(self, action: #selector(checkIfUserScored), for: .touchUpInside)
        view.addSubview(checkButton)
    }
    
    func setupAndPopulateTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 240, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 240))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        viewModel.populateList()
        updateScore()
    }
}

// MARK: Timer
extension ReservedWordsViewController {
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timerLabel.text = "Time: \(self.timeFormatted(self.totalTimeInSeconds))"
        
        if totalTimeInSeconds != 0 {
            totalTimeInSeconds -= 1  // decrease counter timer
        } else {
            self.completeGame(with: .defeat)
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: Score Handling
extension ReservedWordsViewController {
    @objc func checkIfUserScored() {
        guard let text = textField.text else { return }
        if viewModel.didUserScore(word: text) {
            updateScore()
        }
        
        clearTextField()
    }
    
    func updateScore() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.scoreLabel.text = "Score: \(self.viewModel.getTotalScore()) / \(self.viewModel.getList().count)"
            self.tableView.reloadData()
            
            if self.viewModel.getTotalScore() == self.viewModel.getList().count {
                self.completeGame(with: .victory)
            }
        }
    }
    
    func clearTextField() {
        textField.text = ""
    }

    func completeGame(with status: GameStatus) {
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        
        textField.isUserInteractionEnabled = false
        checkButton.setTitle(status == .victory ? "You Rock 🏁" : "Game Over ⚠️", for: .normal)
        checkButton.isEnabled = false
    }
}

// MARK: Table View Delegates
extension ReservedWordsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getList().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kCellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.getList()[indexPath.row].wordTitle
        cell.textLabel?.textColor = UIColor.green
        cell.textLabel?.font.withSize(14)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.isHidden = !viewModel.getList()[indexPath.row].alreadyScored
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: TextField Delegates
extension ReservedWordsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfUserScored()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
