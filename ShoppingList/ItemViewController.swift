//
//  ShoppingItemViewController.swift
//  ShoppingList
//
//  Created by zero on 2020/11/10.
//

import UIKit

class ItemViewController:
    UIViewController,
    UITextFieldDelegate, UITextViewDelegate,
    UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var commentTextViewDoneBtn: UIButton!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var ratingControl: RatingControl!
    
    var item : Item?
    var commentTextViewPlaceholder = "请输入描述"
    var placeholderColor : UIColor = .lightGray
    var textColor : UIColor = .black
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            placeholderColor = .systemGray3
            textColor = .label
        }
        
        nameTextField.delegate = self
        commentTextView.delegate = self
        commentTextView.layer.borderWidth = 0.5
        commentTextView.layer.cornerRadius = 5.0
        commentTextView.layer.borderColor = placeholderColor.cgColor
        
        if let item = item {
            nameTextField.text = item.name
            photoImageView.image = item.photo
            ratingControl.rating = item.rating
            commentTextView.text = item.comment
            commentTextView.textColor = textColor
        } else {
            commentTextView.text = commentTextViewPlaceholder
            commentTextView.textColor = placeholderColor
            navigationItem.title = "添加商品"
        }
        
        updateSaveBtnState()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(self.keyboardWillBeHidden),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
    
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: UITextFieldDelegate for nameTextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveBtn.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveBtnState()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: UITextViewDelegate for descriptionTextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == placeholderColor {
            textView.text = ""
            textView.textColor = textColor
        }
        commentTextViewDoneBtn.isHidden = false
        textView.isScrollEnabled = true
        saveBtn.isEnabled = false
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = commentTextViewPlaceholder
            textView.textColor = placeholderColor
        }
        commentTextViewDoneBtn.isHidden = true
        textView.isScrollEnabled = false
        updateSaveBtnState()
    }
    
    @IBAction func textViewDoneBtnTouched(_ sender: Any) {
        commentTextView.resignFirstResponder()
    }
    
    
    // MARK: Keyboard Notification
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let kbHeight = keyboardSize.cgRectValue.size.height
        scrollView.contentInset.bottom = kbHeight
        scrollView.scrollIndicatorInsets.bottom = kbHeight
        if commentTextView.isFirstResponder {
            scrollView.scrollRectToVisible(commentTextView.superview!.frame, animated: false)
        }
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        scrollView.contentInset.bottom = 0.0
        scrollView.scrollIndicatorInsets.bottom = 0.0
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        photoImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if presentingViewController is UINavigationController {
            // is in add item mode
            dismiss(animated: true, completion: nil)
        } else {
            // is in edit mode
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        item = Item(
            name: nameTextField.text ?? "",
            photo: photoImageView.image,
            rating: ratingControl.rating,
            comment: getDescTextViewText()
        )
    }

    
    // MARK: Action
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        nameTextField.resignFirstResponder()
        commentTextView.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }

    
    // MARK: private functions
    private func updateSaveBtnState() {
        let nameText = nameTextField.text ?? ""
        saveBtn.isEnabled = !(nameText.isEmpty)
    }
    
    private func getDescTextViewText() -> String {
        if commentTextView.textColor == placeholderColor {
            return ""
        } else {
            return commentTextView.text
        }
    }
}
