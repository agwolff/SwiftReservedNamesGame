//
//  ReservedWordsViewController.swift
//  SwiftReservedWords
//
//  Created by Allan Wolff on 03/03/20.
//  Copyright © 2020 Allan Wolff. All rights reserved.
//

import UIKit

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
        populateTableView()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension ReservedWordsViewController {
    
    func setupUI() {
        self.title = "Swift Reserved Words"
        view.backgroundColor = .white
        
        scoreLabel = UILabel(frame: CGRect(x: 20, y: 60, width: (UIScreen.main.bounds.width / 2 - 20), height: 30))
        scoreLabel.font = scoreLabel.font.withSize(24)
        view.addSubview(scoreLabel)
        
        timerLabel = UILabel(frame: CGRect(x: (UIScreen.main.bounds.width / 2), y: 60, width: (UIScreen.main.bounds.width / 2 - 20), height: 30))
        timerLabel.textAlignment = .right
        timerLabel.font = scoreLabel.font.withSize(24)
        timerLabel.text = "Time: \(self.timeFormatted(self.totalTimeInSeconds))"
        view.addSubview(timerLabel)
        
        
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
        
        checkButton = UIButton(frame: CGRect(x: 20, y: 170, width: UIScreen.main.bounds.width - 40, height: 60))
        checkButton.backgroundColor = .black
        checkButton.layer.cornerRadius = 8
        checkButton.layer.borderWidth = 2.0
        checkButton.layer.borderColor = UIColor.gray.cgColor
        
        checkButton.setTitle("Check", for: .normal)
        
        checkButton.addTarget(self, action: #selector(checkIfUserScored), for: .touchUpInside)
        view.addSubview(checkButton)
        
        tableView = UITableView(frame: CGRect(x: 0, y: 240, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 240))
        tableView.register(ReservedWordTableViewCell.self, forCellReuseIdentifier: kCellIdentifier)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
    }
    
    func populateTableView() {
        viewModel.populateList()
        updateScore()
    }
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        timerLabel.text = "Time: \(self.timeFormatted(self.totalTimeInSeconds))"
        
        if totalTimeInSeconds != 0 {
            totalTimeInSeconds -= 1  // decrease counter timer
        } else {
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
                disableButtonAndInput()
            }
        }
    }
    
    func timeFormatted(_ totalSeconds: Int) -> String {
        let seconds: Int = totalSeconds % 60
        let minutes: Int = (totalSeconds / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
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
        }
    }
    
    func clearTextField() {
        textField.text = ""
    }
    
    
    func disableButtonAndInput() {
        textField.isUserInteractionEnabled = false
        checkButton.setTitle("Game Over", for: .normal)
        checkButton.isEnabled = false
    }
}

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

extension ReservedWordsViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkIfUserScored()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
