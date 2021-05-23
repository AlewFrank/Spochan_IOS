//
//  FullCompetitionInfoViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 08.05.2021.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseFirestore

class FullCompetitionInfoViewController: UIViewController {
    
    @IBOutlet weak var competitionTitleLabel: UILabel!
    @IBOutlet weak var competitionLocationLabel: UILabel!
    @IBOutlet weak var competitionDataLabel: UILabel!
    @IBOutlet weak var competitionAdressLabel: UILabel!
    @IBOutlet weak var competitionDescriptionTextView: UITextView!
    
    @IBOutlet weak var competitionImageView: UIImageView!
    @IBOutlet weak var loadingBar: UIActivityIndicatorView!
    @IBOutlet weak var EditButton: UIButton!
    
    let db = Firestore.firestore()
    
    var isDirector: Bool = false
    
    var competitionId: String = ""
    var competitionTitle: String = ""
    var competitionDescription: String = ""
    var competitionLocation: String = ""
    var competitionAddress: String = ""
    var competitionImageUrl: String = ""
    var competitionDate: String = ""
    
    var daysCompetitionDate: String = "00"
    var monthCompetitionDate: String = "00"
    var yearCompetitionDate: String = "00"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        EditButton.layer.cornerRadius = 5
        EditButton.isHidden = true
        
        loadingBar.layer.cornerRadius = 5
        loadingBar.isHidden = false
        loadingBar.startAnimating()
        
        let user = Auth.auth().currentUser
        if let user = user {
        let uid = user.uid
            
        self.db.collection("UsersRussia").getDocuments { (snapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
               } else {
                   for document in snapshot!.documents {
                      let docId = document.documentID
                    if docId == uid {
                        self.isDirector = document.get("director") as? Bool ?? false
                        if self.isDirector {
                            self.EditButton.isHidden = false
                        }

                    }
                   }
               }
        }
    }
        

        competitionTitleLabel.text = competitionTitle
        competitionLocationLabel.text = competitionLocation
        competitionDataLabel.text = competitionDate
        competitionAdressLabel.text = competitionAddress
        competitionDescriptionTextView.text = competitionDescription
        
        let imageUrl = URL(string: competitionImageUrl)
        competitionImageView.sd_setImage(with: imageUrl, completed: {_,_,_,_ in
            //выполняется когда изображение все же загрузится
            self.loadingBar.isHidden = true
        })
        
    }
    

    @IBAction func editButtonPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destVC = storyboard.instantiateViewController(identifier: "AddCompetitionViewController") as? AddCompetitionViewController else { return }
        
        destVC.competitionId = competitionId
        destVC.competitionTitle = competitionTitle
        destVC.competitionDescription = competitionDescription
        destVC.competitionLocation = competitionLocation
        destVC.competitionAddress = competitionAddress

        destVC.daysCompetitionDate = daysCompetitionDate
        destVC.monthCompetitionDate = monthCompetitionDate
        destVC.yearCompetitionDate = yearCompetitionDate
        
        destVC.previousImageUrl = competitionImageUrl
        
        self.show(destVC, sender: nil)
    }
}
