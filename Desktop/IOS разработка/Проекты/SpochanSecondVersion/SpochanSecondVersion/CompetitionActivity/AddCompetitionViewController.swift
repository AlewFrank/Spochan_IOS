//
//  AddCompetitionViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 08.05.2021.
//

import UIKit
import FirebaseStorage
import Firebase
import SDWebImage

class AddCompetitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var addCompetitionImage: UIButton!
    @IBOutlet weak var competitionTitleTextField: UITextField!
    @IBOutlet weak var competitionDaysTextField: UITextField!
    @IBOutlet weak var competitionMonthsTextField: UITextField!
    @IBOutlet weak var competitionYearsTextField: UITextField!
    @IBOutlet weak var competitionLocationTextField: UITextField!
    @IBOutlet weak var competitionAsressTextField: UITextField!
    @IBOutlet weak var competitionDescriptionTextField: UITextView!
    @IBOutlet weak var loadImageLabel: UILabel!
    @IBOutlet weak var loadLabel: UILabel!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var competitionImageUrl: String = ""
    var itemID: String = ""
    
    var competitionId: String = ""
    var competitionTitle: String = ""
    var competitionDescription: String = ""
    var competitionLocation: String = ""
    var competitionAddress: String = ""
    var previousImageUrl: String = ""
    
    var daysCompetitionDate: String = "00"
    var monthCompetitionDate: String = "00"
    var yearCompetitionDate: String = "00"
    
    private let storage = Storage.storage().reference()
    let db = Firestore.firestore()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        cancelButton.layer.cornerRadius = 8
        saveButton.layer.cornerRadius = 8
        competitionDescriptionTextField.layer.cornerRadius = 5
        competitionDescriptionTextField.layer.borderWidth = 1
        competitionDescriptionTextField.layer.borderColor = UIColor.systemGray5.cgColor
        
        loadingBar.isHidden = true
        loadLabel.isHidden = true
        loadImageLabel.isHidden = true
        addCompetitionImage.layer.cornerRadius = 8
        
        if competitionId != "" { //редактируем запись, а не создаем новую
            
            competitionTitleTextField.text = competitionTitle
            competitionLocationTextField.text = competitionLocation
            competitionAsressTextField.text = competitionAddress
            competitionDescriptionTextField.text = competitionDescription
            
            competitionDaysTextField.text = daysCompetitionDate
            competitionMonthsTextField.text = monthCompetitionDate
            competitionYearsTextField.text = yearCompetitionDate
            
            competitionImageUrl = previousImageUrl
            
            loadingBar.isHidden = false
            loadingBar.startAnimating()
            self.addCompetitionImage.sd_setBackgroundImage(with: URL(string: previousImageUrl), for: .normal, placeholderImage: nil, options: .highPriority, completed:{_,_,_,_ in
                //выполняется когда изображение все же загрузится
                self.loadingBar.isHidden = true
            })
        }
        
        
    }
    


    @IBAction func saveButtonPressed(_ sender: Any) {
        
        if competitionDaysTextField.text == "" || competitionMonthsTextField.text == "" || competitionYearsTextField.text == "" || competitionTitleTextField.text == "" || competitionLocationTextField.text == "" || competitionAsressTextField.text == "" || competitionDescriptionTextField.text == ""{
            
            loadLabel.isHidden = false
            loadLabel.text = "Заполните все данные"
        } else if competitionImageUrl == "" {
            loadLabel.isHidden = false
            loadLabel.text = "Загрузите изображение"
        } else {
            
            itemID = (competitionYearsTextField.text ?? "00") + (competitionMonthsTextField.text ?? "00") + (competitionDaysTextField.text ?? "00")
            
            
            if competitionId != itemID && competitionId != "" { //мы редактировали и дата изменилась
                print("Удаляем запись при изменение даты")
                db.collection("CompetitionsRussia").document(competitionId).delete()
            }
            
            
            db.collection("CompetitionsRussia").document(itemID).setData([  "competitionId" : itemID,
                                                                    "competitionTitle" : competitionTitleTextField.text!,
                                                                    "competitionDescription" : competitionDescriptionTextField.text!,
                                                                    "competitionLocation" : competitionLocationTextField.text!,
                                                                    "competitionAddress" : competitionAsressTextField.text!,
                                                                    "competitionImageUrl" : competitionImageUrl,
                                                                    "daysCompetitionDate" : competitionDaysTextField.text!,
                                                                    "monthCompetitionDate" : competitionMonthsTextField.text!,
                                                                    "yearCompetitionDate" : competitionYearsTextField.text!])
            
            navigationController?.popToRootViewController(animated: true) //возвращаемся к предыдущей активити
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { //когда человек все-таки выбирает какое-то фото
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        if competitionDaysTextField.text == "" || competitionMonthsTextField.text == "" || competitionYearsTextField.text == "" {
            loadImageLabel.isHidden = false
            self.loadImageLabel.text = "Заполните дату соревнований"
        } else {
            
            self.addCompetitionImage.isEnabled = false //чтоб не могли использовать
            self.saveButton.isEnabled = false
            self.loadImageLabel.isHidden = false
            self.loadImageLabel.text = "Загрузка..." //если перед этим была неудачная попытка загрузки изображения
            self.loadingBar.isHidden = false
            self.loadingBar.startAnimating()
            
            itemID = (competitionYearsTextField.text ?? "00") + (competitionMonthsTextField.text ?? "00") + (competitionDaysTextField.text ?? "00")
            
            storage.child("Russia").child("Competitions_images").child(itemID).putData(imageData, metadata: nil, completion: { _, error in
                guard error == nil else {
                    print("Изображение не загружено")
                    self.loadImageLabel.text = "Изображение не загружено"
                    return
                }
                
                self.storage.child("Russia").child("Competitions_images").child(self.itemID).downloadURL(completion: {url, error in
                    guard let url = url, error == nil else {return}
                    
                    self.competitionImageUrl = url.absoluteString
                    
                    self.addCompetitionImage.sd_setBackgroundImage(with: url, for: .normal, placeholderImage: nil, options: .highPriority, completed:{_,_,_,_ in
                        //выполняется когда изображение все же загрузится
                        self.loadingBar.isHidden = true
                    })
                    
                    
                    self.loadImageLabel.isHidden = true
                    self.loadLabel.isHidden = true
                    self.addCompetitionImage.isEnabled = true 
                    self.saveButton.isEnabled = true
                    print("Изображение загружено")
                    
                })
            })
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { //если мы отменяем выбор изображения
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        
        let ac = UIAlertController(title: "", message: "Удалить данное соревновнование?", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            
            //удаляем изображения
            self.storage.child("Russia").child("Competitions_images").child(self.competitionId).delete { error in
                if error != nil {
                  print("Ошибочка")
                } else {
                  // File deleted successfully
                }
              }
            
            //удаляем запись
            self.db.collection("CompetitionsRussia").document(self.competitionId).delete() { err in
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
    
}
