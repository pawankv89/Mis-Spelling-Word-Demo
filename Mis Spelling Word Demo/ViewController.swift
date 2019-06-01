//
//  ViewController.swift
//  Mis Spelling Word Demo
//
//  Created by Pawan kumar on 18/05/19.
//  Copyright © 2019 Pawan Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var suggestionsLabel: UILabel!
    @IBOutlet weak var autocompleteCollectionView: UICollectionView!
    @IBOutlet weak var flowLayout: FlowLayout!
    var sizingCell: TagCell?
    
    var autocompleteWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Configuration Tag Cell
        let cellNib = UINib(nibName: "TagCell", bundle: nil)
        self.autocompleteCollectionView.register(cellNib, forCellWithReuseIdentifier: "TagCell")
        self.autocompleteCollectionView.backgroundColor = UIColor.clear
        self.sizingCell = (cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! TagCell?
        self.autocompleteCollectionView.delegate = self
        self.autocompleteCollectionView.dataSource = self
        
        flowLayout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.autocompleteCollectionView.collectionViewLayout = flowLayout
        self.autocompleteCollectionView.reloadData()
        
        //Status Label Set Text and Color
        statusLabel.text = ""
        statusLabel.textColor = UIColor.clear
        
        //Suggestions
        suggestionsLabel.text = ""
        suggestionsLabel.textColor = UIColor.clear
        
        //TextField Delegation
        searchTextField.delegate = self
        
    }

    @IBAction func validateWord(_ sender: UIButton) {
        
        //IF Word Cout is lessthen 3 charter
        if searchTextField.text!.count < 3 {
           
            //status
            statusLabel.textColor = UIColor.clear
            statusLabel.text = ""
    
            return
        }
        
        if self.wordIsSpelledCorrect(word: searchTextField.text!) {
            statusLabel.textColor = UIColor(red: 24/255, green: 156/255, blue: 25/255, alpha: 1)
            statusLabel.text = "verified"
        } else {
            statusLabel.textColor = UIColor.red
            statusLabel.text = "worng"
        }
        
    }
}


//MARK: - Tag Collection View
extension ViewController {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        self.configureCell(cell: self.sizingCell!, forIndexPath: indexPath)
        return self.sizingCell!.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return autocompleteWords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCell", for: indexPath as IndexPath) as! TagCell
        self.configureCell(cell: cell, forIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: TagCell, forIndexPath indexPath: IndexPath) {
        let tag = autocompleteWords[indexPath.row]
        cell.tagName.text = tag
        
        //Cell Corner Radius
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = cell.frame.size.height / 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt:-\(indexPath.row) Value \(autocompleteWords[indexPath.row])")
        
    }
}

//MARK: - AutoComplete TextField Delegate Methods
extension ViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     
        autocompleteWords.removeAll(keepingCapacity: false)
        
        let searchResults = self.suggestionsWordList(word: textField.text!)
        
        if searchResults.count == 0 {
            autocompleteCollectionView.isHidden = true
            
            //Suggestions
            suggestionsLabel.text = ""
            suggestionsLabel.textColor = UIColor.clear
        }
        else
        {
            //Suggestions
            suggestionsLabel.text = "Suggestions"
            suggestionsLabel.textColor = UIColor.black
            
            for task in searchResults {
                autocompleteWords.append(task)
            }
            
            autocompleteCollectionView.isHidden = false
            autocompleteCollectionView.reloadData()
        }
        
        return true
    }
    
    func suggestionsWordList(word: String) -> [String] {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        //let guessesList = checker.guesses(forWordRange: range, in: word, language: "en")
        
        let guessesList = checker.completions(forPartialWordRange: range, in: word, language: "en")
        if guessesList == nil {
            return []
        }
        if guessesList?.count == 0 {
            return []
        }
        
        print("Enter Word is \(word) and result is \(String(describing: guessesList))")
        
        return guessesList!
    }
    
    func wordIsSpelledCorrect(word: String) -> Bool {
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.count)
        let wordRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        print("Enter Word is \(word) and validate is \(String(describing: wordRange.location))")
        
        return wordRange.location == NSNotFound
    }
}
