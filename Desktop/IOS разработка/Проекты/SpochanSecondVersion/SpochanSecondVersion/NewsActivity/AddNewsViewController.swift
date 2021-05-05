//
//  AddNewsViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 13.04.2021.
//

import UIKit
import FirebaseStorage
import Firebase

class AddNewsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var newsTitleTextField: UITextField!
    @IBOutlet weak var newsDescriptionTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    private let storage = Storage.storage().reference()
    var imageCounter: Int = 1
    var itemID: String = ""
    var newsImageUrl_1: String = ""
    var newsImageUrl_2: String = ""
    var newsImageUrl_3: String = ""
    var newsImageUrl_4: String = ""
    var newsImageUrl_5: String = ""
    var newsTime: String = ""
    var newsData: String = ""
    
    var idForEditing: String = ""
    var titleForEditing: String = ""
    var descriptionForEditing: String = ""
    var timeForEditing: String = ""
    var dataForEditing: String = ""
    
    let db = Firestore.firestore()
    
    
    
    
    //Не забыть про защиту от дурака,чтоб все данные были загружены до нажатия на сохранить
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if idForEditing != "" { //то есть мы редактируем запись
            newsTitleTextField.text = titleForEditing
            newsDescriptionTextView.text = descriptionForEditing
            
            addImageButton.isHidden = true
            addImageButton.isEnabled = false
            image1.isHidden = true
            image2.isHidden = true
            image3.isHidden = true
            image4.isHidden = true
            image5.isHidden = true
        } else {
            //скрываем кнопку удаления записи
            self.deleteButton.isEnabled = false
            self.deleteButton.tintColor = UIColor.clear
        }
        
        cancelButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        newsDescriptionTextView.layer.cornerRadius = 5
        newsDescriptionTextView.layer.borderWidth = 1
        newsDescriptionTextView.layer.borderColor = UIColor.systemGray5.cgColor
        
        loadLabel.isHidden = true
        loadingBar.isHidden = true
        

        addImageButton.layer.cornerRadius = 8
        image1.layer.cornerRadius = 5
        image2.layer.cornerRadius = 5
        image3.layer.cornerRadius = 5
        image4.layer.cornerRadius = 5
        image5.layer.cornerRadius = 5
        
        setupId()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if newsTitleTextField.text == "" || newsDescriptionTextView.text == "" {
            loadLabel.isHidden = false
            loadLabel.text = "Заполните все данные"
        } else if newsImageUrl_1 == "" {
            loadLabel.isHidden = false
            loadLabel.text = "Загрузите изображение"
        } else {
            
            if idForEditing != "" {//то есть мы редактировали запись
                itemID = idForEditing
                newsTime = timeForEditing
                newsData = dataForEditing
            }
            
            
            db.collection("NewsRussia").document(itemID).setData([  "newsTitle" : newsTitleTextField.text!,
                                                                    "newsDescription" : newsDescriptionTextView.text!,
                                                                    "newsData" : newsData,
                                                                    "newsTime" : newsTime,
                                                                    "newsId" : itemID,
                                                                    "newsImageUrl_1" : newsImageUrl_1,
                                                                    "newsImageUrl_2" : newsImageUrl_2,
                                                                    "newsImageUrl_3" : newsImageUrl_3,
                                                                    "newsImageUrl_4" : newsImageUrl_4,
                                                                    "newsImageUrl_5" : newsImageUrl_5,
                                                                    "previousImageIndex" : 0,
                                                                    "nextImageIndex" : 2])
            
            navigationController?.popToRootViewController(animated: true) //возвращаемся к предыдущей активити
        }
    }
    
    
    @IBAction func deleteNewsNote(_ sender: Any) {
        
        let ac = UIAlertController(title: "", message: "Удалить новостную запись?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            guard let destVC = storyboard.instantiateViewController(identifier: "NewsViewController") as? NewsViewController else { return }
            print(self.idForEditing)
            //удаляем изображения
            self.storage.child("Russia").child("News_images").child(self.idForEditing).delete { error in
                if error != nil {
                  print("Ошибочка")
                } else {
                  // File deleted successfully
                }
              }
            
            //удаляем запись
            self.db.collection("NewsRussia").document(self.idForEditing).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    //self.navigationController?.pushViewController(destVC, animated: true)
                    self.navigationController?.popToRootViewController(animated: true) //возвращаемся к предыдущей активити
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel) { (_) in
        }
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true)
    }
    
    
    
    @IBAction func addImageButtonPressed(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //когда человек все-таки выбирает какое-то фото
        
        self.addImageButton.isEnabled = false //чтоб не могли использовать
        self.saveButton.isEnabled = false
        self.loadLabel.isHidden = false
        self.loadLabel.text = "Загрузка" //если перед этим была неудачная попытка загрузки изображения
        self.loadingBar.isHidden = false
        self.loadingBar.startAnimating()
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        storage.child("Russia").child("News_images").child(itemID).child(String(imageCounter)).putData(imageData, metadata: nil, completion: { _, error in
            guard error == nil else {
                print("Изображение не загружено")
                self.loadLabel.text = "Изображение не загружено"
                return
            }
            self.storage.child("Russia").child("News_images").child(self.itemID).child(String(self.imageCounter)).downloadURL(completion: {url, error in
                guard let url = url, error == nil else {return}
                
                let urlString = url.absoluteString
                self.loadImage(imageUrl: urlString)
                print("Изображение загружено")
            })
        })
        
        
        
        //https://www.youtube.com/watch?v=TAF6cPZxmmI  на 18 минуте важная штука про действие в файле Info.plist
    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //если мы отменяем выбор изображения
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func loadImage(imageUrl: String) {
        
        DispatchQueue.main.async { //загружаем изображения в другом потоке, чтоб не тормозить приложение
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    
                    if self.imageCounter == 1 {
                        self.image1.image = UIImage(data: data)
                        self.newsImageUrl_1 = imageUrl
                    } else if self.imageCounter == 2 {
                        self.image2.image = UIImage(data: data)
                        self.newsImageUrl_2 = imageUrl
                    } else if self.imageCounter == 3 {
                        self.image3.image = UIImage(data: data)
                        self.newsImageUrl_3 = imageUrl
                    } else if self.imageCounter == 4 {
                        self.image4.image = UIImage(data: data)
                        self.newsImageUrl_4 = imageUrl
                    } else if self.imageCounter == 5 {
                        self.image5.image = UIImage(data: data)
                        self.newsImageUrl_5 = imageUrl
                    }
                }
            }
            self.loadLabel.isHidden = true
            self.loadingBar.isHidden = true
            self.addImageButton.isEnabled = true
            self.saveButton.isEnabled = true
            self.imageCounter = self.imageCounter + 1
        }
    }
    
    
    func setupId() {
        // get the current date and time
        let currentDateTime = Date()

        // get the user calendar
        let userCalendar = Calendar.current

        // choose which date and time components are needed
        let requestedComponents: Set<Calendar.Component> = [
            .year,
            .month,
            .day,
            .hour,
            .minute,
            .second
        ]

        // get the components
        let dateTimeComponents = userCalendar.dateComponents(requestedComponents, from: currentDateTime)

        // now the components are available
        let years = (dateTimeComponents.year ?? 0) * 13 * 32
        let month = (dateTimeComponents.month ?? 0) * 32
        let day = dateTimeComponents.day ?? 0
        let hour = (dateTimeComponents.hour ?? 0) * 3600
        let minute = (dateTimeComponents.minute ?? 0) * 60
        let second = dateTimeComponents.second ?? 0
        
        let sum1 = second + minute + hour
        let sum2 = day + month + years
        
        let sum1Invert = 1000000 - sum1
        let sum2Invert = 1000000000 - sum2
        
        itemID = String(sum2Invert) + "." + String(sum1Invert)
        
        
        
        let date = NSDate()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.newsTime = dateFormatter.string(from: date as Date)
        
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "dd.MM.yyyy"
        self.newsData = dateFormatter2.string(from: date as Date)
    }
    
}
