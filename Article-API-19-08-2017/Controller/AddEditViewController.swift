//
//  AddEditViewController.swift
//  Article-API-19-08-2017
//
//  Created by Soeng Saravit on 8/20/17.
//  Copyright © 2017 Soeng Saravit. All rights reserved.
//

import UIKit

class AddEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var articleImageView: UIImageView!

    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    var articlePresenter:ArticlePresenter?
    
    var detailArticle:Article?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.articlePresenter = ArticlePresenter()
        self.articlePresenter?.delegate = self
        
        if detailArticle != nil {
            self.titleTextField.text = detailArticle?.title
            self.descriptionTextField.text = detailArticle?.description
            if let url = URL(string: (detailArticle?.image)!) {
                self.articleImageView.kf.setImage(with: url)
            }
        }
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        let image = UIImageJPEGRepresentation(self.articleImageView.image!, 0.5)
        let article = Article()
        if detailArticle != nil {
            article.id = detailArticle?.id
        }else{
            article.id = 0
        }
        article.title = self.titleTextField.text
        article.description = self.descriptionTextField.text
        
        self.articlePresenter?.insertUpdateArticle(article: article, img: image!)
        
    }
    
    @IBAction func browseImage(_ sender: UITapGestureRecognizer){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image:UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        DispatchQueue.main.async {
            self.articleImageView.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
}
    
extension AddEditViewController:ArticlePresenterProcotol {
    func responseMessage(msg: String) {
        print(msg)
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func responseArticle(articles: [Article]) {}
    
}
    

