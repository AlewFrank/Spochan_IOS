//
//  CompetitionTableViewCell.swift
//  SpochanSecondVersion
//
//  Created by Admin on 13.04.2021.
//

import UIKit
import FirebaseStorage

class CompetitionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var competitionTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(competitionTitle: String, competitionDescription: String, competitionLocation: String, competitionAddress: String, competitionImageUrl: String, daysCompetitionDate: String, monthCompetitionDate: String, yearCompetitionDate: String) {
        
        
//        previousImage.layer.cornerRadius = 20
//        previousImage.isHidden = true
//        nextImage.layer.cornerRadius = 20
//        loadingBar.layer.cornerRadius = 5
        
//        newsTitleLabel.text = newsTitle
//        newsDescriptionLabel.text = newsDescription
//        newsDataLabel.text = newsData
//        newsTimeLabel.text = newsTime
        
        competitionTitleLabel.text = competitionTitle
        
        
    }

}
