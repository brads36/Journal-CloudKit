//
//  EntryDetailViewController.swift
//  CloudKitJournal
//
//  Created by Bryce Bradshaw on 5/11/20.
//  Copyright © 2020 Zebadiah Watson. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    // MARK: - Properties
    var entry: Entry? {
        didSet {
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self

    }
    
    // MARK: - Actions
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
    }
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextView.text = "Enter Text Here"
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, !title.isEmpty,
            let body = bodyTextView.text, !body.isEmpty
            else { return }
        EntryController.sharedInstance.createEntryWith(title: title, body: body) { (result) in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateViews() {
        guard let entry = entry  else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.body
            
        }
} // End class

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}
