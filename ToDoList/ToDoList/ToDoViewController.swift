//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by William Figueroa on 4/18/21.
//

import UIKit

class ToDoViewController: UITableViewController
{
    var todo: ToDo?
    var isPickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 2)
    let normalCellHeight: CGFloat = 44
    let largeCellHeight: CGFloat = 200
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var isCompleteButton: UIButton!
    
    @IBOutlet weak var dueDateLabel: UILabel!
    
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textEditingChanged(_ sender: UITextField)
    {
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField)
    {
        titleTextField.resignFirstResponder()
    }
    
    @IBAction func isCompleteButtonTapped(_ sender: UIButton)
    {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker)
    {
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let todo = todo
        {
            navigationItem.title = "To-Do"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            notesTextView.text = todo.notes
        }
        
        else
        {
            dueDatePickerView.date = Date().addingTimeInterval(24*60*60)
        }
        updateSaveButtonState()
        updateDueDateLabel(date: dueDatePickerView.date)
    }
    
    func updateSaveButtonState()
    {
        let text = titleTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    func updateDueDateLabel(date: Date)
    {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath
        {
        case datePickerIndexPath:
            return isPickerHidden ? 0 : dueDatePickerView.frame.height
        
        case notesTextViewIndexPath:
            return largeCellHeight
            
        default:
            return normalCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath == dateLabelIndexPath
        {
            isPickerHidden = !isPickerHidden
            
            dueDateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else {return}
        
        let title = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        todo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
    }
}
